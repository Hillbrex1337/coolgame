varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_Color;  // The solid outline color

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);  // Sample the texture color

    // Define the blur amount (how far to sample neighboring pixels)
    float blurAmount = 1.0 / 1024.0;  // Smaller value for thinner outline
    float alpha = texColor.a;

    // Sample neighboring pixels in 8 directions for a basic blur
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2( blurAmount,  0.0)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-blurAmount,  0.0)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2( 0.0,  blurAmount)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2( 0.0, -blurAmount)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2( blurAmount,  blurAmount)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-blurAmount,  blurAmount)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2( blurAmount, -blurAmount)).a;
    alpha += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-blurAmount, -blurAmount)).a;

    // Average the alpha (center + 8 surrounding pixels)
    alpha /= 9.0;

    // Apply an alpha threshold to make the outline thinner
    float alphaThreshold = 0.5;  // Adjust this to control outline thickness
    alpha = step(alphaThreshold, alpha) * alpha;

    // Set the final color with the blurred and thresholded alpha
    gl_FragColor = vec4(u_Color.rgb, alpha * texColor.a);
}
