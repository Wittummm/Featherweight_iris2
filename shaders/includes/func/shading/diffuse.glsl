/* Sources:

This currently uses hammon diffuse

## Hammon diffuse(current diffuse model)
 [1] https://ubm-twvideo01.s3.amazonaws.com/o1/vault/gdc2017/Presentations/Hammon_Earl_PBR_Diffuse_Lighting.pdf #113 #135
 [2] https://mutantstargoat.com/~nuclear/tmp/realtime_rendering_4ed.pdf.

## Burley diffuse(previous diffuse model used)
 [x] https://cs418.cs.illinois.edu/website/text/disney-brdf.html
 [x] https://media.disneyanimation.com/uploads/production/publication_asset/48/asset/s2012_pbs_disney_brdf_notes_v3.pdf
*/

#ifndef diffuse_glsl
#define diffuse_glsl
#include "/includes/shared/math_const.glsl"
#include "/includes/func/shading/specular.glsl"

// [1] (p113), [2] (equation 9.68/9.69)
vec3 calcDiffuse(
	vec3 subsurfaceAlbedo, // [2] p314 p369(9.9.1) states its the subsurface albedo, as in under the specular layer, so its actually just the "diffuse surface" albedo here
	float alpha, // Linear roughness
	float f0,
	float LdotV,
	float NdotL,
	float NdotV,
	float NdotH
) {

    float facing = LdotV*0.5 + 0.5;
    float rough = facing * (0.9 - 0.4 * facing) * ((NdotH + 0.5) / max(NdotH, 0.1)); // NOTE: TODOEVENTUALLY: max(NdotH, 0.1) is a baidaid solution, should find an actual solution.
	float smoothTerm = 1.05 * (1.0 - pow5OneMinusX(NdotL)) * (1.0 - pow5OneMinusX(NdotV)); 	// This is SG approximation(see in specular.glsl). Full term is: float smoothTerm = 1.05 * (1.0 - pow(1.0 - NdotL, 5)) * (1.0 - pow(1.0 - NdotV, 5));
	float single = mix(smoothTerm, rough, alpha)*ONE_OVER_PI;
	float multi = 0.1159 * alpha;

	return (single + subsurfaceAlbedo*multi) * subsurfaceAlbedo;
}

#endif 