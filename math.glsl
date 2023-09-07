#if !defined CORE_MATH
#define CORE_MATH

////////////////////////////////////////////////////////////////////////
// Constants

#define GAMMA 2.2

#include "core/constants.glsl"

////////////////////////////////////////////////////////////////////////
// General Functions

bool closeTo(float a, float b, float epsilon) {
    return abs(a-b) < epsilon;
}

float fstep(float edge, float x) { // Fast step() function with no branching
    return clamp((x - edge) * 1e36, 0, 1);
}
float fstep(float edge, float x, float slope) { // Fast step() function with no branching
    return clamp((x - edge) * slope, 0, 1);
}

#include "core/utils.glsl"

float angleBetween(vec3 v1, vec3 v2) {
    return acos(dot(normalize(v1), normalize(v2)));
}

float asinf(float x) { // s(x) = x + x³/8 + x^5/5
    float x2  = x*x;
    float x4  = x2*x2;
    return x + (x2 * x * .125) + (x4 * x * .2);
}
float acosf(float x) {
    return HALF_PI - asinf(x);
}

float smootherstep(float x) { // Second derivative zero as well
    return saturate( cb(x) * (x * (6. * x - 15.) + 10.) );
}
float smootherstep(float edge0, float edge1, float x) {
    x = saturate((x - edge0) * (1. / (edge1 - edge0)));
    return cb(x) * (x * (6. * x - 15.) + 10.);
}


float tri(float x) {
    return abs(fract(x) * 2 - 1);
}

#include "core/dither.glsl"
#include "core/random.glsl"

#include "core/matrix.glsl"

////////////////////////////////////////////////////////////////////////
// Color-Specific functions

#include "core/color.glsl"

vec4 cubic(float v) {
    vec4 n = vec4(1.0, 2.0, 3.0, 4.0) - v;
    vec4 s = n * n * n;
    float x = s.x;
    float y = s.y - 4.0 * s.x;
    float z = s.z - 4.0 * s.y + 6.0 * s.x;
    float w = 6.0 - x - y - z;
    return vec4(x, y, z, w) * (1.0/6.0);
}

vec4 textureBicubic(sampler2D sampler, vec2 coord, vec2 samplerSize, vec2 pixelSize) {
    coord = coord * samplerSize - 0.5;

    vec2 fxy = fract(coord);
    coord -= fxy;

    vec4 xcubic = cubic(fxy.x);
    vec4 ycubic = cubic(fxy.y);

    vec4 c = coord.xxyy + vec2 (-0.5, +1.5).xyxy;

    vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
    vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;

    offset *= pixelSize.xxyy;

    vec4 sample0 = texture(sampler, offset.xz);
    vec4 sample1 = texture(sampler, offset.yz);
    vec4 sample2 = texture(sampler, offset.xw);
    vec4 sample3 = texture(sampler, offset.yw);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix(
        mix(sample3, sample2, sx), 
        mix(sample1, sample0, sx)
    , sy);
}

float triangle(float x) {
    return saturate(1 - abs(x));
}
float sincNorm(float x) {
    return x == 0 ? 1 : sin(x*PI) / (x*PI);
}
float bell(float x) {
    return exp(-(x*x*2));
}

vec4 textureSmoothstep(sampler2D sampler, vec2 coord, vec2 samplerSize, vec2 samplerSizeInverse) {
    vec2 icoord    = coord * samplerSize;
    vec2 pixCoord  = fract(icoord);
    //pixCoord       = pixCoord * (pixCoord * (4 * pixCoord - 6) + 3);
    pixCoord       = pixCoord * (pixCoord * (2.22222 * pixCoord - 3.33333) + 2.11111);
    return texture(sampler, (floor(icoord) + pixCoord) * samplerSizeInverse);
}


/////////////////////////////////////////////////////////////////////////////////////////
//                                 TONEMAPPING

#include "core/tonemap.glsl"

/////////////////////////////////////////////////////////////////////////////////
//                              OTHER FUNCTIONS

float peak05(float x) { return x * (-4*x + 4); }
vec2  peak05(vec2 x)  { return x * (-4*x + 4); }
vec3  peak05(vec3 x)  { return x * (-4*x + 4); }
vec4  peak05(vec4 x)  { return x * (-4*x + 4); }

float lineDist2P(vec2 coord, vec2 start, vec2 end) {
    vec2 pa = coord - start;
    vec2 ba = end - start;
    float t = clamp(dot(pa, ba) / dot(ba, ba), 0, 1);
    return sqmag(ba * -t + pa);
}
float line2P(vec2 coord, vec2 start, vec2 end, float thickness) {
    return fstep(lineDist2P(coord, start, end), thickness * thickness);
}
float line2P(vec2 coord, vec2 start, vec2 end, float thickness, float slope) {
    thickness = thickness * thickness;
    return saturate((thickness - lineDist2P(coord, start, end)) * slope + 1);
}

float lineDist1P1V(vec2 coord, vec2 start, vec2 dir) {
    vec2 pa = coord - start;
    float t = dot(pa, dir) / dot(dir, dir);
    return sqmag(dir * -t + pa);
}
float line1P1V(vec2 coord, vec2 start, vec2 dir, float thickness) {
    return fstep(lineDist1P1V(coord, start, dir), thickness * thickness);
}
float line1P1V(vec2 coord, vec2 start, vec2 dir, float thickness, float slope) {
    thickness = thickness * thickness;
    return saturate((thickness - lineDist1P1V(coord, start, dir)) * slope + 1);
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}
float mapclamp(float value, float from_min, float from_max, float to_min, float to_max) {
    return clamp(map(from_min, from_max, to_min, to_max, value), to_min, to_max);
}

vec2 convertPolarCartesian(vec2 coord) {
    return vec2(coord.x * cos(coord.y), coord.x * sin(coord.y));
}

float linearizeDepth(float d,float nearPlane,float farPlane) { // Linearizes the depth to viewspace z
    d = 2.0 * d - 1.0; // Convert to NDC (normalized device coordinates)
    return 2.0 * nearPlane * farPlane / (farPlane + nearPlane - d * (farPlane - nearPlane));
}
float linearizeDepthInverse(float l, float nearPlane, float farPlane) { // Un-Linearizes viewspace z to screenspace depth
    return (farPlane * (l-nearPlane))/(l * (farPlane-nearPlane));
}
float linearizeDepthf(float d, float slope) { // For matching results, slope should be set to 1/nearPlane
    return 1 / ((-d * slope) + slope);
}
float linearizeDepthfDivisor(float d, float slope) { // Returns 1 / linearizeDepthf For matching results, slope should be set to 1/nearPlane
    return (-d * slope) + slope;
}
float linearizeDepthfInverse(float ld, float slope) { // For matching results, slope should be set to 1/nearPlane
    return 1 / (-ld * slope) + 1;
}

float schlickFresnel(vec3 viewRay, vec3 normal, float refractiveIndex, float baseReflectiveness) {
    //Schlick-Approximation of Fresnel
    float R0 = (1 - refractiveIndex) / (1 + refractiveIndex);
    R0 *= R0;

    float cosAngle = dot(viewRay, normal);
    float reflectiveness = R0 + ( (1 - R0) * pow(1 - cosAngle, 5) );
    reflectiveness = clamp(1 - reflectiveness, 0, 1) + baseReflectiveness;
    return reflectiveness;
}
float schlickFresnel(vec3 viewDir, vec3 normal, float F0) {
    float NormalDotView = clamp(dot(-viewDir, normal), 0, 1);
    return F0 + (1.0 - F0) * pow(1.0 - NormalDotView, 5.0);
}
float customFresnel(vec3 viewRay, vec3 normal, float bias, float scale, float power) {
    float reflectiveness = clamp(bias + scale * pow(1.0 + dot(viewRay, normal), power), 0, 1); 
    return reflectiveness;
}

// Spins A point around the origin (negate for full coverage)
vec2 spiralOffset(float x, float expansion) {
    float n = fract(x * expansion) * PI;
    return vec2(cos(n), sin(n)) * x;
}
vec2 spiralOffset_full(float x, float expansion) {
    float n = fract(x * expansion) * TWO_PI;
    return vec2(cos(n), sin(n)) * x;
}


vec2 radClamp(vec2 coord) {
    // Center at 0,0
    coord = coord - 0.5;
    // Calculate oversize vector by subtracting 1 on each axis from the absulute
    // We just need the length so sing doesnt matter
    vec2 oversize = max(vec2(0), abs(coord) - 0.5);
    coord        /= (length(oversize) + 1);
    coord         = coord + 0.5;
    return coord;
}
vec3 radClamp(vec3 coord) {
    // Center at 0,0
    coord = coord - 0.5;
    // Calculate oversize vector by subtracting 1 on each axis from the absulute
    // We just need the length so sign doesnt matter
    vec3 oversize = max(vec3(0), abs(coord) - 0.5);
    coord /= (length(oversize) + 1);
    coord = coord + 0.5;
    return coord;
}
vec2 mirrorClamp(vec2 coord) { //Repeats coords while mirroring them (without branching)

    // Determines whether an axis has to be flipped or not
    vec2 reversal = mod(floor(coord), vec2(2));
    vec2 add      = reversal;
    vec2 mult     = reversal * -2 + 1;

    coord         = fract(coord);
    // Flips the axis
    // Flip:    1 - coord = -1 * coord + 1
    // No Flip:     coord =  1 * coord + 0
    // Using these expressions I can make the flipping branchless
    coord         = mult * coord + add;

    return coord;
}
vec2 distortClamp(vec2 coord) {
    coord = coord * 2 - 1;

    vec2 d = abs(coord * 1.5);
    d      = max(d-1.5, 0);
    coord *= exp2(-d);
 
    return coord * .5 + .5;
}


float smoothCutoff(float x, float cutoff, float taper) {
    if (x > cutoff + taper) {return x;}
    float a   = cutoff / (taper*taper*taper);
    float tmp = (x - cutoff - taper);
    return clamp( (a * tmp) * (tmp * tmp) + x ,0,1);
}

float angle(vec2 v) {
    float ang = HALF_PI - atan(v.x / v.y);
    if(v.y < 0) {ang = ang + PI;}
    return ang;
}


////////////////////////////////////////////////////////////////////////
// (Un)Packing Functions

vec2 signNotZero(vec2 v) {
    return vec2((v.x >= 0.0) ? +1.0 : -1.0, (v.y >= 0.0) ? +1.0 : -1.0);
}

vec2 octahedralEncode(in vec3 v) {
    float l1norm = abs(v.x) + abs(v.y) + abs(v.z);
    vec2  result = v.xy * (1.0 / l1norm);
    if (v.z < 0.0) {
        result = (1.0 - abs(result.yx)) * signNotZero(result.xy);
    }
    return result;
}

vec3 octahedralDecode(vec2 o) {
    vec3 v = vec3(o.x, o.y, 1.0 - abs(o.x) - abs(o.y));
    if (v.z < 0.0) {
        v.xy = (1.0 - abs(v.yx)) * signNotZero(v.xy);
    }
    return normalize(v);
}

#include "core/packing.glsl"

#endif