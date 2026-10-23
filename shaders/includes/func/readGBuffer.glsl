#ifndef readGBuffer_glsl

#include "/includes/settings/pbr.glsl"

void readGBuffer(uvec4 gbuffers, out vec4 gbuffer0, out vec4 gbuffer1) {
    #if PBR == 1
				gbuffer0 = unpackUnorm4x8(gbuffers.x);
        gbuffer1 = unpackUnorm4x8(gbuffers.y);
    #elif PBR == 2
        uint data = gbuffers.x;
        gbuffer0.r = pow(bitfieldExtract(data, 0, 6)/63.0, 2);
        gbuffer0.g = bitfieldExtract(data, 6, 6)/63.0;
        if (gbuffer0.g >= 0.9) {
            float hcmIndex = (1-gbuffer0.g)*63;
            gbuffer0.g = (230 + hcmIndex)/255.0;
        } 

        gbuffer0.b = pow(bitfieldExtract(data, 12, 5)/31.0, 2);
        gbuffer0.a = bitfieldExtract(data, 17, 5)/31.0;
        gbuffer1.r = bitfieldExtract(data, 22, 5)/31.0;
        gbuffer1.g = bitfieldExtract(data, 27, 5)/31.0;
    #endif
}

#define readGBuffer_glsl
#endif