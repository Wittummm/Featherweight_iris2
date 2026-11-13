#ifndef shadows_glsl
#define shadows_glsl
#include "/includes/settings/_base.glsl"
#include "/includes/func/pixelize.glsl"

/// Soft Shadows
#define ShadowSamples 0.25 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1] Arbitrary constant(Advanced, dont change unless required)
int shadowSamples = int(ShadowSamples*1000000);
#define ShadowSamplesQuality 0.6 // [0 0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.825 0.85 0.875 0.9 0.925 0.95 0.975 1]
#define ShadowSoftness 0.25 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1] In block units

#define ShadowSoftnessFadeStrength 4 // [0 0.05 0.15 0.3 1.5 3 4 5]
#define SHADOW_SOFTNESS_FADE_START 0.13 // [0.08 0.13 0.17 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8]
/// General Shadows
const float shadowIntervalSize = 1.0;

#define ShadowsEnabled true // [false true]

#define ShadowCascadeCount 1 // Is on iris, iris doesnt do csm, means theres one cascade
const int shadowMapResolution = 420; // [128 192 256 420 512 640 768 896 1024 1280 1536 1792 2048 2560 3072 4096]
const float shadowDistance = 45;  // [10 25 45 60 70 80 90 110 130 150 180 200 230 260 300 350 400 450 500 550 600]
const float shadowDistanceRenderMul = 1.0;
const float sunPathRotation = 0; // [-100 -95 -90 -85 -80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

#define Nearest 0
#define Linear 1
#define PCF 2
#define ShadowFilter Linear // [Nearest Linear PCF]

#define ShadowDistort 4 // [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6]
#define ShadowThreshold 0 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]
#define SHADOW_BIAS 1 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2] Multiplier on Shadow Bias
float pixelMult = getPixelization(ShadowPixelization) == None ? 1.0 : 24.0/getPixelization(ShadowPixelization);
float ShadowBias = SHADOW_BIAS*max(pixelMult*0.75, 1);
#define ShadowDistortBias 1 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2 ] Multipler on Distort factor of Shadow Bias
#define ShadowBiasDistortFacMin 0.5 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2] Clamp on Distort factor of Shadow Bias
float minMult = ShadowFilter == PCF ? mix(1, 3, ShadowSoftness) : 1;
float shadowBiasDistortFacMin = ShadowBiasDistortFacMin * pow(shadowMapResolution/256, 0.65) * minMult;
#define ShadowBiasZSkew 7 // [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9 8 ] How much weighted to bias in Z instead of along normals
float upness = max(dot(lightDirection, upDirection), 0);
vec3 zSkew = normalize(vec3(1, 1, ShadowBiasZSkew * mix(0.1, 1, upness*upness)));

// Shadow Fading Out
#define CIRCLE 1
#define BOX 2
#define ShadowFadeShape BOX // [None CIRCLE BOX]
#define ShadowFadeStrength 7 // [0 1 2 3 4 5 6 7 8 9 10]
#define SHADOW_FADE_START 0.9 // [0.5 0.6 0.7 0.75 0.8 0.85 0.9 0.95]
const float circleCompensation = 1.4;
float ShadowFadeStart = ShadowFadeShape == CIRCLE ? SHADOW_FADE_START * circleCompensation : SHADOW_FADE_START;
float ShadowSoftnessFadeStart = ShadowFadeShape == CIRCLE ? SHADOW_SOFTNESS_FADE_START * circleCompensation : SHADOW_SOFTNESS_FADE_START;

// ShadowColor is not realtime because realtime has a small performance degradation, on my device 1-3 fps
#define SHADOW_COLOR On // [Off On] Takes 1-2 more samples per pixel
/*
const int shadowcolor0Format = RGB565;
*/
/*
const vec4 shadowcolor0ClearColor = vec4(0,0,0,1);
*/

#endif

