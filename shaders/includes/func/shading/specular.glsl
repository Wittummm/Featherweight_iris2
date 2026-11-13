/* Sources: 

This currently uses the Cook-Torrance Specular BRDF

 [1] https://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html, list of formulas, pick any to form the brdf
 [2] https://google.github.io/filament/Filament.md.html#materialsystem/specularbrdf, A specific combination of said formulas as an example
 [3] https://ubm-twvideo01.s3.amazonaws.com/o1/vault/gdc2017/Presentations/Hammon_Earl_PBR_Diffuse_Lighting.pdf #113
 [4] https://seblagarde.wordpress.com/2012/06/03/spherical-gaussien-approximation-for-blinn-phong-phong-and-fresnel/ Uses the SG approx of schlick fresnel

 // Below is Schlick-Lazanyi Fresnel, but conclusion is that it is mostly useless for RGB renderers and dialetrics. It improved conductors a bit but is probably not worth the extra compute for non-realistic renderers.
 [x] https://naos-be.zcu.cz/server/api/core/bitstreams/c2d8b0a7-9947-4458-98e3-d3f8df920153/content, Schlick-Lazanyi Fresnel
 [x] (8) https://diglib.eg.org/server/api/core/bitstreams/726dc384-d7dd-4c0e-8806-eadec0ff3886/content, Schlick-Lazanyi Fresnel Reparametized
 [x] https://www.researchgate.net/publication/354065225_The_Schlick_Fresnel_Approximation, Schlick-Lazanyi Fresnel Discussion

 [x] http://www.codinglabs.net/article_physically_based_rendering_cook_torrance.aspx

Dev Notes:
 - Precomputed F0 value suffices and cannot be differtentiated with the naked eye, so a fresnel function for conductors is not needed.
*/

#ifndef specular_glsl
#define specular_glsl
#include "/includes/shared/math_const.glsl"

/* These are isolated terms kept for reference, real implementation uses the simplified form instead of isolating them for performance.
// Trowbridge-Reitz (GGX) [1] (NDF #4)
float distributionGGX(float NdotH, float alpha) {
    float alpha2 = alpha*alpha;
    return alpha2 / (PI*pow(NdotH*NdotH*(alpha2 - 1.0) + 1.0, 2));
}

// Schlick Fresnel [1] (Fresnel Schlick)
vec3 fresnelSchlick(float NdotV, vec3 f0) {
    return f0 + (1.0 - f0) * pow(1.0 - NdotV, 5.0);
}

// Schlick-GGX (UE4) [1] (Geometric Shadowing bottom)
float geometric(float NdotM, float alpha) {
    float k = alpha*0.5;
    return NdotM / (NdotM*(1-k) + k);
}*/

/*
// Schlick Fresnel [1] (Fresnel Schlick)
vec3 fresnelSchlick(float NdotV, vec3 f0) {
	float f = pow(1.0 - NdotV, 5.0);
    return f + f0*(1.0 - f);

    //return f0 + (1.0 - f0) * pow(1.0 - NdotV, 5.0); // Unoptimized cuz it uses more vector instructions, above one uses more scalar ones. [2] (4.4.3 listing 5)
}*/

#define pow5OneMinusX(x) (exp2((-5.55473 * x - 6.98316) * x)) // using spherical gaussian approximation from [4]

// Schlick Fresnel [1] (Fresnel Schlick)
vec3 fresnelSchlick(float NdotV, vec3 f0) {
	float f = pow5OneMinusX(NdotV); 
    return f + f0*(1.0 - f);
}

// Schlick-GGX (UE4) [1] (Geometric Shadowing bottom)
float geometricDenom(float NdotM, float k) {
    return (NdotM*(1-k) + k);
}
// Trowbridge-Reitz (GGX) [1] (NDF #4)
float distributionDenom(float NdotH, float alpha2) {
    return pow(NdotH*NdotH*(alpha2 - 1.0) + 1.0, 2); // has extra pi but we separate it out to optimize
}

vec3 calcSpecular(
	vec3 f0, 
	float alpha, // Linear roughness
	float VdotH,
	float NdotL,
	float NdotV,
	float NdotH
) {

	float alpha2 = alpha*alpha;
    float k = alpha*0.5;

	vec3 specular = ((alpha2) / (4*PI * distributionDenom(NdotH, alpha2) * geometricDenom(NdotL, k) * geometricDenom(NdotV, k))) * fresnelSchlick(VdotH, f0); // Multiply by vec3 last to keep to floats until last step

    return specular;
}

#endif