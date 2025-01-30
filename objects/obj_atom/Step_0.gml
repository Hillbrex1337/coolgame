if (phase == 0) {
    // Pre-animation phase
    if (!collision_occurred) {
        // Before collision, ensure the sprite is stuck on the first frame
        image_index = 0;

        // Check for collision with obj_player
        if (place_meeting(x, y, obj_player)) {
            // Collision has occurred, start animation
            collision_occurred = true;
            image_speed = 1; // Start the animation

            // Freeze the player
            with (obj_player) {
                can_move = false; // Disable player movement
            }
        }
    } else {
        // During animation phase
        var total_frames = sprite_get_number(sprite_index); // Get total frames
        if (image_index >= total_frames - 1) {
            // If animation reaches the last frame, transition to jump phase
            image_speed = 0; // Stop animation
            image_index = total_frames - 1; // Ensure it stays on the last frame
            phase = 1; // Switch to jump phase

        }
    }
} else if (phase == 1) {
    // Jumping phase
    y += jump_speed; // Move obj_atom upward
    if (y <= jump_peak) {
        // If obj_atom reaches the jump peak, switch to descending phase
        phase = 2;

        // Get the center of obj_player
        if (instance_exists(obj_player)) {
		    target_x = obj_player.x; // Center horizontally (since origin is already centered)
			target_y = obj_player.y - (sprite_height / 2); // Move up by half the sprite's height
		}
    }
} else if (phase == 2) {
    // Descending phase
    // Move toward the middle of obj_player
    var dx = target_x - x;
    var dy = target_y - y;
    var distance = point_distance(x, y, target_x, target_y);

    // Normalize the movement vector and apply descend speed
    if (distance > 0) {
        x += (dx / distance) * descend_speed; // Move horizontally
        y += (dy / distance) * descend_speed; // Move vertically
    }

    // If obj_atom reaches the target (middle of obj_player) or collides, destroy it
    if (distance < 5) {
		// Re-enable player movement
        with (obj_player) {
            can_move = true; // Enable player movement
        }
        instance_destroy(); // Destroy obj_atom
    }
	
}

