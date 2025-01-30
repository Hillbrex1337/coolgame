if (attacking) {
    draw_sprite(sprite_lower, attack_leg_index, x, y); // Draw lower body first
    draw_sprite(sprite_upper, image_index, x, y); // Draw upper body slightly above
} else {
    draw_sprite(sprite_full, image_index, x, y);
}
