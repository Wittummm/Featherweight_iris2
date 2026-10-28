#ifndef shadow_softness_glsl
#include "/includes/settings/shadows.glsl"

#define ShadowSamples 3 // [2 3 5 9 10 12 16 20 24 28 34 40 48 56 64]
#define ShadowSoftness 1 // [0.25 0.5 0.75 1 1.25 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10]


#define ShadowSoftnessFadeStrength 4 // [0 0.05 0.15 0.3 1.5 3 4 5]
#define SHADOW_SOFTNESS_FADE_START 0.13 // [0.08 0.13 0.17 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8]
float ShadowSoftnessFadeStart = ShadowFadeShape == CIRCLE ? SHADOW_SOFTNESS_FADE_START * circleCompensation : SHADOW_SOFTNESS_FADE_START;

#define shadow_softness_glsl
#endif

