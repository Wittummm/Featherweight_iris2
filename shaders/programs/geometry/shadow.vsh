#include "/includes/shared/version.glsl"

#include "/includes/settings/shadows.glsl"
#include "/includes/func/shadows/distortShadow.glsl"

out vec2 texCoord;

void main() {
	vec3 posView = mul(vaPosition, modelViewMatrix).xyz;
	vec4 posClip = mul(vec4(posView, 1), projectionMatrix);

	gl_Position.xyz = distortShadow(posClip.xyz);
	gl_Position.w = posClip.w;
	texCoord = vaUV;
}