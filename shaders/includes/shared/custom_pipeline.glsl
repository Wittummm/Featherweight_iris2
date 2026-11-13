#ifndef pipeline_defines_glsl
#define pipeline_defines_glsl

// Specific to Featherweight

#define SCENE_FORMAT r11f_g11f_b10f  // Must be lowercase, or else will fail on some drivers // should find a better place to put this in

// Uniforms
/// POINT: Even though these are built in uniforms, they are put here as they are non static, the samplers require changing type according to texture format ie `usampler2D` and `sampler2D`
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform usampler2D colortex2;

uniform sampler2D shadowcolor0;
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
    #define discardCutout(color) if (color.a < alphaTestRef) { discard; }
#else
    #define discardCutout(color)
#endif

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
#define farPlane far*4.0

#define sceneTex colortex0
#define sceneImg colorimg0
#define lightTex colortex1
#define lightImg colorimg1
#define gbufferTex colortex2
#define gbufferImg colorimg2

#define shadowMap shadowtex0
#define shadowMapFiltered shadowtex0HW
#define opaqueShadowMap shadowtex1
#define opaqueShadowMapFiltered shadowtex1HW
#define shadowMapSize vec2(shadowMapResolution, shadowMapResolution)
#define shadowColorTex shadowcolor0
#define shadowColorImg shadowcolorimg0

#define depthTex depthtex0
#define opaqueDepthTex depthtex1
#define opaqueWorldDepthTex depthtex2

#define albedoAtlas gtexture
#define normalsAtlas normals
#define specularAtlas specular

/* Convert "core" vars to compatiblity profile, always use compatibility profile!(at least for final code :3)
Short docs for this:
You can assume each of the defines below are "ghost" vertex attributes where you dont need to define the input vertex attribute and that it is magically patched in.
Note that these dont follow Iris core profile 1:1, but a custom one by Featherweight
*/
#define vaPosition gl_Vertex // vec4
#define modelViewMatrix gl_ModelViewMatrix // mat4
#define projectionMatrix gl_ProjectionMatrix // mat4
#define normalMatrix gl_NormalMatrix // mat3
#define vaColor gl_Color // vec4
#define vaNormal gl_Normal // vec3
#define vaUV gl_MultiTexCoord0.xy // vec2 fix rhis
// no vaUV1 for now cuz its behavior is bad in both core and compat(its a fake uniform)

#define vaLightLevel mul(gl_MultiTexCoord1, gl_TextureMatrix[1]).xy; // vec2

#include "/includes/shared/math_const.glsl"
#include "/includes/shared/internal/samplers.glsl"
#include "/includes/settings/debug.glsl"

// Implementation of pass index as iris doesnt let you actually disable programs
#define DEFERRED_INDEX 55

#define disable(i) (_DebugPassIndex < i ? vec4(0) : gl_Vertex)

#ifdef PROGRAM_GEOMETRY_BASIC
	#define vaPosition disable(36)
#endif
#ifdef PROGRAM_GEOMETRY_LINE
	#define vaPosition disable(37)
#endif
#ifdef PROGRAM_GEOMETRY_TEXTURED
	#define vaPosition disable(38)
#endif
#ifdef PROGRAM_GEOMETRY_TEXTURED_LIT
	#define vaPosition disable(39)
#endif
#ifdef PROGRAM_GEOMETRY_PARTICLES
	#define vaPosition disable(40)
#endif
#ifdef PROGRAM_GEOMETRY_SKY_BASIC
	#define vaPosition disable(41)
#endif
#ifdef PROGRAM_GEOMETRY_SKY_TEXTURED
	#define vaPosition disable(42)
#endif
#ifdef PROGRAM_GEOMETRY_TERRAIN
	#define vaPosition disable(44)
#endif
#ifdef PROGRAM_GEOMETRY_TERRAIN_SOLID
	#define vaPosition disable(45)
#endif
#ifdef PROGRAM_GEOMETRY_TERRAIN_CUTOUT
	#define vaPosition disable(46)
#endif
#ifdef PROGRAM_GEOMETRY_DAMAGED_BLOCK
	#define vaPosition disable(47)
#endif
#ifdef PROGRAM_GEOMETRY_BLOCK_ENTITY
	#define vaPosition disable(48)
#endif
#ifdef PROGRAM_GEOMETRY_BEACON_BEAM
	#define vaPosition disable(49)
#endif
#ifdef PROGRAM_GEOMETRY_ENTITY
	#define vaPosition disable(50)
#endif
#ifdef PROGRAM_GEOMETRY_LIGHTING
	#define vaPosition disable(51)
#endif
#ifdef PROGRAM_GEOMETRY_GLINT
	#define vaPosition disable(52)
#endif
#ifdef PROGRAM_GEOMETRY_EYE
	#define vaPosition disable(53)
#endif
#ifdef PROGRAM_GEOMETRY_HAND
	#define vaPosition disable(54)
#endif

#ifdef PROGRAM_GEOMETRY_CLOUD
	#define vaPosition disable(DEFERRED_INDEX + 1)
#endif
#ifdef PROGRAM_GEOMETRY_TERRAIN_TRANSLUCENT
	#define vaPosition disable(DEFERRED_INDEX + 2)
#endif
#else

////
#endif
