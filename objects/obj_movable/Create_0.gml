is_hit = false;
x_hit=0;
y_hit=0;
aura_index = 0;
only_mirror = false;
uniForm_Handle = shader_get_uniform(shd_aura, "texture_Pixel");

facing_direction = "down"; // Default to facing downward

collision_box_left   = -1; // offset from x (object’s center or origin)
collision_box_right  = 1;
collision_box_top    = -1;
collision_box_bottom = 1;
collision_detected_x = false;
collision_detected_y = false;
dead_by_falling=false;
might_die=false;
death=false;
respawn_x = x;
respawn_y = y;
hmove=0;
vmove=0;
is_moving = false;
move_speed_max = 5;
move_speed_right = 3;
move_speed_left = 3;
move_speed_up = 3;
move_speed_down = 3;
move_speed_slope = 0.7071;
speed_increment = 0.6;
jumping=false;
about_to_jump=false;
old_height=0;
jump_speed=0;
jump_factor = 5;
jump_angle = 0;
jump_from_height = 0;
jump_from_x = x;
jump_from_y = y;
falling=false;
can_jump=false;
fall_speed_x = 0;
fall_speed_y = 1;
z=0;
falling = false;
takeoff=false;
old_platform = -1;
z_target = 0;    // The target height from height tiles
z_speed = 15;     // Falling speed
jump_speed = 0;
//gravity = 0.5;   // Gravity strength
on_ground = true;

//height above sea level physics
height=0;
has=0;
layer_names = ["ground_tiles", "cliff_and_wall_tiles_1", "cliff_and_wall_tiles_2"];


function decreaseSpeed(some_speed, min_speed) {
    return some_speed >  min_speed ? some_speed - speed_increment :  min_speed;
}

// Function to increase speed but cap it at max speed
function increaseSpeed(some_speed, max_speed) {
    return some_speed < max_speed ? some_speed + speed_increment : max_speed;
}

// Function to increase speed for diagonal movement (scaled by sqrt(2))
function increaseDiagonalSpeed(some_speed) {
    maxDiagonalSpeed = move_speed_max / sqrt(2);
    return some_speed < maxDiagonalSpeed ? some_speed + speed_increment : maxDiagonalSpeed;
}

// Get the tilemap ID from the layer in the room
if (layer_exists("climbing_tiles")) {
    self.tilemap_slope_layer = layer_tilemap_get_id("climbing_tiles");
} else {
    show_debug_message("Error: Tilemap layer 'climbing_tiles' does not exist!");
}