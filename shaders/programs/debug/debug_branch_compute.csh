// AI: this is TEMP: code not for actual usage
#include "/includes/shared/version.glsl"

layout (local_size_x = 32, local_size_y = 8) in;

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

    // Initialize workgroup-local counters.
    if (gl_LocalInvocationIndex == 0u) {
        wgSky = 0u;
        wgObject = 0u;
        wgDiscard = 0u;
        wgBranched = 0u;
    }

    barrier();

    bool isSky = false;
    bool isObject = false;

    // Classify this invocation.
    if (inScreen) {
        float depth = texelFetch(depthtex0, pixel, 0).r;

        isSky = depth >= 1.0;
        isObject = !isSky;
    }

    // Every invocation contributes to its workgroup's shared counters.
    if (!inScreen) {
        atomicAdd(wgDiscard, 1u);
    } else if (isSky) {
        atomicAdd(wgSky, 1u);
    } else if (isObject) {
        atomicAdd(wgObject, 1u);
    }

    // Wait until all invocations have completed classification.
    barrier();

    // One invocation per workgroup updates dispatch-wide counters.
    if (gl_LocalInvocationIndex == 0u) {
        uint paths = 0u;

        if (wgSky > 0u) {
            paths++;
            atomicAdd(skyCount, 1u);
        }

        if (wgObject > 0u) {
            paths++;
            atomicAdd(objectCount, 1u);
        }

        if (wgDiscard > 0u) {
            paths++;
            atomicAdd(discardCount, 1u);
        }

        // Count this workgroup once if it contains multiple paths.
        if (paths > 1u) {
            wgBranched = 1u;
            atomicAdd(branchedWorkgroups, 1u);
        }
    }

    // Ensure wgBranched is visible to every invocation.
    barrier();

    
    // Read current scene color.
    vec3 scene = imageLoad(sceneImg, pixel).rgb;

    // Red for workgroups executing multiple paths.
    if (wgBranched != 0u) {
        scene = vec3(1.0, 0.0, 0.0);
    }

    // Render text into scene color.
    endText(scene);

    imageStore(
        sceneImg,
        pixel,
        vec4(scene, 1.0)
    );
} 