/// @description Step event for obj_movable with proper jump/fall handling

if (!variable_instance_exists(id, "aura_index")) aura_index = 0;
if (!variable_instance_exists(id, "z")) z = 0;
if (!variable_instance_exists(id, "z_speed")) z_speed = 20;
if (!variable_instance_exists(id, "only_mirror")) only_mirror = false;

if (is_hit) {
    aura_index += image_speed;
    if (floor(aura_index >= 5)) aura_index = 0;
}

var height_layer = layer_tilemap_get_id("height_map_tiles");
var new_height = tilemap_get_at_pixel(height_layer, x, y + collision_box_bottom);

if (new_height < height) {
    var slope_layer = layer_tilemap_get_id("climbing_tiles");
    var on_slope = tilemap_get_at_pixel(slope_layer, x, y + collision_box_bottom);
    if (on_slope == 0) about_to_jump = true;
}

if (about_to_jump && !falling) {
    z = 64 * height;
    might_die = true;
    jump_angle = radtodeg(arctan2(vmove, hmove));
    about_to_jump = false;
    
    // 🧠 Save jump origin height and position
    jump_from_height = height;
    jump_from_x = x;
    jump_from_y = y;
}

height = new_height;

// Collision setup
var _tilemap = layer_tilemap_get_id("collision_tiles_" + string(max(0, old_height - 1)));
var tile_size = 1;
var future_x = x + hmove;
var future_y = y + vmove;
collision_detected_x = false;
collision_detected_y = false;
var max_step_size = 1;

// Horizontal movement collision
if (abs(hmove) > 0) {
    var total_distance_x = abs(future_x - x);
    var steps_x = max(1, ceil(total_distance_x / max_step_size));
    var step_x = (future_x - x) / steps_x;

    for (var i = 0; i < steps_x; i++) {
        var next_x = x + step_x;
        var side_x = (hmove > 0) ? collision_box_right : collision_box_left;
        var collision_positions = [], free_positions = [];

        for (var sweep_y = collision_box_top; sweep_y <= collision_box_bottom; sweep_y += max_step_size) {
            var check_x = next_x + side_x;
            var check_y = y + sweep_y;
            var tile_id = tilemap_get_at_pixel(_tilemap, check_x, check_y);
            if (tile_id == 1 || tile_id == 2) collision_positions[array_length(collision_positions)] = sweep_y;
            else free_positions[array_length(free_positions)] = sweep_y;
        }

        if (array_length(collision_positions) > 0) {
            if (array_length(free_positions) > 0) {
                var best_start = 0, best_length = 0, current_start = 0, current_length = 0;
                for (var f = 0; f < array_length(free_positions); f++) {
                    if (f == 0 || free_positions[f] == free_positions[f - 1] + max_step_size) current_length++;
                    else {
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
                var optimal_y = clamp((free_positions[best_start] + free_positions[best_start + best_length - 1]) / 2, collision_box_top, collision_box_bottom);
                y += optimal_y - ((collision_box_top + collision_box_bottom) / 2);
            }
            collision_detected_x = true;
            break;
        }
        x = next_x;
    }
}

// Vertical movement collision
if (abs(vmove) > 0) {
    var total_distance_y = abs(future_y - y);
    var steps_y = max(1, ceil(total_distance_y / max_step_size));
    var step_y = (future_y - y) / steps_y;

    for (var j = 0; j < steps_y; j++) {
        var next_y = y + step_y;
        var check_y = (vmove > 0) ? (next_y + collision_box_bottom) : (next_y + collision_box_top);
        var collision_positions = [], free_positions = [];

        for (var sweep_x = collision_box_left; sweep_x <= collision_box_right; sweep_x += max_step_size) {
            var check_x = x + sweep_x;
            var tile_id = tilemap_get_at_pixel(_tilemap, check_x, check_y);
            if (tile_id == 1 || tile_id == 2) collision_positions[array_length(collision_positions)] = sweep_x;
            else free_positions[array_length(free_positions)] = sweep_x;
        }

        if (array_length(collision_positions) > 0) {
            if (array_length(free_positions) > 0) {
                var best_start = 0, best_length = 0, current_start = 0, current_length = 0;
                for (var f = 0; f < array_length(free_positions); f++) {
                    if (f == 0 || free_positions[f] == free_positions[f - 1] + max_step_size) current_length++;
                    else {
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
                var optimal_x = clamp((free_positions[best_start] + free_positions[best_start + best_length - 1]) / 2, collision_box_left, collision_box_right);
                x += optimal_x - ((collision_box_left + collision_box_right) / 2);
            }
            collision_detected_y = true;
            break;
        }
        y = next_y;
    }
}

// Fall and landing logic
// Fall and landing logic
if (z > 0) {
    if (!falling) falling = true;
    if (fall_speed_x == 0) fall_speed_x = hmove;
    if (fall_speed_y == 0) fall_speed_y = vmove / 2;

    if (!jumping) {
        z -= z_speed;
        var rad = degtorad(jump_angle);
        fall_speed_y += 1.8 + 1.8 * sin(rad);
    }

    hmove = fall_speed_x;
    vmove = fall_speed_y;

    // Improved landing check across multiple bottom points
    if (!jumping) {
        var tilemap_id = layer_tilemap_get_id("height_map_tiles");
        var sample_count = 5;
        var total_height = 0;
        var valid_samples = 0;

        for (var i = 0; i < sample_count; i++) {
            var offset_x = lerp(collision_box_left, collision_box_right, i / (sample_count - 1));
            var check_x = x + offset_x;
            var check_y = y + collision_box_bottom + 1;
            var tile_index = tilemap_get_at_pixel(tilemap_id, check_x, check_y);

            // ✅ Compare with jump_from_height instead of old_height
            if (tile_index > 0 && tile_index <= jump_from_height) {
                total_height += tile_index;
                valid_samples++;
            }
        }
		show_debug_message("checking valid samples")
        if (valid_samples >= sample_count * 0.6) {
            var avg_height = total_height / valid_samples;
			show_debug_message("valid samples found")
            var ground_y = floor(y + collision_box_bottom);
			if(abs(jump_angle)==0 || abs(jump_angle)==180){
				y=jump_from_y;
				show_debug_message("adjusting y to jump_from_y")
			} else {
				y = ground_y - collision_box_bottom;
			}

            z = 0;
            falling = false;
            might_die = false;
            takeoff = false;

            show_debug_message("Landing on height: " + string(avg_height));
        }
    }
} else {
    if (might_die) {
        var tilemap_id = layer_tilemap_get_id("height_map_tiles");
        var tile_x = x;
        var tile_y = y + collision_box_bottom + 1;
        var tile_index = tilemap_get_at_pixel(tilemap_id, tile_x, tile_y);
        if (tile_index == 0 || tile_index == -1) death = true;
        else might_die = false;
    }
    old_height = height;
    takeoff = false;
    falling = false;
    z = 0;
}

if (death) {
    image_xscale = max(0.01, image_xscale - 0.1);
    image_yscale = max(0.01, image_yscale - 0.1);
    if (image_xscale == 0.01) dead_by_falling = true;
}
