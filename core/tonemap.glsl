#if !defined CORE_TONEMAP
#define CORE_TONEMAP

vec3 reinhard_tonemap(vec3 color, float a) {
    return color / (a + color);
}
vec3 reinhard_luminance_tonemap(vec3 color, float a) {
    float l = luminance(color);
    return color / (a+l);
}
vec3 reinhard_jodie_tonemap(vec3 color, float a) {
    float l   = luminance(color);
    vec3 tmc  = color / (color + a);
    return mix(color / (l+a), tmc, tmc);
}
vec3 reinhard_sqrt_tonemap(vec3 color, float a) {
    return color / sqrt(color * color + a);
}
vec3 reinhard_sqrt_tonemap_inverse(vec3 color, float a) {
    return sqrt(a) * color * inversesqrt(-color * color + 1);
}


vec3 unreal_tonemap(vec3 color) {
  return color / (color + 0.155) * 1.019;
}


vec3 exp_tonemap(vec3 color, float a) {
    return 1 - exp(-color * a);
}

#endif