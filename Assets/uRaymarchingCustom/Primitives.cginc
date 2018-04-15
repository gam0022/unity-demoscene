#ifndef CUSTOM_PRIMITIVES_H
#define CUSTOM_PRIMITIVES_H

#include "Assets/uRaymarching/Shaders/Include/Primitives.cginc"

inline float sdBox(float3 p, float3 b)
{
  float3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

#endif
