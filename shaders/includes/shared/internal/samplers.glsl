#ifndef internal_samplers_glsl
#define internal_samplers_glsl

// NOTE: This doesnt include atlss textures cuz im too lazy + aperture will likely mess em up

float sampleDepthTex(vec2 coord) {
	return texture(depthTex, coord).r;
}
float loadDepthTex(ivec2 pos) {
	return texelFetch(depthTex, pos, 0).r;
}
vec4 gatherDepthTex(vec2 coord) {
	return textureGather(depthTex, coord);
}

float sampleOpaqueDepthTex(vec2 coord) {
	return texture(opaqueDepthTex, coord).r;
}
float loadOpaqueDepthTex(ivec2 pos) {
	return texelFetch(opaqueDepthTex, pos, 0).r;
}
vec4 gatherOpaqueDepthTex(vec2 coord) {
	return textureGather(opaqueDepthTex, coord);
}

float sampleOpaqueWorldDepthTex(vec2 coord) {
	return texture(opaqueWorldDepthTex, coord).r;
}
float loadOpaqueWorldDepthTex(ivec2 pos) {
	return texelFetch(opaqueWorldDepthTex, pos, 0).r;
}
vec4 gatherOpaqueWorldDepthTex(vec2 coord) {
	return textureGather(opaqueWorldDepthTex, coord);
}

#include "/includes/func/buffers/readWriteScene.glsl"
vec3 sampleSceneTex(vec2 coord) {
	return readScene(texture(sceneTex, coord).rgb);
}
vec3 loadSceneTex(ivec2 pos) {
	return readScene(texelFetch(sceneTex, pos, 0).rgb);
}

#include "/includes/func/buffers/readWriteGBuffer.glsl"
void sampleGBufferTex(vec2 coord, out vec4 gbuffer0, out vec4 gbuffer1) {
	readGBuffer(texture(gbufferTex, coord), gbuffer0, gbuffer1);
}
void loadGBufferTex(ivec2 pos, out vec4 gbuffer0, out vec4 gbuffer1) {
	readGBuffer(texelFetch(gbufferTex, pos, 0), gbuffer0, gbuffer1);
}

vec4 sampleLightTex(vec2 coord) {
	return texture(lightTex, coord);
}
vec4 loadLightTex(ivec2 pos) {
	return texelFetch(lightTex, pos, 0);
}

vec4 sampleShadowColorTex(vec2 coord, int cascade) {
	return texture(shadowColorTex, coord);
}
vec4 loadShadowColorTex(ivec2 pos, int cascade) {
	return texelFetch(shadowColorTex, pos, 0);
}
#endif