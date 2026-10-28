// WARNING: This should not be included/used directly, instead it should use shadow0.glsl or shadow1.glsl

#include "/includes/settings/soft_shadows.glsl"
#include "/includes/func/goldenDiskSample.glsl"
#include "/includes/func/fade.glsl"
#include "/includes/func/shadows/distortShadow.glsl"

int getCascade(vec3 shadowView) {
    return 0; // In Iris we dont have cascades, this we only have 1 cascade
}

////////////////////////////////
float sampleShadowPCF(vec3 coord, float sampleCount, float offset, int cascade) {
    //TODOEVENTUALLY: if sample count is low do hardcded pattern
    float totalShadowed = 0;

    for (int i = 0; i < sampleCount; ++i) {
        vec2 sampleOffset = goldenDiskSample(i, sampleCount) * offset;

        totalShadowed += sampleShadowMapFiltered(coord + vec3(sampleOffset.xy,0), cascade);
    }
    return 1 - (totalShadowed/sampleCount);
}

const float baseSoftness = 0.002;
float sampleShadowPCF(vec3 shadowScreenPos, int cascade) {
    return sampleShadowPCF(shadowScreenPos, ShadowSamples, baseSoftness*ShadowSoftness, cascade); 
}

// NOTE: We dont just make the algorithm specific functions this base name; as to potentially allow other code to use algorithm-specific function and not only the user-set one
float sampleShadow(vec3 shadowScreenPos, int cascade) {
    if (ShadowFilter == Nearest) {
        return step(sampleShadowMap(shadowScreenPos.xy, cascade), shadowScreenPos.z);
    } else if (ShadowFilter == Linear) {
        return 1.0 - sampleShadowMapFiltered(shadowScreenPos, cascade); 
    } else if (ShadowFilter == PCF) {
        return sampleShadowPCF(shadowScreenPos, cascade);
    }
}

float calcShadow(vec3 posPlayer, vec3 normalsView) {
    if (!ShadowsEnabled) return 0.0;

    float shadowStrength = 1;
    fadeShadows(posPlayer, shadowStrength);

    if (shadowStrength > 0) {
        vec3 shadowView = mul(vec4(posPlayer, 1), shadowModelView).xyz;
        int cascade = getCascade(shadowView);
        if (cascade == -1) return 0;

        vec4 shadowClip = mul(vec4(shadowView, 1.0), shadowProjection);
        float distortFac;
        shadowClip.xyz = distortShadow(shadowClip.xyz, distortFac);

        /// Z Biasing
        float zBias = ShadowBias;
        zBias *= distortFac*(cascade+1.0); // CREDIT: @builderb0y https://discord.com/channels/237199950235041794/1100010778133794827/1114276461856174121
       
        float d = abs(dot(normalsView, lightDirection));
        zBias *= pow(15, d); // NOTE: Biasing along normals, instead of depending on normals is probably better as it require less sharp pushing, but we dont have access to geometry normals so this isnst possible currently

        shadowClip.z -= zBias;
        ////////////////
        vec3 shadowNdc = shadowClip.xyz / shadowClip.w;
        vec3 shadowScreen = shadowNdc * 0.5 + 0.5;

        float shadow = sampleShadow(shadowScreen, cascade);
        shadow *= step(ShadowThreshold, shadow);

        return shadow * shadowStrength;
    }
    return 0;
}