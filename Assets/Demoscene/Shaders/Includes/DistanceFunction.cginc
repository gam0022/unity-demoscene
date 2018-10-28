#ifndef __DISTANCE_FUNCTION__
#define __DISTANCE_FUNCTION__

// KIFS
// https://www.shadertoy.com/view/MdlSRM

void ry(inout vec3 p, float a) {
    float c, s;
    vec3 q = p;
    c = cos(a);
    s = sin(a);
    p.x = c * q.x + s * q.z;
    p.z = -s * q.x + c * q.z;
}
void rx(inout vec3 p, float a) {
    float c, s;
    vec3 q = p;
    c = cos(a);
    s = sin(a);
    p.y = c * q.y - s * q.z;
    p.z = s * q.y + c * q.z;
}

void rz(inout vec3 p, float a) {
    float c, s;
    vec3 q = p;
    c = cos(a);
    s = sin(a);
    p.x = c * q.x - s * q.y;
    p.y = s * q.x + c * q.y;
}

float dPlane(vec3 p, float y) {
    return length(vec3(p.x, y, p.z) - p);
}

// folding hex from nimitz: https://www.shadertoy.com/view/XtdGDB
vec2 fold(vec2 p) {
    p.xy = abs(p.xy);
    const vec2 pl1 = vec2(-0.5, 0.8657);
    const vec2 pl2 = vec2(-0.8657, 0.4);
    p -= pl1 * 2. * min(0., dot(p, pl1));
    p -= pl2 * 2. * min(0., dot(p, pl2));
    return p;
}

#endif
