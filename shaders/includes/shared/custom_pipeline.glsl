#ifndef pipeline_defines_glsl
#define pipeline_defines_glsl

// Specific to Featherweight

// Custom behavior
#ifdef CUTOUT
    #define discardCutout(color) if (color.a < alphaTestRef) { discard; return; }
#else
    #define discardCutout(color)
#endif

// Variables
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
// Uniforms
uniform vec2 screenSize;
uniform vec2 oneOverScreenSize;

uniform vec3 lightPosition;
uniform vec3 moonDirection;
uniform vec3 sunDirection;
uniform vec3 lightDirection;
uniform vec3 upDirection;


#endif