// Calculate the distance between the cursor and the player
var distance_to_player = point_distance(mouse_x, mouse_y, obj_player.x, obj_player.y);

// Check if the cursor is within 50 pixels of obj_player
if (distance_to_player <= 50) {
    draw_sprite(spr_mouse_melee, 0, mouse_x, mouse_y);
} else {
    // Show the default system cursor when it's outside the range
    window_set_cursor(cr_default);
}
