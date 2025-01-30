// Step Event

// Get the current view's x, y, width, and height
var view_x = camera_get_view_x(view_camera[0]);
var view_y = camera_get_view_y(view_camera[0]);
var view_width = view_get_wport(0);
var view_height = view_get_hport(0);

// Calculate the number of columns and rows needed to cover the current view
grid_columns = ceil(room_width / tile_width);
grid_rows = ceil(room_height / tile_height);

if (phase == 1) {
    // Phase 1: Animate all tiles from frame 0-4 (not 1-5, because of zero indexing)
    animation_frame += animation_speed;
    
    // When the animation reaches frame 5 (index 4), freeze it
    if (animation_frame >= 5) {
        animation_frame = 4;  // Freeze all tiles at frame 4 (zero-based frame 5)
        freeze_timer += 1;    // Start the freeze timer

        // After a short delay, move to Phase 2
        if (freeze_timer > 30) {  // Adjust the delay time as needed
            phase = 2;
            freeze_timer = 0;  // Reset the timer
            animation_frame = 5;  // Start the column animation at frame 6 (index 5)
        }
    }
} 
else if (phase == 2) {
    // Phase 2: Animate columns from left to right, frames 6-14 (index 5-13)
    animation_frame += column_animation_speed;

    // Ensure that each column animates from frames 6 to 14 (index 5 to 13)
    if (animation_frame > 14) {
        animation_frame = 5;  // Reset frame to index 5 for the next column
        current_column += 1;  // Move to the next column

        // If we've animated all columns, restart the loop
        if (current_column >= grid_columns) {
            //current_column = 0;  // Reset to the first column
        }
    }
}
else if (phase == 3) {
    // Phase 1: Animate all tiles from frame 0-4 (not 1-5, because of zero indexing)
    animation_frame -= animation_speed;
    
    // When the animation reaches frame 5 (index 4), freeze it
    if (animation_frame <= 1) {
        animation_frame = 0;  // Freeze all tiles at frame 4 (zero-based frame 5)
        freeze_timer -= 1;    // Start the freeze timer

        // After a short delay, move to Phase 2
        if (freeze_timer > 30) {  // Adjust the delay time as needed
            phase = 2;
            freeze_timer = 0;  // Reset the timer
            animation_frame = 5;  // Start the column animation at frame 6 (index 5)
			instance_destroy();
        }
    }
} 
if (!global.battle_mode) {
    phase = 3;
}
