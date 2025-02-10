// Calculate movement direction
var dir = point_direction(x_start, y_start, x, y);

// Ensure hook_distance doesn't go negative
hook_distance = max(0, hook_distance);

// Draw the retracting chain
draw_sprite_ext(spr_hook_chain, 0, x_start, y_start, hook_distance / sprite_get_width(spr_hook_chain), 1, dir, c_white, 1);

// Draw hook head
draw_sprite(spr_hook_head, 0, x, y);
