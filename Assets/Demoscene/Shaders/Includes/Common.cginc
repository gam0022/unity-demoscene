#ifndef __COMMON__
#define __COMMON__

#define PI2 6.28318530718
#define EPS 0.0001

#include "PortingFromGLSL.cginc"

float remap(float s, float a1, float a2, float b1, float b2)
{
    return b1 + (s - a1 ) * (b2 - b1) / (a2 - a1);
}

float remap(float s, float a1, float a2)
{
    return (s - a1 ) / (a2 - a1);
}

vec3 hsvToRgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, saturate(p - K.xxx), c.y);
}

#include "DistanceFunction.cginc"

#endif
