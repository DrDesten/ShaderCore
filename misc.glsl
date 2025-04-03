#if !defined CORE_MISC
#define CORE_MISC

#include "core/utils.glsl"

vec2 cylinder(vec3 viewDir, vec3 cylinderDir, vec3 cylinderNormal, float cylinderRadius) {
    float cos_vd    = dot(viewDir, cylinderDir);
    float cos_vd_sq = sq(cos_vd);

    // viewDir with component in cylinderDir removed
    vec3  v_proj        = viewDir - cylinderDir * cos_vd;
    vec3  cylinderCross = cross(cylinderDir, cylinderNormal);

    // distance along cylinder
    float dist  = cylinderRadius * sqrt(cos_vd_sq / (1 - cos_vd_sq)) * sign(cos_vd);
    // inner angle
    float angle = atan(dot(v_proj, cylinderNormal), dot(v_proj, cylinderCross));

    return vec2(dist, angle);
}

#endif