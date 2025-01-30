// Define dead zone size
var dead_zone_width = 120;  // Horizontal dead zone
var dead_zone_height = 80;  // Vertical dead zone

// Camera smoothing factor
var smooth_speed = 0.1; // Adjust between 0.05 (slower) and 0.2 (faster)

// Get player position
var player_x = obj_player.x;
var player_y = obj_player.y;

// Get current camera position
var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
var cam_width = camera_get_view_width(view_camera[0]);
var cam_height = camera_get_view_height(view_camera[0]);

// Calculate dead zone center (camera's focus point)
var dead_zone_x = cam_x + (cam_width / 2);
var dead_zone_y = cam_y + (cam_height / 2);

// Define dead zone boundaries
var dead_zone_left = dead_zone_x - (dead_zone_width / 2);
var dead_zone_right = dead_zone_x + (dead_zone_width / 2);
var dead_zone_top = dead_zone_y - (dead_zone_height / 2);
var dead_zone_bottom = dead_zone_y + (dead_zone_height / 2);

// Check if player is outside the dead zone
if (player_x < dead_zone_left) {
    cam_x = player_x - (cam_width / 2) + (dead_zone_width / 2);
}
if (player_x > dead_zone_right) {
    cam_x = player_x - (cam_width / 2) - (dead_zone_width / 2);
}
if (player_y < dead_zone_top) {
    cam_y = player_y - (cam_height / 2) + (dead_zone_height / 2);
}
if (player_y > dead_zone_bottom) {
    cam_y = player_y - (cam_height / 2) - (dead_zone_height / 2);
}

// Smoothly transition to the new camera position
var final_cam_x = lerp(camera_get_view_x(view_camera[0]), cam_x, smooth_speed);
var final_cam_y = lerp(camera_get_view_y(view_camera[0]), cam_y, smooth_speed);

// Apply the new camera position
camera_set_view_pos(view_camera[0], final_cam_x, final_cam_y);
