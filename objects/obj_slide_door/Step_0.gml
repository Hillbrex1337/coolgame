if (instance_exists(obj_player)) {
	var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
	var threshold_distance = 200;

	var max_frames = sprite_get_number(sprite_index);
	var final_frame = max_frames - 1;

	if (distance_to_player < threshold_distance) {
	    // Player is close, play forward
	    if (image_index < final_frame) {
	        image_speed = 2;
	    } else {
	        image_speed = 0;
	        image_index = final_frame;
	    }
	} else {
	    // Player is far, play backward
	    if (image_index > 0) {
	        image_speed = -2;
	    } else {
	        image_speed = 0;
	        image_index = 0;
	    }
	}
}
