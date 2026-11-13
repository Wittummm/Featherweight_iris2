#include "/includes/shared/version.glsl"
#include "/includes/settings/pbr.glsl"

in vec4 at_tangent;

out vec2 lightLevel;
out vec3 vertPosition;
#ifdef PROGRAM_GEOMETRY_BASIC
flat out vec3 vertColor;
#else
out vec3 vertColor;
#endif
flat out vec3 vertNormal;
#ifdef PBR_ENABLED
	flat out vec4 tangent;
#endif

out vec2 texCoord;

void main() {
	vec3 posView = mul(vaPosition, modelViewMatrix).xyz;
	vec4 posClip = mul(vec4(posView, 1), projectionMatrix);
	//////////
	lightLevel = vaLightLevel;
	lightLevel.y *= vaColor.a; // Apply AO to indirect lighting(the sky light)

	texCoord = vaUV;
	vertPosition = posView.xyz;
	gl_Position = posClip;
	vertNormal = vaNormal;
	#ifdef PBR_ENABLED
		tangent = at_tangent;
	#endif
	vertColor = vaColor.rgb;
}