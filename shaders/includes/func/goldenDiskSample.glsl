#ifndef goldenDiskSample_glsl
#define goldenDiskSample_glsl

vec2 goldenDiskSample(float index, float count) {
    float theta = index * 2.4;
    float r = sqrt((index + 0.5) / count);

    return r * vec2(cos(theta), sin(theta));
}

#endif