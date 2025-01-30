// Movement speed
var hmove = 0;
var vmove = 0;
is_moving = false;
var facing_direction_old = facing_direction; // used to check if direction changed

// Handle movement input
if (keyboard_check(ord("A"))) {
    hmove = -move_speed;
    facing_direction = "left";
    is_moving = true;
}
if (keyboard_check(ord("D"))) {
    hmove = move_speed;
    facing_direction = "right";
    is_moving = true;
}
if (keyboard_check(ord("W"))) {
    vmove = -move_speed;
    facing_direction = "up";
    is_moving = true;
}
if (keyboard_check(ord("S"))) {
    vmove = move_speed;
    facing_direction = "down";
    is_moving = true;
}

// **🔥 Attack System 🔥**
if (mouse_check_button_pressed(mb_left)) {
    attacking = true;
    attack_timer = 0;

    // Cycle through attack steps (0,1 → 2,3 → 4,5 → loop)
    attack_image_index = attack_step * 2; // Set to frame 0, 2, or 4
    attack_step = (attack_step + 1) mod max_attack_steps;

    // Set attack sprites based on facing direction
    switch (facing_direction) {
        case "left":
            sprite_upper = character_melee_left;
            sprite_lower = character_melee_legs_left;
			hmove=-move_speed;
            break;
        case "right":
            sprite_upper = character_melee_right;
            sprite_lower = character_melee_legs_right;
			hmove = move_speed;
            break;
        case "up":
            sprite_upper = character_melee_up;
            sprite_lower = character_melee_legs_up;
            break;
        case "down":
            sprite_upper = character_melee_down;
            sprite_lower = character_melee_legs_down;
            break;
    }

    // **Start animation from the correct attack frame**
    image_index = attack_image_index;
    image_speed = 1; // Allow animation to start
	if (!is_moving){
	attack_leg_index = attack_leg_index+2;
	}
    show_debug_message("ATTACK START: attack_step = " + string(attack_step) + ", image_index = " + string(image_index));
}

// **🔥 Upper Body Animation Control 🔥**
if (attacking) {
    attack_timer++;
	move_speed = 3;
    // **Allow animation to play fully before stopping**
    if (image_index % 2 == 1) {
        if (image_speed > 0) {
            show_debug_message("Animation reached frame " + string(image_index) + ", freezing...");
        }
        image_speed = 0; // Stop animation at 1, 3, 5
    }

    // **Reset if attack animation takes too long**
    if (attack_timer >= 30 || facing_direction!=facing_direction_old) {
        attacking = false;
        attack_step = 0;
        show_debug_message("ATTACK RESET due to timeout");
    }
}

// **🔥 Lower Body Animation Control 🔥**
if (attacking) {
    if (is_moving) {
        attack_leg_index += 0.2; // Legs animate if moving
    }
} else {
	move_speed=5;
    attack_leg_index = 0; // Reset lower body animation if not attacking

    // Set correct idle/run sprites when not attacking
    switch (facing_direction) {
        case "left":
            sprite_full = is_moving ? character_run_left : character_idle_left;
            break;
        case "right":
            sprite_full = is_moving ? character_run_right : character_idle_right;
            break;
        case "up":
            sprite_full = is_moving ? character_run_up : character_idle_back;
            break;
        case "down":
            sprite_full = is_moving ? character_run_down : character_idle_front;
            break;
    }

    // Apply movement animation speed
    if (is_moving) {
        image_speed = image_speed_moving; // Use normal movement animation speed
    } else {
        image_speed = image_speed_idle; // Use idle animation speed
    }
}

// **🔥 Collision and Movement Logic 🔥**
var feet_left_x = x - 14;
var feet_right_x = x + 9;
var feet_y = y;

// Depth sorting
depth = room_height - bbox_bottom + 100;

// Collision handling before applying movement
if (hmove != 0) {
    if (!collision_point(feet_left_x + hmove, feet_y, obj_stopper, true, true) &&
        !collision_point(feet_right_x + hmove, feet_y, obj_stopper, true, true)) {
        x += hmove;
    }
}
if (vmove != 0) {
    if (!collision_point(feet_left_x, feet_y + vmove, obj_stopper, true, true) &&
        !collision_point(feet_right_x, feet_y + vmove, obj_stopper, true, true)) {
        y += vmove;
    }
}