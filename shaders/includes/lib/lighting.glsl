
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/lib/pbr.glsl"
#include "/includes/lib/space_conversion.glsl"
#include "/includes/func/pixelize.glsl"
#include "/includes/lib/shadows/opaque_shadow.glsl"
#include "/includes/func/shading/specular.glsl"
#include "/includes/func/shading/diffuse.glsl"
#include "/includes/settings/lighting.glsl"

//////////////////////////////

//TODONOWBUTLATER: these are temp: they should be vec4 with alpha storing lux value and should get resolved on prepare to multiply rgb*a
vec3 CelestialColor = vec3(0.988, 0.898, 0.7);
vec3 SkyLightColor = 0.7*vec3(0.784, 0.878, 0.878);
vec3 LocalLightColor = 0.4*vec3(0.96, 0.85, 0.8);

// PIN!
bool shade(inout vec3 color, inout Material material, vec2 lightLevel, vec3 posView, out float shadow) {
    bool editGBuffers = false;

    vec3 posWorld = viewToWorld(posView);
    vec3 originalPosWorld = posWorld;
    if (ShadingPixelization != None) {
        posWorld = pixelize(posWorld, ShadingPixelization);
        posView = worldToView(posWorld);
    }
    vec3 dirView = normalize(posView);

    vec3 albedo = material.albedo;
    vec3 normals = material.normals;
    float roughness = material.roughness;
    float porosity = material.porosity;
    vec3 f0 = material.f0;
    float emission = material.emission;
    float metallic = material.metallic;
    vec3 outDir = -dirView;
    /////////////////////////////////////////
    vec3 shadowPosWorld = originalPosWorld;
    if (ShadowPixelization != None) {
        //TODONOWBUTLATER: geonormals was removed, find a solution, perhaps use normals, or get from depth
        shadowPosWorld += viewToWorldDir(normals)*(0.75/ShadowPixelization); // POINT: Bias the position outward so it doesnt round to be inside the block
    }
    /// Intermediate
    vec3 kS = vec3(0);
    vec3 specular = vec3(0);
    if (SpecularEnabled) {
        specular = calcSpecular(lightDirection, outDir, normals, roughness, f0, kS);
    }
    float diffuseFactor = calcDiffuseFactor(lightDirection, outDir, normals, roughness);

    if (diffuseFactor > 0) {
        shadow = calcShadow(pixelize(shadowPosWorld, ShadowPixelization) - cameraPosition, normals);
    }
    float visibility = diffuseFactor * (1.0 - shadow); 
    vec3 diffuse = albedo*(1.0 - metallic);
    float localLight = lightLevel.x;
    float skyLight = lightLevel.y;

//todo: below
    color.rgb = (diffuse+specular)*visibility*CelestialColor.rgb + albedo*(skyLight*SkyLightColor.rgb + localLight*LocalLightColor.rgb + emission);

    //color.rgb = (diffuse + specular)*visibility*LightColor.rgb + albedo*(skylight + EMISSION_LUX*emission + localLight); // Old unported line, kept for reference as above isnt dome
    
    return editGBuffers;
}

void writeMaterial(Material material, inout vec4 GBuffer0, inout vec4 GBuffer1) {
    GBuffer0.r = writeRoughness(material.roughness);
    GBuffer1.rg = writeNormals(viewToWorldDir(material.normals));
    GBuffer0.g = writeReflectanceFromF0(material.f0.x);
}