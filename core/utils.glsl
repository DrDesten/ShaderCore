#if !defined CORE_UTILS
#define CORE_UTILS

// HLSL Saturate

float saturate(float a) {
    return clamp(a, 0.0, 1.0);
}
vec2 saturate(vec2 a) {
    return clamp(a, 0.0, 1.0);
}
vec3 saturate(vec3 a) {
    return clamp(a, 0.0, 1.0);
}
vec4 saturate(vec4 a) {
    return clamp(a, 0.0, 1.0);
}

// Maximum Component

float maxc(vec2 v) {
    return max(v.x, v.y);
}
float maxc(vec3 v) {
    return max(max(v.x, v.y), v.z);
}
float maxc(vec4 v) {
    return max(max(v.x, v.y), max(v.z, v.w));
}

// Minimum Component

float minc(vec2 v) {
    return min(v.x, v.y);
}
float minc(vec3 v) {
    return min(min(v.x, v.y), v.z);
}
float minc(vec4 v) {
    return min(min(v.x, v.y), min(v.z, v.w));
}

// Sum of Components

float sum(vec2 v) {
    return v.x + v.y;
}
float sum(vec3 v) {
    return v.x + v.y + v.z;
}
float sum(vec4 v) {
    return (v.x + v.y) + (v.z + v.w);
}

// Average of Components

float avg(vec2 v) {
    return (v.x + v.y) / 2;
}
float avg(vec3 v) {
    return (v.x + v.y + v.z) / 3;
}
float avg(vec4 v) {
    return ((v.x + v.y) + (v.z + v.w)) / 4;
}

// Vector Midpoint

vec2 midpoint(vec2 v1, vec2 v2) {
    return (v1 + v2) / 2;
}
vec3 midpoint(vec3 v1, vec3 v2) {
    return (v1 + v2) / 2;
}
vec4 midpoint(vec4 v1, vec4 v2) {
    return (v1 + v2) / 2;
}

// Square Length

float sqmag(vec2 v) {
    return dot(v, v);
}
float sqmag(vec3 v) {
    return dot(v, v);
}
float sqmag(vec4 v) {
    return dot(v, v);
}

// Manhattan Length

float manhattan(vec2 v) {
    return abs(v.x) + abs(v.y);
}
float manhattan(vec3 v) {
    return abs(v.x) + abs(v.y) + abs(v.z);
}
float manhattan(vec4 v) {
    return (abs(v.x) + abs(v.y)) + (abs(v.z) + abs(v.w));
}

// Manhattan Distance

float manhattan(vec2 v1, vec2 v2) {
    return manhattan(v1-v2);
}
float manhattan(vec3 v1, vec3 v2) {
    return manhattan(v1-v2);
}
float manhattan(vec4 v1, vec4 v2) {
    return manhattan(v1-v2);
}

// Square

float sq(float x) {
    return x * x;
}
vec2 sq(vec2 x) {
    return x * x;
}
vec3 sq(vec3 x) {
    return x * x;
}
vec4 sq(vec4 x) {
    return x * x;
}

// Signed Square

float ssq(float x) {
    return x * abs(x);
}
vec2 ssq(vec2 x) {
    return x * abs(x);
}
vec3 ssq(vec3 x) {
    return x * abs(x);
}
vec4 ssq(vec4 x) {
    return x * abs(x);
}

// Cube

float cb(float x) {
    return x * x * x;
}
vec2 cb(vec2 x) {
    return x * x * x;
}
vec3 cb(vec3 x) {
    return x * x * x;
}
vec4 cb(vec4 x) {
    return x * x * x;
}

// Squared Square

float sqsq(float x) {
    return sq(sq(x));
}
vec2 sqsq(vec2 x) {
    return sq(sq(x));
}
vec3 sqsq(vec3 x) {
    return sq(sq(x));
}
vec4 sqsq(vec4 x) {
    return sq(sq(x));
}

// Logarithm base n

float logn(float base, float x) {
    return log2(x) / log2(base);
}

// Square Root Approximations

float sqrtf01(float x) {
    return x * (2.0 - x);
}
vec2 sqrtf01(vec2 x) {
    return x * (2.0 - x);
}
vec3 sqrtf01(vec3 x) {
    return x * (2.0 - x);
}
vec4 sqrtf01(vec4 x) {
    return x * (2.0 - x);
}
float sqrtf13(float x) {
    return x * ( -0.23606797749978969641 * x + 1.23606797749978969641 );
}
vec2 sqrtf13(vec2 x) {
    return x * ( -0.23606797749978969641 * x + 1.23606797749978969641 );
}
vec3 sqrtf13(vec3 x) {
    return x * ( -0.23606797749978969641 * x + 1.23606797749978969641 );
}
vec4 sqrtf13(vec4 x) {
    return x * ( -0.23606797749978969641 * x + 1.23606797749978969641 );
}

#endif