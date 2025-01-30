/// @description Player Create Event
can_move = true;
is_moving = false;
has_moved = false;
move_speed = 5;
// Attack animation control
attacking = false;
attack_timer = 0;
attack_hold_time = room_speed / 10; // 100ms hold
attack_step = 0; // 0 -> (0,1), 1 -> (2,3), 2 -> (4,5)
max_attack_steps = 3; // Loops from 0 to 2
attack_leg_index = 0;
attack_image_index = 0;


// Image speed settings
image_speed_moving = 0.8;
image_speed_idle = 0.3;
image_speed_attacking = 1;

// Default facing direction (left/right/up/down)
facing_direction = "down"; // Default to facing downward

// Default full-body sprite
sprite_full = character_idle_front; // Can be idle or running

// Split-body sprites (used only during attacks)
sprite_upper = character_melee_left;
sprite_lower = character_melee_legs_left;

// Follower logic
array_size = 94;
for (var i = array_size - 1; i >= 0; i--) {
    saved_pos_x[i] = x - i * 3;
    saved_pos_y[i] = y;
}

// Flag to indicate whether party members have been initialized
party_members_initialized = false;

// Create followers if party members are initialized
if (!party_members_initialized && global.spawn_followers_at_player) {
    if (variable_global_exists("party_members")) {
        var party_members = global.party_members;

        if (ds_exists(party_members, ds_type_map)) {
            show_debug_message("party_members is a valid ds_map");

            var map_size = ds_map_size(party_members);
            show_debug_message("party_members size: " + string(map_size));

            if (map_size > 0) {
                var record_value = 7;
                var index = 0;
                var key = ds_map_find_first(party_members);

                while (key != undefined) {
                    var member = party_members[? key];

                    if (index == 0) {
                        index++;
                        key = ds_map_find_next(party_members, key);
                        continue;
                    }

                    var follower_instance = instance_create_layer(saved_pos_x[record_value], y, "Player", obj_follower);
                    follower_instance.sprite_index = member.sprite;
                    follower_instance.record = record_value;

                    record_value += 7;
                    index++;
                    key = ds_map_find_next(party_members, key);
                }

                party_members_initialized = true;
            } else {
                show_debug_message("party_members is empty.");
            }
        } else {
            show_debug_message("party_members is not a valid ds_map.");
        }
    } else {
        show_debug_message("global.party_members is not initialized.");
    }
}
