/// draw_sprite_outline(sprite, image_index, x, y, color, alpha, thickness)
/// Draws an outline around a sprite with the given color and transparency
function draw_sprite_outline(_spr, _subimg, _x, _y, _color, _alpha, _thickness) {
    draw_set_alpha(_alpha);

    // Draw the outline by offsetting the sprite in different directions
    for (var i = -_thickness; i <= _thickness; i += _thickness) {
        for (var j = -_thickness; j <= _thickness; j += _thickness) {
            if (i != 0 || j != 0) { // Prevent drawing at center
                draw_sprite_ext(_spr, _subimg, _x + i, _y + j, 1, 1, 0, _color, _alpha);
            }
        }
    }
	
	 draw_sprite(_spr, _subimg, _x, _y);

    draw_set_alpha(1); // Reset alpha to normal
}
