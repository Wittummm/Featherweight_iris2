#ifndef writeNormals_glsl

// Normals
// https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/
#define octWrap(v) (1.0 - abs(v.yx)) * sign(v)

vec2 writeNormals(vec3 n) {
    n = normalize(n + 1e-6);
    n /= ( abs( n.x ) + abs( n.y ) + abs( n.z ) );
		n.xy = n.z > 0.0 ? n.xy : octWrap( n.xy );
    return fma(n.xy, 0.5, 0.5); //return n.xy * 0.5 + 0.5;
}

#define writeNormals_glsl
#endif