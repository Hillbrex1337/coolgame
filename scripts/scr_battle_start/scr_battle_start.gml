function scr_battle_start(player, enemy) {
    global.battle_mode = true;
    show_debug_message("Battle mode activated!");

    // Get the current camera ID from viewport 0
    var cam = view_camera[0];

    // Get the camera's position and size
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    // Move the player to the center of the screen
    player.x = view_x + (view_w / 2);
    player.y = view_y + (view_h / 2);

    // Freeze the player's movement
    player.speed = 0;
    player.can_move = false;

    // Position and create the battle menu
    var menu_x = view_x + 50;
    var menu_y = view_y + (view_h / 2) - 50;
    instance_create_layer(menu_x, menu_y, "BattleLayer", obj_battle_menu);
    obj_battle_menu.enemy = enemy;

    // Create the grid and distortion objects
    instance_create_layer(view_x, view_y, "GravityGrid", obj_battle_grid);
    instance_create_layer(0, 0, "Effects", obj_distortion);  // Add obj_distortion to the Effects layer
}
