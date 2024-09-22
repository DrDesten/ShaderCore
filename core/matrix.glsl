#if !defined CORE_MATRIX
#define CORE_MATRIX

#define MAT2_ROT(angle, scale) \
    (mat2(cos(angle), sin(angle), -sin(angle), cos(angle)) * scale);

mat2 mat2Rot(float angle) {
    float ca = cos(angle), sa = sin(angle);
    return mat2(ca, sa, -sa, ca);
}

#define VEC2_ROT(angle, length) \
    (vec2(cos(angle), sin(angle)) * length);

vec2 vec2Rot(float angle) {
    return vec2(cos(angle), sin(angle));
}

#define VEC3_ROT(angles, length) \
    (vec3(cos(angles.x) * cos(angles.y), sin(angles.x) * cos(angles.y), sin(angles.y)) * length);
vec3 vec3Rot(vec2 angles) {
    float cosA = cos(angles.x);
    float sinA = sin(angles.x);
    float cosE = cos(angles.y);
    float sinE = sin(angles.y);
    return vec3(cosA * cosE, sinA * cosE, sinE);
}

mat3 rotationMatrix3DX(float angle) { // You can use mat2 instead, but flip angle and keep X. > vec3(x, mat2 * yz)
    float s = sin(angle);
    float c = cos(angle);
    return mat3(
        1, 0, 0,
        0, c,-s,
        0, s, c
    );
}
mat3 rotationMatrix3DZ(float angle) { // You can use mat2 instead, but flip angle and keep Z. > vec3(mat2 * xy, z)
    float s = sin(angle);
    float c = cos(angle);    
    return mat3(
        c, -s, 0,
        s,  c, 0,
        0,  0, 1
    );
}

mat3 rotationMatrix3D(vec3 axis, float angle) {
    float s  = sin(angle);
    float c  = cos(angle);
    float oc = 1.0 - c;
    return mat3(
        oc * axis.x * axis.x + c,          oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s,
        oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c,          oc * axis.y * axis.z - axis.x * s,
        oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c
    );
}

vec3 arbitraryTangent(vec3 normal) {
    // Equivalent to: normalize( cross(normal, vec3(0,0,1)) )
    //return vec3(normal.y, -normal.x, 0) * (1 / sqrt( sqmag( normal.xy ) ));
    return vec3(normalize(vec2(normal.y, -normal.x)), 0);
}

mat3 arbitraryTBN(vec3 normal) {
    // Equivalent to: cross(normal, vec3(0,0,1))
    vec3 tangent  = vec3(normal.y, -normal.x, 0);
    // Equivalent to: cross(normal, tangent)
    vec3 binomial = vec3(-normal.x * normal.z, normal.x * normal.z, (normal.y * normal.y) + (normal.x * normal.x));
    return mat3(normalize(tangent), normalize(binomial), normal);
}

#endif