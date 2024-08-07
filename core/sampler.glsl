#if !defined CORE_SAMPLER
#define CORE_SAMPLER

vec4 textureSmoothstep(sampler2D tex, vec2 coord, vec2 samplerSize, vec2 pixelSize) {
    vec2 icoord    = coord * samplerSize;
    vec2 pixCoord  = fract(icoord);
    //pixCoord       = pixCoord * (pixCoord * (4 * pixCoord - 6) + 3);
    pixCoord       = pixCoord * (pixCoord * (2.22222 * pixCoord - 3.33333) + 2.11111);
    return texture(tex, (floor(icoord) + pixCoord) * pixelSize);
}

vec4 texture3x3(sampler2D tex, vec2 coord, vec2 samplerSize, vec2 pixelSize) {
	vec4 a = texture(tex, coord + .5 * pixelSize.xy);
    vec4 b = texture(tex, coord - .5 * pixelSize.xy);
    vec4 c = texture(tex, coord + .5 * vec2(pixelSize.x, -pixelSize.y));
    vec4 d = texture(tex, coord + .5 * vec2(-pixelSize.x, pixelSize.y));
	return (a + b + c + d) / 4.;
}
vec4 texture3x3Lod(sampler2D tex, vec2 coord, vec2 samplerSize, vec2 pixelSize, float lod) {
	vec4 a = textureLod(tex, coord + .5 * pixelSize.xy, lod);
    vec4 b = textureLod(tex, coord - .5 * pixelSize.xy, lod);
    vec4 c = textureLod(tex, coord + .5 * vec2(pixelSize.x, -pixelSize.y), lod);
    vec4 d = textureLod(tex, coord + .5 * vec2(-pixelSize.x, pixelSize.y), lod);
	return (a + b + c + d) / 4.;
}

vec4 cubic(float v) {
    vec4 n = vec4(1,2,3,4) - v;
    vec4 s = n * n * n;
    float x = s.x;
    float y = s.y - 4.0 * s.x;
    float z = s.z - 4.0 * s.y + 6.0 * s.x;
    float w = 6.0 - x - y - z;
    return vec4(x, y, z, w) * (1.0/6.0);
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

vec4 textureBicubic(sampler2D tex, vec2 coord, vec2 samplerSize, vec2 pixelSize) {
    coord = coord * samplerSize - 0.5;

    vec2 fxy = fract(coord);
    coord -= fxy;

    vec4 xcubic = cubic(fxy.x);
    vec4 ycubic = cubic(fxy.y);

    vec4 c = coord.xxyy + vec2 (-0.5, +1.5).xyxy;

    vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
    vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;

    offset *= pixelSize.xxyy;

    vec4 sample0 = texture(tex, offset.xz);
    vec4 sample1 = texture(tex, offset.yz);
    vec4 sample2 = texture(tex, offset.xw);
    vec4 sample3 = texture(tex, offset.yw);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix(
        mix(sample3, sample2, sx), 
        mix(sample1, sample0, sx)
    , sy);
}


#endif