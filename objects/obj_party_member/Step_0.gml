
/// Step Event of obj_party_member

// Check if the party member has a target position
/// Step Event of obj_party_member

// Check if the Enter key is pressed to disable battle_mode (for debugging)
/// Step Event of obj_party_member


// Check if the game is in battle mode
if (!global.battle_mode) {
    // Move towards the original position stored in the party member object
    speed = 4;  // Adjust the speed to control how fast the party member moves back
    move_towards_point(original_x, original_y, speed);
	global.spawn_followers_at_player = false;
    // Check if the party member has reached the original position
    if (point_distance(x, y, original_x, original_y) < speed) {
        // If this is the last party member, recreate the player at this party member's original position
        if (is_player) {
            var player_instance=instance_create_layer(original_x, original_y, "Player", obj_player);
			player_instance. sprite_index=original_sprite;
        }
		else {
			sprite = global.party_members[? key].sprite;
			var follower_instance = instance_create_layer(original_x, original_y, "Player", obj_follower);
            follower_instance.sprite_index = sprite;
			follower_instance.record = record;
		}
		instance_destroy();
        // Destroy the party member once it reaches its original position
    }
}



if (target_x != noone && target_y != noone) {
    // Move smoothly towards the target position
    speed = 4;  // Adjust the speed to control how fast the party member moves
    move_towards_point(target_x, target_y, speed);

    // Optionally, check if the party member has reached the target position and stop
    if (point_distance(x, y, target_x, target_y) < speed) {
        // Stop moving once close to the target
        target_x = noone;
        target_y = noone;
        speed = 0;
    }
}




