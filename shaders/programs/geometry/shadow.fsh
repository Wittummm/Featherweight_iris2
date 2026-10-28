#include "/includes/shared/version.glsl"

#include "/includes/settings/shadows.glsl"

in vec2 texCoord;

void main() {
	discardCutout(texture(albedoAtlas, texCoord));
}