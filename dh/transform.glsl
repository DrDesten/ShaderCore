#ifndef CORE_DH_TRANSFORM
#define CORE_DH_TRANSFORM

#include "../core/transform.glsl"
#include "uniforms.glsl"

#ifdef DISTANT_HORIZONS

vec3 toViewDH(vec3 clipPos) { // Clippos to viewpos
    return unprojectPerspectiveMAD(clipPos, dhProjectionInverse);
}
vec3 screenToViewDH(vec3 screenPos) { // screenpos to viewpos
    return toViewDH(screenPos * 2. - 1.);
}

vec3 backToClipDH(vec3 viewpos) { // viewpos to clip pos
    return projectPerspectiveMAD(viewpos, dhProjection);
}
vec4 backToClipWDH(vec3 viewpos) { // viewpos to clip pos
    vec4 tmp = projectHomogeneousMAD(viewpos, dhProjection);
    return vec4(tmp.xyz / tmp.w, tmp.w);
}
vec3 backToScreenDH(vec3 viewpos) { // viewpos to screen pos
    return backToClipDH(viewpos) * 0.5 + 0.5;
}

vec3 toPrevClipDH(vec3 prevviewpos) { // previous viewpos to previous screen pos
    return projectPerspectiveMAD(prevviewpos, dhPreviousProjection);
}
vec4 toPrevClipWDH(vec3 prevviewpos) { // previous viewpos to previous screen pos
    vec4 tmp = projectHomogeneousMAD(prevviewpos, dhPreviousProjection);
    return vec4(tmp.xyz / tmp.w, tmp.w);
}
vec3 toPrevScreenDH(vec3 prevviewpos) { // previous viewpos to previous screen pos
    return toPrevClipDH(prevviewpos) * 0.5 + 0.5;
}

#endif

#endif