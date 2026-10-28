#ifndef reconstructZ_glsl
#define reconstructZ_glsl

vec3 reconstructZ(vec2 normals) {
    return vec3(normals, sqrt( max(1.0 - dot(normals, normals), 0) ));
}

#endif