// Set shadow color and transparency
draw_set_alpha(0.5);
draw_set_color(c_black);

// Get movement angle from hmove and vmove
var angle = radtodeg(arctan2(vmove, hmove));
var rad = degtorad(angle);

// Calculate shadow height using sin()
var height = (z / 2) + (sin(rad) * (z / 4));
if (height > 0) show_debug_message("height: " + string(height));

var scale = z / 24;
if(!death){
	draw_ellipse(x - 12 + scale, y + height + scale + 14, x + 11 - scale, y - scale + height + 28, false);
}
// Reset color and alpha
draw_set_color(c_white);
draw_set_alpha(1);

// Tractor beam aura effect defaults
if (!variable_instance_exists(id, "y_hit")) y_hit = 0;
if (!variable_instance_exists(id, "x_hit")) x_hit = 0;
if (!variable_instance_exists(id, "only_mirror")) only_mirror = false;
if (!variable_instance_exists(id, "is_hit")) is_hit = false;
if (!variable_instance_exists(id, "aura_index")) aura_index = 0;
if (!variable_instance_exists(id, "image_index")) image_index = 0;
if (!variable_instance_exists(id, "uniForm_Handle"))
    uniForm_Handle = shader_get_uniform(shd_aura, "texture_Pixel");

if (is_hit) {
    shader_set(shd_aura);
    var obj_width = sprite_get_width(sprite_index);
    var obj_height = sprite_get_height(sprite_index);
    var texture = sprite_get_texture(sprite_index, image_index);
    var texture_Width = texture_get_texel_width(texture);
    var texture_Height = texture_get_texel_height(texture);
    shader_set_uniform_f(uniForm_Handle, texture_Width, texture_Height);
}

if (is_hit) {
    var aura_width = sprite_get_width(spr_aura);
    var aura_height = sprite_get_height(spr_aura);
    aura_index += 0.1;
    if (floor(aura_index) >= 5) aura_index = 0;
    draw_sprite(spr_aura, aura_index, x_hit, y_hit);
}
shader_reset();

// Draw attack shadow effect
if (attacking) {
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_circle(x, y, 50, false);
    draw_set_alpha(1);
}

// Atom visual effect placeholder
if (atom_spawned) {
    // draw_sprite(sprite_atom, atom_index, x-2, y-2);
}

// Charging visual
if (charging) {
    var angle_to_mouse = point_direction(x, y, mouse_x, mouse_y);
    var arrow_angle = angle_to_mouse - 90;
    var charge_factor = charge / charge_max_length;
    var arrow_scale = 1 + charge_factor * (max_scale - 1);

    draw_sprite_ext(
        spr_charge_arrow,
        0,
        x, y + 25,
        1, arrow_scale,
        arrow_angle,
        c_white,
        1
    );
    draw_sprite(sprite_full, charging_index, x, y);
}

// Melee charge afterimages
else if (charge_attack_melee) {
    for (var i = afterimage_count - 1; i >= 0; i--) {
        var pos = afterimages[i];
        var alpha = pos[2] * 0.8;
        if (alpha > 0) {
            draw_sprite_ext(
                sprite_full,
                charging_index,
                pos[0], pos[1],
                image_xscale, image_yscale,
                image_angle,
                c_white,
                alpha
            );
        }
        afterimages[i][2] = alpha;
    }
    draw_sprite(sprite_full, charging_index, x, y);
}

// Frozen visual
else if (frozen) {
    draw_sprite(sprite_frozen, frozen_index, x, y);
}

// Dodging afterimages
else if (dodging) {
    for (var i = afterimage_count - 1; i >= 0; i--) {
        var pos = afterimages[i];
        var alpha = pos[2] * 0.8;
        if (alpha > 0) {
            draw_sprite_ext(
                sprite_full,
                charging_index,
                pos[0], pos[1],
                image_xscale, image_yscale,
                image_angle,
                c_white,
                alpha
            );
        }
        afterimages[i][2] = alpha;
    }
    draw_sprite(sprite_full, image_index, x, y);
}

// Default appearance
else {
    draw_sprite_ext(sprite_full, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
}

