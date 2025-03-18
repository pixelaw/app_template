mod tests {
    use debug::PrintTrait;

    use dojo::model::{ModelStorage};
    use dojo::world::{
        world, IWorldDispatcher, IWorldDispatcherTrait, WorldStorageTrait, WorldStorage
    };
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef,
        WorldStorageTestTrait
    };
    use myapp::app::{
        myapp_actions, IMyAppActionsDispatcher, IMyAppActionsDispatcherTrait, m_Player, Player,
        e_Highscore
    };
    use pixelaw::core::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use pixelaw::core::models::pixel::{Pixel, PixelUpdate};
    use pixelaw::core::models::registry::{App, AppName, CoreActionsAddress};

    use pixelaw::core::utils::{
        get_core_actions, encode_rgba, decode_rgba, Direction, Position, DefaultParameters
    };
    use pixelaw::tests::test_helpers::{
        update_test_world, setup_core, setup_core_initialized, setup_apps, setup_apps_initialized,
        ZERO_ADDRESS, set_caller, drop_all_events, TEST_POSITION, WHITE_COLOR, RED_COLOR
    };
    use starknet::class_hash::Felt252TryIntoClassHash;

    use zeroable::Zeroable;


    fn deploy_app(ref world: WorldStorage) -> IMyAppActionsDispatcher {
        let ndef = NamespaceDef {
            namespace: "pixelaw", resources: [
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Event(e_Highscore::TEST_CLASS_HASH),
                TestResource::Contract(myapp_actions::TEST_CLASS_HASH),
            ].span()
        };

        let cdefs: Span<ContractDef> = [
            ContractDefTrait::new(@"pixelaw", @"myapp_actions")
                .with_writer_of([dojo::utils::bytearray_hash(@"pixelaw")].span())
        ].span();

        update_test_world(ref world, [ndef].span());

        world.sync_perms_and_inits(cdefs);

        let (myapp_actions_address, _) = world.dns(@"myapp_actions").unwrap();
        IMyAppActionsDispatcher { contract_address: myapp_actions_address }
    }

    #[test]
    #[available_gas(3000000000)]
    fn test_myapp_actions() {
        // Deploy everything
        let (mut world, _core_actions, player_1, _player_2) = setup_core_initialized();

        // Deploy MyApp actions
        let myapp_actions = deploy_app(ref world);

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

        let pixel_1_1: Pixel = world.read_model((1, 1));
        assert(pixel_1_1.color == color, 'should be the color');

        'Passed test'.print();
    }
}
