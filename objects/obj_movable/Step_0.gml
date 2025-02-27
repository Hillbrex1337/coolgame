/// @description Insert description here
// You can write your code in this editor
if (!variable_instance_exists(id, "aura_index")) {
    aura_index = 0; // Ensure it's initialized
}

if (!variable_instance_exists(id, "z")) {
    z = 0; // Ensure it's initialized
}

if (!variable_instance_exists(id, "z_speed")) {
    z_speed = 20; // Ensure it's initialized
}


if (!variable_instance_exists(id, "only_mirror")) {
    only_mirror=false; // Ensure it's initialized
}

if (is_hit){
	aura_index += image_speed;
	if (floor(aura_index >= 5)){
		aura_index = 0;
	}
}
var height_layer = layer_tilemap_get_id("height_map_tiles");
var new_height=tilemap_get_at_pixel(height_layer, x, y+collision_box_bottom);
if(new_height < height){
	var slope_layer = layer_tilemap_get_id("climbing_tiles");
	var on_slope=tilemap_get_at_pixel(slope_layer, x, y+collision_box_bottom);
	show_debug_message("on_slope is: " + string(on_slope));
	if(on_slope == 0)
		about_to_jump=true;
}

if (about_to_jump && !falling) {
    // Move down initially
    z = 64;
	jump_angle = radtodeg(arctan2(vmove, hmove));
	about_to_jump=false;
    // Keep falling until we find the second ground tile
  
}
height=new_height;

// Assuming 'platform_tiles' is the tilemap layer and 'old_height' is a predefined variable



// Tilemap and settings
var _tilemap = layer_tilemap_get_id("collision_tiles_" + string(old_height));
var tile_size = 1; // 1px tiles for precision

// Target positions
var future_x = x + hmove;
var future_y = y + vmove;

// Collision flags
collision_detected_x = false;
collision_detected_y = false;

// Maximum step size to prevent tunneling (e.g., 1px per step)
var max_step_size = 1;

//////////////////////
// Horizontal Movement (Check Left, Right, Top, and Bottom)
//////////////////////
if (abs(hmove) > 0) {
    var total_distance_x = abs(future_x - x);
    var steps_x = max(1, ceil(total_distance_x / max_step_size));
    var step_x = (future_x - x) / steps_x;

    for (var i = 0; i < steps_x; i++) {
        var next_x = x + step_x;

        var step_direction_x = (hmove > 0) ? 1 : -1;
        var side_x = (hmove > 0) ? collision_box_right : collision_box_left;

        // Initialize arrays for collision and free positions
        var collision_positions = [];
        var free_positions = [];

        // Sweep check along the vertical edge from top to bottom
        for (var sweep_y = collision_box_top; sweep_y <= collision_box_bottom; sweep_y += max_step_size) {
            var check_x = next_x + side_x;
            var check_y = y + sweep_y;

            var tile_id = tilemap_get_at_pixel(_tilemap, check_x, check_y);

            if (tile_id == 1) {
                collision_positions[array_length(collision_positions)] = sweep_y;
            } else {
                free_positions[array_length(free_positions)] = sweep_y;
            }
        }

        // Collision detected in the horizontal sweep
        if (array_length(collision_positions) > 0) {
            show_debug_message("Horizontal Collision at X: " + string(next_x));

            // Only proceed if there are free positions available
            if (array_length(free_positions) > 0) {
                // Determine the largest contiguous free space
                var best_start = 0;
                var best_length = 0;

                var current_start = 0;
                var current_length = 0;

                // Check free positions to find the largest contiguous segment
                for (var f = 0; f < array_length(free_positions); f++) {
                    if (f == 0 || free_positions[f] == free_positions[f-1] + max_step_size) {
                        current_length++;
                    } else {
                        if (current_length > best_length) {
                            best_start = current_start;
                            best_length = current_length;
                        }
                        current_start = f;
                        current_length = 1;
                    }
                }

                // Final check to update the best range
                if (current_length > best_length) {
                    best_start = current_start;
                    best_length = current_length;
                }

                // Calculate the optimal sliding position (center of the best free space)
                var best_free_start = free_positions[best_start];
                var best_free_end = free_positions[best_start + best_length - 1];
                
                // Ensure the computed position is clamped within the collision box bounds
                var optimal_y = clamp((best_free_start + best_free_end) / 2, collision_box_top, collision_box_bottom);

                // Apply auto-correction to the optimal position
                y = y + (optimal_y - ((collision_box_top + collision_box_bottom) / 2));
                show_debug_message("Auto-corrected Y to: " + string(y));
            } else {
                show_debug_message("No free pixels available for auto-correction (Horizontal Movement).");
            }

            collision_detected_x = true;
            break;
        }

        x = next_x;
    }
}

////////////////////
// Vertical Movement (Check Bottom and Top Edges)
////////////////////
if (abs(vmove) > 0) {
    var total_distance_y = abs(future_y - y);
    var steps_y = max(1, ceil(total_distance_y / max_step_size));
    var step_y = (future_y - y) / steps_y;

    for (var j = 0; j < steps_y; j++) {
        var next_y = y + step_y;

        var step_direction_y = (vmove > 0) ? 1 : -1;

        // Determine which edge to check (top or bottom)
        var check_y = (vmove > 0) 
            ? (next_y + collision_box_bottom)  // Moving Down
            : (next_y + collision_box_top);    // Moving Up

        // Initialize arrays for collision and free positions
        var collision_positions = [];
        var free_positions = [];

        // Sweep along the horizontal edge
        for (var sweep_x = collision_box_left; sweep_x <= collision_box_right; sweep_x += max_step_size) {
            var check_x = x + sweep_x;

            var tile_id = tilemap_get_at_pixel(_tilemap, check_x, check_y);

            if (tile_id == 1) {
                collision_positions[array_length(collision_positions)] = sweep_x;
            } else {
                free_positions[array_length(free_positions)] = sweep_x;
            }
        }

        // Collision detected in the vertical sweep
        if (array_length(collision_positions) > 0) {
            show_debug_message("Vertical Collision at Y: " + string(next_y));

            if (array_length(free_positions) > 0) {
                var best_start = 0;
                var best_length = 0;

                var current_start = 0;
                var current_length = 0;

                for (var f = 0; f < array_length(free_positions); f++) {
                    if (f == 0 || free_positions[f] == free_positions[f-1] + max_step_size) {
                        current_length++;
                    } else {
                        if (current_length > best_length) {
                            best_start = current_start;
                            best_length = current_length;
                        }
                        current_start = f;
                        current_length = 1;
                    }
                }

                if (current_length > best_length) {
                    best_start = current_start;
                    best_length = current_length;
                }

                var best_free_start = free_positions[best_start];
                var best_free_end = free_positions[best_start + best_length - 1];
                
                var optimal_x = clamp((best_free_start + best_free_end) / 2, collision_box_left, collision_box_right);

                x = x + (optimal_x - ((collision_box_left + collision_box_right) / 2));
                show_debug_message("Auto-corrected X to: " + string(x));
            } else {
                show_debug_message("No free pixels available for auto-correction (Vertical Movement).");
            }

            collision_detected_y = true;
            break;
        }

        y = next_y;
    }
}


// Safely snap to grid, even when movement is zero
/*if (hmove > 0) {
    x = floor(x);
} else if (hmove < 0) {
    x = ceil(x);
} else {
    x = round(x);
}

if (vmove > 0) {
    y = floor(y);
} else if (vmove < 0) {
    y = ceil(y);
} else {
    y = round(y);
}*/
//show_debug_message("hmove: " + string(hmove) + " | vmove: " + string(vmove));








//slope logic
if (self.tilemap_slope_layer != -1) {
	var _tile = tilemap_get_at_pixel(self.tilemap_slope_layer, x, y+24);
	var tile_size = 32;
	var diagonal_distance = sqrt(tile_size * tile_size + tile_size * tile_size);
	var steps = diagonal_distance / hmove;
				
		
				
	if (_tile != -1) { // Ensure a valid tile was found
		if (_tile == 1) { // ↗ Up-Right Slope
			if (facing_direction == "right" || facing_direction == "up_right" || facing_direction == "down_right") {
				move_speed_right = move_speed_right/1.3;
				move_speed_up = move_speed_right/2;
			}
			if (facing_direction == "left" || facing_direction == "up_left" || facing_direction == "down_left") {
				move_speed_left= move_speed_left/1.3;
				move_speed_down = move_speed_left/2;
			}
		}

		if (_tile == 2) { // ⬆ Steep Up
			if (facing_direction == "up" || facing_direction == "up_left" || facing_direction == "up_right") {
			    move_speed_up = move_speed_up/1.3;
			             
			}
			if (facing_direction == "down" || facing_direction == "down_left" || facing_direction == "down_right") {
			    move_speed_down = move_speed_down/1.3;;
			               
			}
		}

		if (_tile == 3) { // ↖ Up-Left Slope
			if (facing_direction == "left" || facing_direction == "up_left" || facing_direction == "down_left") {
			    move_speed_left = move_speed_left/1.3;
				move_speed_up = move_speed_left/2;
			}
			if (facing_direction == "right" || facing_direction == "up_right" || facing_direction == "down_right") {
			    move_speed_right= move_speed_right/1.3;
				move_speed_down = move_speed_right/2;
			}
		}

		if (_tile == 4) { // ⬇ Down Slope
			if (facing_direction == "down" || facing_direction == "down_left" || facing_direction == "down_right") {
			    move_speed_down = move_speed_down/1.3;
			}
			if (facing_direction == "up" || facing_direction == "up_left" || facing_direction == "up_right") {
			        move_speed_up = move_speed_up/1.3;

			}
		}
	} else {
		show_debug_message("Warning: No tile found at (" + string(x) + ", " + string(y) + ")");
	}
}


//fall and jump logic

// height and drop physics

// Check if the tile is ID 2 (collision tile)
var height_tilemap = layer_tilemap_get_id("height_map_tiles");


//falling
if (z>0){
	//show_debug_message("old_platform: " + string(old_platform));
	if (!falling) {
		falling = true;
		
	}
	var current_platform = tilemap_get_at_pixel(height_tilemap, x, bbox_bottom);
	//show_debug_message("current_platform: " + string(current_platform));
	
	/*if (old_platform!=current_platform && !takeoff){
		//show_debug_message("setting takeoff true");
		//we have left the old platform and we can now check for collisions
		takeoff=true;
		//show_debug_message("TAKEOOOFF: " + string(takeoff));
	} 
	
	if(takeoff){
		//show_debug_message("old_platform: " + string(old_platform));
		//show_debug_message("current_platform: " + string(current_platform));
		if (old_platform==current_platform){
			z=0;
			show_debug_message("LANDIIIING");
			takeoff =false;
			falling=false;
		}
	}
	
	if(tile_id==1) {
		z+=z_speed;
	}*/
	//show_debug_message("vmove is: " + string(vmove));
	//show_debug_message("tile_id is: " + string(tile_id));
	
	if (fall_speed_x==0)
		fall_speed_x=hmove;
	if(fall_speed_y==0)
		fall_speed_y = vmove/4;
	
	if (!jumping){
		z-=z_speed;
		
		// Get movement angle from hmove and vmove
		 // Converts radians to degrees

		// Convert to radians
		var rad = degtorad(jump_angle);

		// Calculate shadow height using sin()
		//show_debug_message("rad is: " + string(rad));
		//show_debug_message("sin(rad) is: " + string(sin(rad)));
		fall_speed_y += 1.8 + 1.8*(sin(rad));
		//show_debug_message("fall_speed_y is: " + string(fall_speed_y));
		
		/*if (vmove<=0){
			fall_speed_y+=0.4*(abs(fall_speed_x));
		}
		else {
			fall_speed_y+=0.4*(abs(vmove)+(abs(fall_speed_x)));
		}*/
	}
	
	show_debug_message("hmove: " + string(hmove) + " | vmove: " + string(vmove));
	hmove=fall_speed_x;
	//show_debug_message("x is " + string(x));
	//show_debug_message("fall_speed_x is " + string(fall_speed_x));
	vmove=fall_speed_y;
	//show_debug_message("y is " + string(y));
	// Get the tilemap ID from the layer name
	var tilemap_id = layer_tilemap_get_id("platform_tiles");

	// Get the tile at the object's current position
	var tile_x = x;
	var tile_y = y + collision_box_bottom/2; // +1 to check just below the object for collision

	// Retrieve the tile ID at the specified position
	var tile_index = tilemap_get_at_pixel(tilemap_id, tile_x, tile_y);

	// Compare with old_height and set z to 0 if they match
	if (tile_index == old_height) {
		show_debug_message("LANDING!");
	    z = 0;
		takeoff =false;
		falling=false;
	}


} else {
	old_height = height;
	takeoff=false;
	falling = false;
	z = 0;
}





