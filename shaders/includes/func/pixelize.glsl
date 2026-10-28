#ifndef pixelize_glsl
#define pixelize_glsl

#include "/includes/settings/pixelization.glsl"

// General Pixelize function. Each feature can have their own Override
#define pixelize(pos, size) ((size == 0) ? (pos) : floor(pos*size + 0.003)/size)

#endif