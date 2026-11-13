#include "/includes/shared/version.glsl"

layout (local_size_x = 32, local_size_y = 8) in; // We assume horizontal is more similar in code flow, so less divergence, because the horizon is horizontal

#include "/includes/settings/pbr.glsl"
#include "/includes/func/reconstructZ.glsl"
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/func/depthToNormals.glsl"
#include "/includes/lib/lighting.glsl"
#include "/includes/lib/material.glsl"

layout (SCENE_FORMAT) uniform image2D sceneImg;

void main() {
	if (_DebugPassIndex < DEFERRED_INDEX) return; // For debugging
	
	ivec2 pixelPos = ivec2(gl_GlobalInvocationID.xy);
    if (any(greaterThanEqual(pixelPos, ivec2(screenSize)))) return;
    vec2 fragCoord = vec2(pixelPos) * oneOverScreenSize;
    
    vec3 scene = vec3(0);

	float depth = loadOpaqueDepthTex(pixelPos);
    vec3 posView = depthToViewPos(fragCoord, depth);
    bool isSky = depth >= 1;
    
    if (!isSky) { // Render Object
	    scene = loadSceneTex(pixelPos);
       vec2 lightLevel = loadLightTex(pixelPos).rg;

		vec4 gbuffer0 = gbuffer0Default; vec4 gbuffer1 = gbuffer1Default; 
		#ifdef PBR_ENABLED
		loadGBufferTex(pixelPos, gbuffer0, gbuffer1);
		#endif
		Material material = Mat(scene, gbuffer0, gbuffer1);

		shade(scene, material, posView, lightLevel);
    } else {
        // todo: render (non vanilla) sky, if vanilla render nothing
        scene.rgb = vec3(0,0,0.5);
	}
	imageStore(sceneImg, pixelPos, writeScene(scene.rgbb)); // .rgbb bc we need to write vec4 but we only need vec3
    
}
