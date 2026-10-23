#include "/includes/shared/version.glsl"
#include "/includes/func/writeGBuffer.glsl"

in mediump vec2 lightLevel;
in lowp vec3 vertColor;
in vec3 vertPosition;
flat in mediump vec3 vertNormal;
#ifdef PBR_ENABLED
flat in mediump vec4 tangent;
#endif

in mediump vec2 texCoord;

/* RENDERTARGETS: 0,1 */
layout(location = 0) out vec3 Scene;
layout(location = 1) out vec2 LightLevel;
#ifdef PBR_ENABLED
/* RENDERTARGETS: 0,1,2 */
layout(location = 2) out uvec4 Gbuffer;
#endif

#ifdef PBR_ENABLED
mediump mat3 tbnNormalTangent(mediump vec3 normal, mediump vec4 tangent) {
    mat3 tbnMatrix;
    mat3 t = mat3(gbufferModelViewInverse) * normalMatrix;
    tbnMatrix[0] = normalize(t * tangent.xyz);
    tbnMatrix[2] = normalize(t * normal);
    tbnMatrix[1] = normalize(cross(tbnMatrix[0], tbnMatrix[2]) * tangent.w);
    return tbnMatrix;
}
#endif

void main() {
    #include "/includes/shared/core_to_compat.fsh"
    
    Scene = vec4(vertColor.rgb, 1) * texture(gtexture, texCoord);
    discardCutout(Scene);

    LightLevel = lightLevel;
    
    #ifdef PBR_ENABLED
        mat3 tbn = tbnNormalTangent(vertNormal, tangent);
        
        vec4 gbuffer0 = texture(specular, texCoord);
        vec4 gbuffer1 = texture(normals, texCoord);
        
        vec2 normal = (gbuffer1.rg * 2.0) - 1.0;
        gbuffer1.rg = writeNormals(vertNormal, tangent, reconstructZ(normal)*NORMAL_STRENGTH);
        
        Gbuffer = writeGBuffer(gbuffer0, gbuffer1);
    #endif
}
