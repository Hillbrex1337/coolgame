function tile_collision_check(_tilemap, _x, _y) {

    var tile_id = tilemap_get_at_pixel(_tilemap, _x, _y); // Get tile at position
    return (tile_id == 1); // Return true if it's a solid tile (non-walkable)
}
