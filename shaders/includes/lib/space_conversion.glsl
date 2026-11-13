#ifndef space_conversion_glsl
#define space_conversion_glsl

// World <-> View
vec3 viewToWorld(vec3 p) {
    return mul(vec4(p, 1.0), gbufferModelViewInverse).xyz + cameraPosition;
}
vec3 worldToView(vec3 p) {
    return mul(vec4(p - cameraPosition, 1.0), gbufferModelView).xyz;
}
vec3 viewToWorldDir(vec3 p) {
    return mul(p, mat3(gbufferModelViewInverse));
}
vec3 worldToViewDir(vec3 p) {
    return mul(p, mat3(gbufferModelView));
}

// World <-> Camera(Player space), no direction as is world space directions
vec3 worldToCamera(vec3 p) {
	return p - cameraPosition;
}
vec3 cameraToWorld(vec3 p) {
	return p + cameraPosition;
}

vec3 viewToCamera(vec3 p) {
    return mul(vec4(p, 1.0), gbufferModelViewInverse).xyz;
}
vec3 cameraToView(vec3 p) {
    return mul(vec4(p, 1.0), gbufferModelView).xyz;
}

#endif