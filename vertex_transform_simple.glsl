#if !defined CORE_VERTEX_TRANSFORM_SIMPLE
#define CORE_VERTEX_TRANSFORM_SIMPLE

// In Geometry Shaders, gl_* vertex attributes are not available
#ifndef GEO

vec3 getNormal() {
    return normalize(gl_NormalMatrix * gl_Normal);
}

vec2 getCoord() {
    return (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
vec2 getLmCoord() { // Intel Version (Less Optimised)
    return (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
}

mat3 getTBN(vec4 tangentAttribute) {
	vec3 normal   = normalize(gl_NormalMatrix * gl_Normal);
    vec3 tangent  = normalize(gl_NormalMatrix * tangentAttribute.xyz);
    vec3 binormal = normalize(gl_NormalMatrix * cross(tangentAttribute.xyz, gl_Normal.xyz) * tangentAttribute.w );
	return mat3(tangent, binormal, normal);
}

vec3 getView() {
    return mat3(gl_ModelViewMatrix) * gl_Vertex.xyz + gl_ModelViewMatrix[3].xyz;
}
vec4 getView4() {
    return gl_ModelViewMatrix * gl_Vertex;
}

#endif

vec3 viewToClip(vec3 viewPos) {
    return mat3(gl_ProjectionMatrix) * viewPos + gl_ProjectionMatrix[3].xyz;
}
vec4 viewToClip(vec4 viewPos) {
    return gl_ProjectionMatrix * viewPos;
}

int getID(vec4 entityAttribute) {
    return int(entityAttribute.x) - 1000;
}
int getID(int entityId) {
    return entityId - 1000;
}

#endif