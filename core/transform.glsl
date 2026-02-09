#if !defined CORE_TRANSFORM
#define CORE_TRANSFORM

////////////////////////////////////////////////////////////////////////
// Matrix Projections

vec3 projectOrthographicMAD(vec3 position, mat4 projectionMatrix_) {
    return vec3(projectionMatrix_[0].x, projectionMatrix_[1].y, projectionMatrix_[2].z) * position + projectionMatrix_[3].xyz;
}
vec2 projectOrthographicMAD(vec2 position, mat4x2 projectionMatrix_) {
    return vec2(projectionMatrix_[0].x, projectionMatrix_[1].y) * position + projectionMatrix_[3].xy;
}
vec3 projectPerspectiveMAD(vec3 position, mat4 projectionMatrix_) {
    return projectOrthographicMAD(position, projectionMatrix_) / -position.z;
}
vec2 projectPerspectiveMAD(vec3 position, mat4x2 projectionMatrix_) {
    return projectOrthographicMAD(position.xy, projectionMatrix_) / -position.z;
}
vec4 projectHomogeneousMAD(vec3 position, mat4 projectionMatrix_) {
    return vec4(projectOrthographicMAD(position, projectionMatrix_), -position.z);
}

vec3 unprojectOrthographicMAD(vec2 position, mat4 inverseProjectionMatrix) {
    return vec3(vec2(inverseProjectionMatrix[0].x, inverseProjectionMatrix[1].y) * position + inverseProjectionMatrix[3].xy, inverseProjectionMatrix[3].z);
}
vec3 unprojectPerspectiveMAD(vec3 position, mat4 inverseProjectionMatrix) {
    return unprojectOrthographicMAD(position.xy, inverseProjectionMatrix) / (inverseProjectionMatrix[2].w * position.z + inverseProjectionMatrix[3].w);
}
vec4 unprojectHomogeneousMAD(vec3 position, mat4 inverseProjectionMatrix) {
    return vec4(unprojectOrthographicMAD(position.xy, inverseProjectionMatrix), inverseProjectionMatrix[2].w * position.z + inverseProjectionMatrix[3].w);
}
vec3 transformMAD(vec3 position, mat4 transformationMatrix) {
    return mat3(transformationMatrix) * position + transformationMatrix[3].xyz;
}

////////////////////////////////////////////////////////////////////////
// Other Transformations

float linearizeDepth(float depth,float nearPlane,float farPlane) { // Linearizes the depth to viewspace z
    return 2. * nearPlane * farPlane / (farPlane + nearPlane - (depth * 2. - 1.) * (farPlane - nearPlane));
}
float linearizeDepthInverse(float linearDepth, float nearPlane, float farPlane) { // Un-Linearizes viewspace z to screenspace depth
    return (farPlane * (linearDepth-nearPlane)) / (linearDepth * (farPlane-nearPlane));
}

float linearizeDepthf(float depth, float nearPlaneInverse) {
    return 1. / (-depth * nearPlaneInverse + nearPlaneInverse);
}
float linearizeDepthfDivisor(float depth, float nearPlaneInverse) { // Returns 1 / linearizeDepthf
    return -depth * nearPlaneInverse + nearPlaneInverse;
}
float linearizeDepthfInverse(float linearDepth, float nearPlaneInverse) {
    return 1. / -linearDepth * nearPlaneInverse + 1.;
}

#endif