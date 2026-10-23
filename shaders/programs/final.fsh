#include "/includes/shared/version.glsl"
#include "/includes/settings/pbr.glsl"

/*
const int colortex0Format = R11F_G11F_B10F;
const int colortex1Format = RG8;
*/

layout(location = 0) out vec4 FinalScene;

void main() {
    FinalScene = texelFetch(sceneTex, ivec2(gl_FragCoord.xy), 0);
}