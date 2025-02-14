for (var i = 1; i < array_length(beam_path); i++) {
    var x1 = beam_path[i - 1][0];
    var y1 = beam_path[i - 1][1];
    var x2 = beam_path[i][0];
    var y2 = beam_path[i][1];

    var angle = point_direction(x1, y1, x2, y2);
    var segment_length = point_distance(x1, y1, x2, y2);

    // Draw multiple smaller beam segments instead of stretching
    var segment_step = sprite_width; // Length of each drawn beam sprite
    var segments = ceil(segment_length / segment_step); // How many sprites needed
    var progress = 0;

    for (var j = 0; j < segments; j++) {
        var draw_x = x1 + lengthdir_x(progress, angle);
        var draw_y = y1 + lengthdir_y(progress, angle);
		
		if(repelling){
	        draw_sprite_ext(
	            spr_tractor_repell,
	            image_index,
	            draw_x,
	            draw_y,
	            1, // No horizontal stretch
	            1, // No vertical stretch
	            angle,
	            c_white,
	            1
	        );
		} else {
			draw_sprite_ext(
	            spr_tractor_beam,
	            image_index,
	            draw_x,
	            draw_y,
	            1, // No horizontal stretch
	            1, // No vertical stretch
	            angle,
	            c_white,
	            1
	        );
		}

        progress += segment_step; // Move to next segment position
    }
}
