#ifndef fade_glsl
#define fade_glsl
#include "/includes/settings/soft_shadows.glsl"

void fadeShadows(vec3 playerPos, out float alpha, out float softness) {
    alpha = 1;
    softness = 1;
    if (ShadowFadeShape == CIRCLE) {
        float dist = length(playerPos.xyz)/shadowDistance;

        if (ShadowFadeStrength > 0 && dist > ShadowFadeStart) { 
            alpha = 1-((dist - ShadowFadeStart) * ShadowFadeStrength); 
        }
        if (ShadowSoftnessFadeStrength > 0 && dist > ShadowSoftnessFadeStart) { 
            softness = max(1.0 - ((dist - ShadowSoftnessFadeStart) * ShadowSoftnessFadeStrength), 0); 
        } 

    } else if (ShadowFadeShape == BOX) {
        vec3 dist = abs(playerPos.xyz/shadowDistance);
        float maxAxis = max(dist.x,max(dist.y,dist.z));
    
        if (ShadowFadeStrength > 0 && maxAxis > ShadowFadeStart) {
            alpha = 1-((maxAxis-ShadowFadeStart)*ShadowFadeStrength);
        }
    
        if (ShadowSoftnessFadeStrength > 0 && maxAxis > ShadowSoftnessFadeStart) {
           softness = max(1-((maxAxis - ShadowSoftnessFadeStart) * ShadowSoftnessFadeStrength), 0);
        }
    }

    alpha = min(alpha, 1.0);
}

void fadeShadows(vec3 playerPos, out float alpha) {
    float _ = 0;
    fadeShadows(playerPos, alpha, _);
}

#endif

