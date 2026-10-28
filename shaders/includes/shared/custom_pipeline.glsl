#ifndef pipeline_defines_glsl
#define pipeline_defines_glsl

// Specific to Featherweight

#define SCENE_FORMAT r11f_g11f_b10f  // Must be lowercase, or else will fail on some drivers // should find a better place to put this in

// Uniforms
/// POINT: Even though these are built in uniforms, they are put here as they are non static, the samplers require changing type according to texture format ie `usampler2D` and `sampler2D`
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform usampler2D colortex2;
////
uniform vec2 screenSize;
uniform vec2 oneOverScreenSize;

uniform vec3 lightPosition;
uniform vec3 moonDirection;
uniform vec3 sunDirection;
uniform vec3 lightDirection;
uniform vec3 upDirection;

uniform sampler2D lightMapTex;

uniform vec2 shadowMapSize; 

// Custom behavior
#ifdef CUTOUT
    #define discardCutout(color) if (color.a < alphaTestRef) { discard; return; }
#else
    #define discardCutout(color)
#endif

vec3 sampleLightmap(vec2 coord) {
    return texture(lightMapTex, coord).rgb;
}

vec3 sampleSkyLight(float level) {
    return sampleLightmap(vec2(0, level));
}
vec3 sampleLocalLight(float level) {
    return sampleLightmap(vec2(level, 0));
}
// Slang Compat(convert slang syntax to glsl)
mat4 mul(mat4 a, mat4 b) {
    return a * b;
}
// Slang: mul(v, m) -> GLSL: m * v
vec4 mul(vec4 v, mat4 m) {
    return m * v; 
}
// Slang: mul(m, v) -> GLSL: v * m
vec4 mul(mat4 m, vec4 v) {
    return v * m; 
}
vec3 mul(vec3 v, mat3 m) {
    return m * v;
}

vec3 mul(mat3 m, vec3 v) {
    return v * m;
}

mat3 mul(mat3 a, mat3 b) {
    return a * b;
}


// Variables
#define renderDistance far
#define nearPlane near

#define sceneTex colortex0
#define sceneImg colorimg0
#define lightLevelTex colortex1
#define lightLevelImg colorimg1
#define gbufferTex colortex2
#define gbufferImg colorimg2

#define depthTex depthtex0
#define opaqueDepthTex depthtex1
#define opaqueWorldDepthTex depthtex2

#define albedoAtlas gtexture
#define normalsAtlas normals
#define specularAtlas specular

#define shadowMap shadowtex0
#define shadowMapFiltered shadowtex0HW
#define opaqueShadowMap shadowtex1
#define opaqueShadowMapFiltered shadowtex1HW
#define shadowMapSize vec2(shadowMapResolution, shadowMapResolution)

#include "/includes/shared/math_const.glsl"

#endif