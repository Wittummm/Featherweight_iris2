#include "/includes/shared/version.glsl"
layout (local_size_x = 32, local_size_y = 8) in; // We assume horizontal is more similar in code flow, so less divergence, because the horizon is horizontal

#include "/includes/func/reconstructZ.glsl"
#include "/includes/func/readWriteScene.glsl"
#include "/includes/func/readGBuffer.glsl"
#include "/includes/settings/pbr.glsl"

layout (R11F_G11F_B10F) uniform image2D sceneImg;

void main() {
	uvec2 pixelPos = gl_GlobalInvocationID.xy;
    if (any(greaterThanEqual(pixelPos, uvec2(screenSize)))) return;
    vec2 fragCoord = pixelPos * oneOverScreenSize;
    
    vec3 scene = readScene(imageLoad(sceneImg, pixelPos));

	float depth = texelFetch(opaqueDepthTex, pixelPos, 0).r;
    vec3 viewPos = depthToViewPos(fragCoord, depth);
    bool isSky = depth >= 1;
    
    if (!isSky) { // Render Object
       //vec3 normals; vec2 lightLevel = vec2(0);
		//readData0(texelFetch(dataTex0, pixelPos, 0), normals, lightLevel);

		vec4 gbuffer0 = gbuffer0Default; vec4 gbuffer1 = gbuffer1Default; 
		#ifdef PBR_ENABLED
		readGBuffer(imageLoad(gbufferTex, pixelPos), gbuffer0, gbuffer1);
		#endif
		Material material = Mat(scene, gbuffer0, gbuffer1);

        //todo: below
		float shadow;
		bool shouldUpdate = shade(scene, material, lightLevel, viewPos, shadow);
		#ifdef PBREnabled
		if (shouldUpdate) {
			writeMaterial(material, gbuffer0, gbuffer1);
			imageStore(gbufferImg, pixelPos, writeGBuffer(gbuffer0, gbuffer1).rgrg);
		} 
		#endif
    } else {
        // todo render (non vanilla) sky, if vanilla render nothing
	}
    imageStore(sceneImg, pixelPos, writeScene(Scene));
}