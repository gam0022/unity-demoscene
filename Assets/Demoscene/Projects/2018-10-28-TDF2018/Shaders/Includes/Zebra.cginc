#ifndef __TDF2018_ZEBRA__
#define __TDF2018_ZEBRA__

#include "UnityCG.cginc"

// https://www.shadertoy.com/view/MsfGzr
float dBase(vec3 p)
{
	return cos(p.x) + cos(p.y) + cos(p.z) + cos(p.y*20.)*.01;
}

inline float DistanceFunction(float3 pos)
{
    float d = dBase(pos);
    return d;
}


half4 _FogColor;
float _FogIntensity;
float _FogPower;

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    o.diffuse = sign(cos(ray.endPos.y * 20));

    float fog = saturate(_FogIntensity * pow(ray.totalLength, _FogPower));
    o.diffuse = lerp(o.diffuse, _FogColor, fog);
    o.specular = lerp(o.specular, _FogColor, fog);
    o.emission = lerp(o.emission, _FogColor, fog);
}

#endif
