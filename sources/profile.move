module sui_flash::profile;

use std::string::{Self, String};
use sui::dynamic_field;
use sui::event;
use sui::object::{Self, UID};
use sui::random::{Random, new_generator};
use sui::table::{Self, Table};
use sui::transfer;

public struct ProfileManager has key, store {
    id: UID,
    user_profiles: Table<address, ID>,
}

public struct UserProfile has key {
    id: UID,
}

public struct UserData has store {
    // id: ID,
    total_collections_created: u64,
    total_collections_owned: u64,
    collections: Table<ID, String>,
}

public struct FlashCardCollection has key, store {
    id: UID,
    name: String,
    total_flash_cards: u64,
    flashCards: Table<ID, FlashCard>,
}

public struct FlashCard has key, store {
    id: UID,
    front: String,
    back: String,
}

// Dynamic Field Keys
const USER_DATA_KEY: vector<u8> = b"USER_DATA";

// OTW
public struct PROFILE has drop {}

// errors

const E_USER_ALREADY_REGISTERED: u64 = 0;
const E_USER_NOT_REGISTERED: u64 = 1;
const E_INVALID_COLLECTION_NAME: u64 = 2;
const E_COLLECTION_NOT_FOUND: u64 = 4;
const E_INVALID_FRONT_CARD_CONTENT: u64 = 5;
const E_INVALID_BACK_CARD_CONTENT: u64 = 6;

// events

fun init(_witness: PROFILE, ctx: &mut TxContext) {
    let profile_manager = init_profile_manager(ctx);
    transfer::share_object(profile_manager);
}

entry fun register_user(profile_manager: &mut ProfileManager, ctx: &mut TxContext) {
    assert!(!profile_manager.user_profiles.contains(ctx.sender()), E_USER_ALREADY_REGISTERED);

    let user_profile = init_user_profile(ctx);

    let user_id = user_profile.id.to_inner();

    profile_manager.user_profiles.add(ctx.sender(), user_id);

    transfer::transfer(user_profile, ctx.sender());

    // emit event
}

entry fun create_new_collection(
    profile_manager: &mut ProfileManager,
    user_profile: &mut UserProfile,
    collection_name: String,
    ctx: &mut TxContext,
) {
    assert!(profile_manager.user_profiles.contains(ctx.sender()), E_USER_NOT_REGISTERED);

    assert!(string::length(&collection_name) > 0, E_INVALID_COLLECTION_NAME);

    let flash_card_collection = create_flash_card_collection(collection_name, ctx);

    // let user_id = user_profile.id.to_inner();

    let user_data = mut_get_user_data(user_profile);

    user_data.collections.add(flash_card_collection.id.to_inner(), collection_name);

    user_data.total_collections_created = user_data.total_collections_created + 1;

    user_data.total_collections_owned = user_data.total_collections_owned + 1;

    transfer::transfer(flash_card_collection, ctx.sender());
}

entry fun add_flash_card(
    profile_manager: &mut ProfileManager,
    flash_card_collection: &mut FlashCardCollection,
    user_profile: &mut UserProfile,
    collection_id: ID,
    front: String,
    back: String,
    ctx: &mut TxContext,
) {
    assert!(profile_manager.user_profiles.contains(ctx.sender()), E_USER_NOT_REGISTERED);

    assert!(string::length(&front) > 0, E_INVALID_FRONT_CARD_CONTENT);

    assert!(string::length(&back) > 0, E_INVALID_BACK_CARD_CONTENT);

    validate_flash_card_collection(collection_id, user_profile);

    let flash_card = create_flash_card(front, back, ctx);

    flash_card_collection.flashCards.add(flash_card.id.to_inner(), flash_card);

    flash_card_collection.total_flash_cards = flash_card_collection.total_flash_cards + 1;
}

// private functions

fun init_profile_manager(ctx: &mut TxContext): ProfileManager {
    let profile_manager = ProfileManager {
        id: object::new(ctx),
        user_profiles: table::new<address, ID>(ctx),
    };

    profile_manager
}

fun init_user_profile(ctx: &mut TxContext): UserProfile {
    let mut user_profile = UserProfile {
        id: object::new(ctx),
    };

    let user_data = UserData {
        total_collections_created: 0,
        total_collections_owned: 0,
        collections: table::new<ID, String>(ctx),
    };

    dynamic_field::add(&mut user_profile.id, USER_DATA_KEY, user_data);

    user_profile
}

fun create_flash_card_collection(
    collection_name: String,
    ctx: &mut TxContext,
): FlashCardCollection {
    let collection_id = object::new(ctx);

    let flash_card_collection = FlashCardCollection {
        id: collection_id,
        name: collection_name,
        total_flash_cards: 0,
        flashCards: table::new<ID, FlashCard>(ctx),
    };

    flash_card_collection
}

fun create_flash_card(front: String, back: String, ctx: &mut TxContext): FlashCard {
    let flash_card = FlashCard {
        id: object::new(ctx),
        front: front,
        back: back,
    };

    flash_card
}

// get dynamic field data from user profile
fun mut_get_user_data(user_profile: &mut UserProfile): &mut UserData {
    dynamic_field::borrow_mut<vector<u8>, UserData>(&mut user_profile.id, USER_DATA_KEY)
}

fun validate_flash_card_collection(collection_id: ID, user_profile: &mut UserProfile) {
    let user_data = mut_get_user_data(user_profile);

    assert!(table::contains(&mut user_data.collections, collection_id), E_COLLECTION_NOT_FOUND);

    // let collection_name = table::borrow(&user_data.collections, collection_id);
}
