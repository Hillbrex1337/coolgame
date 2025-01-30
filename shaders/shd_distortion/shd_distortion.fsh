varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D distortion_texture_page;  // Distortion surface texture
uniform float blur_radius;                  // Control for the blur radius

void main()
{
    // Apply distortion by sampling the distortion texture
    vec2 distort_amount = vec2((v_vColour * texture2D(distortion_texture_page, v_vTexcoord)).xy);
    distort_amount.x = 1.0 - distort_amount.x;
    distort_amount -= 0.5;
    if (distort_amount.x > 0.5) { distort_amount.x -= 1.0; }  // Wrap around
    if (distort_amount.y > 0.5) { distort_amount.y -= 1.0; }  // Wrap around
    distort_amount /= 12.0;

    // Get the distorted texture coordinates
    vec2 distorted_coords = v_vTexcoord + distort_amount;

    // Sample the base texture with distortion applied
    vec4 base_color = texture2D(gm_BaseTexture, distorted_coords);

    // Initialize blur color accumulator
    vec4 blur_color = vec4(0.0);
    int samples = 8;  // Number of blur samples
    float step_size = blur_radius / float(samples);  // Step size for blur

    // Accumulate blur samples from neighboring pixels
    for (int i = 0; i < samples; i++) {
        float offset = float(i) * step_size;
        blur_color += texture2D(gm_BaseTexture, distorted_coords + vec2(offset, offset));
        blur_color += texture2D(gm_BaseTexture, distorted_coords + vec2(-offset, offset));
        blur_color += texture2D(gm_BaseTexture, distorted_coords + vec2(offset, -offset));
        blur_color += texture2D(gm_BaseTexture, distorted_coords + vec2(-offset, -offset));
    }

    // Average the blur samples
    blur_color /= float(samples * 4);

    // Blend the original color with the blur to create the glowing effect
    gl_FragColor = mix(base_color, blur_color, 0.5) * v_vColour;
}
