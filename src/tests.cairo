#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use dojo::utils::test::{spawn_test_world};

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    use myapp::app::{myapp_actions, IMyAppActionsDispatcher, IMyAppActionsDispatcherTrait};
    use pixelaw::core::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};

    use pixelaw::core::models::pixel::{Pixel, PixelUpdate};
    use pixelaw::core::models::pixel::{pixel};
    use pixelaw::core::models::registry::{app, app_name, core_actions_address};
    use pixelaw::core::tests::helpers::{
        setup_core, setup_core_initialized, setup_apps, setup_apps_initialized, ZERO_ADDRESS,
        set_caller, drop_all_events, TEST_POSITION, WHITE_COLOR, RED_COLOR
    };
    use pixelaw::core::utils::{
        get_core_actions, encode_rgba, decode_rgba, Direction, Position, DefaultParameters
    };
    use starknet::class_hash::Felt252TryIntoClassHash;

    use zeroable::Zeroable;

    fn deploy_app(world: IWorldDispatcher) -> IMyAppActionsDispatcher {
        // Deploy MyApp actions
        let myapp_actions_address = world
            .deploy_contract('salt2', myapp_actions::TEST_CLASS_HASH.try_into().unwrap());

        IMyAppActionsDispatcher { contract_address: myapp_actions_address }
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_myapp_actions() {
        // Deploy everything
        let (world, _core_actions, player_1, _player_2) = setup_core_initialized();

        // Deploy MyApp actions
        let myapp_actions = deploy_app(world);

        myapp_actions.init();

        set_caller(player_1);
        let color = encode_rgba(1, 1, 1, 1);

        myapp_actions
            .interact(
                DefaultParameters {
                    player_override: Option::None,
                    system_override: Option::None,
                    position: Position { x: 1, y: 1 },
                    color: color,
                    area_hint: Option::None
                },
            );

        let pixel_1_1 = get!(world, (1, 1), (Pixel));
        assert(pixel_1_1.color == color, 'should be the color');

        'Passed test'.print();
    }
}
