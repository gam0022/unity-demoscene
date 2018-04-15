#ifndef CUSTOM_MATH_H
#define CUSTOM_MATH_H

#include "Assets/uRaymarching/Shaders/Include/Math.cginc"

inline float RepeatLimit(float pos, float span, float limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

inline float2 RepeatLimit(float2 pos, float2 span, float2 limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

inline float3 RepeatLimit(float3 pos, float3 span, float3 limit)
{
    return Mod(clamp(pos, -limit, limit), span) - span * 0.5;
}

#endif
