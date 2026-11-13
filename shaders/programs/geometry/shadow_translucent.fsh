#if SHADOW_COLOR == On

#include "/includes/shared/version.glsl"
#include "/includes/func/srgb_conversion.glsl"
#include "/includes/settings/shadows.glsl"

in vec2 texCoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 Color;

void main() {
	vec4 albedo = srgbToLinear(texture(albedoAtlas, texCoord));
	
	Color.rgb = mix(vec3(1.0), albedo.rgb, albedo.a);
}

#else
#include "/programs/geometry/shadow.fsh"
#endif