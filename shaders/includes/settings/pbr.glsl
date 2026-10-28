#ifndef pbr_glsl_0
#define pbr_glsl_0

#define PBR 1 //[0 1 2]
#if PBR != 0
    #define PBR_ENABLED
#endif
#define PBRFull PBR == 1
#define PBRReduced PBR == 2

#if PBR == 1
#define GBUFFER_FORMAT rg32ui // Must be lowercase, or else will fail on some drivers
/* 
const int colortex2Format = RG32UI; 
*/
#elif PBR == 2
#define GBUFFER_FORMAT r32ui // Must be lowercase, or else will fail on some drivers
/* 
const int colortex2Format = R32UI; 
*/
#endif

#define NormalMapStrength 1 // [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]

const vec4 gbuffer0Default = vec4(0.2, 0.03, 0.7, 0); // spec
const vec4 gbuffer1Default = vec4(-1, -1, 1, 0.25); // norm

#endif