
#include "/includes/func/shading/radiance.glsl"

//////////////////////////////

// PIN!
bool shade(out vec3 color, inout Material material, vec3 posView, vec2 lightLevel) {
	color = calcRadiance(posView, lightDirection, material, lightLevel);

	return false; // Returns if material was edited or not
}

void writeMaterial(Material material, inout vec4 GBuffer0, inout vec4 GBuffer1) {
    GBuffer0.r = writeRoughness(material.roughness);
    GBuffer1.rg = writeNormals(viewToWorldDir(material.normals));
    GBuffer0.g = writeReflectanceFromF0(material.f0.x);
}