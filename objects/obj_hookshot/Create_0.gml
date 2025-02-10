// Set the hookshot's initial position
x_start = x;
y_start = y;

// Set speed and movement direction
if (!variable_instance_exists(id, "target_x")) target_x = x;
if (!variable_instance_exists(id, "target_y")) target_y = y;
speed = 10;
hook_x = 0;
hook_y = 0;
// Maximum range the hookshot can travel
max_distance = 100;
traveled_distance = 0;
hook_speed=1;
// Hookshot state
hook_attached = false; // Whether it hit something
hook_returning = false; // Whether it's retracting
owner = noone; // The player object that fired it
// Initialize hook_distance to prevent errors
hook_distance = 0;
 image_speed = 0.3