// Movement speed
// Persistent movement variables (do NOT reset each frame)

var facing_direction_old = facing_direction; // used to check if direction changed
sprite_index = sprite_full;


// Handle movement input
if(frozen_timer>=0){
	frozen = true;
	frozen_timer--;
	if(floor(frozen_index)!=frozen_max_animate){
		frozen_index +=frozen_image_speed;
	}
	move_speed_up=0;
	move_speed_down=0;
	move_speed_left=0;
	move_speed_right=0;
	image_speed=0;
	var beam = instance_nearest(x, y, obj_tractor_beam);
		 with (obj_movable) {
		    is_hit = false;
		}
         instance_destroy(beam); // Destroy the hook after reaching
} else {
	frozen = false;
}

if (!frozen && !falling){
	if (keyboard_check(ord("A"))) {
	    facing_direction = "left";
		sprite_atom = atom_melee_left;
	    is_moving = true;
	}
	if (keyboard_check(ord("D"))) {
	    facing_direction = "right";
		sprite_atom = atom_melee_right;
	    is_moving = true;
	} 
	if (keyboard_check(ord("W"))) {
		if (keyboard_check(ord("D"))) {
			facing_direction = "up_right";
		} else if (keyboard_check(ord("A"))){
			facing_direction = "up_left";
		}
		else {
			facing_direction = "up";
		}
	    is_moving = true;
	}
	if (keyboard_check(ord("S"))) {
		if (keyboard_check(ord("D"))) {
			facing_direction = "down_right";
		} else if (keyboard_check(ord("A"))){
			facing_direction = "down_left";
		}
		else {
			facing_direction = "down";
		}
	    is_moving = true;
	}

	
	// ** Reset is_moving if no movement keys are pressed **
	if (!(keyboard_check(ord("A")) || keyboard_check(ord("D")) || keyboard_check(ord("W")) || keyboard_check(ord("S")))) {
	    is_moving = false;
	}
	
	if (!(keyboard_check(ord("Q") || keyboard_check(ord("E"))))){
		 var beam = instance_nearest(x, y, obj_tractor_beam);
		 with (obj_movable) {
		    is_pulled = false;
			is_pushed = false;
		}
         instance_destroy(beam); // Destroy the hook after reaching
	}

	// Melee attack logic

	//limit click speed
	if (click_timer > 0) {
	    click_timer--;
	}
	if (mouse_check_button_pressed(mb_left) && point_distance(x, y, mouse_x, mouse_y)<50 && click_timer <= 0 && !charge_attack_melee) {
		click_timer = click_cooldown; // Reset click cooldown
		var angle = point_direction(x, y-24, mouse_x, mouse_y);
	
		// Assign string direction based on angle
		/*if (angle > 337.5 || angle <= 22.5) {
		    facing_direction = "right";
		} else if (angle > 22.5 && angle <= 67.5) {
		    facing_direction = "up_right";
		} else if (angle > 67.5 && angle <= 112.5) {
		    facing_direction = "up";
		} else if (angle > 112.5 && angle <= 157.5) {
		    facing_direction = "up_left";
		} else if (angle > 157.5 && angle <= 202.5) {
		    facing_direction = "left";
		} else if (angle > 202.5 && angle <= 247.5) {
		    facing_direction = "down_left";
		} else if (angle > 247.5 && angle <= 292.5) {
		    facing_direction = "down";
		} else {
		    facing_direction = "down_right";
		}*/
	    attacking = true;
	    attack_timer = 0;
		dash_timer = dash_duration;
		dash_speed = dash_power;

		// Cycle through attack steps (0,1 → 2,3 → 4,5 → loop)
	    attack_image_index = attack_step * ((image_number+1)/max_attack_steps); // Set to frame 0, 2, or 4
	    attack_step = (attack_step + 1) mod max_attack_steps;
	
		if(attack_step==0){
			click_timer=max_attack_timer;
			force_dash = true;
		
		}
		//if on final attack step, always dash
	
	
	    // Set attack sprites based on facing direction
	    switch (facing_direction) {
	        case "left":
				sprite_full = spr_character_melee_left;
	            break;
	        case "right":
				sprite_full = spr_character_melee_right;
	            break;
	        case "up":
	            sprite_full = spr_haracter_melee_up;
	            break;
	        case "down":
	            sprite_full = spr_character_melee_down;
	            break;
			case "down_left":
				sprite_full = spr_character_melee_down_left;
	            break;
			case "down_right":
				sprite_full = spr_character_melee_down_right;
	            break;
			case "up_left":
				sprite_full = spr_character_melee_up_left;
	            break;
			case "up_right":
				sprite_full = spr_character_melee_up_right;
	            break;
	    }
		atom_timer=0;
	    // **Start animation from the correct attack frame**
	    image_index = attack_image_index;
		show_debug_message("image:speed " + string(image_speed));
	    image_speed = 0.8; // Allow animation to start
		if (!is_moving){
			attack_leg_index = attack_leg_index+1;
		}
	    //show_debug_message("ATTACK START: attack_step = " + string(attack_step) + ", image_index = " + string(image_index));
	}

	//Charge attack
	if (mouse_check_button(mb_left) && !charge_attack_melee) {
		move_speed_up=0;
		move_speed_down=0;
		move_speed_left=0;
		move_speed_right=0;
	    charge_timer++; // Increase timer while held
	    if (charge_timer >= max_charge_timer) { // 1 second hold
	        charging = true;
			var angle_to_mouse = point_direction(x, y, mouse_x, mouse_y);

			// Snap to 8 directions
			var snapped_angle = round(angle_to_mouse / 45) * 45;
			switch (snapped_angle) {
		        case 0:
					sprite_full = spr_character_melee_right;
					facing_direction = "right";
		            break;
		        case 45:
					sprite_full = spr_character_melee_up_right;
					facing_direction = "up_right";
		            break;
		        case 90:
		            sprite_full = spr_haracter_melee_up;
					facing_direction = "up";
		            break;
		        case 135:
		            sprite_full = spr_character_melee_up_left;
					facing_direction = "up_left";
		            break;
				case 180:
					sprite_full = spr_character_melee_left;
					facing_direction = "left";
		            break;
				case 225:
					sprite_full = spr_character_melee_down_left;
					facing_direction = "down_left";
		            break;
				case 270:
					sprite_full = spr_character_melee_down;
					facing_direction = "down";
		            break;
				case 315:
					sprite_full = spr_character_melee_down_right;
					facing_direction = "down_right";
		            break;
	    }
			charge = min(charge + charge_speed, charge_max_length); // Grow charge
	    }
		charging_index = 0;
	}
	if (mouse_check_button_released(mb_left)) {
		charge_timer=0;
		if(charging){
		    // Start charge attack melee
			image_index = 11;
		    charge_attack_melee = true;
		    charging = false;
		    // Calculate charge factor (0 to 1)
		    var charge_factor = charge / charge_max_length;
		    // Calculate attack movement distance based on charge
		    charge_attack_distance = charge_factor * max_scale*11; // Min 20, Max 200 pixels
	
			// how long to be stunned after charge
			charge_attack_freeze_timer = charge_attack_distance;
		    // Start speed (faster at the beginning)
		    charge_attack_speed = charge_attack_distance / 5; // Adjust this for acceleration balance

		    // Get movement direction
		    charge_attack_direction = point_direction(x, y, mouse_x, mouse_y);
    
		    // Reset tracking
		    charge_attack_travelled = 0;
    
		    // Reset charge after attacking
		    charge = 0;
		}
	}
	// Step Event
	if (mouse_check_button_pressed(mb_right) && !dodging && is_moving) {
	    dodging = true;
	    dodge_timer = max(dodge_duration, min_dodge_duration); // Ensures dodge always has a minimum duration

	    // Apply penalty if dodged more than free_dodge times
	    if (dodge_penalty >= free_dodge) {
	        dodge_duration -= 2; // Reduce dodge duration
	        dodge_speed -= 2; // Reduce dodge speed

	        // Ensure dodge duration and speed never drop below their minimums
	        if (dodge_duration < min_dodge_duration) {
	            dodge_duration = min_dodge_duration;
	        }
	        if (dodge_speed < min_dodge_speed) {
	            dodge_speed = min_dodge_speed;
	        }
	    } else {
	        dodge_penalty++; // Increase penalty count
	    }

	    // Determine dodge direction based on facing_direction
	    switch (facing_direction) {
	        case "up": dodge_x = 0; dodge_y = -dodge_speed; break;
	        case "down": dodge_x = 0; dodge_y = dodge_speed; break;
	        case "left": dodge_x = -dodge_speed; dodge_y = 0; break;
	        case "right": dodge_x = dodge_speed; dodge_y = 0; break;
	        case "up_right": dodge_x = dodge_speed * 0.707; dodge_y = -dodge_speed * 0.707; break;
	        case "up_left": dodge_x = -dodge_speed * 0.707; dodge_y = -dodge_speed * 0.707; break;
	        case "down_right": dodge_x = dodge_speed * 0.707; dodge_y = dodge_speed * 0.707; break;
	        case "down_left": dodge_x = -dodge_speed * 0.707; dodge_y = dodge_speed * 0.707; break;
	    }
		
		
	}
	
	if (keyboard_check_pressed(vk_space) && !hook_active) {
	    /*show_debug_message("hooking!");
	    hook_active = true;

	    // Create the hookshot object at the player's position
	    var hookshot = instance_create_layer(x, y, "Player", obj_hookshot);
    
	    // Ensure target_x and target_y are set before use
	    hookshot.target_x = mouse_x;
	    hookshot.target_y = mouse_y;

	    // Pass player reference so the hookshot knows its owner
	    hookshot.owner = id;
		*/
	    // Set movement direction and speed
	    //hookshot.direction = point_direction(hookshot.x, hookshot.y, hookshot.target_x, hookshot.target_y);
	    //hookshot.speed = 10; // ✅ This ensures movement starts
	}
	if (keyboard_check_pressed(ord("Q"))) {
	    var beam = instance_create_layer(x, y, "Player", obj_tractor_beam);
		beam.owner = id;
		
	}
	if (keyboard_check_released(ord("Q"))) {
	     var beam = instance_nearest(x, y, obj_tractor_beam);
		 with (obj_movable) {
		    is_pulled = false;
			is_pushed = false;
		}
         instance_destroy(beam); // Destroy the hook after reaching
	}
	
	if (keyboard_check_pressed(ord("E"))) {
	    var beam = instance_create_layer(x, y, "Player", obj_tractor_beam);
		beam.repelling=true;
		beam.owner = id;
		
	}
	if (keyboard_check_released(ord("E"))) {
	     var beam = instance_nearest(x, y, obj_tractor_beam);
		 with (obj_movable) {
		    is_pulled = false;
			is_pushed = false;
		}
         instance_destroy(beam); // Destroy the hook after reaching
	}


}
if(atom_spawned){
	//show_debug_message("atom_index: " + string(atom_index));
	//show_debug_message("atom_timer: " + string(atom_timer));
	if(atom_index<=4){
		atom_index +=image_speed;
	} else if (atom_timer >= max_atom_timer) {
		if(atom_index<20){
			atom_index=20
		}
		atom_index += atom_image_speed;
		if(atom_index>24){
			atom_index=0;
			atom_timer = 0;
			atom_spawned=false;
	    } 
	} else {
		if(attacking){
			atom_index = image_index+5;
		}
    } 
}
//dodge recharge
if (!dodging) {
	if (dodge_cooldown > 0){
		dodge_cooldown--;
	}
	if (dodge_cooldown <= 0) {
		if (dodge_duration <base_dodge_duration){
		    dodge_duration += dodge_recovery_rate;
		}
		if (dodge_speed < base_dodge_speed){
			dodge_speed += dodge_recovery_rate;
		}
    // Ensure they never exceed their base values

        dodge_penalty = 0; // Reset penalty when fully recharged
    }
}

// **🔥 Lower Body Animation Control 🔥**
if (attacking) {
	move_speed_left = decreaseSpeed(move_speed_left, 0);
	move_speed_right = decreaseSpeed(move_speed_right, 0);
	move_speed_up = decreaseSpeed(move_speed_up, 0);
	move_speed_down = decreaseSpeed(move_speed_down, 0);
	first_attack = false;
	atom_spawned = true;
	// If dashing, move the player
	if (dash_timer > 0) {
	    dash_timer--; // Decrease dash time

	    // Move player in the facing direction
		if(is_moving || force_dash){
		    var dash_dir = 0; // Default direction
		    switch (facing_direction) {
		        case "right":       dash_dir = 0; break;
		        case "up_right":    dash_dir = 45; break;
		        case "up":          dash_dir = 90; break;
		        case "up_left":     dash_dir = 135; break;
		        case "left":        dash_dir = 180; break;
		        case "down_left":   dash_dir = 225; break;
		        case "down":        dash_dir = 270; break;
		        case "down_right":  dash_dir = 315; break;
		    }

		    // Move player in the dash direction
		    var dash_x = lengthdir_x(dash_speed, dash_dir);
		    var dash_y = lengthdir_y(dash_speed, dash_dir);

		    x += dash_x;
		    y += dash_y;

		    // Smoothly reduce dash speed over time
		    dash_speed *= 0.9; 
		}
		
	} else {
		dash_speed=0;
	}
	
    attack_timer++;
	//move_speed = 3;
    // **Allow animation to play fully before stopping**
    if (floor(image_index) == 4 || floor(image_index) == 9 || floor(image_index) == 14) {
        
     

        image_speed = 0; // Stop animation at 1, 3, 5
    }

    // **Reset if attack animation takes too long**
    if (attack_timer >= max_attack_timer) {
        attacking = false;
        attack_step = 0;
    }
} else if (charging) {
} else if (dodging) {
	for (var i = afterimage_count - 1; i > 0; i--) {
		afterimages[i] = afterimages[i - 1]; // Move older afterimages back
	}
	afterimages[0] = [x, y, 1.0]
	// TODO add doge sprite
	dodge_cooldown = 30;
    dodge_timer--;

    if (dodge_timer <= 0) {
        dodging = false;
        dodge_x = 0;
        dodge_y = 0;
		afterimages = array_create(afterimage_count, [x, y, 0]);
    }
} else if (charge_attack_melee) {
	for (var i = afterimage_count - 1; i > 0; i--) {
		afterimages[i] = afterimages[i - 1]; // Move older afterimages back
	}
	afterimages[0] = [x, y, 1.0];
	charging_index = image_index;
	if (floor(image_index) == 14){
		image_speed = 0;
	}
	charge_attack_freeze_timer--;
    // Calculate movement per step
    var hsp = lengthdir_x(charge_attack_speed, charge_attack_direction);
    var vsp = lengthdir_y(charge_attack_speed, charge_attack_direction);

    // Move player
    x += hsp;
    y += vsp;
    
    // Track total distance traveled
    charge_attack_travelled += point_distance(0, 0, hsp, vsp);

    // Slow down as the player moves
    charge_attack_speed = max(charge_attack_speed - friction, 1); // Prevents stopping too soon

    // Stop when full distance is covered
    if (charge_attack_travelled >= charge_attack_distance) {
		afterimages = array_create(afterimage_count, [x, y, 0]); // Recreate array with empty values
		charge_timer=0;
		image_index=0;
		frozen_index = charging_index
		sprite_frozen = sprite_full;
		frozen_max_animate = 14;
		frozen_timer = charge_freeze;

        charge_attack_melee = false;
    }
} else if(jumping){
} else if(frozen){
} else {
	force_dash=false;
	if(atom_timer<max_atom_timer){
		atom_timer++;
	}
	first_attack = true;
    attack_leg_index = 0; // Reset lower body animation if not attacking
    // Set correct idle/run sprites when not attacking
   // Function to decrease speed, ensuring it doesn't go below zero


	switch (facing_direction) {
	    case "left":
	        sprite_full = is_moving ? spr_character_run_left : spr_character_idle_left;
	        move_speed_left = is_moving ? increaseSpeed(move_speed_left, move_speed_max) : decreaseSpeed(move_speed_left, 0);
	        move_speed_right = decreaseSpeed(move_speed_right, 0);
	        move_speed_up = decreaseSpeed(move_speed_up, 0);
	        move_speed_down = decreaseSpeed(move_speed_down, 0);
	        break;

	    case "right":
	        sprite_full = is_moving ? spr_character_run_right : spr_character_idle_right;
	        move_speed_right = is_moving ? increaseSpeed(move_speed_right, move_speed_max) : decreaseSpeed(move_speed_right, 0);
	        move_speed_left = decreaseSpeed(move_speed_left, 0);
	        move_speed_up = decreaseSpeed(move_speed_up, 0);
	        move_speed_down = decreaseSpeed(move_speed_down, 0);
	        break;

	    case "up":
	        sprite_full = is_moving ? spr_character_run_up : spr_character_idle_back;
	        move_speed_up = is_moving ? increaseSpeed(move_speed_up, move_speed_max) : decreaseSpeed(move_speed_up, 0);
	        move_speed_down = decreaseSpeed(move_speed_down, 0);
	        move_speed_left = decreaseSpeed(move_speed_left, 0);
	        move_speed_right = decreaseSpeed(move_speed_right, 0);
	        break;

	    case "down":
	        sprite_full = is_moving ? spr_character_run_down : spr_character_idle_front;
	        move_speed_down = is_moving ? increaseSpeed(move_speed_down, move_speed_max) : decreaseSpeed(move_speed_down, 0);
	        move_speed_up = decreaseSpeed(move_speed_up, 0);
	        move_speed_left = decreaseSpeed(move_speed_left, 0);
	        move_speed_right = decreaseSpeed(move_speed_right, 0);
	        break;

	    case "down_left":
	        sprite_full = is_moving ? spr_character_run_down_left : spr_character_idle_front_left;
	        move_speed_left = is_moving ? increaseDiagonalSpeed(move_speed_left) : decreaseSpeed(move_speed_left, 0);
	        move_speed_down = is_moving ? increaseDiagonalSpeed(move_speed_down) : decreaseSpeed(move_speed_down, 0);
	        move_speed_right = decreaseSpeed(move_speed_right, 0);
	        move_speed_up = decreaseSpeed(move_speed_up, 0);
	        break;

	    case "down_right":
	        sprite_full = is_moving ? spr_character_run_down_right : spr_character_idle_front_right;
	        move_speed_right = is_moving ? increaseDiagonalSpeed(move_speed_right) : decreaseSpeed(move_speed_right, 0);
	        move_speed_down = is_moving ? increaseDiagonalSpeed(move_speed_down) : decreaseSpeed(move_speed_down, 0);
	        move_speed_left = decreaseSpeed(move_speed_left, 0);
	        move_speed_up = decreaseSpeed(move_speed_up, 0);
	        break;

	    case "up_left":
	        sprite_full = is_moving ? spr_character_run_up_left : spr_character_idle_back_left;
	        move_speed_left = is_moving ? increaseDiagonalSpeed(move_speed_left) : decreaseSpeed(move_speed_left, 0);
	        move_speed_up = is_moving ? increaseDiagonalSpeed(move_speed_up) : decreaseSpeed(move_speed_up, 0);
	        move_speed_right = decreaseSpeed(move_speed_right, 0);
	        move_speed_down = decreaseSpeed(move_speed_down, 0);
	        break;

	    case "up_right":
	        sprite_full = is_moving ? spr_character_run_up_right : spr_character_idle_back_right;
	        move_speed_right = is_moving ? increaseDiagonalSpeed(move_speed_right) : decreaseSpeed(move_speed_right, 0);
	        move_speed_up = is_moving ? increaseDiagonalSpeed(move_speed_up) : decreaseSpeed(move_speed_up, 0);
	        move_speed_left = decreaseSpeed(move_speed_left, 0);
	        move_speed_down = decreaseSpeed(move_speed_down, 0);
	        break;
		}
		if (is_moving) {
			image_speed = image_speed_moving; // Use normal movement animation speed
			
		} else {
		    image_speed = image_speed_idle; // Use idle animation speed
		}

    }

    // Apply movement animation speed


// Depth sorting
depth = room_height - bbox_bottom + 100;

// Collision handling before applying movement


//show_debug_message(string(dodge_y));


event_inherited(); // falling pshysics

//jumping

if(about_to_jump){
	hmove=0;
	vmove=0;
}
if (z>0){
	is_moving=false;
	

	if(jump_factor>0){
		jumping = true;
		vmove-=jump_factor;
		z+=jump_factor;
		jump_factor-=0.5;
	} else {
		jumping = false;
	}
		
	image_index=0;
	image_speed=0;

} else {
	hmove = move_speed_right - move_speed_left + dodge_x;
	vmove = move_speed_down - move_speed_up + dodge_y;
	jump_factor=5;
	jumping = false;
	fall_speed_x= 0;
	fall_speed_y=0;
}