#ifndef pbr_glsl

#define PBR 1 //[0 1]
#if PBR != 0
    #define PBR_ENABLED 
#endif
#if PBR == 1
    #define PBR_FULL 
#elif PBR == 2
    #define PBR_REDUCED
#endif

#define NORMAL_MAP_STRENGTH 1

#if PBR == 1
/* 
const int colortex2Format = RG32UI; 
*/
#elif PBR == 2
/* 
const int colortex2Format = R32UI; 
*/
#endif

const vec4 gbuffer0Default = vec4(0.2, 0.03, 0.7, 0); // spec
const vec4 gbuffer1Default = vec4(-1, -1, 1, 0.25); // norm

#define pbr_glsl
#endif