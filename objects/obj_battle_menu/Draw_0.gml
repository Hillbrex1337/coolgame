// In obj_battle_menu Draw Event
draw_set_color(c_white);
var width = (display_get_width() / 15);
highlight_sprite(party_members[selected_party_member], [255, 255, 255]);  // Example with a white outline

// Set the size of the menu boxes (smaller than before)
var menu_width = 150;  // Reduced width
var menu_height = 150;  // Reduced height

// Loop through party members and draw their respective menus
for (var member_idx = 0; member_idx < array_length(party_members); member_idx++) {
    // Position menus horizontally without padding between them
    var menu_x = x + (member_idx * menu_width);  // No padding between menus
    var menu_y = y + 100;
	
	member = party_members[member_idx];

    // Draw the rectangle for the menu of the current party member
    draw_rectangle_with_outline(menu_x - 5, menu_y - 5, menu_x + menu_width, menu_y + menu_height, c_red, c_black, 5, 0.2);

    // Highlight the selected party member's menu
    if (member_idx == selected_party_member) {
        draw_set_color(c_lime);  // Color to indicate active member
        draw_rectangle(menu_x - 10, menu_y - 10, menu_x + menu_width + 5, menu_y + menu_height + 5, false);  // Outline around selected member
    }

    // Display the party member's name
    draw_set_color(c_white);
    draw_text(menu_x, menu_y - 30, member.name);  // Name of the party member above their menu

    // Draw the ready meter above each party member's sprite
    var meter_width = 40;  // Full width of the meter
    var meter_height = 4;  // Height of the meter
    var meter_x = member.x - (meter_width / 2);  // Center the meter above the sprite
    var meter_y = member.y - member.sprite_height;  // Position the meter above the sprite

    var meter_fill_width = member.ready_meter * meter_width;  // Calculate the filled portion based on readiness

    // Draw the background of the ready meter (black)
    draw_set_color(c_black);
    draw_rectangle(meter_x, meter_y, meter_x + meter_width, meter_y + meter_height, false);  // Meter background

    // Draw the filled portion of the ready meter (green)
    draw_set_color(c_green);
    draw_rectangle(meter_x, meter_y, meter_x + meter_fill_width, meter_y + meter_height, false);  // Meter fill

    // Only draw the menu if the party member is ready
    if (member.is_ready) {
        // Draw the menu options for the current party member
        for (var i = 0; i < array_length(action_list); i++) {
            if (i == selected_action && member_idx == selected_party_member) {
                draw_set_color(c_yellow);  // Highlight the selected option for the active member
            } else {
                draw_set_color(c_white);  // Normal color for other options
            }
            draw_text(menu_x, menu_y + i * 30, action_list[i]);  // Draw the menu at object's x, y coordinates
        }
    } else {
        // Draw a message indicating the member isn't ready yet
        draw_set_color(c_gray);
        draw_text(menu_x, menu_y + 30, "Not Ready");  // Message when not ready
    }
}
