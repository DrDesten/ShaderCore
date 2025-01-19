#ifndef CORE_DH_UNIFORMS
#define CORE_DH_UNIFORMS

#if defined DISTANT_HORIZONS

uniform float dhNearPlane;
uniform float dhFarPlane;
uniform int   dhRenderDistance;

uniform mat4 dhProjection;
uniform mat4 dhProjectionInverse;
uniform mat4 dhPreviousProjection;

#endif

#endif