// Set a fixed depth for the whole beam
depth = -500;

for (var i = 1; i < array_length(beam_path); i++) {
    var x1 = beam_path[i - 1][0];
    var y1 = beam_path[i - 1][1];
    var x2 = beam_path[i][0];
    var y2 = beam_path[i][1];

    var angle = point_direction(x1, y1, x2, y2);
    var segment_length = point_distance(x1, y1, x2, y2);

    var segment_step = sprite_width;
    var segments = floor(segment_length / segment_step); // use floor to stop just before final point
    var progress = 0;

    for (var j = 0; j < segments; j++) {
        var draw_x = x1 + lengthdir_x(progress, angle);
        var draw_y = y1 + lengthdir_y(progress, angle);

        var beam_sprite = repelling ? spr_tractor_repell : spr_tractor_beam;

        draw_sprite_ext(
            beam_sprite,
            image_index,
            draw_x,
            draw_y,
            1,
            1,
            angle,
            c_white,
            1
        );

        progress += segment_step;
    }
}

// ✅ Draw aura at the beam endpoint (on top)
if (array_length(beam_path) > 0) {
    var last_point = beam_path[array_length(beam_path) - 1];
    var aura_x = last_point[0];
    var aura_y = last_point[1];

    var aura_sprite = repelling ? spr_aura_repell : spr_aura;

    draw_sprite_ext(
        aura_sprite,
        0,
        aura_x,
        aura_y,
        1, 1,
        0,
        c_white,
        1
    );
}
