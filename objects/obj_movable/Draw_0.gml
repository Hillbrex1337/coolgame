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
// ✅ Draw the aura sprite behind the object, properly scaled
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

// ✅ Draw the object normally on top
draw_self();

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
