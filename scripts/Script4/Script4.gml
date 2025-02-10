/// point_distance_to_line(px, py, x1, y1, x2, y2)
// Returns the perpendicular distance from (px, py) to the line segment (x1, y1) -> (x2, y2)
function point_distance_to_line(px, py, x1, y1, x2, y2) {
    var A = py - y1;
    var B = x1 - px;
    var C = (y2 - y1) * x1 + (x1 - x2) * y1;
    
    var numerator = abs(A * (x2 - x1) + B * (y2 - y1) + C);
    var denominator = point_distance(x1, y1, x2, y2);

    // Prevent division by zero
    if (denominator == 0) return point_distance(px, py, x1, y1);
    
    return numerator / denominator;
}
