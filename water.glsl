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

vec3 waterNormalsSine(vec3 pos, float time, float strength) {
    time = mod(time, 1000) - 500;

    float angleNoise  = noise(pos.xz * .03);
    float angleNoise2 = noise(pos.xz * .03 - 100);
    float angles[5] = float[5](
        time *  0.03,
        time * -0.05 + angleNoise,
        time *  0.02 - angleNoise,
        time * -0.04 + angleNoise2,
        time *  0.08 - angleNoise2
    );
    
    vec3  normal = vec3(0);
    float amp    = strength;
    for (int i = 0; i < 5; i++) {
        pos.xz *= 1.5;
        amp    *= 0.5;

        float offset = time * (0.5 + i * .5) + noise(pos.xz * .075) * 8;
        normal      += rotatedWaveNormals(pos.xz, offset, angles[i], amp);
    }

    return normalize(normal);
}


vec3 noiseNormals(vec2 coord, float strength) {
    vec2  e = vec2(0.01, 0);
    float C = fbm(coord,        2);
    float R = fbm(coord + e.xy, 2);
    float B = fbm(coord + e.yx, 2);

    vec3 n  = vec3(R-C, B-C, e.x);
    n.xy   *= strength;
    return normalize(n);
}

#endif