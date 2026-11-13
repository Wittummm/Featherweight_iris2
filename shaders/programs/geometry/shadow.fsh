#include "/includes/shared/version.glsl"

in vec2 texCoord;

void main() {
	discardCutout(texture(albedoAtlas, texCoord));
}