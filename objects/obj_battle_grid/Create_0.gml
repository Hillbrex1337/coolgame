// Create Event

animation_frame = 0;         // Tracks the current frame of animation
animation_speed = 0.2;       // Speed of the initial animation (frames 1-5)
phase = 1;                   // Track the current phase (1 or 2)
freeze_timer = 0;            // Timer to track how long to freeze at frame 5
column_animation_speed = 0.5; // Speed for animating columns progressively (frames 6-14)
current_column = 0;          // Track the column being animated in Phase 2

// Tile size (128x128 based on the grid provided)
tile_width = 128;
tile_height = 128;

// Initialize grid_columns and grid_rows with default values
grid_columns = 0;
grid_rows = 0;
// Initialize the surface variable
battle_grid_surface = -1;
// Set the depth of the battle grid to ensure proper rendering order
depth = room_height - 1;  // This ensures it is drawn above background but under dynamic objects like the player



#macro COLOUR_FOR_NO_MOVE make_colour_rgb(127,127,255)

// name of what you want it to be called in the shader
distortion_stage = shader_get_sampler_index(shd_distortion, "distortion_texture_page") 

//application_surface_draw_enable(true)
old_surface = noone;
surface_distort = -1
distort =true