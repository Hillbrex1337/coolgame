// Door Animation Controller
if (instance_exists(obj_player)) {
    var distance = point_distance(x, y, obj_player.x, obj_player.y);
    var threshold = 90;

    var max_frames = sprite_get_number(sprite_index);
    var final_frame = max_frames - 1;

    // OPENING
    if (distance < threshold) {
        if (image_index < final_frame) {
            image_speed = 1; // Smooth opening
        } else {
            image_speed = 0;
            image_index = final_frame; // Snap to open
        }
    }
    // CLOSING
    else {
        if (image_index > 0) {
            image_speed = -1; // Smooth closing
        } else {
            image_speed = 0;
            image_index = 0; // Snap to closed
        }
    }
}
