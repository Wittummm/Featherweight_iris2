#ifndef material_glsl
#define material_glsl
#include "/includes/lib/pbr.glsl"
#include "/includes/lib/space_conversion.glsl"

struct Material { //Note, order affects  memory
    vec3 albedo;
    float roughness;

    vec3 normals; // NOTE!: This is in viewSpace where as gbuffers store normals in playerSpace
    float emission;

    vec3 f0;
    float metallic;

    float porosity; // Not physically based
    float sss; // Currently unimplemented
    float ao; // Currently unsupported
    float height; // Currently unsupported
};

// PIN: This parses the gbuffers into actual useable data
Material Mat(vec3 albedo, vec4 gbuffer0, vec4 gbuffer1) {
    float roughness = readRoughness(gbuffer0.r);
    float reflectance = gbuffer0.g;
    bool isPorosity = false;
    float porosity = readPorosity(gbuffer0.b, isPorosity);
    float emission = readEmission(gbuffer0.a);
    vec3 normals = worldToViewDir(readNormals(gbuffer1.rg));

    return Material(
        albedo, 
        roughness, 

        normals, 
        emission,

        readReflectance(reflectance, albedo), 
        getMetallic(reflectance),

        isPorosity ? porosity : 0, // Porosity
        !isPorosity ? porosity : 0, // SSS
        0, // AO
        0 // Height
    );
}

#ifdef PBR_ENABLED
#ifdef readGBuffer_glsl
Material Mat(vec3 albedo, uvec4 gbuffer) {
    vec4 gbuffer0; vec4 gbuffer1; readGBuffer(gbuffer, gbuffer0, gbuffer1);
    return Mat(albedo, gbuffer0, gbuffer1);
}
#endif
#endif


#endif