#include "/includes/shared/version.glsl"
#include "/includes/settings/pbr.glsl"

in mediump vec2 vaUV0;
in ivec2 vaUV2;
in mediump vec3 vaNormal;
in vec3 vaPosition;
in mediump vec4 vaColor;
in mediump vec4 at_tangent;

out mediump vec2 lightLevel;
out lowp vec3 vertColor;
out vec3 vertPosition;
flat out mediump vec3 vertNormal;
#ifdef PBR_ENABLED
	flat out mediump vec4 tangent;
#endif

out mediump vec2 texCoord;

void main() {
  #include "/includes/shared/core_to_compat.vsh"

	vec3 viewPos = (modelViewMatrix * vec4(vaPosition + chunkOffset, 1)).xyz;
	lowp vec4 clipPos = projectionMatrix * vec4(viewPos, 1);
	//////////
	lightLevel = (textureMatrix2 * vec4(vaUV2, 0.0, 1.0)).xy;

	texCoord = vaUV0;
	vertPosition = viewPos.xyz;
	gl_Position = clipPos;
	vertNormal = vaNormal;
	#ifdef PBR_ENABLED
		tangent = at_tangent;
	#endif
	vertColor = vaColor.rgb * vaColor.a;
}