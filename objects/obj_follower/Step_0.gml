/// Step Event for obj_follower

if (instance_exists(obj_player)) {
	if (obj_player.has_moved){
	    // Get the saved target position for this follower
	    var target_x = obj_player.saved_pos_x[record];
	    var target_y = obj_player.saved_pos_y[record];

	    // Define the interpolation factor (adjust for smoothness)
	    var lerp_speed = 0.2;  // Adjust for smoother/slower movement

	    // Define the minimum distance before the follower starts moving (in pixels)
	    var min_distance = 5;  // Adjust this to set the threshold

	    // Check the distance between the follower and the target position
	    var distance = point_distance(x, y, obj_player.x, obj_player.y);
    
	    // Only apply lerp if the player is farther than the minimum distance
	    if (distance > min_distance) {
	        // Smoothly interpolate towards the target position
	        x = lerp(x, target_x, lerp_speed);
	        y = lerp(y, target_y, lerp_speed);
	    }
	}
}
depth = room_height - bbox_bottom + 100;  // The lower the player's feet, the more "in front" they are
