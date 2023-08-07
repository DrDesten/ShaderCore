#if !defined CORE_PACKING
#define CORE_PACKING

const float INT8_SCALE     = 255;
const float INT8_SCALE_INV = 1 / INT8_SCALE;

const float INT16_SCALE     = 65535;
const float INT16_SCALE_INV = 1 / INT16_SCALE;

const float INT24_SCALE     = 16777215;
const float INT24_SCALE_INV = 1 / INT24_SCALE;

vec3 Int24ToVec3_asfloat(float x) {
    int ix = int(x * INT24_SCALE);
    return vec3(
        ix & 255,          // Bitwise AND. Masks the first 8 bits (255 -> 11111111 in binary, AND operation zeros out all other bits)
        (ix >> 8)  & 255,  // Bitshift down by 8. Moves the first 8 bits out. Afterwards, selecting the first 8 bits again (this isolates bit 9-16)
        (ix >> 16) & 255   // Same principle
    ) * INT8_SCALE_INV;
}
vec3 Int24ToVec3(int x) {
    return vec3(
        x & 255,          // Bitwise AND. Masks the first 8 bits (255 -> 11111111 in binary, AND operation zeros out all other bits)
        (x >> 8)  & 255,  // Bitshift down by 8. Moves the first 8 bits out. Afterwards, selecting the first 8 bits again (this isolates bit 9-16)
        (x >> 16) & 255   // Same principle
    ) * INT8_SCALE_INV;
}


vec2 Int16ToVec2_asfloat(float x) {
    int ix = int(x * INT16_SCALE);
    return vec2(
        ix & 255,        // Bitwise AND. Masks the first 8 bits (255 -> 11111111 in binary, AND operation zeros out all other bits)
        (ix >> 8) & 255  // Bitshift down by 8. Moves the first 8 bits out. Afterwards, selecting the first 8 bits again (this isolates bit 9-16)
    ) * INT8_SCALE_INV;
}
vec2 Int16ToVec2(int x) {
    return vec2(
        x & 255,         // Bitwise AND. Masks the first 8 bits (255 -> 11111111 in binary, AND operation zeros out all other bits)
        (x >> 8) & 255   // Bitshift down by 8. Moves the first 8 bits out. Afterwards, selecting the first 8 bits again (this isolates bit 9-16)
    ) * INT8_SCALE_INV;
}



int Vec3ToInt24(vec3 x) {
    ivec3 ix = ivec3(x * INT8_SCALE);
    return ix.x + (ix.y << 8) + (ix.z << 16);
}
float Vec3ToInt24_asfloat(vec3 x) {
    ivec3 ix = ivec3(x * INT8_SCALE);
    return float( ix.x + (ix.y << 8) + (ix.z << 16) ) * INT24_SCALE_INV;
}

int Vec2ToInt16(vec2 x) {
    ivec2 ix = ivec2(x * INT8_SCALE);
    return ix.x + (ix.y << 8);
}
float Vec2ToInt16_asfloat(vec2 x) {
    ivec2 ix = ivec2(x * INT8_SCALE);
    return float( ix.x + (ix.y << 8) ) * INT16_SCALE;
}

#endif