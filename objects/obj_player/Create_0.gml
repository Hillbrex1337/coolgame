/// @description Player Create Event


event_inherited(); // falling pshysics
friction=0.2;
surf = noone;
can_move = true;

frozen_timer = 0;
frozen = false;
frozen_index = 0;
frozen_max_animate = 0;
frozen_image_speed = 0.2;
// Attack animation control
click_cooldown = 5;
click_timer = 0;
attacking = false;
attack_timer = 0;
max_attack_timer = 20;
attack_hold_time = room_speed / 10; // 100ms hold
attack_step = 0; // 0 -> (0,1), 1 -> (2,3), 2 -> (4,5)
max_attack_steps = 3; // Loops from 0 to 2
attack_leg_index = 0;
attack_image_index = 0;

collision_box_left   = -10; // offset from x (object’s center or origin)
collision_box_right  = 10;
collision_box_top    = 20;
collision_box_bottom = 24;

//charge
charge_timer=0;
max_charge_timer=20;
charging = false;
first_attack = true
charge = 0;               // How much charge has been built up
charge_max_length = 50;   // Maximum charge time
charge_speed = 2;         // How fast charge increases
charging = false;         // Is the player holding charge?
max_scale = 10;            // Max stretch factor for the arrow
// Charge Attack Variables
charge_attack_melee = false;
charge_attack_distance = 0;  // Total distance to move
charge_attack_travelled = 0; // Track how far we've moved
charge_attack_speed = 0;
charge_attack_direction = 0;
charging_index = 0;
charge_attack_freeze_timer = 0;
charge_cooldown=false;
charge_freeze=30;
friction = 1; // Slowdown 
// Afterimage effect
afterimage_count = 10; // Number of afterimages
afterimages = array_create(afterimage_count, [x, y, 1]); // Array of positions & opacity

//atom
atom_index = 0;
atom_spawned = false;
atom_timer=0;
max_atom_timer= max_attack_timer*2;
atom_image_speed = 0.1;

//dash
dash_speed = 0;      // Speed boost during dashing
dash_timer = 0;      // Countdown timer for dash duration
dash_duration = 10;  // Frames the dash lasts (adjust as needed)
dash_power = 6;      // Speed increase during dash
force_dash = false;

// Base Dodge Stats
base_dodge_speed = 8;  // Base speed of the dodge
base_dodge_duration =8; // Base dodge duration
dodge_speed = base_dodge_speed;  
dodge_duration = base_dodge_duration; 
dodge_x=0;
dodge_y=0;
dodge_timer = 0;  // Timer for the dodge
dodging = false;  // Flag to track if dodging
dodge_cooldown=0;
free_dodge = 2;  // Number of free dodges before penalties apply
dodge_penalty = 0; // Penalty counter (increases with spam)
dodge_recovery_rate = 0.1; // Rate of dodge recovery over time
min_dodge_duration = 2; 
min_dodge_speed = 2; 
only_mirror =true;
// Image speed settings
image_speed_moving = 0.8;
image_speed_idle = 0.3;
image_speed_attacking = 1;

// Default full-body sprite
sprite_full = spr_character_idle_front; // Can be idle or running
sprite_frozen = NaN;

jumping = false;
jump_strength = 6;
jump_factor = 5;

// Follower logic
array_size = 94;
for (var i = array_size - 1; i >= 0; i--) {
    saved_pos_x[i] = x - i * 3;
    saved_pos_y[i] = y;
}

//respawn and death
respawn_pending=false;