#ifndef shadows_glsl
#define shadows_glsl
#include "/includes/settings/_base.glsl"

#define ShadowsEnabled On // [Off On]

#define ShadowCascadeCount 1 // Is on iris, iris doesnt do csm, means theres one cascade
const int shadowMapResolution = 420; // [128 192 256 420 512 640 768 896 1024 1280 1536 1792 2048 2560 3072 4096]
const float shadowDistance = 45;  // [10 25 45 60 70 80 90 110 130 150 180 200 230 260 300 350 400 450 500 550 600]
const float shadowDistanceRenderMul = 1.0;

#define Nearest 0
#define Linear 1
#define PCF 2
#define ShadowFilter Linear // [Nearest Linear PCF]

#define ShadowDistort 3 // [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6]
#define SHADOW_BIAS 0.6 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]
float ShadowBias = SHADOW_BIAS/shadowMapResolution;
#define ShadowThreshold 0 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]

// Shadow Fading Out
#define CIRCLE 1
#define BOX 2
#define ShadowFadeShape BOX // [None CIRCLE BOX]
#define ShadowFadeStrength 7 // [0 1 2 3 4 5 6 7 8 9 10]
#define SHADOW_FADE_START 0.9 // [0.5 0.6 0.7 0.75 0.8 0.85 0.9 0.95]
const float circleCompensation = 1.4;
float ShadowFadeStart = ShadowFadeShape == CIRCLE ? SHADOW_FADE_START * circleCompensation : SHADOW_FADE_START;

#endif

