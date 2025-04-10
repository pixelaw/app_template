use pixelaw::core::utils::{DefaultParameters, Position};
use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct ClickGame {
    #[key]
    position: Position,
    pub last_player: ContractAddress,
}


#[starknet::interface]
pub trait IMyAppActions<T> {
    fn interact(ref self: T, default_params: DefaultParameters);
}

/// contracts must be named as such (APP_KEY + underscore + "actions")
#[dojo::contract]
pub mod myapp_actions {
    use dojo::model::{ModelStorage};
    use myapp::constants::{APP_ICON, APP_KEY};
    use pixelaw::core::actions::{IActionsDispatcherTrait as ICoreActionsDispatcherTrait};
    use pixelaw::core::models::pixel::{Pixel, PixelUpdate, PixelUpdateResultTraitImpl};
    use pixelaw::core::utils::{DefaultParameters, get_callers, get_core_actions};
    use starknet::{contract_address_const};
    use super::{ClickGame, IMyAppActions};

    /// Initialize the MyApp App
    fn dojo_init(ref self: ContractState) {
        let mut world = self.world(@"pixelaw");
        let core_actions = pixelaw::core::utils::get_core_actions(ref world);
        core_actions.new_app(contract_address_const::<0>(), APP_KEY, APP_ICON);
    }

    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl ActionsImpl of IMyAppActions<ContractState> {
        /// Put color on a certain position
        ///
        /// # Arguments
        ///
        /// * `position` - Position of the pixel.
        /// * `new_color` - Color to set the pixel to.
        fn interact(ref self: ContractState, default_params: DefaultParameters) {
            let mut core_world = self.world(@"pixelaw");
            let mut app_world = self.world(@"myapp");

            // Load important variables
            let core_actions = get_core_actions(ref core_world);
            let (player, system) = get_callers(ref core_world, default_params);

            let position = default_params.position;

            // Load the Pixel
            let mut pixel: Pixel = core_world.read_model(position);
            let mut game: ClickGame = app_world.read_model(position);

            // Check that its not the same player clicking
            assert!(
                game.last_player == contract_address_const::<0>() || game.last_player == player,
                "{:?}_{:?} Let someone else first!",
                position.x,
                position.y,
            );

            game.last_player = player;
            app_world.write_model(@game);

            // Increment the number in pixel.text
            let mut current_count: u64 = pixel.text.try_into().unwrap();
            current_count = (current_count + 1).into();

            // We can now update color of the pixel
            core_actions
                .update_pixel(
                    player,
                    system,
                    PixelUpdate {
                        position,
                        color: Option::Some(default_params.color),
                        timestamp: Option::None,
                        text: Option::Some(current_count.into()),
                        app: Option::Some(system),
                        owner: Option::Some(player),
                        action: Option::None // Not using this feature for myapp
                    },
                    default_params.area_hint, // area_hint
                    false // hook_can_modify
                )
                .unwrap();
        }
    }
}
