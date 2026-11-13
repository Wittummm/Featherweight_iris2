#ifndef depthToNormals_glsl
#define depthToNormals_glsl

#include "/includes/func/depthToViewPos.glsl"
#include "/includes/func/linearizeDepth.glsl"

vec3 depthToNormals(vec2 fragCoord, vec4 depth, vec3 topLeft) {
	vec3 bottomLeft = depthToViewPos(fragCoord + oneOverScreenSize*vec2(0,1), depth.r);
	vec3 topRight = depthToViewPos(fragCoord + oneOverScreenSize*vec2(1,0), depth.b);
	
	return normalize(cross(topRight - topLeft, bottomLeft - topLeft));
}

vec3 depthToNormals(vec2 fragCoord, vec4 depth) {
	return depthToNormals(fragCoord, depth, depthToViewPos(fragCoord, depth.a));
}

#endif