#if !defined CORE_TONEMAP
#define CORE_TONEMAP

vec3 tm_reinhard(vec3 color, float a) {
    return color / (a + color);
}
vec3 tm_reinhard_luminance(vec3 color, float a) {
    float l = luminance(color);
    return color / (a+l);
}
vec3 tm_reinhard_jodie(vec3 color, float a) {
    float l   = luminance(color);
    vec3 tmc  = color / (color + a);
    return mix(color / (l+a), tmc, tmc);
}
vec3 tm_reinhard_sqrt(vec3 color, float a) {
    return color / sqrt(color * color + a);
}
vec3 tm_reinhard_sqrt_inverse(vec3 color, float a) {
    return sqrt(a) * color * inversesqrt(-color * color + 1);
}


vec3 tm_unreal(vec3 color) {
  return color / (color + 0.155) * 1.019;
}


vec3 tm_exp(vec3 color, float a) {
    return 1 - exp(-color * a);
}

#endif