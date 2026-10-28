#include "/includes/shared/version.glsl"

#include "/includes/settings/shadows.glsl"
#include "/includes/func/shadows/distortShadow.glsl"

in vec3 vaPosition;
in vec2 vaUV0;
in vec2 mc_Entity;
in vec4 at_midBlock;

out vec2 texCoord;

void main() {
	#include "/includes/shared/core_to_compat.vsh"

	
	vec3 posView = mul(vec4(vaPosition + chunkOffset, 1), modelViewMatrix).xyz;
	vec4 posClip = mul(vec4(posView, 1), projectionMatrix);

	if (mc_Entity.x == 10000) { // Specific block zbias
		posClip.z -= mix(0, 0.003, clamp(at_midBlock.y*2, 0,1));
	}

#ifdef ENTITIES
posClip.z -= 0.0006;//todo:
#endif


	gl_Position.xyz = distortShadow(posClip.xyz);
	gl_Position.w = posClip.w;
	texCoord = vaUV0;
}