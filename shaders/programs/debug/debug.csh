#include "/includes/shared/version.glsl"
layout (local_size_x = 8, local_size_y = 8) in;
#include "/includes/lib/text_renderer.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/lib/shadows/shadow.glsl"
#include "/includes/func/depthToViewPos.glsl"
#include "/includes/func/linearizeDepth.glsl"
#include "/includes/settings/debug.glsl"
#include "/includes/settings/pbr.glsl"

layout(SCENE_FORMAT) uniform image2D sceneImg;
layout (GBUFFER_FORMAT) uniform uimage2D gbufferImg;

ivec2 moveTo(int position, ivec2 coord) {
    if ((_ScreenMode == SLICE) && position >= 0) {
        return coord;
    }

    int x = int(screenSize.x);
    int y = int(screenSize.y);

    if (position == 3) {
        coord = coord * 2;
    } else if (position == 4) {
        coord = ivec2(-x, 0) + coord*2;
    } else if (position == 1) {
        coord = ivec2(0, -y) + coord*2;
    } else if (position == 2) {
        coord = ivec2(-x, -y) + coord*2;
    } else if (position < 0) {
        coord = ivec2(-1);
    }

    return coord;
}
bool clip(ivec2 coord, int position) {
    ivec2 minimum = ivec2(0);
    ivec2 maximum = ivec2(screenSize);

    if (_ScreenMode == SLICE) {
        if (position == 3) {
            maximum /= 2;
        } else if (position == 4) {
            minimum.x = maximum.x/2;
            maximum.y /= 2;
        } else if (position == 1) {
            minimum.y = maximum.y/2;
            maximum.x /= 2;
        } else if (position == 2) {
            minimum = maximum/2;
        }
    }

    return all(lessThan(coord, maximum)) && all(greaterThanEqual(coord, minimum));
}

vec2 scale(vec2 coord) {
    return coord/max(_DebugUIScale, 0.001);
}

void newStat(vec4 uiCoord, inout int lineCounter) {
    beginText(ivec2(uiCoord.xy), ivec2(uiCoord.zw));
    printLine(lineCounter*2);
    lineCounter++;
}

void endColorStat(vec3 displayCol, inout vec4 color) {
    printString((_colon,_block,_space));
    color.rgb = mix(color.rgb, mix(text.result.rgb, displayCol.rgb, round(text.result.a)), text.result.a);
}

void endColorStat(vec4 displayCol, inout vec4 color) {
    printString((_colon,_block,_space));
    printFloat(displayCol.a); printString((_x));
    color.rgb = mix(color.rgb, mix(text.result.rgb, displayCol.rgb, round(text.result.a)), text.result.a);
}

Material mat(ivec2 t, vec4 color) {
	vec4 gbuffer0 = gbuffer0Default; vec4 gbuffer1 = gbuffer1Default; 
    loadGBufferTex(t, gbuffer0, gbuffer1);  
    return Mat(color.rgb, gbuffer0, gbuffer1);
}

void main() {
    if (!DebugEnabled) return;
    if (any(greaterThanEqual(gl_GlobalInvocationID.xy, screenSize))) return;
    ivec2 coord = ivec2(gl_GlobalInvocationID.xy);
    ivec2 squareCoord = ivec2(coord * vec2(aspectRatio, 1)); // scale to square grid based on height
    vec2 fragCoord = vec2(coord)*oneOverScreenSize;

    vec4 color = vec4(-1);
    float depth = loadDepthTex(coord);
    vec3 posView = depthToViewPos(fragCoord, depth);
    vec3 posPlayer = viewToCamera(posView); 

    ivec2 t;

    if (_ShowShadows) {
    	Material material = mat(coord, color);
    	vec3 normals = material.normals;
    	
		vec3 light = gatherLightSamples(viewToCamera(posView), normals);
        color.rgb = vec3(max(dot(normals, lightDirection), 0) * light);
    }

    if (_ShowShadowCascades) {
    	 vec3 shadowView = mul(vec4(posPlayer, 1), gbufferModelView).xyz;
        int currentCascade = getCascade(shadowView);
        if (currentCascade != -1) {
            float display = float(currentCascade)/ShadowCascadeCount;

            color.rgb = mix(color.rgb, vec3(1-display), 0.1);
        }
    }

    if (_ScreenEnabled) {
        vec3 baseNorm = vec3(0,1,0);
        t = moveTo(_ShowDepth, coord);
        if (clip(t, _ShowDepth)) { 
            color.rgb = linearizeDepthFull(loadDepthTex(t), 0.0005, renderDistance).rrr; 
        }
    
        #ifdef PBR_ENABLED
    
        t = moveTo(_ShowRoughness, coord);
        if (clip(t, _ShowRoughness)) { color.rgb = sqrt(vec3(mat(t, color).roughness)); }
    
        t = moveTo(_ShowReflectance, coord);
        if (clip(t, _ShowReflectance)) { color.rgb = mat(t, color).f0; color.a = 1; }
    
        t = moveTo(_ShowPorosity, coord);
        if (clip(t, _ShowPorosity)) { color.rgb = vec3(mat(t, color).porosity);  color.a = 1;}
    
        t = moveTo(_ShowEmission, coord);
        if (clip(t, _ShowEmission)) { color.rgb = vec3(mat(t, color).emission); }
    
        t = moveTo(_ShowNormals, coord);
        if (clip(t, _ShowNormals)) { color.rgb = mat(t, color).normals; }
    
        t = moveTo(_ShowAmbientOcclusion, coord);
        if (clip(t, _ShowAmbientOcclusion)) { color.rgb = vec3(mat(t, color).ao); }
    
        t = moveTo(_ShowHeight, coord);
        if (clip(t, _ShowHeight)) { color.rgb = vec3(mat(t, color).height); }
        #endif
    
        t = moveTo(_ShowLightLevel, coord);
        if (clip(t, _ShowLightLevel)) {
            color.rgb = vec3(loadLightTex(t).xy, 0);
        }

        // Display shadow map texture
        if (ShadowsEnabled) {
            t = ivec2(vec2(moveTo(_ShowShadowMap, ivec2(coord*(shadowMapSize/1536.0)) ))); // calibrate based on 1024px
            if (clip(t, _ShowShadowMap) && all(lessThan(t, shadowMapSize))) {
                vec2 pos = ((vec2(t))/shadowMapSize);
    
                float shadowDepth = sampleShadowTex(pos, _DebugShadowCascadeIndex);
                color.rgb = shadowDepth.rrr * (shadowDepth < 1 ? 1 : 0.0);
            }
            
                        t = ivec2(vec2(moveTo(_ShowShadowColor, ivec2(coord*(shadowMapSize/1536.0)) ))); // calibrate based on 1024px
            if (clip(t, _ShowShadowColor) && all(lessThan(t, shadowMapSize))) {
                vec2 pos = ((vec2(t))/shadowMapSize);
    
                vec4 shadowColor = sampleShadowColorTex(pos, _DebugShadowCascadeIndex);
                color.rgb = shadowColor.rgb;
            }
        }
    }

    // Visualize Settings //
    //TODOREMOVE: causes shit ton of lag, so bye bye, will probably be redone from scratch, kept for reference
    /*
    vec4 uiCoord = vec4(scale(coord), scale(ivec2(10, screenSize.y - 10)));
    int line = 0;

    if (_DebugStats) {
        newStat(uiCoord, line);
        printFloat(frameTime*1000); printString((_space, _m, _s));
        endText(color.rgb);

        newStat(uiCoord, line);
        printString((_N,_e,_a,_r,_minus,_F,_a,_r,_colon));
        printString((_opsqr));
        printFloat(nearPlane);
        printString((_comma));
        printFloat(renderDistance);
        printString((_clsqr));
        endText(color.rgb);

        if (ShadowsEnabled) {
            newStat(uiCoord, line);
            printString((_S,_h,_a,_d,_o,_w,_space,_r,_e,_s,_colon,_opsqr));
            printIvec2(textureSize(shadowMap, 0).xy);
            printString((_clsqr,_x));
            printInt(ShadowCascadeCount);
            endText(color.rgb);
        }
        //newStat(uiCoord, line);
        //printString((_S,_h,_a,_d,_o,_w,_s,_colon,_O,_f,_f));
        endText(color.rgb);
    }*/

    if (all(lessThanEqual(color, vec4(-1)))) {
        color.rgb = loadSceneTex(coord);
    } else {
        //color *= 25000;
        color.a = 1;
    }

    if (color.a > 0) imageStore(sceneImg, coord, writeScene(color));
}
