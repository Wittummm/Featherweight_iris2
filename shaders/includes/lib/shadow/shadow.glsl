#ifdef SHADOWS_ENABLED

float sampleShadowMap(vec2 coord, int cascade) {
    return texture(shadowMap, coord).r;
    //return texture(shadowMap, vec3(coord.xy, cascade)).r;
}
float sampleShadowMap(vec2 coord) {
    return sampleShadowMap(coord, 0)
}

float sampleShadowMapFiltered(vec3 coord, int cascade) {
    float t = texture(shadowMapFiltered, coord).r;
    //float t = texture(shadowMapFiltered, vec4(coord.xy, cascade, coord.z)).r;
    return t*t; // t*t looks better than t
}
float sampleShadowMapFiltered(vec3 coord) {
    return sampleShadowMapFiltered(coord, 0)
}

#include "/includes/lib/shadow/_shadow.glsl"
#endif
// need one line to include