use pixelaw::core::utils::{DefaultParameters};


#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Player {
    #[key]
    pub id: u64,
    pub score: u64,
}

#[derive(Copy, Drop, Serde)]
#[dojo::event]
pub struct Highscore {
    #[key]
    player_id: u64,
    score: u64,
}


#[starknet::interface]
pub trait IMyAppActions<T> {
    fn init(ref self: T);
    fn interact(ref self: T, default_params: DefaultParameters);
}

/// contracts must be named as such (APP_KEY + underscore + "actions")
#[dojo::contract]
pub mod myapp_actions {
    use dojo::model::{ModelStorage};
    use myapp::constants::{APP_ICON, APP_KEY};
    use pixelaw::core::actions::{IActionsDispatcherTrait as ICoreActionsDispatcherTrait};
    use pixelaw::core::models::pixel::{Pixel, PixelUpdate};
    use pixelaw::core::utils::{DefaultParameters, get_callers, get_core_actions};
    use starknet::{contract_address_const};
    use super::IMyAppActions;


    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl ActionsImpl of IMyAppActions<ContractState> {
        /// Initialize the MyApp App
        fn init(ref self: ContractState) {
            let mut world = self.world(@"pixelaw");
            let core_actions = pixelaw::core::utils::get_core_actions(ref world);
            core_actions.new_app(contract_address_const::<0>(), APP_KEY, APP_ICON);
        }

        /// Put color on a certain position
        ///
        /// # Arguments
        ///
        /// * `position` - Position of the pixel.
        /// * `new_color` - Color to set the pixel to.
        fn interact(ref self: ContractState, default_params: DefaultParameters) {
            let mut world = self.world(@"pixelaw");
            // Load important variables
            let core_actions = get_core_actions(ref world);
            let position = default_params.position;
            let (player, system) = get_callers(ref world, default_params);

            // Load the Pixel

            let mut pixel: Pixel = world.read_model((position.x, position.y));

            // TODO: Load MyApp App Settings like the fade steptime
            // For example for the Cooldown feature
            let COOLDOWN_SECS = 5;

            // Check if 5 seconds have passed or if the sender is the owner
            assert(
                pixel.owner == contract_address_const::<0>()
                    || (pixel.owner) == player
                    || starknet::get_block_timestamp()
                    - pixel.timestamp < COOLDOWN_SECS,
                'Cooldown not over',
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
