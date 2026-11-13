// WARNING: This should not be included/used directly, instead it should use shadow0.glsl or shadow1.glsl
// CREDIT: @builderb0y says it should be related to shadow map res, https://discord.com/channels/237199950235041794/1100010778133794827/1114276461856174121

#include "/includes/settings/shadows.glsl"
#include "/includes/func/goldenDiskSample.glsl"
#include "/includes/func/fade.glsl"
#include "/includes/func/shadows/distortShadow.glsl"
#include "/includes/lib/space_conversion.glsl"

vec4 cameraToShadowClip(vec3 posCamera) {
	vec3 shadowView = mul(vec4(posCamera, 1), shadowModelView).xyz;
	return mul(vec4(shadowView, 1.0), shadowProjection);
}

vec3 cameraToShadowClipDir(vec3 dir) {
	vec3 normalsShadowView = mul(viewToWorldDir(dir), mat3(shadowModelView));
	return mul(normalsShadowView, mat3(shadowProjection));
}

vec3 shadowClipToShadowScreen(vec4 posShadowClip) {
	vec3 shadowNdc = posShadowClip.xyz / posShadowClip.w;
	return shadowNdc*0.5 + 0.5;
}
////
uint getSampleCount(float radius2, float quality, float maxSamples) { // max samples at 1/16 radius
	if (ShadowFilter != PCF) return 1;
	return uint(max(PI * radius2 * quality * maxSamples, 1));
}
uint getSampleCount(float radius2) {
	return getSampleCount(radius2, ShadowSamplesQuality, shadowSamples);
}
float shadowRadius = ShadowSoftness/(shadowDistance*2); // Meters/ShadowRange = Radius in Texels(how many pixel radius it is)
float shadowRadius2 = shadowRadius*shadowRadius;
uint shadowSampleCount = getSampleCount(shadowRadius2);
////
float sampleLight(vec3 coord, int cascade) {
	return ShadowFilter == Nearest ?
		step(coord.z, sampleShadowTex(coord.xy, cascade)) :
		sampleShadowTexFiltered(coord, cascade);
}
float sampleOpaqueLight(vec3 coord, int cascade) {
	return ShadowFilter == Nearest ?
		step(coord.z, sampleOpaqueShadowTex(coord.xy, cascade)) :
		sampleOpaqueShadowTexFiltered(coord, cascade);
}

vec3 calcVisibility(vec3 coord, int cascade) {
	if (SHADOW_COLOR == Off) {
		return vec3(sampleOpaqueLight(coord, cascade));
	} else {
		float visibility = sampleLight(coord, cascade); // Assumes translucents as opaque
		if (visibility >= 1) return vec3(1.0);
		
		float opaqueVisibility = sampleOpaqueLight(coord, cascade);
		
		if (opaqueVisibility > visibility) { // If its translucent, lit(1) > notLit(0), NOTE_PERF: This branch is questionable if it improves or degrades performance
			vec3 transmitted = ShadowFilter == Nearest ? loadShadowColorTex(ivec2(coord.xy*shadowMapSize), cascade).rgb : sampleShadowColorTex(coord.xy, cascade).rgb;
			
			// Below is lowkey magic but it works, visualize the values and youll see. I also dont understand why it works but it does 2026/11/12
			vec3 transmittedShadow = transmitted*opaqueVisibility;

			return mix(transmittedShadow, vec3(1), visibility);
		}
		
		return vec3(visibility);
	}
	return vec3(0.0);
}
vec3 calcVisibility(vec4 posShadowClip, int cascade) {
	 return calcVisibility(shadowClipToShadowScreen(posShadowClip), cascade);
}

// Bias & Distort, returns clip pos
vec4 transformShadowPos(vec4 shadowClipPos, vec3 normalsShadowClip, float NdotL) {
	float distortFac = getDistortShadowBias(shadowClipPos.xyz);

	float biasMult = max(distortFac, shadowBiasDistortFacMin * mix(1, 0.5, NdotL) )*ShadowDistortBias*9.0;
	vec3 bias = 20*biasMult*normalsShadowClip;
	shadowClipPos.xyz += (bias * ShadowBias * zSkew) / shadowMapResolution;
	shadowClipPos.xyz = distortShadow(shadowClipPos.xyz);
	
	return shadowClipPos;
}

vec3 gatherLightSamples(vec4 posShadowClip, vec3 normalsView, int cascade, uint sampleCount) {
	vec3 _posShadowScreen = shadowClipToShadowScreen(posShadowClip);
	if (clamp(_posShadowScreen, 0, 1) != _posShadowScreen) return vec3(1);
	
	vec3 total = vec3(0);
	float NdotL = max(dot(normalsView, lightDirection), 0);
	vec3 normalsShadowClip = cameraToShadowClipDir(normalsView);
	
	for (int i = 0; i < sampleCount; ++i) {
		if (ShadowFilter == PCF) {
			vec2 offset = goldenDiskSample(i, sampleCount);
			posShadowClip.xy += offset * shadowRadius * posShadowClip.w;
		}
		
		vec3 posShadowScreen = shadowClipToShadowScreen(transformShadowPos(posShadowClip, normalsShadowClip, NdotL)); 
		
		vec3 visibility = calcVisibility(posShadowScreen, cascade); 
		total += visibility;
    }
   
   total /= float(sampleCount);
   total = 1-((1-total)*step(ShadowThreshold, 1-total)); // Threshold shadow to reduce sillouete, not sure if this is optimal formula. Also unsure if its even a good shader feature or its too minor and should be culled
    
    return total;
}

vec3 gatherLightSamples(vec3 posCamera, vec3 normalsView, int cascade, uint sampleCount) {
	return gatherLightSamples(cameraToShadowClip(posCamera), normalsView, cascade, sampleCount);
}
vec3 gatherLightSamples(vec3 posCamera, vec3 normalsView, int cascade) {
	return gatherLightSamples(posCamera, normalsView, cascade, shadowSampleCount); 
}

int getCascade(vec3 posCamera) {
    return 0; // In Iris we dont have cascades, thus we only have 1 cascade
}
vec3 gatherLightSamples(vec3 posCamera, vec3 normalsView, uint sampleCount) {
	int cascade = getCascade(posCamera);
	if (cascade < 0) return vec3(0.0);
	
	return gatherLightSamples(cameraToShadowClip(posCamera), normalsView, cascade, sampleCount);
}
vec3 gatherLightSamples(vec3 posCamera, vec3 normalsView) {
	return gatherLightSamples(posCamera, normalsView, shadowSampleCount); 
}
