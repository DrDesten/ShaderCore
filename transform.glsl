#if !defined CORE_TRANSFORM_2
#define CORE_TRANSFORM_2

#include "core/transform.glsl"

uniform float near;
uniform float nearInverse;
uniform float far;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;

float fovScale = gbufferProjection[1][1] * 0.7299270073;

vec3 toView(vec3 clippos) { // Clippos to viewPos
    return unprojectPerspectiveMAD(clippos, gbufferProjectionInverse);
}
vec3 screenToView(vec3 screenPos) { // Clippos to viewPos
    return toView(screenPos * 2 - 1);
}


vec3 toPlayer(vec3 viewPos) { // Viewpos to Playerfeetpos
    return mat3(gbufferModelViewInverse) * viewPos + gbufferModelViewInverse[3].xyz;
}
vec3 toPlayerEye(vec3 viewPos) { // Viewpos to Playereyepos
    return mat3(gbufferModelViewInverse) * viewPos;
}
vec3 playerEyeToFeet(vec3 playerEyePos) {
    return playerEyePos + gbufferModelViewInverse[3].xyz;
}

vec3 toWorld(vec3 playerPos) { // Playerfeetpos to worldPos
    return playerPos + cameraPosition;
}


vec3 backToPlayer(vec3 worldPos) { // Worldpos to playerfeetpos
    return worldPos - cameraPosition;
}

vec3 backToView(vec3 playerPos) { // playerfeetpos to viewPos
    return mat3(gbufferModelView) * (playerPos - gbufferModelViewInverse[3].xyz);
}
vec3 eyeToView(vec3 playerEyePos) {
    return mat3(gbufferModelView) * playerEyePos;
}

vec3 backToClip(vec3 viewPos) { // viewPos to clip pos
    return projectPerspectiveMAD(viewPos, gbufferProjection);
}

vec4 backToClipW(vec3 viewPos) { // viewPos to clip pos
    vec4 tmp = projectHomogeneousMAD(viewPos, gbufferProjection);
    return vec4(tmp.xyz / tmp.w, tmp.w);
}

vec3 backToScreen(vec3 viewPos) { // viewPos to screen pos
    return backToClip(viewPos) * 0.5 + 0.5;
}

vec4 backToScreenW(vec3 viewPos) { // viewPos to screen pos
    return backToClipW(viewPos) * 0.5 + 0.5;
}


vec3 toPrevPlayer(vec3 worldPos) { // Worldpos to previous playerfeetpos
    return worldPos - previousCameraPosition;
}

vec3 toPrevView(vec3 prevPlayerPos) { // previous playerfeetpos to previous viewPos
    return mat3(gbufferPreviousModelView) * prevPlayerPos + gbufferPreviousModelView[3].xyz;
}
vec3 eyeToPrevView(vec3 prevPlayerEyePos) { // previous playereyepos to previous viewPos
    return mat3(gbufferPreviousModelView) * prevPlayerEyePos;
}

vec3 toPrevClip(vec3 prevViewPos) { // previous viewPos to previous screen pos
    return projectPerspectiveMAD(prevViewPos, gbufferPreviousProjection);
}
vec4 toPrevClipW(vec3 prevViewPos) { // previous viewPos to previous screen pos
    vec4 tmp = projectHomogeneousMAD(prevViewPos, gbufferPreviousProjection);
    return vec4(tmp.xyz / tmp.w, tmp.w);
}
vec3 toPrevScreen(vec3 prevViewPos) { // previous viewPos to previous screen pos
    return projectPerspectiveMAD(prevViewPos, gbufferPreviousProjection) * 0.5 + 0.5;
}


vec4 reprojectScreen(vec3 screenPos) {
    // Project to World Space
    vec3 pos = screenToView(screenPos);
    pos      = toPlayer(pos);
    pos      = toWorld(pos);

    // Project to previous Screen Space
    pos       = toPrevPlayer(pos);
    pos       = toPrevView(pos);
    vec4 clip = toPrevClipW(pos);
    return vec4(clip.xyz * .5 + .5, clip.w);
}
vec3 previousReproject(vec3 clipPos) {
    // Project to World Space
    vec3 pos = toView(clipPos);
    pos      = toPlayer(pos);
    pos      = toWorld(pos);

    // Project to previous Screen Space
    pos      = toPrevPlayer(pos);
    pos      = toPrevView(pos);
    return     toPrevScreen(pos);
}
vec3 previousReprojectClip(vec3 clipPos) {
    // Project to World Space
    vec3 pos = toView(clipPos);
    pos      = toPlayer(pos);
    pos      = toWorld(pos);

    // Project to previous Screen Space
    pos      = toPrevPlayer(pos);
    pos      = toPrevView(pos);
    return     toPrevClip(pos);
}

vec3 reprojectTAA(vec3 screenPos) {
    if (screenPos.z < 0.56) return screenPos;

    // Project to World Space
    vec3 pos = screenToView(screenPos);
    pos      = toPlayer(pos);
    pos      = toWorld(pos);

    // Project to previous Screen Space
    pos      = toPrevPlayer(pos);
    pos      = toPrevView(pos);
    return     toPrevScreen(pos);
}

vec3 screenSpaceMovement(vec3 clipPos, vec3 weight) {
    // Project to Player Space
    vec3 pos = toView(clipPos);
    pos      = toPlayer(pos);

    // Calculate World Space
    pos      += (cameraPosition - previousCameraPosition) * 1.;

    // Project to previous Screen Space
    pos      = backToView(pos);
    return     backToScreen(pos);
}

#endif