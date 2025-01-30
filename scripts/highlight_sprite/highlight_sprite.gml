function highlight_sprite(member, outline_color) {
    var outline_width = 2;  // Thickness of the outline

    var sprite_x = member.x;
    var sprite_y = member.y;
    var member_sprite = member.sprite_index;
    var sprite_subimage = member.image_index;

    if (member_sprite != noone) {
        // Activate the shader
        shader_set(shd_solid_color);

        // Set the shader's uniform color
        var color_uniform = shader_get_uniform(shd_solid_color, "u_Color");
        shader_set_uniform_f(color_uniform, outline_color[0]/255, outline_color[1]/255, outline_color[2]/255, 1.0);

        // Draw the outline by offsetting the sprite in all directions
        for (var i = -outline_width; i <= outline_width; i++) {
            for (var j = -outline_width; j <= outline_width; j++) {
                if (i != 0 || j != 0) {  // Don't draw in the center
                    draw_sprite_ext(member_sprite, sprite_subimage, sprite_x + i, sprite_y + j, 1, 1, 0, c_white, 1);
                }
            }
        }

        // Reset the shader
        shader_reset();

        // Draw the actual sprite in its original form
        draw_sprite(member_sprite, sprite_subimage, sprite_x, sprite_y);
    }
}
