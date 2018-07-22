#ifndef __COMMON__
#define __COMMON__

float remap(float s, float a1, float a2, float b1, float b2)
{
    return b1 + (s - a1 ) * (b2 - b1) / (a2 - a1);
}

float remap(float s, float a1, float a2)
{
    return (s - a1 ) / (a2 - a1);
}

float2x2 rotateMat(float theta)
{
    float c = cos(theta);
    float s = sin(theta);
    return float2x2(c, -s ,s, c);
}

#endif
