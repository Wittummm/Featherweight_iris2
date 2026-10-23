#ifndef writeGBuffer_glsl

#include "/includes/settings/pbr.glsl"

uvec4 writeGBuffer(vec4 gbuffer0, vec4 gbuffer1) {
		#if PBR == 1
        return uvec4(packUnorm4x8(gbuffer0), packUnorm4x8(gbuffer1), 0, 0);
    #elif PBR == 2
        uint smoothness = uint(min(sqrt(gbuffer0.r), 1)*63);

        float r = gbuffer0.g;
        if (r >= 0.9) {
            r = min(r*255, 237) - 230; // hcm index
            r = 63 - r; // reverse index encoding, first is rightmost, last is leftmost
            r /= 63;
        }
        uint reflectance = uint(min(r, 1)*63);
        uint porosity = uint(min(sqrt(gbuffer0.b), 1)*31);
        uint emissive = uint(min(gbuffer0.a, 1)*31);
        uvec2 normals = uvec2(round(clamp(gbuffer1.rg, 0, 1)*31));

        uint data = 0;
        data = bitfieldInsert(data, smoothness, 0, 6);
        data = bitfieldInsert(data, reflectance, 6, 6);
        data = bitfieldInsert(data, porosity, 12, 5);
        data = bitfieldInsert(data, emissive, 17, 5);
        data = bitfieldInsert(data, normals.x, 22, 5);
        data = bitfieldInsert(data, normals.y, 27, 5);

        return uvec4(data, 0, 0, 0);
    #endif
}

#define writeGBuffer_glsl
#endif