#if !defined CORE_RANDOM
#define CORE_RANDOM

#include "constants.glsl"
#include "matrix.glsl"

// Random Functions

float rand(float x) {
    return fract(sin(x * 12.9898) * 4375.5453123);
}
float rand(vec2 x) {
    return fract(sin(x.x * 12.9898 + x.y * 78.233) * 4375.5453);
}
float rand(vec3 x){
    return fract(sin(dot(x, vec3(64.25375463, 23.27536534, 86.29678483))) * 59482.7542);
}

const float RAND_EXPAND = PHI;
const float RAND_SHIFT  = RAND_EXPAND / 2.;

vec2 rand2(float x) {
    float t = rand(x);
    return vec2(t, rand(t * RAND_EXPAND - RAND_SHIFT));
}
vec2 rand2(vec2 x) {
    float t = rand(x);
    return vec2(t, rand(t * RAND_EXPAND - RAND_SHIFT));
}
vec2 rand2(vec3 x) {
    float t = rand(x);
    return vec2(t, rand(t * RAND_EXPAND - RAND_SHIFT));
}

vec3 rand3(float x) {
    float t = rand(x);
    float u = rand(t * RAND_EXPAND - RAND_SHIFT);
    return vec3(t, u, rand(u * RAND_EXPAND - RAND_SHIFT));
}
vec3 rand3(vec2 x) {
    float t = rand(x);
    float u = rand(t * RAND_EXPAND - RAND_SHIFT);
    return vec3(t, u, rand(u * RAND_EXPAND - RAND_SHIFT));
}
vec3 rand3(vec3 x) {
    float t = rand(x);
    float u = rand(t * RAND_EXPAND - RAND_SHIFT);
    return vec3(t, u, rand(u * RAND_EXPAND - RAND_SHIFT));
}

// Linear Value Noise

float lnoise(float x) {
    float i = floor(x);
    float f = fract(x);
    float a = rand(i), b = rand(i+1.);
    return mix(a, b, f);
}
float lnoise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
	float a = rand(i), b = rand(i + vec2(1,0));
    float c = rand(i + vec2(0,1)), d = rand(i + vec2(1,1));
    return mix(
        mix(a, b, f.x),
        mix(c, d, f.x),
        f.y
    );
}
float lnoise(vec3 x) {
    vec3 i = floor(x);
    vec3 frac = fract(x);

    const vec2 s = vec2(1,0);
	float a = rand(i + s.yyy), b = rand(i + s.xyy);
	float c = rand(i + s.yxy), d = rand(i + s.xxy);
	float e = rand(i + s.yyx), f = rand(i + s.xyx);
	float g = rand(i + s.yxx), h = rand(i + s.xxx);
    return mix( 
        mix( 
            mix(a, b, frac.x),
            mix(c, d, frac.x),
            frac.y 
        ), mix(
            mix(e, f, frac.x),
            mix(g, h, frac.x),
            frac.y 
        ),
        frac.z
    );
}

// Smoothstep Value Noise

float snoise(float x) {
    float cell = floor(x);
    float frac = fract(x);
    float i    = frac * frac * (3.0 - 2.0 * frac);

    float a = rand(cell);
    float b = rand(cell + 1.0);
    return mix(a, b, i);
}
float snoise(vec2 x) {
    vec2 cell = floor(x);
    vec2 frac = fract(x);
    vec2 i    = frac * frac * (3.0 - 2.0 * frac);

	float a = rand(cell);
    float b = rand(cell + vec2(1, 0));
    float c = rand(cell + vec2(0, 1));
    float d = rand(cell + vec2(1, 1));
    return mix(
        mix(a, b, i.x),
        mix(c, d, i.x),
        i.y
    );
}
float snoise(vec3 x) {
    vec3 cell = floor(x);
    vec3 frac = fract(x);
    vec3 i    = frac * frac * (3.0 - 2.0 * frac);

    const vec2 s = vec2(1,0);
	float a = rand(cell + s.yyy);
    float b = rand(cell + s.xyy);
	float c = rand(cell + s.yxy);
    float d = rand(cell + s.xxy);
	float e = rand(cell + s.yyx);
    float f = rand(cell + s.xyx);
	float g = rand(cell + s.yxx);
    float h = rand(cell + s.xxx);
    return mix( 
        mix( 
            mix(a, b, i.x),
            mix(c, d, i.x),
            i.y 
        ), mix(
            mix(e, f, i.x),
            mix(g, h, i.x),
            i.y 
        ),
        i.z
    );
}

// Perlin Noise

/* float pnoise(float x) {
    float i = floor(x);
    float f = fract(x);
    f = f * f * (3.0 - 2.0 * f);

    float a = rand(i), b = rand(i+1);
    return mix(a, b, f);
} */
float perlinRaw(vec2 x, vec2 cell, vec2 frac, vec2 interpolation) {
    vec2 p  = x;
    vec2 pa = cell;
    vec2 pb = cell + vec2(1,0);
    vec2 pc = cell + vec2(0,1);
    vec2 pd = cell + vec2(1,1);

	vec2 a = vec2Rot(rand(pa) * TWO_PI);
    vec2 b = vec2Rot(rand(pb) * TWO_PI);
    vec2 c = vec2Rot(rand(pc) * TWO_PI);
    vec2 d = vec2Rot(rand(pd) * TWO_PI);
    return mix(
        mix(dot(a, p-pa), dot(b, p-pb), interpolation.x),
        mix(dot(c, p-pc), dot(d, p-pd), interpolation.x),
        interpolation.y
    );
}
float lpnoiseUnscaled(vec2 x) {
    vec2  c = floor(x), f = fract(x);
    float perlin = perlinRaw(x, c, f, f);
    return perlin;
}
float lpnoise(vec2 x) {
    return lpnoiseUnscaled(x) * (SQRT2 / 2.) + 0.5;
}
float pnoiseUnscaled(vec2 x) {
    vec2  c = floor(x), f = fract(x);
    vec2  i = f * f * (3.0 - 2.0 * f);
    float perlin = perlinRaw(x, c, f, i);
    return perlin;
}
float pnoise(vec2 x) {
    return pnoiseUnscaled(x) * (SQRT2 / 2.) + 0.5;
}

float perlinRaw(vec3 x, vec3 cell, vec3 frac, vec3 interpolation) {
    vec3 p  = x;
    vec3 pa = cell;
    vec3 pb = cell + vec3(1,0,0);
    vec3 pc = cell + vec3(0,1,0);
    vec3 pd = cell + vec3(1,1,0);
    vec3 pe = cell + vec3(0,0,1);
    vec3 pf = cell + vec3(1,0,1);
    vec3 pg = cell + vec3(0,1,1);
    vec3 ph = cell + vec3(1,1,1);

    vec3 a = vec3Rot(rand2(pa) * TWO_PI);
    vec3 b = vec3Rot(rand2(pb) * TWO_PI);
    vec3 c = vec3Rot(rand2(pc) * TWO_PI);
    vec3 d = vec3Rot(rand2(pd) * TWO_PI);
    vec3 e = vec3Rot(rand2(pe) * TWO_PI);
    vec3 f = vec3Rot(rand2(pf) * TWO_PI);
    vec3 g = vec3Rot(rand2(pg) * TWO_PI);
    vec3 h = vec3Rot(rand2(ph) * TWO_PI);

    float mix1 = mix(mix(dot(a, p - pa), dot(b, p - pb), interpolation.x),
                     mix(dot(c, p - pc), dot(d, p - pd), interpolation.x), interpolation.y);
    float mix2 = mix(mix(dot(e, p - pe), dot(f, p - pf), interpolation.x),
                     mix(dot(g, p - pg), dot(h, p - ph), interpolation.x), interpolation.y);
    return mix(mix1, mix2, interpolation.z);
}
float lpnoiseUnscaled(vec3 x) {
    vec3  c = floor(x), f = fract(x);
    float perlin = perlinRaw(x, c, f, f);
    return perlin;
}
float lpnoise(vec3 x) {
    return lpnoiseUnscaled(x) * (SQRT2 / 2.) + 0.5;
}
float pnoiseUnscaled(vec3 x) {
    vec3  c = floor(x), f = fract(x);
    vec3  i = f * f * (3.0 - 2.0 * f);
    float perlin = perlinRaw(x, c, f, i);
    return perlin;
}
float pnoise(vec3 x) {
    return pnoiseUnscaled(x) * (SQRT2 / 2.) + 0.5;
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

	// Four corners in 2D of a tile
	float a = rand(i);
    float b = rand(i + vec2(1,0));
    float c = rand(i + vec2(0,1));
    float d = rand(i + vec2(1,1));

    vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
float noise(float x) {
    float i = floor(x);
    float f = fract(x);

	// Two connecting points
	float a = rand(i);
    float b = rand(i + 1.0);

	return smoothstep(a, b, f);
}

vec2 noise2(float x) {
    float i = floor(x);
    float f = fract(x);

	// Two connecting points
	vec2 a = rand2(i);
    vec2 b = rand2(i + 1.0);

	return smoothstep(a, b, vec2(f));
}
vec2 noise2(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

	// Four corners in 2D of a tile
	vec2 a = rand2(i);
    vec2 b = rand2(i + vec2(1,0));
    vec2 c = rand2(i + vec2(0,1));
    vec2 d = rand2(i + vec2(1,1));

    vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 noise3(float x) {
    float i = floor(x);
    float f = fract(x);

    // Two connecting points
    vec3 a = rand3(i);
    vec3 b = rand3(i + 1.0);

    return smoothstep(a, b, vec3(f));
}

vec3 noise3(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

	// Four corners in 2D of a tile
	vec3 a = rand3(i);
    vec3 b = rand3(i + vec2(1,0));
    vec3 c = rand3(i + vec2(0,1));
    vec3 d = rand3(i + vec2(1,1));

    vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 noise3(vec3 x) {
    vec3 i = floor(x);
    vec3 fr = fract(x);
    
    // Eight corners of a cube
    vec3 a = rand3(i);
    vec3 b = rand3(i + vec3(1,0,0));
    vec3 c = rand3(i + vec3(0,1,0));
    vec3 d = rand3(i + vec3(1,1,0));
    vec3 e = rand3(i + vec3(0,0,1));
    vec3 f = rand3(i + vec3(1,0,1));
    vec3 g = rand3(i + vec3(0,1,1));
    vec3 h = rand3(i + vec3(1,1,1));
    
    vec3 u = fr * fr * (3.0 - 2.0 * fr);
    
    // Interpolate along x axis for the bottom face
    vec3 bottom_x0 = mix(a, b, u.x);
    vec3 bottom_x1 = mix(c, d, u.x);
    // Interpolate along y axis for the bottom face
    vec3 bottom = mix(bottom_x0, bottom_x1, u.y);
    
    // Interpolate along x axis for the top face
    vec3 top_x0 = mix(e, f, u.x);
    vec3 top_x1 = mix(g, h, u.x);
    // Interpolate along y axis for the top face
    vec3 top = mix(top_x0, top_x1, u.y);
    
    // Final interpolation along z axis
    return mix(bottom, top, u.z);
}

// Fractal Noise

#define DECLR_FRACTAL_NOISE(function_identifier, noise_function)  \
    float function_identifier(vec2 x, int n) {                    \
        float      result    = 0;                                 \
        float      amplitude = 0.5;                               \
        const vec2 shift     = vec2(100);                         \
        const mat2 rotscale  = MAT2_ROT(0.5, 2.0);                \
        for (int i = 0; i < n; i++) {                             \
            result    += amplitude * noise_function(x);           \
            x          = rotscale * x + shift;                    \
            amplitude *= 0.5;                                     \
        }                                                         \
        return result;                                            \
    }

DECLR_FRACTAL_NOISE(sfbm, snoise);
DECLR_FRACTAL_NOISE(pfbm, pnoise);

float fbm(vec2 x, int n) {
	float v = .0;
	float a = .5;
	vec2 shift = vec2(100);

	// Rotate to reduce axial bias
    const mat2 rot = mat2(cos(.5), sin(.5), -sin(.5), cos(.5));

	for (int i = 0; i < n; i++) {
		v += a * noise(x);
		x  = rot * x * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}

float fbm(vec2 x, int n, float scale, float falloff) {
	float v = .0;
	float a = .5;
	vec2 shift = vec2(100);

	// Rotate to reduce axial bias
    const mat2 rot = mat2(cos(.5), sin(.5), -sin(.5), cos(.5));

	for (int i = 0; i < n; i++) {
		v += a * noise(x);
		x  = rot * x * scale + shift;
		a *= falloff;
	}
	return v;
}

float stretched_fbm(vec2 x, int n, float scale, float falloff, float stretch) {
	float v = .0;
	float a = .5;
	vec2 shift = vec2(100);

	// Rotate to reduce axial bias
    const mat2 rot = mat2(cos(.5), sin(.5), -sin(.5), cos(.5));

	for (int i = 0; i < n; i++) {
		v += a * noise(x * vec2(1, stretch));
		x  = rot * x * scale + shift;
		a *= falloff;
	}
	return v;
}


float voronoiSmooth(vec2 coord, float size, int complexity, float time) {
    vec2 uv  = coord;
    
    // Calculate Grid UVs (Also center at (0,0))
    vec2 guv = fract(uv * size) - .5;
    vec2 gid = floor(uv * size);

    float minDistance = 1e3;

    // Check neighboring Grid cells
    for (int x = -complexity; x <= complexity; x++) {
        for (int y = -complexity; y <= complexity; y++) {
        
            vec2 offset = vec2(x, y);
            
            // Get the id of current cell (pixel cell + offset by for loop)
            vec2 id    = gid + offset;
            // Get the uv difference to that cell (offset has to be subtracted)
            vec2 relUV = guv - offset;
            
            // Get Random Point (adjust to range (-.5, .5))
            vec2 p     = rand2(id) - .5;
            p          = vec2(sin(time * p.x), cos(time * p.y)) * .5;
            
            // Calculate Distance bewtween point and relative UVs)
            vec2 tmp   = p - relUV;
            float d    = dot(tmp, tmp);
            
            // Select the smallest distance
            
            float h     = smoothstep( 0.0, 2.0, 0.5 + (minDistance-d) * 1.);
            minDistance = mix( minDistance, d, h ); // distance
            
        }
    }

    return minDistance;
}

float voronoi(vec2 coord, int search_radius) {
    vec2 uv  = coord;
    
    // Calculate Grid UVs (Also center at (0,0))
    vec2 guv = fract(uv) - .5;
    vec2 gid = floor(uv);

    float minDistance = 1e3;

    // Check neighboring Grid cells
    for (int x = -search_radius; x <= search_radius; x++) {
        for (int y = -search_radius; y <= search_radius; y++) {
        
            vec2 offset = vec2(x, y);
            
            // Get the id of current cell (pixel cell + offset by for loop)
            vec2 id    = gid + offset;
            // Get the uv difference to that cell (offset has to be subtracted)
            vec2 relUV = guv - offset;
            
            // Get Random Point (adjust to range (-.5, .5))
            vec2 p     = rand2(id) - .5;
            
            // Calculate Distance bewtween point and relative UVs)
            vec2 tmp   = p - relUV;
            float d    = dot(tmp, tmp);
            
            // Select the smallest distance
            minDistance = min(d, minDistance);
            
        }
    }

    return minDistance;
}

#endif