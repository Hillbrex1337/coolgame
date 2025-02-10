// Pull obj_movable towards obj_player
x_start = owner.x;
y_start = owner.y;
x = owner.x;
y = owner.y;

with (obj_movable) {
    is_hit = false;
}


with (obj_mirror) {
    is_hit = false;
}


if (!pulling && beam_distance <= beam_distance_max) {
    beam_distance = floor(beam_distance+growth_increment);
}

if (!pulling && mirror_beam_distance <= beam_distance_max) {
    mirror_beam_distance = floor(mirror_beam_distance+growth_increment);
}

// Define the beam's start and end positions
var beam_x_start = x_start;
var beam_y_start = y_start;
var beam_x_end = x_start + lengthdir_x(beam_distance, point_direction(x_start, y_start, mouse_x, mouse_y));
var beam_y_end = y_start + lengthdir_y(beam_distance, point_direction(x_start, y_start, mouse_x, mouse_y));

// Initialize reflection variables

// Create lists for both collision checks
var mov_list = ds_list_create();
var mir_list = ds_list_create();

// Get all obj_movable instances in the beam path
var mov_hits = collision_line_list(beam_x_start, beam_y_start, beam_x_end, beam_y_end, obj_movable, false, true, mov_list, true);

// Get all obj_mirror instances in the beam path
var mir_hits = collision_line_list(beam_x_start, beam_y_start, beam_x_end, beam_y_end, obj_mirror, false, true, mir_list, true);

mirror_hit = noone; // Store mirror collision separately

// If we hit a mirror and the mov_hits+player <2 (we always hit the player so must do it like this)
if (mir_hits > 0 && mov_hits <2) {
    mirror_hit = ds_list_find_value(mir_list, 0);
}

// Clean up lists
ds_list_destroy(mov_list);
ds_list_destroy(mir_list);



if (mirror_hit) {
    reflected = true;
    reflect_x = beam_x_end;
    reflect_y = beam_y_end;
	with(mirror_hit){
		var distance = point_distance(x, y, other.x, other.y);
		is_hit=true;
		x_hit=beam_x_end;
		y_hit=beam_y_end;
		other.beam_distance = distance;
	}

   // Get mirror angle
	var mirror_angle = mirror_hit.image_angle;

	// Compute beam direction
	var beam_dir = point_direction(beam_x_start, beam_y_start, beam_x_end, beam_y_end);

	// Calculate reflection direction
	var reflection_dir = 2 * mirror_angle - beam_dir;

	// **Check if reflection angle is too steep**
	var mirror_front = mirror_hit.front_direction; // Defined in obj_mirror
    var mirror_back = mirror_front + 180; // Back is opposite direction
	var approach_angle = angle_difference(beam_dir, mirror_front);
	show_debug_message("approach_angle " + string(approach_angle));
    // Ensure beam is hitting the front side
    if (approach_angle <0) {
	    show_debug_message("Reflection canceled: Angle too steep!");
	    reflected = false; // Cancel reflection
	} else {
	    // Apply normal reflection logic
	    reflected = true;
	    reflect_x = beam_x_end;
	    reflect_y = beam_y_end;

	    beam_x_start = reflect_x;
	    beam_y_start = reflect_y;
	    beam_x_end = reflect_x + lengthdir_x(mirror_beam_distance, reflection_dir);
	    beam_y_end = reflect_y + lengthdir_y(mirror_beam_distance, reflection_dir);
	}

} else {
	reflected=false;
}

// Check for collision with obj_movable (after possible reflection)
// Create a list to store collisions
var hit_list = ds_list_create();

// Get all obj_movable instances in the beam path
var num_hits = collision_line_list(beam_x_start, beam_y_start, beam_x_end, beam_y_end, obj_movable, false, true, hit_list, true);

hit = noone; // Default to no collision

if (num_hits > 0) {
    show_debug_message("Objects hit: " + string(num_hits));  // Print the total number of hits
    for (var i = 0; i < ds_list_size(hit_list); i++) {
        var instance_hit = ds_list_find_value(hit_list, i);
        
        show_debug_message("Hit: " + string(instance_hit) + " - Object Name: " + object_get_name(instance_hit.object_index));

        // Ignore obj_player unless the beam has already reflected
       if (instance_hit.object_index == obj_player && !reflected) {
	    show_debug_message("Ignoring player: " + string(instance_hit));
	    continue;
	}

        // First valid hit will be the one used
        hit = instance_hit;
        break;
    }
}

// Clean up the list after use
ds_list_destroy(hit_list);

// If the beam hits an object, handle pulling logic
if (hit) {
    with (hit) {
		if(!only_mirror){
			show_debug_message("not only_mirror!");
			other.pulling = true;
			if (other.reflected) {
				var distance = point_distance(x, y, other.reflect_x, other.reflect_y);
				other.mirror_beam_distance= distance;
			}
			else {
				var distance = point_distance(x, y, other.x, other.y);
				other.beam_distance = distance;
			
			}
			x_hit=beam_x_end;
			y_hit=beam_y_end;
	        is_hit = true;


	        // Apply pull force
	        var pull_force = (distance >= 5) ? 1 : 0;

	        // Determine pull direction
	        var pull_target_x = other.reflected ? other.reflect_x : obj_tractor_beam.x;
	        var pull_target_y = other.reflected ? other.reflect_y : obj_tractor_beam.y;
	        var dir = point_direction(x, y, pull_target_x, pull_target_y);

	        // Move object towards the appropriate point
	        x += lengthdir_x(pull_force, dir);
	        y += lengthdir_y(pull_force, dir);
		} else if(other.reflected){
			other.pulling = true;
			if (other.reflected) {
				var distance = point_distance(x, y, other.reflect_x, other.reflect_y);
				other.mirror_beam_distance= distance;
			}
			else {
				var distance = point_distance(x, y, other.x, other.y);
				other.beam_distance = distance;
			
			}
			x_hit=beam_x_end;
			y_hit=beam_y_end;
	        is_hit = true;


	        // Apply pull force
	        var pull_force = (distance >= 5) ? 1 : 0;

	        // Determine pull direction
	        var pull_target_x = other.reflected ? other.reflect_x : obj_tractor_beam.x;
	        var pull_target_y = other.reflected ? other.reflect_y : obj_tractor_beam.y;
	        var dir = point_direction(x, y, pull_target_x, pull_target_y);

	        // Move object towards the appropriate point
	        x += lengthdir_x(pull_force, dir);
	        y += lengthdir_y(pull_force, dir);
		} else {
			other.pulling = false;
		}
    }
} else {
    pulling = false;
}
