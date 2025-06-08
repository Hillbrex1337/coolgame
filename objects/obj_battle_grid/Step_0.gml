// Step Event

// Get the current view's x, y, width, and height
var view_x = camera_get_view_x(view_camera[0]);
var view_y = camera_get_view_y(view_camera[0]);
var view_width = view_get_wport(0);
var view_height = view_get_hport(0);

// Calculate the number of columns and rows needed to cover the current view
grid_columns = ceil((view_width) / tile_width);
grid_rows = ceil((view_height) / tile_height);


if (phase == 1) {
    animation_frame += animation_speed;

    if (animation_frame >= 5) {
        animation_frame = 4;
        freeze_timer += 1;

        if (freeze_timer > 10) {
            var r = irandom_range(1, 100);
            if (r <= 80) {
				freeze_duration = irandom_range(30, 500);
                phase = 3; // 80% chance to go to reverse animation
            } else {
                phase = 2; // 20% chance to go to column wave
                animation_frame = 5;
            }
            freeze_timer = 0;
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
			freeze_duration = irandom_range(30, 500);
            phase =3;
        }
    }
}
else if (phase == 3) {
    animation_frame -= animation_speed;

    if (animation_frame <= 1) {
        animation_frame = 0;
        freeze_timer += 1;

        if (freeze_timer > freeze_duration) {
            phase = 1;
            freeze_timer = 0;
            animation_frame = 0;
            current_column = 0;
        }
    }
}


