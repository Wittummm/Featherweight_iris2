#include "/includes/shared/version.glsl"
#include "/includes/func/readWriteNormals.glsl"
#include "/includes/func/reconstructZ.glsl"
#include "/includes/settings/pbr.glsl"
#include "/includes/lib/space_conversion.glsl"
#include "/includes/func/pixelize.glsl"
#include "/includes/lib/material.glsl"
#include "/includes/lib/lighting.glsl"
#include "/includes/func/srgb_conversion.glsl"

in vec2 lightLevel;
#ifdef PROGRAM_GEOMETRY_BASIC
flat in vec3 vertColor;
#else
in vec3 vertColor;
#endif
in vec3 vertPosition;
flat in vec3 vertNormal;
#ifdef PBR_ENABLED
flat in vec4 tangent;
#endif

in vec2 texCoord;

#ifdef PBR_ENABLED
/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 Scene;
layout(location = 1) out vec2 LightLevel;
layout(location = 2) out uvec4 Gbuffer;
#else
/* RENDERTARGETS: 0,1 */
layout(location = 0) out vec4 Scene;
layout(location = 1) out vec2 LightLevel;
#endif

#ifdef PBR_ENABLED
mat3 t = mul(mat3(gbufferModelViewInverse), normalMatrix);
mat3 tbnNormalTangent(vec3 normal, vec4 tangent) {
    mat3 tbnMatrix;
    tbnMatrix[0] = normalize(t * tangent.xyz);
    tbnMatrix[2] = normalize(t * normal);
    tbnMatrix[1] = normalize(cross(tbnMatrix[0], tbnMatrix[2]) * tangent.w);
    return tbnMatrix;
}
#endif

void main() {
	vec2 dx = dFdx(texCoord);
	vec2 dy = dFdy(texCoord);

    Scene = vec4(vertColor.rgb, 1) * textureGrad(albedoAtlas, texCoord, dx, dy);
    discardCutout(Scene); // discard will trash derivatives but not ensure it will terminate, so we store derivatives beforehand.
    Scene = srgbToLinear(Scene);

    LightLevel = lightLevel;
    
    #ifdef PBR_ENABLED
        mat3 tbn = tbnNormalTangent(vertNormal, tangent);
        
        vec4 gbuffer0 = textureGrad(specularAtlas, texCoord, dx, dy);
        vec4 gbuffer1 = textureGrad(normalsAtlas, texCoord, dx, dy);
        
        vec2 normal = (gbuffer1.rg * 2.0) - 1.0;
        gbuffer1.rg = writeNormals(tbn * reconstructZ(normal * NormalMapStrength));
        
        Gbuffer = writeGBuffer(gbuffer0, gbuffer1);
    #endif

	#ifdef FORWARD
		Material material = Mat(Scene.rgb, gbuffer0, gbuffer1);

		shade(Scene.rgb, material, vertPosition, lightLevel);
	#endif
}
