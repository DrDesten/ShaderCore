#if !defined CORE_COLOR
#define CORE_COLOR

#include "utils.glsl"

float luminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}
float saturation(vec3 color, float luma) {
    return distance(vec3(luma), color);
}
float saturation(vec3 color) {
    return saturation(color, luminance(color));
}


vec3 applyBrightness(vec3 color, float brightness, float colorOffset) { // Range: inf-0
	float tmp = 1 / (2 * colorOffset + 1);
	color = color * tmp + (colorOffset * tmp);
	return pow(color, vec3(brightness));
}
vec3 applyContrast(vec3 color, float contrast) { // Range: 0-inf
	color = color * 0.99 + 0.005;
	vec3 colorHigh = vec3(1) - 0.5 * pow(-2 * color + 2, vec3(contrast));
	vec3 colorLow  = vec3(0.5)     * pow( 2 * color,     vec3(contrast));
	return saturate(mix(colorLow, colorHigh, color));
}
vec3 applySaturation(vec3 color, float saturation) { // Range: 0-2
    return saturate(mix(vec3(luminance(color)), color, saturation));
}
vec3 applyVibrance(vec3 color, float vibrance) { // -1 to 1
	float saturation = saturation(color);
	return applySaturation(color, (1 - saturation) * vibrance + 1);
}

vec3 rgb2hsv(vec3 c) {
    const vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
    const vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, saturate(p - K.xxx), c.y);
}

vec3 gamma(vec3 color) {
    return pow(color, vec3(GAMMA));
}
vec3 gamma_inv(vec3 color) {
    return pow(color, vec3(1 / GAMMA));
}

vec3 normalizeColor(vec3 col) {
    return min( col / maxc(col), 1. );
}

// Algorithm from "https://tannerhelland.com/2012/09/18/convert-temperature-rgb-algorithm-code.html"
vec3 blackbody(float temperature) {
    temperature /= 100;
    if (temperature < 66) {
        return vec3(
            1,
            saturate(0.3900815787690196 * log(temperature) - 0.6318414437886275),
            saturate(0.543206789110196 * log(temperature - 10) - 1.19625408914) // Ternary not necessary since clamp() sets NaNs to zero already
        );
    } else {
        return vec3(
            saturate(1.292936186062745 * pow(temperature - 60, -0.1332047592)),
            saturate(1.129890860895294 * pow(temperature - 60, -0.0755148492)),
            1
        );
    }
}

#endif