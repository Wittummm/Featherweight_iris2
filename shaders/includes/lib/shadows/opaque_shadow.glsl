#include "/includes/settings/shadows.glsl"

float sampleShadowMap(vec2 coord, int cascade) {
    return texture(opaqueShadowMap, coord).r;
}
float sampleShadowMapFiltered(vec3 coord, int casecade) {
    return texture(opaqueShadowMapFiltered, coord).r;
}

#include "/includes/lib/shadows/_shadow.glsl"

// need one line to include