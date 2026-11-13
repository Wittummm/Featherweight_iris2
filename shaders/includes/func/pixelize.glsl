#ifndef pixelize_glsl
#define pixelize_glsl

#include "/includes/settings/pixelization.glsl"

#define pixelize(pos, size) \
    ((size) == FALLBACK \
        ? ((Pixelization == 0) ? (pos) : floor((pos) * Pixelization + 0.003) / (Pixelization)) \
        : ((size) == 0 ? (pos) : floor((pos) * (size) + 0.003) / (size)))

#define getPixelization(size) ((size == FALLBACK) ? (Pixelization) : (size))

#endif