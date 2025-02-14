is_hit = false;
x_hit=0;
y_hit=0;
aura_index = 0;
only_mirror = false;
uniForm_Handle = shader_get_uniform(shd_aura, "texture_Pixel");

z_target = 0;    // The target height from height tiles
z_speed = 0;     // Falling speed
gravity = 0.5;   // Gravity strength
on_ground = true;