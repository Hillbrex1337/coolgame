// === Ensure obj_player exists ===
var player = obj_player;
if (!instance_exists(player)) exit;

// === Get beam origin from player ===
var start_x = player.x;
var start_y = player.y;

// === Reset movable and mirror states ===
with (obj_movable) {
    is_pushed = false;
    is_pulled = false;
}

with (obj_mirror) {
    is_pushed = false;
    is_pulled = false;
}

// === Get direction from player to mouse ===
direction = point_direction(start_x, start_y, mouse_x, mouse_y);

// === Initialize beam path ===
beam_path = [];
array_push(beam_path, [start_x, start_y]);

// === Beam movement setup ===
var current_x = start_x;
var current_y = start_y;
var segment_length = 10;
var beam_growth_speed = 10;
beam_length = min(beam_length + beam_growth_speed, max_distance);

moving = true;
target = noone;
reflected = false;
var travel_distance = 0;

// === Beam casting loop ===
while (moving && travel_distance < beam_length) {
    with (obj_movable) {
        is_pushed = false;
        is_pulled = false;
    }

    var prev_x = current_x;
    var prev_y = current_y;

    // Move beam forward
    current_x += lengthdir_x(segment_length, direction);
    current_y += lengthdir_y(segment_length, direction);
    travel_distance += segment_length;

    // === TILE COLLISION CHECK ===
    var _tilemap = layer_tilemap_get_id("collision_tiles_" + string(obj_player.height));
    if (_tilemap != -1) {
        var tile = tilemap_get_at_pixel(_tilemap, current_x, current_y);
        if (tile == 1) {
            // Simulate a tile hit like obj_movable
            moving = false;
            target = noone; // or create a dummy target struct if needed
            array_push(beam_path, [current_x, current_y]);
            break;
        }
    }

    // === Check for collision with obj_mirror ===
    var mirror_hit = instance_place(current_x, current_y, obj_mirror);
    if (mirror_hit) {
        if (repelling) {
            mirror_hit.is_pushed = true;
        } else {
            mirror_hit.is_pulled = true;
        }
        mirror_hit.x_hit = current_x;
        mirror_hit.y_hit = current_y;

        var mirror_angle = mirror_hit.image_angle;
        var beam_dir = point_direction(prev_x, prev_y, current_x, current_y);
        direction = 2 * mirror_angle - beam_dir;

        array_push(beam_path, [current_x, current_y]);
        reflected = true;
    }

    // === Check for collision with obj_movable ===
    var mov_hit = instance_place(current_x, current_y, obj_movable);
    if (mov_hit) {
        if (repelling) {
            mov_hit.is_pushed = true;
        } else {
            mov_hit.is_pulled = true;
        }
        mov_hit.x_hit = current_x;
        mov_hit.y_hit = current_y;

        if (mov_hit.only_mirror && !reflected) {
            // Skip player if not reflected yet
        } else {
            moving = false;
            target = mov_hit;
            array_push(beam_path, [current_x, current_y]);
        }
    }
}

// === End point if beam hit nothing ===
if (moving) {
    array_push(beam_path, [current_x, current_y]);
}

// === Pull/Repel logic ===
var pull_speed = 0.3;

if (!moving && target != noone) {
    if (repelling) {
        var origin_x = start_x;
        var origin_y = start_y;

        if (target.object_index == obj_player) {
            if (array_length(beam_path) > 1) {
                var last_mirror_index = array_length(beam_path) - 2;
                origin_x = beam_path[last_mirror_index][0];
                origin_y = beam_path[last_mirror_index][1];
            }
        }

        var dist_to_origin = point_distance(target.x, target.y, origin_x, origin_y);
        var repel_factor = clamp(3 + (1300 / dist_to_origin), 3, 13);
        var repel_distance = 10 * repel_factor;

        var target_x = target.x + lengthdir_x(repel_distance, direction);
        var target_y = target.y + lengthdir_y(repel_distance, direction);

        target.x = lerp(target.x, target_x, pull_speed / 7.0);
        target.y = lerp(target.y, target_y, pull_speed / 7.0);
    } else {
        if (array_length(beam_path) > 1) {
            var next_pos = beam_path[array_length(beam_path) - 2];
            target.x = lerp(target.x, next_pos[0], pull_speed / 10.0);
            target.y = lerp(target.y, next_pos[1], pull_speed / 10.0);

            if (point_distance(target.x, target.y, next_pos[0], next_pos[1]) < 2) {
                array_resize(beam_path, array_length(beam_path) - 1);
            }
            if (beam_length < 10) {
                instance_destroy();
            }
        } else {
            target = noone;
        }
    }
}
