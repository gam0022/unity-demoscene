#ifndef __COMMON__
#define __COMMON__

float2x2 rotateMat(float theta)
{
    float c = cos(theta);
    float s = sin(theta);
    return float2x2(c, -s ,s, c);
}

#endif
