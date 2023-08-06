#if !defined CORE_WATER
#define CORE_WATER

float rotatedSine(vec2 pos, float angle) {
    vec2  dir = vec2(cos(angle), sin(angle));
    float len = dot(pos, dir);
    return sin(len);
}
vec3 rotatedSineNormals(vec2 pos, float offset, float angle, float strength) {
    vec2  dir = vec2(cos(angle), sin(angle));
    float len = dot(pos, dir) + offset;

    float derivative = cos(len);
    dir             *= derivative * strength;
    vec3  normals    = normalize(vec3(dir, 1));
    return normals;
}
vec3 rotatedWaveNormals(vec2 pos, float offset, float angle, float strength) {
    vec2  dir = vec2(cos(angle), sin(angle));
    float len = dot(pos, dir) + offset;

    float derivative = cos(len) * exp(sin(len));
    dir             *= derivative * strength;
    vec3  normals    = normalize(vec3(-dir, 1));
    return normals;
}

float waterOffsetSine(vec3 pos, float time) {
    pos.xz *= 0.25;
    pos.xz += time;

    float       offset   = 0;
    const mat2 rot       = MAT2_ROT(0.7, 2);
    vec2       shift     = vec2(.5, -2);
    float      amplitude = 0.4;

    offset += sin(pos.x) * amplitude + cos(pos.z) * amplitude;
    for (int i = 0; i < 1; i++) {
        pos.xz     = rot * pos.xz + shift * time;
        amplitude *= 0.25;
        offset    += sin(pos.x) * amplitude + cos(pos.z) * amplitude;
    }

    return offset;
}

float waterVertexOffset(vec3 pos, float time) {
    float flowHeight = fract(pos.y + 0.01);
    float offset     = waterOffsetSine(pos, time);

    float lowerbound = flowHeight;
    float upperbound = 1 - flowHeight;
    offset          *= (offset < 0 ? lowerbound : upperbound)
                     * float(flowHeight > 0.05);
    return offset;
}

vec3 waterNormalsSine(vec3 pos, float time) {
    time    = mod(time, 1000) - 500;

    float angle     = .1;
    float offset    = 0;
    float amplitude = 1;
    vec3  normal    = vec3(0);

    for (int i = 0; i < 3; i++) {
        angle     += .6;
        offset    += 1;
        amplitude *= 0.75;
        pos       *= 1.5;
        normal    += rotatedWaveNormals(pos.xz, offset + time / (offset * 4), angle, .1) * amplitude;
    }
    
    return normalize(normal);
}

#endif