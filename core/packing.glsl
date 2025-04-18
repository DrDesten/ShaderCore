#if !defined CORE_PACKING
#define CORE_PACKING

// Normal Packing

vec2 spheremapEncode(vec3 n) {
    float p = sqrt(n.z * 8. + 8.);
    return vec2(n.xy / p + 0.5);
}

vec3 spheremapDecode(vec2 v) {
    vec2 fenc = v * 4. - 2.;
    float f = dot(fenc, fenc);
    float g = sqrt(1. - f / 4.);
    return vec3(fenc * g, 1. - f / 2.);
}

vec2 signNotZero(vec2 v) {
    return vec2(
        v.x >= 0. ? 1. : -1., 
        v.y >= 0. ? 1. : -1.
    );
}

vec2 octahedralEncode(vec3 n) {
    float l1norm = abs(n.x) + abs(n.y) + abs(n.z);
    vec2  result = n.xy * (1.0 / l1norm);
    if (n.z < 0.0) {
        result = (1.0 - abs(result.yx)) * signNotZero(result.xy);
    }
    return result;
}

vec3 octahedralDecode(vec2 v) {
    vec3 n = vec3(v.x, v.y, 1.0 - abs(v.x) - abs(v.y));
    if (n.z < 0.0) {
        n.xy = (1.0 - abs(n.yx)) * signNotZero(n.xy);
    }
    return normalize(n);
}

// Vector to Integer Packing

const float INT8_SCALE     = 255.;
const float INT8_SCALE_INV = 1. / INT8_SCALE;

const float INT16_SCALE     = 65535.;
const float INT16_SCALE_INV = 1. / INT16_SCALE;

const float INT24_SCALE     = 16777215.;
const float INT24_SCALE_INV = 1. / INT24_SCALE;

// i24 -> vec3
// .x = ObABCDEF
//    & 0b0000EF
// .y = 0bABCDEF
//   >> 0b00ABCD
//    & 0b0000CD
// .z = 0bABCDEF
//   >> 0b0000AB
//    & 0b0000AB
vec3 i24ToVec3_f(float x) {
    int ix = int(x * INT24_SCALE);
    return vec3(
        ix       & 255,
        ix >> 8  & 255,
        ix >> 16 & 255
    ) * INT8_SCALE_INV;
}
vec3 i24ToVec3(int x) {
    return vec3(
        x       & 255,
        x >> 8  & 255,
        x >> 16 & 255
    ) * INT8_SCALE_INV;
}

// vec3 -> i24
// i = 0b000000
//   = 0b0000EF ( .x: 0b0000EF )
//   | 0b00CDEF ( .y: 0b0000CD, .y << 8:  0b00CD00 )
//   | 0bABCDEF ( .z: 0b0000AB, .z << 16: 0bAB0000 )
int vec3ToI24(vec3 x) {
    ivec3 ix = ivec3(x * INT8_SCALE);
    return ix.x | ix.y << 8 | ix.z << 16;
}
float vec3ToI24_f(vec3 x) {
    ivec3 ix = ivec3(x * INT8_SCALE);
    return float( ix.x | ix.y << 8 | ix.z << 16 ) * INT24_SCALE_INV;
}

// i16 -> vec2
// .x = ObABCD
//    & 0b00CD
// .y = 0bABCD
//   >> 0b00AB
//    & 0b00AB
vec2 i16ToVec2_f(float x) {
    int ix = int(x * INT16_SCALE);
    return vec2(
        ix      & 255,
        ix >> 8 & 255
    ) * INT8_SCALE_INV;
}
vec2 i16ToVec2(int x) {
    return vec2(
        x      & 255,
        x >> 8 & 255
    ) * INT8_SCALE_INV;
}

// vec2 -> i16
// i = 0b0000
//   = 0b00CD ( .x: 0b00CD )
//   | 0bABCD ( .y: 0b00AB, .y << 8: 0bAB00 )
int vec2ToI16(vec2 x) {
    ivec2 ix = ivec2(x * INT8_SCALE);
    return ix.x | ix.y << 8;
}
float vec2ToI16_f(vec2 x) {
    ivec2 ix = ivec2(x * INT8_SCALE);
    return float( ix.x | ix.y << 8 ) * INT16_SCALE_INV;
}


vec2 vec4to16x2(vec4 data) {
    ivec4 idata = ivec4(saturate(data) * 255 + 0.5);
    ivec2 encoded = ivec2(idata.x, idata.z);
    encoded.x |= idata.y << 8;
    encoded.y |= idata.w << 8;
    return vec2(encoded) * (1./65535.);
}
vec4 vec2x16to4(vec2 encoded) {
    ivec2 ienc  = ivec2(encoded * 65535.);
    ivec4 idata = ivec4(ienc.x & 255, 0, ienc.y & 255, 0);
    idata.y = ienc.x >> 8;
    idata.w = ienc.y >> 8;
    return vec4(idata) * (1./255.);
}

uint vec4toUI(vec4 data) {
    uvec4 idata = uvec4(saturate(data) * 255. + 0.5);
    uint encoded = idata.x;
    encoded     |= idata.y << 8u;
    encoded     |= idata.z << 16u;
    encoded     |= idata.w << 24u;
    return encoded;
}
vec4 UItovec4(uint encoded) {
    return vec4(
		float(encoded & 255u) * (1./255.),
		float((encoded >> 8u) & 255u) * (1./255.),
		float((encoded >> 16u) & 255u) * (1./255.),
		float(encoded >> 24u) * (1./255.)
	);
}


#endif