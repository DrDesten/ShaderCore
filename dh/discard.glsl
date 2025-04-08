#if ! defined CORE_DH_DISCARD
#define CORE_DH_DISCARD

#include "../core.glsl"
#include "../transform.glsl"

bool discardDHSimple(vec3 playerPos, float borderTolerance) {
    float farSq  = sq(far);
    float distXZ = sqmag(playerPos.xz);
    float distY  = sq(playerPos.y);

    float threshold = farSq / 3 + borderTolerance;
    bool  distdiscardable   = distXZ < threshold;
    bool  heightdiscardable = distY  < threshold;

    return distdiscardable && heightdiscardable;
}

bool discardDHSimple(vec3 playerPos) {
    return discardDHSimple(playerPos, 0);
}

#ifdef FRAG

bool discardDHDithered(vec3 playerPos, vec2 fragCoord, float borderTolerance) {
    float farSq  = sq(far);
    float distXZ = sqmag(playerPos.xz);
    float distY  = sq(playerPos.y);

    float threshold = (farSq / 3 + borderTolerance) * (Bayer4(fragCoord) * 0.5 + 0.5);
    bool  distdiscardable   = distXZ < threshold;
    bool  heightdiscardable = distY  < threshold;

    return distdiscardable && heightdiscardable;
}

bool discardDHDithered(vec3 playerPos, vec2 fragCoord) {
    return discardDHDithered(playerPos, fragCoord, 0);
}

#endif

bool discardDH(vec3 worldPos, float borderTolerance) {
    vec3  borderCorrection = vec3(lessThan(cameraPosition, worldPos)) * 2 * borderTolerance - borderTolerance;
    float roundwh = floor(worldPos.y / 8 + borderCorrection.y) * 8;
    vec2  roundwp = floor(worldPos.xz / 16 + borderCorrection.xz) * 16 + 8;
    vec2  roundcp = floor(cameraPosition.xz / 16) * 16 + 8;

    vec2  floorwp = floor(worldPos.xz / 16) * 16;
    vec2  ceilwp  = ceil(worldPos.xz / 16) * 16;
    float mindist = sqrt(min(
        min(sqmag(vec2(floorwp.x, floorwp.y) - cameraPosition.xz),
            sqmag(vec2(floorwp.x, ceilwp.y)  - cameraPosition.xz)),
        min(sqmag(vec2(ceilwp.x,  floorwp.y) - cameraPosition.xz),
            sqmag(vec2(ceilwp.x,  ceilwp.y)  - cameraPosition.xz))
    ));

    bool chunkdiscardable  = length(roundcp - roundwp) - 8 < far;
    bool distdiscardable   = mindist < far;
    bool heightdiscardable = abs(roundwh - cameraPosition.y) - 8 < far;

    return chunkdiscardable && distdiscardable && heightdiscardable;
}

bool discardDH(vec3 worldPos) {
    return discardDH(worldPos, 4./16);
}

#endif