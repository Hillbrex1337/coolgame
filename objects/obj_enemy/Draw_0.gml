/// Draw Event of obj_enemy

// Call the default draw function to ensure the object itself is drawn
draw_self();
var show_spawn_circle=false
if (show_spawn_circle){

	// Set the circle's color (optional, for better visibility)
	draw_set_color(c_yellow);  // You can change this to any color

	// Radius for the circle (this should match the radius you use for placing party members)
	var radius = 100;

	// Draw the circle around the enemy (centered at obj_enemy's position)
	draw_circle(x, y, radius, false);  // `false` means it will be an outline, not a filled circle

	// Reset the drawing color back to default (usually white)
	draw_set_color(c_white);
}
