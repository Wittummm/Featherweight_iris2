
 /*
[1] https://neil3d.github.io/reading/assets/slides/s2012_pbs_disney_brdf_notes_v3.pdf states that we need to account for "(1-incomingFresnel)*(1-outgoingFresnel)" fresnel in diffuse ie "diffuse*(1-incomingFresnel)*(1-outgoingFresnel)", but caution as some diffuse models already include this compensation
*/
#ifndef radiance_glsl
#define radiance_glsl

#include "/includes/func/shading/specular.glsl"
#include "/includes/func/shading/diffuse.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/settings/lighting.glsl"
#include "/includes/func/pixelize.glsl"
#include "/includes/func/srgb_conversion.glsl"
#include "/includes/lib/space_conversion.glsl"
#include "/includes/lib/shadows/shadow.glsl"
#include "/includes/lib/pbr.glsl"

/*
Naming:
V - surface to eye/view
L - surface to light
*/

//TODONOWBUTLATER: these are temp: they should be vec4 with alpha storing lux value and should get resolved on prepare to multiply rgb*a
vec3 CelestialColor = srgbToLinear(0.9*PI*vec3(0.988, 0.898, 0.8));
vec3 SkyLightColor = srgbToLinear(0.4*vec3(0.784, 0.878, 0.878));
vec3 LocalLightColor = srgbToLinear(0.4*vec3(0.96, 0.85, 0.8));
float EmissionStrength = 0.6*PI;

vec3 calcRadiance(Material material, float VdotH, float NdotL, float NdotV, float NdotH, float LdotV) {
    float alpha = material.roughness;
    float alpha2 = alpha*alpha;

    vec3 specular = SpecularEnabled ? calcSpecular(material.f0, material.roughness, VdotH, NdotL, NdotV, NdotH) : vec3(0.0);
    vec3 diffuse = material.metallic >= 1 ? vec3(0) : calcDiffuse(material.albedo, alpha, material.f0.r, LdotV, NdotL, NdotV, NdotH);

    return specular + diffuse;
}

vec3 calcRadiance(Material material, vec3 v, vec3 l, out float NdotL) {
    vec3 n = material.normals;
    float len = length(v + l);
    NdotL = max(dot(n, l), 0);
    float NdotV = max(dot(n, v), 0);
    float NdotH = max((NdotL + NdotV)/len, 0); // [3] #115
    float VdotH = len*0.5; // [3] (#114 b3)
    float LdotV = dot(l, v);

    return calcRadiance(material, VdotH, NdotL, NdotV, NdotH, LdotV);
}

vec3 calcRadiance(Material material, vec3 v, vec3 l) {
    float NdotL = 0;
    return calcRadiance(material, v, l, NdotL);
}

// PIN: radiance function
vec3 calcRadiance(vec3 posView, vec3 l, Material material, vec2 lightLevel) {
    vec3 posWorld = viewToWorld(posView);
    posWorld = pixelize(posWorld, ShadingPixelization);
    posView = worldToView(posWorld);
    vec3 v = -normalize(posView);
    //////
    vec3 normals = material.normals;
    vec3 albedo = material.albedo;
    float emission = material.emission;
    float metallic = material.metallic;

    float localLight = lightLevel.x;
    float skyLight = lightLevel.y;

    float NdotL = 0;
    vec3 directBRDF = calcRadiance(material, v, l, NdotL);
    // shadow
    
    vec3 shadowOffset = getPixelization(ShadowPixelization) > 0 ? viewToWorldDir(normals) : vec3(0);
    vec3 light = NdotL > 0.002 ? gatherLightSamples(viewToCamera(posView), normals) : vec3(0);
    //

    vec3 reflectedRadiance = directBRDF*NdotL*CelestialColor*light; // PBR realistic
    vec3 emittedRadiance = emission*EmissionStrength*albedo; // PBR realistic

    vec3 indirectDiffuse = (1-metallic) * (localLight*LocalLightColor + skyLight*SkyLightColor)*albedo; // PBR unrealistic

    return reflectedRadiance + emittedRadiance + indirectDiffuse;
}

#endif
