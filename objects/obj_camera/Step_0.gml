if (instance_exists(obj_player)) {
    var target_x = obj_player.x - camera_get_view_width(view_camera[0]) / 2;
    var target_y = obj_player.y - camera_get_view_height(view_camera[0]) / 2;
	var _dt = delta_time / 1000000;
    
    var smooth_speed = 5*_dt; // Lower = smoother/slower, Higher = snappier

    // Use lerp() for smooth movement
    var final_cam_x = lerp(camera_get_view_x(view_camera[0]), target_x, smooth_speed);
    var final_cam_y = lerp(camera_get_view_y(view_camera[0]), target_y, smooth_speed);
	
    // Apply the new camera position
    camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);
}
