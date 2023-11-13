use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use pixelaw::core::models::pixel::{pixel, Pixel, PixelUpdate};
use pixelaw::core::utils::{Position, DefaultParameters};
use starknet::{get_caller_address, get_contract_address, get_execution_info, ContractAddress};


#[starknet::interface]
trait IHunterActions<TContractState> {
    fn init(self: @TContractState);
    fn interact(self: @TContractState, default_params: DefaultParameters);
}


#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct LastAttempt {
    #[key]
    player: ContractAddress,
    timestamp: u64
}

const APP_KEY: felt252 = 'hunter';
const APP_ICON: felt252 = 'U+1F946';

#[dojo::contract]
mod hunter_actions {
    use poseidon::poseidon_hash_span;
    use starknet::{
        get_tx_info, get_caller_address, get_contract_address, get_execution_info, ContractAddress
    };

    use super::{IHunterActions, LastAttempt};
    use pixelaw::core::models::pixel::{Pixel, PixelUpdate};

    use pixelaw::core::models::permissions::{Permission};
    use pixelaw::core::actions::{
        IActionsDispatcher as ICoreActionsDispatcher,
        IActionsDispatcherTrait as ICoreActionsDispatcherTrait
    };
    use super::{APP_KEY, APP_ICON};
    use pixelaw::core::utils::{get_core_actions, Direction, Position, DefaultParameters};

    use debug::PrintTrait;


    // impl: implement functions specified in trait
    #[external(v0)]
    impl HunterActionsImpl of IHunterActions<ContractState> {
        /// Initialize the Hunter App
        fn init(self: @ContractState) {
            let core_actions = get_core_actions(self.world_dispatcher.read());

            core_actions.update_app_name(APP_KEY, APP_ICON);
        }



        fn interact(self: @ContractState, default_params: DefaultParameters) {
            'interact'.print();

            let COOLDOWN_SEC = 3;

            // Load important variables
            let world = self.world_dispatcher.read();
            let core_actions = get_core_actions(world);
            let position = default_params.position;
            let player = core_actions.get_player_address(default_params.for_player);
            let system = core_actions.get_system_address(default_params.for_system);
            let mut pixel = get!(world, (position.x, position.y), (Pixel));

            // Check if we have a winner
            let timestamp = starknet::get_block_timestamp();

            let mut last_attempt = get!(world, (player), LastAttempt);

            // assert(timestamp - last_attempt.timestamp > COOLDOWN_SEC, 'Not so fast');
            assert(pixel.owner.is_zero(), 'Hunt only empty pixels');

            let timestamp_felt252 = timestamp.into();
            let x_felt252 = position.x.into();
            let y_felt252 = position.y.into();

            // Generate hash (timestamp, x, y)
            let hash: u256 = poseidon_hash_span(
                array![timestamp_felt252, x_felt252, y_felt252].span()
            )
                .into();

            // Check if the last 3 bytes of the hash are 000
            // let MASK = 0xFFFFFFFFFFFFFFFF0000;  // TODO, this is a placeholder
            // let MASK: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; // use this for debug.
            let MASK: u256 =
                0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc00; // this represents: 1/1024
            let result = ((hash | MASK) == MASK);

            assert(result, 'Oops, no luck');

            // We can now update color of the pixel
            core_actions
                .update_pixel(
                    player,
                    system,
                    PixelUpdate {
                        x: position.x,
                        y: position.y,
                        color: Option::Some(default_params.color),
                        alert: Option::Some(''), // TODO a notification?
                        timestamp: Option::None,
                        text: Option::Some('U+2B50'), // Star emoji
                        app: Option::Some(system),
                        owner: Option::Some(player),
                        action: Option::None
                    }
                );

            // Update the timestamp for the cooldown
            last_attempt.timestamp = timestamp;
            set!(world, (last_attempt));

            'hunt DONE'.print();
        }
    }
}


#[cfg(test)]
mod tests {
    // cairo
    use debug::PrintTrait;  
    use zeroable::Zeroable;
    
    // starknet
    use starknet::class_hash::Felt252TryIntoClassHash;

    // dojo
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // pixelaw
    use pixelaw::core::models::registry::{app, app_name, core_actions_address};
    use pixelaw::core::models::pixel::{pixel, Pixel, PixelUpdate};
    use pixelaw::core::models::permissions::{permissions};
    use pixelaw::core::utils::{get_core_actions, Direction, Position, DefaultParameters};
    use pixelaw::core::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    // hunter
    use pixelaw::apps::hunter::app::{
        hunter_actions, IHunterActionsDispatcher, IHunterActionsDispatcherTrait,LastAttempt
    };



    // Helper function: deploys world and actions
    fn deploy_world() -> (IWorldDispatcher, IActionsDispatcher, IHunterActionsDispatcher) {

        // Deploy World and models
        let world = spawn_test_world(
            array![
                pixel::TEST_CLASS_HASH,
                app::TEST_CLASS_HASH,
                app_name::TEST_CLASS_HASH,
                core_actions_address::TEST_CLASS_HASH,
                permissions::TEST_CLASS_HASH,
            ]
        );

        // Deploy Core actions
        let core_actions_address = world
            .deploy_contract('salt1', actions::TEST_CLASS_HASH.try_into().unwrap());
        let core_actions = IActionsDispatcher { contract_address: core_actions_address };

        // Deploy Paint actions
        let hunter_actions_address = world
            .deploy_contract('salt2', hunter_actions::TEST_CLASS_HASH.try_into().unwrap());
        let hunter_actions = IHunterActionsDispatcher { contract_address: hunter_actions_address };

        // Setup dojo auth
        world.grant_writer('Pixel', core_actions_address);
        world.grant_writer('App', core_actions_address);
        world.grant_writer('AppName', core_actions_address);
        world.grant_writer('CoreActionsAddress', core_actions_address);
        world.grant_writer('Permissions', core_actions_address);

        world.grant_writer('Game', hunter_actions_address);
        world.grant_writer('Player', hunter_actions_address);

        world.grant_writer('LastAttempt', hunter_actions_address);

        (world, core_actions, hunter_actions)
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_hunter_actions() {
        'Running Hunter test'.print();

        // Deploy everything
        let (world, core_actions, hunter_actions) = deploy_world();

        core_actions.init();
        hunter_actions.init();

        let player1 = starknet::contract_address_const::<0x1337>();
        starknet::testing::set_account_contract_address(player1);

        let color = encode_color(1, 1, 1);

        hunter_actions
            .interact(
                DefaultParameters {
                    for_player: Zeroable::zero(),
                    for_system: Zeroable::zero(),
                    position: Position { x: 1, y: 1 },
                    color: color
                },
            );

        let star: felt252 = 'U+2B50';

        let pixel_1_1 = get!(world, (1, 1), (Pixel));
        assert(pixel_1_1.text == star, 'should be star');

        'Passed Hunter test'.print();
    }

    fn encode_color(r: u8, g: u8, b: u8) -> u32 {
        (r.into() * 0x10000) + (g.into() * 0x100) + b.into()
    }

    fn decode_color(color: u32) -> (u8, u8, u8) {
        let r = (color / 0x10000);
        let g = (color / 0x100) & 0xff;
        let b = color & 0xff;

        (r.try_into().unwrap(), g.try_into().unwrap(), b.try_into().unwrap())
    }
}
