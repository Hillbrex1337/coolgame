if (!surface_exists(application_surface)) {
    return; // Exit the script if the surface is missing
}

shader_set(shd_smooth);

var u_time = shader_get_uniform(shd_smooth, "u_time");
var u_resolution = shader_get_uniform(shd_smooth, "u_resolution");

if (u_time != -1) shader_set_uniform_f(u_time, current_time / 1000.0);
if (u_resolution != -1) shader_set_uniform_f(u_resolution, display_get_width(), display_get_height());

draw_surface(application_surface, 0, 0);
shader_reset();
