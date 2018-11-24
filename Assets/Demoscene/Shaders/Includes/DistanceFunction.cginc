#ifndef __DISTANCE_FUNCTION__
#define __DISTANCE_FUNCTION__

// KIFS
// https://www.shadertoy.com/view/MdlSRM

//
// primitives
//

inline float dSphere(float3 pos, float radius) {
    return length(pos) - radius;
}

float dPlane(vec3 p, float y) {
    return length(vec3(p.x, y, p.z) - p);
}

inline float sdBox(float3 p, float3 b) {
  float3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float dTube(float2 p, float width) {
    return length(p) - width;
}

//
// ops
//

mat2 rotate(in float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, s, -s, c);
}

// https://www.shadertoy.com/view/Mlf3Wj
vec2 foldRotate(in vec2 p, in float s) {
    float a = PI / s - atan2(p.x, p.y);
    float n = PI2 / s;
    a = floor(a / n) * n;
    p = mul(rotate(a), p);
    return p;
}

// folding Octagon from nimitz: https://www.shadertoy.com/view/XtdGDB
vec2 foldOctagon(vec2 p) {
    p.xy = abs(p.xy);
    const vec2 pl1 = vec2(-0.5, 0.8657);
    const vec2 pl2 = vec2(-0.8657, 0.4);
    p -= pl1 * 2. * min(0., dot(p, pl1));
    p -= pl2 * 2. * min(0., dot(p, pl2));
    return p;
}

// https://www.iquilezles.org/www/articles/smin/smin.htm
// polynomial smooth min (k = 0.1);
float sminCubic( float a, float b, float k )
{
    float h = max( k-abs(a-b), 0.0 );
    return min( a, b ) - h*h*h/(6.0*k*k);
}


// unused
inline float opRepLimit(float pos, float span, float limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

inline float2 opRepLimit(float2 pos, float2 span, float2 limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

inline float3 opRepLimit(float3 pos, float3 span, float3 limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

#endif
