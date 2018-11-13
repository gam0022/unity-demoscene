#ifndef __COMMON__
#define __COMMON__

#include "PortingFromGLSL.cginc"

float remap(float s, float a1, float a2, float b1, float b2)
{
    return b1 + (s - a1 ) * (b2 - b1) / (a2 - a1);
}

float remap(float s, float a1, float a2)
{
    return (s - a1 ) / (a2 - a1);
}

#define PI2 6.28318530718

#define EPS 0.0001

#include "DistanceFunction.cginc"

#endif
