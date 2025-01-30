global.battle_mode = false;
global.spawn_followers_at_player = true;

// Create a ds_map to store party members with their names as keys
global.party_members = ds_map_create();

// Add members to the map
ds_map_add(global.party_members, "mira", {name: "Alice", sprite: character_idle_front, attack_speed: 1.2});
//ds_map_add(global.party_members, "temp1", {name: "Bob", sprite: arboga, attack_speed: 2.5});
//ds_map_add(global.party_members, "temp2", {name: "Charlie", sprite: alien, attack_speed: 2});