#include "/includes/settings/shadows.glsl"

float sampleShadowMap(vec2 coord, int cascade) {
    return texture(shadowMap, coord).r;
}
float sampleShadowMapFiltered(vec3 coord, int cascade) {
    float t = texture(shadowMapFiltered, coord).r;
    return t*t; // t*t looks better than t
}

#include "/includes/lib/shadows/_shadow.glsl"

// need one line to include