/// obj_battle_grid - Draw Event

// Get the view position (camera position)
var view_x = camera_get_view_x(view_camera[0]);
var view_y = camera_get_view_y(view_camera[0]);
var view_width = view_get_wport(0);
var view_height = view_get_hport(0);

// Draw Event

// Draw the application_surface first
var coordinate_array = [];
var mass_array = [];

// Ensure the battle_grid_surface exists
if (!surface_exists(battle_grid_surface)) {
    battle_grid_surface = surface_create(room_width, room_height);
}

// Set the target to the battle_grid_surface
surface_set_target(battle_grid_surface);

// Clear the surface with transparency
draw_clear_alpha(c_black, 0);

// Draw the grid based on the current phase
if (phase == 1) {
    for (var col = 0; col < grid_columns; col++) {
        for (var row = 0; row < grid_rows; row++) {
            var x_pos =  (col * tile_width);
            var y_pos =  (row * tile_height);
            draw_sprite(grid, floor(animation_frame), x_pos, y_pos);
        }
    }
} else if (phase == 2) {
    for (var col = 0; col < grid_columns; col++) {
        for (var row = 0; row < grid_rows; row++) {
            var x_pos =  (col * tile_width);
            var y_pos =  (row * tile_height);
            if (col < current_column) {
                draw_sprite(grid, 13, x_pos, y_pos);
            } else if (col == current_column) {
                draw_sprite(grid, max(floor(animation_frame), 5), x_pos, y_pos);
            } else {
                draw_sprite(grid, 4, x_pos, y_pos);
            }
        }
    }
} else if (phase == 3) {
    for (var col = 0; col < grid_columns; col++) {
        for (var row = 0; row < grid_rows; row++) {
            var x_pos =  (col * tile_width);
            var y_pos =  (row * tile_height);
            draw_sprite(grid, floor(animation_frame), x_pos, y_pos);
        }
    }
}

// Reset the surface target back to the application surface
surface_reset_target();

// Draw the distorted battle grid surface last, with distortion applied
// Post Draw Event

// Get camera coordinates

// Create a surface to store the distortion effect

if (!surface_exists(surface_distort)) {

	surface_distort = surface_create(room_width, room_height);
}

show_debug_message("distort surface witdh: "+  string(surface_get_width(surface_distort)));
surface_set_target(surface_distort);

// Clear the surface with transparency
draw_clear_alpha(COLOUR_FOR_NO_MOVE, 0);

// Draw any distortion pattern here (this should be relative to the camera)
// Get coordinates for all obj_enemy instances
var enemy_count = instance_number(obj_enemy);
for (var i = 0; i < enemy_count; i++) {
    var enemy = instance_find(obj_enemy, i);
    // Add the x and y coordinates to the array
    array_push(coordinate_array, [enemy.x, enemy.y]);
	array_push(mass_array, 3);
}
// Get coordinates for all obj_party_member instances
var party_count = instance_number(obj_party_member);
for (var i = 0; i < party_count; i++) {
    var party_member = instance_find(obj_party_member, i);
    // Add the x and y coordinates to the array
    array_push(coordinate_array, [party_member.x, party_member.y]);
	array_push(mass_array, 3);
}

gpu_set_blendmode(bm_max);

for (var i = 0; i < array_length(coordinate_array) ; i++){
	var x_coord = coordinate_array[i][0];  // x-coordinate
    var y_coord = coordinate_array[i][1];  // y-coordinate
	show_debug_message("HELLO");
	
	draw_sprite_ext(distortion, 0, x_coord, y_coord, mass_array[i],mass_array[i],10, c_white, 1);

}
gpu_set_blendmode(bm_normal);
// Reset the surface target
surface_reset_target();
	

// Get the texture of the distortion surface
var surface_texture_page = surface_get_texture(surface_distort);

// Set the shader for distortion
shader_set(shd_distortion);
shader_set_uniform_f(shader_get_uniform(shd_distortion, "blur_radius"), 0.0);  // Example blur radius value
// Bind the distortion surface texture to the shader
texture_set_stage(distortion_stage, surface_texture_page);

// Draw the battle grid with the distortion effect applied
//show_debug_message("battle grid surface witdh: "+  string(surface_get_width(battle_grid_surface)));
draw_surface(battle_grid_surface,0, 0);

// Reset the shader
shader_reset();
old_surface = surface_distort;


// Free the distortion surface to prevent memory leaks
surface_free(surface_distort) // always remember to remove the surface from memory 
