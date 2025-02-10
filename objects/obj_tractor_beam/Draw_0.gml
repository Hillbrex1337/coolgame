// Calculate initial beam direction
var beam_dir = point_direction(x_start, y_start, mouse_x, mouse_y);
var beam_x_end = x_start + lengthdir_x(beam_distance, beam_dir);
var beam_y_end = y_start + lengthdir_y(beam_distance, beam_dir);

// Check for mirror collision
var mirror_hit = collision_line(x_start, y_start, beam_x_end, beam_y_end, obj_mirror, false, true);

if (reflected && mirror_hit != noone) {  // Ensure mirror_hit exists before using it
    // Get mirror's angle
    var mirror_angle = mirror_hit.image_angle;
    
    // Calculate reflection angle
    var reflection_dir = 2 * mirror_angle - beam_dir;

    // Ensure reflection angle is valid (prevent extreme reflections)
    var mirror_front = mirror_hit.front_direction; // Defined in obj_mirror
    var mirror_back = mirror_front + 180; // Back is opposite direction
	var approach_angle = angle_difference(beam_dir, mirror_front);

    // Ensure beam is hitting the front side
    if (approach_angle <0) {
        show_debug_message("Reflection canceled: Angle too steep!");
        reflected = false; // Cancel reflection
    } else {
        // Find new beam endpoint after bouncing
        var beam_x_reflected_end = mirror_hit.x + lengthdir_x(mirror_beam_distance, reflection_dir);
        var beam_y_reflected_end = mirror_hit.y + lengthdir_y(mirror_beam_distance, reflection_dir);

        // Draw first segment: Player to Mirror
        draw_sprite_ext(spr_tractor_beam, image_index, x_start, y_start, 
            point_distance(x_start, y_start, beam_x_end, beam_y_end) / sprite_get_width(spr_tractor_beam), 
            1, beam_dir, c_white, 1);

        // Draw second segment: Mirror to new reflected direction
        draw_sprite_ext(spr_tractor_beam, image_index, beam_x_end, beam_y_end, 
            mirror_beam_distance / sprite_get_width(spr_tractor_beam), 
            1, reflection_dir, c_white, 1);
    }
}

if (!reflected) {
    // No mirror hit or reflection canceled, draw a normal beam
    draw_sprite_ext(spr_tractor_beam, image_index, x_start, y_start, 
        beam_distance / sprite_get_width(spr_tractor_beam), 1, beam_dir, c_white, 1);
}
