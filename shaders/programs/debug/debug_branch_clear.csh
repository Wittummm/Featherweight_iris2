// AI: this is TEMP: code not for actual usage
#include "/includes/shared/version.glsl"

layout (local_size_x = 1, local_size_y = 1) in;

layout (std430, binding = 0) buffer DebugCounters {
    uint skyCount;
    uint objectCount;
    uint discardCount;
    uint branchedWorkgroups;
};

void main() {
    skyCount = 0u;
    objectCount = 0u;
    discardCount = 0u;
    branchedWorkgroups = 0u;
}