#ifndef CORE_DH_TEXTURES
#define CORE_DH_TEXTURES

#if defined DISTANT_HORIZONS

uniform sampler2D dhDepthTex0;
//uniform sampler2D dhDepthTex1;

float getDepthDH(vec2 coord) {
    return texture(dhDepthTex0, coord).x;
}
float getDepthDH(ivec2 icoord) {
    return texelFetch(dhDepthTex0, icoord, 0).x;
}

#endif

#endif