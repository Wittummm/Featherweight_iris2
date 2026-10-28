#ifndef readWriteNormals_glsl
#define readWriteNormals_glsl

vec3 readNormals(vec2 f) {
    f = f * 2.0 - 1.0;
    // https://twitter.com/Stubbesaurus/status/937994790553227264
    vec3 n = vec3( f.x, f.y, 1.0 - abs( f.x ) - abs( f.y ) );
    float t = max( -n.z, 0.0 );
    n.x += n.x >= 0.0 ? -t : t;
    n.y += n.y >= 0.0 ? -t : t;
    return normalize(n);
}

// Normals
// https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/
#define octWrap(v) (1.0 - abs(v.yx)) * sign(v)

vec2 writeNormals(vec3 n) {
    n = normalize(n + 1e-6);
    n /= ( abs( n.x ) + abs( n.y ) + abs( n.z ) );
    n.xy = n.z > 0.0 ? n.xy : octWrap( n.xy );
    return n.xy * 0.5 + 0.5;
}

#endif