#ifndef debug_settings_glsl
#define debug_settings_glsl

#define DebugEnabled Off // [Off On]

#define _ScreenEnabled Off // [Off On]
#define SPLIT 1
#define SLICE 2
#define _ScreenMode SPLIT // [SPLIT SLICE]
#define _DebugUIScale 2 // [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9 8]
#define _DebugShadowCascadeIndex 0 // [0 1 2 3 4 5 6 7]
#define _DebugStats Off // [Off On]
#define _ShowShadows Off // [Off On]
#define _ShowShadowCascades Off // [Off On]

#define SHOW_OFF -1
#define FULL 0
#define TOP_LEFT 1
#define TOP_RIGHT 2
#define BOTTOM_LEFT 3
#define BOTTOM_RIGHT 4
#define _ShowLightLevel SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowShadowMap SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowDepth SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowRoughness SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowReflectance SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowPorosity SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowEmission SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowNormals SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowAmbientOcclusion SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]
#define _ShowHeight SHOW_OFF // [SHOW_OFF FULL TOP_LEFT TOP_RIGHT BOTTOM_LEFT BOTTOM_RIGHT]

#endif