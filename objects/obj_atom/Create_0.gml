// Stop the sprite from animating initially
image_speed = 0;

// Ensure the sprite starts on the first frame
image_index = 0;

// Flag to check if collision has occurred
collision_occurred = false;

// Phase tracking: 0 = pre-animation, 1 = jumping, 2 = descending
phase = 0;

// Jumping variables
jump_speed = -10; // Speed at which obj_atom jumps
jump_peak = y - 100; // Target height for the jump (adjust as needed)

// Descend variables
descend_speed = 5; // Speed at which obj_atom descends
target_x = 0; // Target x-position (center of obj_player)
target_y = 0; // Target y-position (center of obj_player)
