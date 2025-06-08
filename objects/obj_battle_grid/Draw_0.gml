/// obj_battle_grid - Draw Event

// === Get camera/view values ===
var view_x = camera_get_view_x(view_camera[0]);
var view_y = camera_get_view_y(view_camera[0]);
var view_width = view_get_wport(0);
var view_height = view_get_hport(0);

// === Expand tile count to prevent edge gaps ===
grid_columns = ceil(view_width / tile_width) + 2;
grid_rows = ceil(view_height / tile_height) + 2;

// === Ensure battle_grid_surface is correctly sized ===
if (!surface_exists(battle_grid_surface) || 
    surface_get_width(battle_grid_surface) != view_width || 
    surface_get_height(battle_grid_surface) != view_height) {
    
    if (surface_exists(battle_grid_surface)) surface_free(battle_grid_surface);
    battle_grid_surface = surface_create(view_width, view_height);
}

// === Set the surface and clear it ===
surface_set_target(battle_grid_surface);
draw_clear_alpha(c_black, 0);

// === Grid alignment offset ===
var offset_x = - (view_x - floor(view_x / tile_width) * tile_width);
var offset_y = - (view_y - floor(view_y / tile_height) * tile_height);


// === Draw the grid ===
for (var col = 0; col < grid_columns; col++) {
    for (var row = 0; row < grid_rows; row++) {
        var x_pos = (col * tile_width) + offset_x;
        var y_pos = (row * tile_height) + offset_y;
        
        var frame = 0;
        if (phase == 1 || phase == 3) {
            frame = floor(animation_frame);
        } else if (phase == 2) {
            if (col < current_column) {
                frame = 13;
            } else if (col == current_column) {
                frame = max(floor(animation_frame), 5);
            } else {
                frame = 4;
            }
        }

        draw_sprite(grid, frame, x_pos, y_pos);
    }
}

// === Finish drawing grid ===
surface_reset_target();


// === Create distortion surface if needed ===
if (!surface_exists(surface_distort) || 
    surface_get_width(surface_distort) != room_width || 
    surface_get_height(surface_distort) != room_height) {
    
    if (surface_exists(surface_distort)) surface_free(surface_distort);
    surface_distort = surface_create(room_width, room_height);
}

// === Draw distortion patterns ===
surface_set_target(surface_distort);
draw_clear_alpha(COLOUR_FOR_NO_MOVE, 0);

var coordinate_array = [];
var mass_array = [];

// === Collect positions for distortion effects ===
var enemy_count = instance_number(obj_enemy);
for (var i = 0; i < enemy_count; i++) {
    var enemy = instance_find(obj_enemy, i);
    array_push(coordinate_array, [enemy.x, enemy.y]);
    array_push(mass_array, 3);
}

var party_count = instance_number(obj_party_member);
for (var i = 0; i < party_count; i++) {
    var party = instance_find(obj_party_member, i);
    array_push(coordinate_array, [party.x, party.y]);
    array_push(mass_array, 3);
}

// === Draw distortion sprites ===
gpu_set_blendmode(bm_max);
for (var i = 0; i < array_length(coordinate_array); i++) {
    var x_pos = coordinate_array[i][0];
    var y_pos = coordinate_array[i][1]; // use y_pos instead of y
    draw_sprite_ext(distortion, 0, x_pos, y_pos, mass_array[i], mass_array[i], 0, c_white, 1);
}
gpu_set_blendmode(bm_normal);
surface_reset_target();

// === Apply shader and draw grid with distortion ===
var surface_texture = surface_get_texture(surface_distort);
shader_set(shd_distortion);
shader_set_uniform_f(shader_get_uniform(shd_distortion, "blur_radius"), 0.0);
texture_set_stage(distortion_stage, surface_texture);

// Draw the grid surface aligned to view
draw_surface(battle_grid_surface, view_x, view_y);

shader_reset();

// === Free the distortion surface ===
surface_free(surface_distort);
depth = 10000;