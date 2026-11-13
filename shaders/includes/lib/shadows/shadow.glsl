#include "/includes/settings/shadows.glsl"

float sampleShadowTex(vec2 coord, int cascade) {
    return texture(shadowMap, coord).r;
}
float sampleShadowTexFiltered(vec3 coord, int cascade) {
    return texture(shadowMapFiltered, coord).r;
}

float sampleOpaqueShadowTex(vec2 coord, int cascade) {
    return texture(opaqueShadowMap, coord).r;
}
float sampleOpaqueShadowTexFiltered(vec3 coord, int casecade) {
    return texture(opaqueShadowMapFiltered, coord).r;
}

#include "/includes/lib/shadows/_shadow.glsl"

// need one line to include