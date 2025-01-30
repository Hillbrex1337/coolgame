

if (instance_exists(obj_player)) {
	var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
	var threshold_distance = 200; // Adjust this to set how close the player should be
	if (distance_to_player < threshold_distance) {
	    // Player is close, play forward
	    if (image_index <= 8) {
	        image_speed = 2; // Set a speed to advance the frames
	    } else {
	        image_speed = 0; // Stop at the 9th frame (index 8 because index is 0-based)
	        image_index = 8;  // Ensure it stops exactly on the 9th frame
	    }
	} else {
	    // Player is far, play backward
	    if (image_index >= 1) {
	        image_speed = -2; // Play the animation in reverse
	    } else {
	        image_speed = 0; // Stop at the 1st frame
	        image_index = 0;  // Ensure it stays on the first frame
	    }
	}
}