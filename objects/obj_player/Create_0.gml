/// @description Player Create Event
friction=0.2;
surf = noone;
can_move = true;
is_moving = false;
has_moved = false;
move_speed_max = 5;
move_speed_right = 3;
move_speed_left = 3;
move_speed_up = 3;
move_speed_down = 3;
speed_increment = 0.6;
frozen_timer = 0;
frozen = false;
frozen_index = 0;
frozen_max_animate = 0;
frozen_image_speed = 0.2;
// Attack animation control
click_cooldown = 5;
click_timer = 0;
attacking = false;
attack_timer = 0;
max_attack_timer = 20;
attack_hold_time = room_speed / 10; // 100ms hold
attack_step = 0; // 0 -> (0,1), 1 -> (2,3), 2 -> (4,5)
max_attack_steps = 3; // Loops from 0 to 2
attack_leg_index = 0;
attack_image_index = 0;

//charge
charge_timer=0;
max_charge_timer=20;
charging = false;
first_attack = true
charge = 0;               // How much charge has been built up
charge_max_length = 50;   // Maximum charge time
charge_speed = 2;         // How fast charge increases
charging = false;         // Is the player holding charge?
max_scale = 10;            // Max stretch factor for the arrow
// Charge Attack Variables
charge_attack_melee = false;
charge_attack_distance = 0;  // Total distance to move
charge_attack_travelled = 0; // Track how far we've moved
charge_attack_speed = 0;
charge_attack_direction = 0;
charging_index = 0;
charge_attack_freeze_timer = 0;
charge_cooldown=false;
charge_freeze=30;
friction = 1; // Slowdown 
// Afterimage effect
afterimage_count = 10; // Number of afterimages
afterimages = array_create(afterimage_count, [x, y, 1]); // Array of positions & opacity

//atom
atom_index = 0;
atom_spawned = false;
atom_timer=0;
max_atom_timer= max_attack_timer*2;
atom_image_speed = 0.1;

//dash
dash_speed = 0;      // Speed boost during dashing
dash_timer = 0;      // Countdown timer for dash duration
dash_duration = 10;  // Frames the dash lasts (adjust as needed)
dash_power = 6;      // Speed increase during dash
force_dash = false;

// Base Dodge Stats
base_dodge_speed = 8;  // Base speed of the dodge
base_dodge_duration =8; // Base dodge duration
dodge_speed = base_dodge_speed;  
dodge_duration = base_dodge_duration; 
dodge_timer = 0;  // Timer for the dodge
dodging = false;  // Flag to track if dodging
dodge_cooldown=0;
free_dodge = 2;  // Number of free dodges before penalties apply
dodge_penalty = 0; // Penalty counter (increases with spam)
dodge_recovery_rate = 0.1; // Rate of dodge recovery over time
min_dodge_duration = 2; 
min_dodge_speed = 2; 

// Image speed settings
image_speed_moving = 0.8;
image_speed_idle = 0.3;
image_speed_attacking = 1;

// Default facing direction (left/right/up/down)
facing_direction = "down"; // Default to facing downward

// Default full-body sprite
sprite_full = character_idle_front; // Can be idle or running
sprite_frozen = NaN;


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

function decreaseSpeed(some_speed) {
    return some_speed > 0 ? some_speed - speed_increment : 0;
}

// Function to increase speed but cap it at max speed
function increaseSpeed(some_speed) {
    return some_speed < move_speed_max ? some_speed + speed_increment : move_speed_max;
}

// Function to increase speed for diagonal movement (scaled by sqrt(2))
function increaseDiagonalSpeed(some_speed) {
    maxDiagonalSpeed = move_speed_max / sqrt(2);
    return some_speed < maxDiagonalSpeed ? some_speed + speed_increment : maxDiagonalSpeed;
}
