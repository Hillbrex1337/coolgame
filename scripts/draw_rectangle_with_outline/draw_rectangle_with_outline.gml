/// draw_rectangle_with_outline(x1, y1, x2, y2, fill_color, outline_color, outline_width, transparency)
/// @param x1 The x-coordinate of the top-left corner of the rectangle
/// @param y1 The y-coordinate of the top-left corner of the rectangle
/// @param x2 The x-coordinate of the bottom-right corner of the rectangle
/// @param y2 The y-coordinate of the bottom-right corner of the rectangle
/// @param fill_color The color of the inner rectangle
/// @param outline_color The color of the outline
/// @param outline_width The thickness of the outline
/// @param transparency The transparency of the inner rectangle (0.0 to 1.0)

function draw_rectangle_with_outline(x1, y1, x2, y2, fill_color, outline_color, outline_width, transparency) {
    // Save the current alpha and color
    var prev_alpha = draw_get_alpha();
    var prev_color = draw_get_color();

    // Draw the outline first (with full opacity)
    draw_set_alpha(transparency);  // Ensure outline is not transparent
    draw_set_color(outline_color);
    draw_rectangle(x1, y1, x2, y2, false);  // Outer rectangle

    // To simulate an outline with thickness, draw a slightly smaller rectangle inside it
    for (var i = 1; i < outline_width; i++) {
        draw_rectangle(x1 + i, y1 + i, x2 - i, y2 - i, false);
    }

    // Now draw the filled rectangle with transparency
    draw_set_color(fill_color);
    draw_set_alpha(transparency);  // Set the alpha for the fill
    draw_rectangle(x1 + outline_width, y1 + outline_width, x2 - outline_width, y2 - outline_width, false);

    // Restore the previous alpha and color to ensure nothing else is affected
    draw_set_alpha(prev_alpha);
    draw_set_color(prev_color);
}
