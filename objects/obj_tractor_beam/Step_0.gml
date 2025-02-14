// Ensure obj_player exists before proceeding

var player = obj_player;
if (!instance_exists(player)) exit;

// Define the origin at the player's position
var start_x = player.x;
var start_y = player.y;

with (obj_movable) {
    is_pushed = false;
	is_pulled = false;
}


with (obj_mirror) {
     is_pushed = false;
	 is_pulled = false;
}

// Get the correct direction towards the mouse
direction = point_direction(start_x, start_y, mouse_x, mouse_y);

// Reset the beam path to start from the player
beam_path = [];
array_push(beam_path, [start_x, start_y]);  // Store the starting point

// Initialize movement variables
var current_x = start_x;
var current_y = start_y; // Maximum beam range
var segment_length = 10; // Length of each step

// Incremental beam growth

// Beam speed control
var beam_growth_speed = 10;  // Lower = slower beam growth (default was 20)
beam_length = min(beam_length + beam_growth_speed, max_distance);

moving = true;
target = noone;
reflected = false;

var travel_distance = 0;

while (moving && travel_distance < beam_length) {
	with (obj_movable) {
	    is_pushed = false;
		is_pulled = false;
	}
	
    var prev_x = current_x;
    var prev_y = current_y;

    // Move in the current direction
    current_x += lengthdir_x(segment_length, direction);
    current_y += lengthdir_y(segment_length, direction);
    travel_distance += segment_length;

    // Check for collision with obj_mirror
    var mirror_hit = instance_place(current_x, current_y, obj_mirror);
    if (mirror_hit) {
		if(repelling) {
			mirror_hit.is_pushed = true;
		} else {
			mirror_hit.is_pulled=true;
		}
		mirror_hit.x_hit=current_x;
		mirror_hit.y_hit=current_y;
        var mirror_angle = mirror_hit.image_angle;
        var beam_dir = point_direction(prev_x, prev_y, current_x, current_y);
        direction = 2 * mirror_angle - beam_dir;

        array_push(beam_path, [current_x, current_y]); // Store mirror bounce point
        reflected = true;
    }

    // Check for collision with obj_movable
    var mov_hit = instance_place(current_x, current_y, obj_movable);
    if (mov_hit) {
		if(repelling) {
			mov_hit.is_pushed = true;
		} else {
			mov_hit.is_pulled=true;
		}
		mov_hit.x_hit=current_x;
		mov_hit.y_hit=current_y;
        if (mov_hit.only_mirror && !reflected) {
            // Ignore obj_player unless beam has reflected
        } else {
            moving = false;
            target = mov_hit;
            array_push(beam_path, [current_x, current_y]); // Store impact point
        }
    }
}

// Store final beam endpoint if no objects hit
if (moving) {
    array_push(beam_path, [current_x, current_y]);
}

// Pull speed control
var pull_speed = 0.3;  // Lower = slower pull speed (default was instant)

// If pulling an object, move it back gradually
// If affecting an object, either pull or repel based on setting
if (!moving && target != noone) {
    if (repelling) {
	    var origin_x = start_x;
	    var origin_y = start_y;

	    // If the target is the player, find the last mirror reflection point
	    if (target.object_index == obj_player) {
			show_debug_message("hitting player");
	        if (array_length(beam_path) > 1) {
	            var last_mirror_index = array_length(beam_path) - 2;
	            origin_x = beam_path[last_mirror_index][0];
	            origin_y = beam_path[last_mirror_index][1];
	        }
	    }

	    // Calculate distance from the correct origin (either player or last mirror)
	    var dist_to_origin = point_distance(target.x, target.y, origin_x, origin_y);
		show_debug_message("dist_to_origin " + string(dist_to_origin));
	    // Amplify repelling strength so it's much stronger
	    var repel_factor = clamp(3 + (1300/dist_to_origin ), 3, 13);
		
		show_debug_message("repel_factor " + string(repel_factor));
	    // Increase base push force
	    var repel_distance = 10 * repel_factor; // Boost from 15 to 18 for extra force
		
		show_debug_message("repel_distance " + string(repel_distance));

	    // Calculate target position further along the beam's direction
	    var target_x = target.x + lengthdir_x(repel_distance, direction);
	    var target_y = target.y + lengthdir_y(repel_distance, direction);

	    // Smoothly interpolate towards the target position
	    target.x = lerp(target.x, target_x, pull_speed / 7.0); // Lower divisor for more push power
	    target.y = lerp(target.y, target_y, pull_speed / 7.0);
	} else {
        // Pull behavior
        if (array_length(beam_path) > 1) {
            var next_pos = beam_path[array_length(beam_path) - 2];  // Get previous position

            // Move gradually instead of instantly jumping
            target.x = lerp(target.x, next_pos[0], pull_speed / 10.0);
            target.y = lerp(target.y, next_pos[1], pull_speed / 10.0);

            // If close enough to the point, remove it from the path
            if (point_distance(target.x, target.y, next_pos[0], next_pos[1]) < 2) {
                array_resize(beam_path, array_length(beam_path) - 1);
            }
            if (beam_length < 10) {
                instance_destroy();
            }
        } else {
            target = noone;
        }
    }
}


