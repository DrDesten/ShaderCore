#if !defined CORE_UTILS
#define CORE_UTILS

/* #define DECLR_MULTIDIM(DECLR_MACRO) \
    DECLR_MACRO(float)              \;
    DECLR_MACRO(vec2)               \;
    DECLR_MACRO(vec3)               \;
    DECLR_MACRO(vec4)               \; */

// HLSL Saturate

float saturate(float a) {
    return clamp(a, 0., 1.);
}
vec2 saturate(vec2 a) {
    return clamp(a, 0., 1.);
}
vec3 saturate(vec3 a) {
    return clamp(a, 0., 1.);
}
vec4 saturate(vec4 a) {
    return clamp(a, 0., 1.);
}

// Epsilon Compare

bool closeTo(float a, float b, float epsilon) {
    return abs(a-b) < epsilon;
}

// Branchless step()

float fstep(float edge, float x) {
    return saturate((x - edge) * 1e36);
}
float fstep(float edge, float x, float slope) {
    return saturate((x - edge) * slope);
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

// Squared Square (4th Power)

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

// Sigmoid

float sigmoid(float x) {
    return 1 / (1 + exp(-x));
}
vec2 sigmoid(vec2 x) {
    return 1 / (1 + exp(-x));
}
vec3 sigmoid(vec3 x) {
    return 1 / (1 + exp(-x));
}
vec4 sigmoid(vec4 x) {
    return 1 / (1 + exp(-x));
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

// Quadratic functions where f(0.5) = 1 and f(0) = f(1) = 0 

float peak05(float x) { 
    return x * (-4*x + 4); 
}
vec2  peak05(vec2 x) { 
    return x * (-4*x + 4); 
}
vec3 peak05(vec3 x) { 
    return x * (-4*x + 4); 
}
vec4 peak05(vec4 x) { 
    return x * (-4*x + 4); 
}

// Smoothstep functions with smooth 2nd derivative 

float smootherstep(float x) {
    return saturate( cb(x) * (x * (6. * x - 15.) + 10.) );
}
float smootherstep(float edge0, float edge1, float x) {
    x = saturate((x - edge0) * (1. / (edge1 - edge0)));
    return cb(x) * (x * (6. * x - 15.) + 10.);
}

// Map Range

float map(float value, float from_min, float from_max, float to_min, float to_max) {
  return to_min + (value - from_min) * (to_max - to_min) / (from_max - from_min);
}
float mapclamp(float value, float from_min, float from_max, float to_min, float to_max) {
    return clamp(map(from_min, from_max, to_min, to_max, value), to_min, to_max);
}

#endif