function tile_collision_line(x1, y1, x2, y2, _tilemap) {
    var steps = max(abs(x2 - x1), abs(y2 - y1)); 
    if (steps == 0) return -1; // No movement, no collision

    var dx = (x2 - x1) / steps;
    var dy = (y2 - y1) / steps;

    for (var i = 0; i <= steps; i++) {
        var check_x = floor(x1 + dx * i);
        var check_y = floor(y1 + dy * i);
        var tile_id = tilemap_get_at_pixel(_tilemap, check_x, check_y);

        if (tile_id == 1) { // Collision tiles
            return true;
        }
    }

    return false; // No collision found
}
