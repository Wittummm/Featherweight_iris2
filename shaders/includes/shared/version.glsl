#ifdef DISTANT_HORIZONS_SHADER
	#version 460 compatibility 
#else
	#version 460 compatibility
#endif

// Only use these for quick debug and never actual code!
#define RED vec3(1,0,0)
#define GREEN vec3(0,1,0)
#define BLUE vec3(0,0,1)

#include "/includes/shared/uniforms.glsl"
