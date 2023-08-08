#if !defined CORE_DITHER
#define CORE_DITHER

vec2 R2(float n) {
    const vec2 a = vec2(1.0/PHI2, 1.0/(PHI2*PHI2));
    return fract(a * n + 0.5);
}

float Bayer2(vec2 a) {
    a = floor(a);
    return fract(a.x * .5 + a.y * a.y * .75);
}
#define Bayer4(a)   (Bayer2 (0.5 * (a)) * 0.25 + Bayer2(a))
#define Bayer8(a)   (Bayer4 (0.5 * (a)) * 0.25 + Bayer2(a))
#define Bayer16(a)  (Bayer8 (0.5 * (a)) * 0.25 + Bayer2(a))
#define Bayer32(a)  (Bayer16(0.5 * (a)) * 0.25 + Bayer2(a))
#define Bayer64(a)  (Bayer32(0.5 * (a)) * 0.25 + Bayer2(a))

float ign(vec2 co) { // Interlieved Gradient Noise, very noice noise ( ͡° ͜ʖ ͡°)
    vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
    return fract( magic.z * fract( dot(co, magic.xy) ) );
}

float ditherColor(vec2 co) {
    return Bayer4(co) * (1./255) - (.5/255);
}

float checkerboard(vec2 co) {
    co = floor(co);
    return fract(co.x * 0.5 + co.y * 0.5);
}

#endif