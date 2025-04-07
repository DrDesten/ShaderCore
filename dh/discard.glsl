#if ! defined CORE_DH_DISCARD
#define CORE_DH_DISCARD

#include "../core.glsl"
#include "../transform.glsl"

bool discardDHSimple(vec3 playerPos, float borderTolerance) {
    float farSq  = sq(far);
    float distXZ = sqmag(playerPos.xz);
    float distY  = sq(playerPos.y);

    bool distdiscardable   = distXZ - borderTolerance < farSq / 2;
    bool heightdiscardable = distY - borderTolerance  < farSq / 2;

    return distdiscardable && heightdiscardable;
}

bool discardDHSimple(vec3 playerPos) {
    return discardDHSimple(playerPos, 0);
}

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