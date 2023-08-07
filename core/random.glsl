#if !defined CORE_RANDOM
#define CORE_RANDOM

vec2 R2(float n) {
    const vec2 a = vec2(1.0/PHI2, 1.0/(PHI2*PHI2));
    return fract(a * n + 0.5);
}

float rand(float x) {
    return fract(sin(x * 12.9898) * 4375.5453123);
}
float rand(vec2 x) {
    return fract(sin(x.x * 12.9898 + x.y * 78.233) * 4375.5453);
}

vec2 rand2(float x) {
    float t = rand(x);
    return vec2(t, rand(t * 50 - 25));
}
vec2 rand2(vec2 x) {
    float t = rand(x);
    return vec2(t, rand(t * 50 - 25));
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);

	// Four corners in 2D of a tile
	float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

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

float fbm(vec2 x, int n) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100);

	// Rotate to reduce axial bias
    const mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

	for (int i = 0; i < n; ++i) {
		v += a * noise(x);
		x  = rot * x * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}

float fbm(vec2 x, int n, float scale, float falloff) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100);

	// Rotate to reduce axial bias
    const mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

	for (int i = 0; i < n; ++i) {
		v += a * noise(x);
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