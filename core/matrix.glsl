#if !defined CORE_MATRIX
#define CORE_MATRIX

////////////////////////////////////////////////////////////////////////
// Matrix Transformations

vec3 projectOrthographicMAD(in vec3 position, in mat4 projectionMatrix) {
    return vec3(projectionMatrix[0].x, projectionMatrix[1].y, projectionMatrix[2].z) * position + projectionMatrix[3].xyz;
}
vec2 projectOrthographicMAD(in vec2 position, in mat4x2 projectionMatrix) {
    return vec2(projectionMatrix[0].x, projectionMatrix[1].y) * position + projectionMatrix[3].xy;
}
vec3 projectPerspectiveMAD(in vec3 position, in mat4 projectionMatrix) {
    return projectOrthographicMAD(position, projectionMatrix) / -position.z;
}
vec2 projectPerspectiveMAD(in vec3 position, in mat4x2 projectionMatrix) {
    return projectOrthographicMAD(position.xy, projectionMatrix) / -position.z;
}
vec4 projectHomogeneousMAD(in vec3 position, in mat4 projectionMatrix) {
    return vec4(projectOrthographicMAD(position, projectionMatrix), -position.z);
}

vec3 unprojectOrthographicMAD(in vec2 position, in mat4 inverseProjectionMatrix) {
    return vec3(vec2(inverseProjectionMatrix[0].x, inverseProjectionMatrix[1].y) * position + inverseProjectionMatrix[3].xy, inverseProjectionMatrix[3].z);
}
vec3 unprojectPerspectiveMAD(in vec3 position, in mat4 inverseProjectionMatrix) {
    return unprojectOrthographicMAD(position.xy, inverseProjectionMatrix) / (inverseProjectionMatrix[2].w * position.z + inverseProjectionMatrix[3].w);
}
vec4 unprojectHomogeneousMAD(in vec3 position, in mat4 inverseProjectionMatrix) {
    return vec4(unprojectOrthographicMAD(position.xy, inverseProjectionMatrix), inverseProjectionMatrix[2].w * position.z + inverseProjectionMatrix[3].w);
}
vec3 transformMAD(in vec3 position, in mat4 transformationMatrix) {
    return mat3(transformationMatrix) * position + transformationMatrix[3].xyz;
}


////////////////////////////////////////////////////////////////////////
// Other Matrix Functions

#define MAT2_ROT(angle, scale) \
    (mat2(cos(angle), sin(angle), -sin(angle), cos(angle)) * scale);

mat2 mat2Rot(float angle) {
    float ca = cos(angle), sa = sin(angle);
    return mat2(ca, sa, -sa, ca);
}

#define VEC2_ROT(angle, length) \
    vec2(cos(angle), sin(angle));

vec2 vec2Rot(float angle) {
    return vec2(cos(angle), sin(angle));
}

mat3 rotationMatrix3DX(float angle) { // You can use mat2 instead, but flip angle and keep X. > vec3(x, mat2 * yz)
    float s = sin(angle);
    float c = cos(angle);
    return mat3(
        1, 0, 0,
        0, c,-s,
        0, s, c
    );
}
mat3 rotationMatrix3DZ(float angle) { // You can use mat2 instead, but flip angle and keep Z. > vec3(mat2 * xy, z)
    float s = sin(angle);
    float c = cos(angle);    
    return mat3(
        c, -s, 0,
        s,  c, 0,
        0,  0, 1
    );
}

mat3 rotationMatrix3D(vec3 axis, float angle) {
    float s  = sin(angle);
    float c  = cos(angle);
    float oc = 1.0 - c;
    return mat3(
        oc * axis.x * axis.x + c,          oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s,
        oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c,          oc * axis.y * axis.z - axis.x * s,
        oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c
    );
}

vec3 arbitraryTangent(vec3 normal) {
    // Equivalent to: normalize( cross(normal, vec3(0,0,1)) )
    return vec3(normal.y, -normal.x, 0) * (1 / sqrt( sqmag( normal.xy ) ));
}

mat3 arbitraryTBN(vec3 normal) {
    // Equivalent to: cross(normal, vec3(0,0,1))
    vec3 tangent  = vec3(normal.y, -normal.x, 0);
    // Equivalent to: cross(normal, tangent)
    vec3 binomial = vec3(-normal.x * normal.z, normal.x * normal.z, (normal.y * normal.y) + (normal.x * normal.x));
    return mat3(normalize(tangent), normalize(binomial), normal);
}

#endif