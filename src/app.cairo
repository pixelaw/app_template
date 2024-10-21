use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use pixelaw::core::utils::{DefaultParameters};


#[dojo::interface]
pub trait IMyAppActions<TContractState> {
    fn init(ref world: IWorldDispatcher);
    fn interact(ref world: IWorldDispatcher, default_params: DefaultParameters);
}

/// contracts must be named as such (APP_KEY + underscore + "actions")
#[dojo::contract(namespace: "pixelaw", nomapping: true)]
pub mod myapp_actions {
    use debug::PrintTrait;
    use myapp::constants::{APP_KEY, APP_ICON};
    use pixelaw::core::actions::{
        IActionsDispatcher as ICoreActionsDispatcher,
        IActionsDispatcherTrait as ICoreActionsDispatcherTrait
    };

    use pixelaw::core::models::pixel::{Pixel, PixelUpdate};
    use pixelaw::core::utils::{
        get_callers, get_core_actions, Direction, Position, DefaultParameters
    };
    use starknet::{
        get_tx_info, get_caller_address, get_contract_address, get_execution_info,
        contract_address_const, ContractAddress
    };

    use super::IMyAppActions;

    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl ActionsImpl of IMyAppActions<ContractState> {
        /// Initialize the MyApp App (TODO I think, do we need this??)
        fn init(ref world: IWorldDispatcher) {
            let core_actions = pixelaw::core::utils::get_core_actions(world);
            core_actions.new_app(contract_address_const::<0>(), APP_KEY, APP_ICON);
        }

        /// Put color on a certain position
        ///
        /// # Arguments
        ///
        /// * `position` - Position of the pixel.
        /// * `new_color` - Color to set the pixel to.
        fn interact(ref world: IWorldDispatcher, default_params: DefaultParameters) {
            // Load important variables
            let core_actions = get_core_actions(world);
            let position = default_params.position;
            let (player, system) = get_callers(world, default_params);

            // Load the Pixel
            let mut pixel = get!(world, (position.x, position.y), (Pixel));

            // TODO: Load MyApp App Settings like the fade steptime
            // For example for the Cooldown feature
            let COOLDOWN_SECS = 5;

            // Check if 5 seconds have passed or if the sender is the owner
            assert(
                pixel.owner.is_zero() || (pixel.owner) == player || starknet::get_block_timestamp()
                    - pixel.timestamp < COOLDOWN_SECS,
                'Cooldown not over'
            );

            // We can now update color of the pixel
            core_actions
                .update_pixel(
                    player,
                    system,
                    PixelUpdate {
                        x: position.x,
                        y: position.y,
                        color: Option::Some(default_params.color),
                        timestamp: Option::None,
                        text: Option::None,
                        app: Option::Some(system),
                        owner: Option::Some(player),
                        action: Option::None // Not using this feature for myapp
                    },
                    default_params.area_hint, // area_hint
                    false // hook_can_modify
                );
        }
    }
}
