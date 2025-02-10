
// Set shadow color and transparency
draw_set_alpha(0.5); // Adjust transparency
draw_set_color(c_black);

// Draw an ellipse under the player
draw_ellipse(x - 12, y + 14, x + 11, y + 28, false);

// Reset color and alpha
draw_set_color(c_white);
draw_set_alpha(1);

///////////////////tractorbeamstuff
if (!variable_instance_exists(id, "y_hit")) {
    y_hit=0; // Ensure it's initialized
}
if (!variable_instance_exists(id, "x_hit")) {
    x_hit=0; // Ensure it's initialized
}
if (!variable_instance_exists(id, "only_mirror")) {
    only_mirror=false; // Ensure it's initialized
}

if (!variable_instance_exists(id, "is_hit")) {
    is_hit = false; // Ensure it's initialized
}if (!variable_instance_exists(id, "aura_index")) {
    aura_index = 0; // Ensure it's initialized
}
if (!variable_instance_exists(id, "image_index")) {
   image_index = 0; // Ensure it's initialized
}
if (!variable_instance_exists(id, "uniForm_Handle")) {
	uniForm_Handle = shader_get_uniform(shd_aura, "texture_Pixel");
}

if (is_hit) {
    shader_set(shd_aura);
	var obj_width = sprite_get_width(sprite_index); // Get object sprite width
    var obj_height = sprite_get_height(sprite_index); // Get object sprite height
	// grab stuff, pointers
	var texture = sprite_get_texture(sprite_index, image_index);
	var texture_Width  = texture_get_texel_width(texture);
	var texture_Height = texture_get_texel_height(texture);

	// put stuff in -> vec2 2 values
	shader_set_uniform_f(uniForm_Handle, texture_Width, texture_Height );
	//draw_sprite_ext(sprite_index, image_index, x, y, obj_width+5, obj_height+50, 0, c_white, 1);
}


if (is_hit) {
    var obj_width = sprite_get_width(sprite_index); // Get object sprite width
    var obj_height = sprite_get_height(sprite_index); // Get object sprite height
    var aura_width = sprite_get_width(spr_aura); // Get aura sprite width
    var aura_height = sprite_get_height(spr_aura); // Get aura sprite height
	aura_index += 0.1;
	if (floor(aura_index >= 5)){
		aura_index = 0;
	}
    draw_sprite(spr_aura, aura_index, x_hit, y_hit); // Color & transparency
}
shader_reset();
/////////////////////////////////////////

if (attacking) {
	draw_set_alpha(0.3); // 50% Transparency (0 = fully transparent, 1 = fully opaque)
	draw_set_color(c_black); // Set color to black
	draw_circle(x, y, 50, false); // Draw a filled circle with radius 30
	draw_set_alpha(1); // Reset alpha to normal

}

if(atom_spawned){


		//draw_sprite(sprite_atom, atom_index, x-2, y-2);
	
}

if (charging) {
    // Get direction to mouse
    var angle_to_mouse = point_direction(x, y, mouse_x, mouse_y);

    // Snap to 8 directions
    var arrow_angle = angle_to_mouse - 90; // Adjust for sprite orientation
    var charge_factor = charge / charge_max_length;
    var arrow_scale = 1 + charge_factor * (max_scale - 1);



    // Draw the arrow
    draw_sprite_ext(
        spr_charge_arrow,     // Sprite
        0,             // Sub-image
        x, y+25,          // Position
        1, arrow_scale, // Scale X = 1, Scale Y = adjusted length
        arrow_angle, // Rotation (fixed)
        c_white,       // No tint
        1              // Full alpha
    );
	draw_sprite(sprite_full, charging_index, x, y);
} else if(charge_attack_melee){
	for (var i = afterimage_count - 1; i >= 0; i--) {
	    var pos = afterimages[i]; 
	    var alpha = pos[2] * 0.8; // Gradually fade out

	    if (alpha > 0) { // Only draw if visible
	        draw_sprite_ext(
	            sprite_full,  // The player sprite
	            charging_index,           // Image index
	            pos[0], pos[1],  // Position
	            1, 1,         // X/Y scale
	            image_angle,  // Keep same rotation
	            c_white,      // No color change
	            alpha         // Fade effect
	        );
	    }

	    // Reduce opacity for the next frame
	    afterimages[i][2] = alpha;
	}
	draw_sprite(sprite_full, charging_index, x, y);
} else if(frozen){
	draw_sprite(sprite_frozen, frozen_index, x, y);
} else if(dodging){
	for (var i = afterimage_count - 1; i >= 0; i--) {
	    var pos = afterimages[i]; 
	    var alpha = pos[2] * 0.8; // Gradually fade out

	    if (alpha > 0) { // Only draw if visible
	        draw_sprite_ext(
	            sprite_full,  // The player sprite
	            charging_index,           // Image index
	            pos[0], pos[1],  // Position
	            1, 1,         // X/Y scale
	            image_angle,  // Keep same rotation
	            c_white,      // No color change
	            alpha         // Fade effect
	        );
	    }

	    // Reduce opacity for the next frame
	    afterimages[i][2] = alpha;
	}
	draw_sprite(sprite_full, image_index, x, y);
}
else {
	draw_sprite(sprite_full, image_index, x, y);
}




