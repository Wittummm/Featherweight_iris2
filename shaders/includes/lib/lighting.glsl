
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/lib/pbr.glsl"

#include "/includes/lib/shadow/shadow0.glsl"
#include "/includes/func/shading/specular.glsl"
#include "/includes/func/shading/diffuse.glsl"
#include "/includes/func/shading/clearcoat.glsl"
#include "/includes/func/random/noiseSimplex.glsl"
#include "/includes/func/random/noise.glsl"
#include "/includes/func/pixelize.glsl"


//////////////////////////////

// PIN!
bool shade(inout vec3 color, inout Material material, vec2 lightLevel, vec3 posView, out float shadow) {
    bool editGBuffers = false;
    float skylight = lightLevel.y;

    vec3 posWorld = (mat3(ap.camera.viewInv) * posView) + ap.camera.pos + ap.camera.viewInv[3].xyz;
    vec3 _posWorld = posWorld;
    if (ShadingPixelization != 0) {
        posWorld = pixelize(posWorld, ShadingPixelization);
        posView = (ap.camera.view * vec4(posWorld - ap.camera.pos, 1)).xyz;
    }
    vec3 viewDir = normalize(posView);

    vec3 albedo = material.albedo;
    vec3 geoNormals = material.baseNormals;
    vec3 normals = material.normals;
    float roughness = material.roughness;
    float porosity = material.porosity;
    vec3 f0 = material.f0;
    float emission = material.emission;
    float metallic = material.metallic;
    vec3 outDir = -viewDir;
    /////////////////////////////////////////
    vec3 shadowPosWorld = _posWorld;
    if (ShadowPixelization != 0) shadowPosWorld += (mat3(ap.camera.viewInv) * geoNormals)*(0.75/ShadowPixelization); // POINT: Bias the position outward so it doesnt round to be inside the block
    /// Intermediate
    vec3 kS = vec3(0.0);
    vec3 specular = vec3(0);
    if (Specular == 1) {
        specular = calcSpecular(lightDir, outDir, normals, roughness, f0, kS);
    }
    vec3 kD = 1-kS;
    float diffuseFactor = calcDiffuseFactor(lightDir, outDir, normals, roughness);
    if (diffuseFactor > 0) {
        shadow = calcShadow(pixelize(shadowPosWorld, ShadowPixelization) - ap.camera.pos, geoNormals);
    }
    float visibility = min(diffuseFactor,1-shadow);
    vec3 diffuse = albedo*(1-metallic) *kD;
    // vec3 localLight = iris_sampleLightmap(lightLevel).rgb; // TODONOW: AP_ISSUE: Aperture doesnt provide this, yet
    vec3 localLight = lightLevel.x*localLightColor.rgb;

    color.rgb = (diffuse + specular)*visibility*LightColor.rgb + 
                albedo*(skylight*AmbientColor.rgb + EMISSION_LUX*emission + localLight);
    
    return editGBuffers;
}

#ifdef PBREnabled
void writeMaterial(Material material, inout vec4 GBuffer0, inout vec4 GBuffer1) {
    GBuffer0.r = roughnessWrite(material.roughness);
    GBuffer1.rg = normalsWrite(mat3(ap.camera.viewInv) * (material.normals));
    GBuffer0.g = reflectanceWriteFromF0(material.f0.x);
}
#endif