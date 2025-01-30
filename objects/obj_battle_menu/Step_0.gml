// In obj_battle_menu Step Event

// Update party member meters
for (var i = 0; i < array_length(party_members); i++) {
	var member = party_members[i];
    if (!member.is_ready) {
        member.ready_meter += 0.01 * member.attack_speed;  // Adjust the speed of meter filling as needed
        if (member.ready_meter >= 1) {
            member.ready_meter = 1;  // Cap the meter at 100%
            member.is_ready = true;  // Mark the member as ready when the meter is full
        }
    }
}

// Ensure you can only choose actions if the selected member is ready
if (party_members[selected_party_member].is_ready) {
    if (keyboard_check_pressed(vk_down)) {
        selected_action = (selected_action + 1) mod array_length(action_list);  // Move down in the menu
    }

    if (keyboard_check_pressed(vk_up)) {
        selected_action = (selected_action - 1 + array_length(action_list)) mod array_length(action_list);  // Move up in the menu
    }

    if (keyboard_check_pressed(vk_enter)) {
        show_debug_message("Party Member: " + string(party_members[selected_party_member]) + " Action selected: " + action_list[selected_action]);
        // Handle the selected action for the selected party member here
        switch (selected_action) {
            case 0:
                // Attack logic for selected_party_member
                break;
            case 1:
                // Defend logic for selected_party_member
                break;
            case 2:
                // Use Item logic for selected_party_member
                break;
            case 3:
                // Run logic for selected_party_member
                global.battle_mode = false;
                break;
        }
    }
} else {
    show_debug_message("Party Member: " + string(party_members[selected_party_member]) + " is not ready!");
}

// Switch between party members with left and right arrow keys
if (keyboard_check_pressed(vk_right)) {
    selected_party_member = (selected_party_member + 1) mod array_length(party_members);  // Move to the next party member
}

if (keyboard_check_pressed(vk_left)) {
    selected_party_member = (selected_party_member - 1 + array_length(party_members)) mod array_length(party_members);  // Move to the previous party member
}

if (!global.battle_mode) {
    instance_destroy();
}
