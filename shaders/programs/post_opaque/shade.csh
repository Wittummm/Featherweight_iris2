#include "/includes/shared/version.glsl"

layout (local_size_x = 32, local_size_y = 8) in; // We assume horizontal is more similar in code flow, so less divergence, because the horizon is horizontal

#include "/includes/settings/pbr.glsl"
#include "/includes/func/reconstructZ.glsl"
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/func/readWriteScene.glsl"
#include "/includes/func/readGBuffer.glsl"
#include "/includes/func/writeGBuffer.glsl"
#include "/includes/lib/lighting.glsl"
#include "/includes/lib/material.glsl"

layout (SCENE_FORMAT) uniform image2D sceneImg;
layout (GBUFFER_FORMAT) uniform uimage2D gbufferImg;

void main() {
	ivec2 pixelPos = ivec2(gl_GlobalInvocationID.xy);
    if (any(greaterThanEqual(pixelPos, ivec2(screenSize)))) return;
    vec2 fragCoord = vec2(pixelPos) * oneOverScreenSize;
    
    vec3 scene = readScene(imageLoad(sceneImg, pixelPos).rgb);

	float depth = texelFetch(opaqueDepthTex, pixelPos, 0).r;
    vec3 posView = depthToViewPos(fragCoord, depth);
    bool isSky = depth >= 1;
    
    if (!isSky) { // Render Object
       vec2 lightLevel = texelFetch(lightLevelTex, pixelPos, 0).rg;

		vec4 gbuffer0 = gbuffer0Default; vec4 gbuffer1 = gbuffer1Default; 
		#ifdef PBR_ENABLED
		readGBuffer(imageLoad(gbufferImg, pixelPos), gbuffer0, gbuffer1);
		#endif
		Material material = Mat(scene, gbuffer0, gbuffer1);

        //todo: below
		float shadow;
		bool shouldUpdate = shade(scene, material, lightLevel, posView, shadow);
		#ifdef PBR_ENABLED
		if (shouldUpdate) {
			writeMaterial(material, gbuffer0, gbuffer1);
			imageStore(gbufferImg, pixelPos, writeGBuffer(gbuffer0, gbuffer1).rgrg);
		} 
		#endif
    } else {
        // todo render (non vanilla) sky, if vanilla render nothing
	}
    imageStore(sceneImg, pixelPos, writeScene(scene.rgbb)); // .rgbb bc we need to write vec4 but we only need vec3
}
