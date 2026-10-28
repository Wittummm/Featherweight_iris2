// AI: this is TEMP: code not for actual usage
#include "/includes/shared/version.glsl"

layout (local_size_x = 16, local_size_y = 16) in;

#include "/includes/settings/pbr.glsl"
#include "/includes/func/reconstructZ.glsl"
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/func/readWriteScene.glsl"
#include "/includes/func/readGBuffer.glsl"
#include "/includes/func/writeGBuffer.glsl"
#include "/includes/lib/lighting.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/lib/text_renderer.glsl"

layout (R11F_G11F_B10F) uniform image2D sceneImg;

layout (std430, binding = 0) buffer DebugCounters {
    uint skyCount;
    uint objectCount;
    uint discardCount;
    uint branchedWorkgroups;
};

shared uint wgSky;
shared uint wgObject;
shared uint wgDiscard;
shared uint wgBranched;

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

    bool inScreen =
        pixel.x < int(screenSize.x) &&
        pixel.y < int(screenSize.y);
    if (!inScreen) return;
    

    // Read dispatch-wide counters.
    int skyText = int(skyCount);
    int objectText = int(objectCount);
    int discardText = int(discardCount);
    int branchedText = int(branchedWorkgroups);

    float s = 0.2;

    beginText(
        ivec2(vec2(gl_GlobalInvocationID.xy) * s),
        ivec2(0, (screenSize.y - 200.0) * s)
    );

    
    // Sky: 10
printString((_S, _k, _y, _colon));
printInt(skyText);
printLine();

// Objects: 10
printString((_O, _b, _j, _e, _c, _t, _s, _colon));
printInt(objectText);
printLine();

// Discard: 10
printString((_D, _i, _s, _c, _a, _r, _d, _colon));
printInt(discardText);
printLine();

// Branches: 10
printString((_B, _r, _a, _n, _c, _h, _e, _s, _colon));
printInt(branchedText);
printLine();

    // Read current scene color.
    vec3 scene = imageLoad(sceneImg, pixel).rgb;


    // Render text into scene color.
    endText(scene);

    imageStore(
        sceneImg,
        pixel,
        vec4(scene, 1.0)
    );
} 