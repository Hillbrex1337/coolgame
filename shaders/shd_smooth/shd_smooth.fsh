varying vec2 v_vTexcoord;
uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 uv = v_vTexcoord;
    vec2 center = vec2(0.5, 0.5);

    // Apply barrel distortion
    vec2 offset = uv - center;
    float distortion = 0.15; // Increase for stronger curvature
    offset *= 1.0 + distortion * dot(offset, offset);
    uv = offset + center;

    // Scanline effect (adjust frequency for visibility)
    float scanline = sin(uv.y * u_resolution.y * 3.0) * 0.1;

    // RGB color separation
    float r = texture2D(gm_BaseTexture, uv + vec2(0.002, 0.0)).r;
    float g = texture2D(gm_BaseTexture, uv).g;
    float b = texture2D(gm_BaseTexture, uv - vec2(0.002, 0.0)).b;
    vec3 color = vec3(r, g, b);

    // Darken scanlines
    color *= 1.0 - scanline;

    // Vignette effect
    float vignette = smoothstep(0.9, 0.5, length(uv - center));
    color *= vignette;

    // Add slight screen flicker
    float flicker = sin(u_time * 10.0) * 0.02;
    color += flicker;

    gl_FragColor = vec4(color, 1.0);
}
