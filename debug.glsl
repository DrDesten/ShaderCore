#if ! defined CORE_DEBUG
#define CORE_DEBUG

vec4 BarLinear(vec2 coord, vec2 pos, vec2 size, float lower, float upper, float value) {
    if (coord.x < pos.x || coord.x > pos.x + size.x || coord.y < pos.y || coord.y > pos.y + size.y) {
        return vec4(0);
    }

    float mapped = (value - lower) / (upper - lower);
    float thresh = pos.y + size.y * mapped;

    if (coord.y < thresh) { // Filled in
        return vec4(1,1,1,1);
    } else { // Not Filled
        return vec4(1,1,1,0.5);
    }
}

vec4 BarChart(vec2 coord, float lower, float upper, float value, int id) {
    vec2 pos = vec2(0.05 + id * 0.1, 0.05);
    vec2 size = vec2(0.05, 0.9);
    return BarLinear(coord, pos, size, lower, upper, value);
}
vec4 BarChart(vec2 coord, float lower, float upper, float value) {
    return BarChart(coord, lower, upper, value, 0);
}
vec4 BarChart(vec2 coord, vec3 values) {
    return BarChart(coord, values.x, values.y, values.z, 0);
}
vec4 BarChart(vec2 coord, vec3 v1, vec3 v2) {
    return BarChart(coord, v1.x, v1.y, v1.z, 0)
         + BarChart(coord, v2.x, v2.y, v2.z, 1);
}
vec4 BarChart(vec2 coord, vec3 v1, vec3 v2, vec3 v3) {
    return BarChart(coord, v1.x, v1.y, v1.z, 0)
         + BarChart(coord, v2.x, v2.y, v2.z, 1)
         + BarChart(coord, v3.x, v3.y, v3.z, 2);
}
vec4 BarChart(vec2 coord, vec3 v1, vec3 v2, vec3 v3, vec3 v4) {
    return BarChart(coord, v1.x, v1.y, v1.z, 0)
         + BarChart(coord, v2.x, v2.y, v2.z, 1)
         + BarChart(coord, v3.x, v3.y, v3.z, 2)
         + BarChart(coord, v4.x, v4.y, v4.z, 3);
}
vec4 BarChart(vec2 coord, vec3 v1, vec3 v2, vec3 v3, vec3 v4, vec3 v5) {
    return BarChart(coord, v1.x, v1.y, v1.z, 0)
         + BarChart(coord, v2.x, v2.y, v2.z, 1)
         + BarChart(coord, v3.x, v3.y, v3.z, 2)
         + BarChart(coord, v4.x, v4.y, v4.z, 3)
         + BarChart(coord, v5.x, v5.y, v5.z, 4);
}

#endif