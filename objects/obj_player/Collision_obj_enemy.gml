/// In obj_player Collision Event with obj_enemy

// Start battle sequence
scr_battle_start(self, other);  // Pass 'self' (the player) and 'other' (the enemy)

// Initialize a global array to store player and follower positions
global.follower_positions = [];  // Use a global array to persist follower positions


// Save the player's position
array_push(global.follower_positions, [x, y]);

// Loop through all followers to store their positions
with (obj_follower) {
    array_push(global.follower_positions, [x, y]);  // Store each follower's position (their x and y)
}

// Destroy all followers
with (obj_follower) {
    instance_destroy();
}

// Destroy the player object
instance_destroy();

// Radius for the circle around the enemy
var radius = 100;  // Adjust this value to set how far the party members will be from the enemy

// Check if global.party_members is initialized
if (ds_exists(global.party_members, ds_type_map)) {
    var keys = ds_map_find_first(global.party_members);
    var i = 0; // This will be used to access the corresponding position in global.follower_positions
    var record = 7;

    // Loop through the map using ds_map_find_next
    while (keys != undefined) {
        var member_data = global.party_members[? keys];
        
        // Make sure there is enough data in follower_positions
        if (i < array_length(global.follower_positions)) {
            var position = global.follower_positions[i];  // Access the saved position
            var x_position = position[0];
            var y_position = position[1];

            // Create the party member at the saved position
            var party_member_instance = instance_create_layer(x_position, y_position, "Player", obj_party_member);

            // Set the party member's sprite and name based on the data in global.party_members
            party_member_instance.sprite_index = member_data.sprite;
            party_member_instance.name = member_data.name;
            party_member_instance.key = keys;

            // Store the party member's original position directly in the object
            party_member_instance.original_x = x_position;
            party_member_instance.original_y = y_position;

            if (keys == "mira") {
                party_member_instance.is_player = true;
				party_member_instance.original_sprite = sprite_index;
            }
            party_member_instance.record = record;
			party_member_instance.attack_speed = member_data.attack_speed

            // Generate a random angle for each party member
            var angle = random_range(0, 360);

            // Calculate the target x and y positions on the circle around obj_enemy
            var target_x = obj_enemy.x + lengthdir_x(radius, angle);
            var target_y = obj_enemy.y + lengthdir_y(radius, angle);

            // Store the target position on the party member object
            party_member_instance.target_x = target_x;
            party_member_instance.target_y = target_y;

            i++;  // Move to the next saved position
            record += 7;
        } else {
            show_debug_message("Error: Not enough positions stored in follower_positions.");
            break;
        }

        // Move to the next key in the map
        keys = ds_map_find_next(global.party_members, keys);
    }
} else {
    show_debug_message("Error: global.party_members is not initialized or valid.");
}
