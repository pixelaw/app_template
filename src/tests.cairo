use dojo::model::{ModelStorage};
use dojo::world::{IWorldDispatcherTrait, WorldStorage, WorldStorageTrait};

use dojo_cairo_test::{
    ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
};
use myapp::app::{IMyAppActionsDispatcher, IMyAppActionsDispatcherTrait, m_ClickGame, myapp_actions};
use pixelaw::core::models::pixel::{Pixel};


use pixelaw::core::utils::{DefaultParameters, Position, encode_rgba};
use pixelaw_testing::helpers::{set_caller, setup_core, update_test_world};


fn deploy_app(ref world: WorldStorage) -> IMyAppActionsDispatcher {
    // NOTE: as far as i understand you need to also register namespace here:
    let namespace = "myapp";

    world.dispatcher.register_namespace(namespace.clone());

    let ndef = NamespaceDef {
        namespace: namespace.clone(),
        resources: [
            TestResource::Model(m_ClickGame::TEST_CLASS_HASH),
            TestResource::Contract(myapp_actions::TEST_CLASS_HASH),
        ]
            .span(),
    };
    let cdefs: Span<ContractDef> = [
        ContractDefTrait::new(@namespace, @"myapp_actions")
            .with_writer_of([dojo::utils::bytearray_hash(@namespace)].span())
    ]
        .span();

    update_test_world(ref world, [ndef].span());

    world.sync_perms_and_inits(cdefs);

    // Set the namespace so the myapp_actions can be found
    world.set_namespace(@namespace);

    let myapp_actions_address = world.dns_address(@"myapp_actions").unwrap();

    // Set the namespace back to pixelaw so everything still works afterwards
    world.set_namespace(@"pixelaw");

    IMyAppActionsDispatcher { contract_address: myapp_actions_address }
}

#[test]
fn test_myapp_actions() {
    // Deploy everything
    let (mut world, _core_actions, player_1, _player_2) = setup_core();
    //println!("Started test");
    set_caller(player_1);
    
    println!("1");
    // Deploy MyApp actions
    let myapp_actions = deploy_app(ref world);


    let color = encode_rgba(1, 1, 1, 1);
    let position = Position { x: 1, y: 1 };
    myapp_actions
        .interact(
            DefaultParameters {
                player_override: Option::None,
                system_override: Option::None,
                area_hint: Option::None,
                position,
                color: color,
            },
        );

    let pixel_1_1: Pixel = world.read_model(position);

    assert(pixel_1_1.color == color, 'should be the color');
    //println!("Passed test");
}

