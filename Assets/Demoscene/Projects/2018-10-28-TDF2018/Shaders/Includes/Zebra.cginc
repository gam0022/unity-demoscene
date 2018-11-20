#ifndef __TDF2018_ZEBRA__
#define __TDF2018_ZEBRA__

#include "UnityCG.cginc"

float _Beat;

// https://www.shadertoy.com/view/MsfGzr
float dBase(vec3 p)
{
	return cos(p.x) + cos(p.y) + cos(p.z) + cos(p.y * 20.0) * 0.0;
}

inline float DistanceFunction(float3 pos)
{
    float d = dBase(pos);
    return d;
}

half4 _FogColor;
float _FogIntensity;
float _FogPower;

float _ZebraBeatSpeed = 1.0;
float _ZebraBeatInvert = 0.0;
float4 _ZebraXYZSpeed = float4(0.0, 6.0, 0.0, 0.0);

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    float phase =
        abs(ray.endPos.x) * _ZebraXYZSpeed.x +
        abs(ray.endPos.y) * _ZebraXYZSpeed.y +
        abs(ray.endPos.z) * _ZebraXYZSpeed.z +
        _Beat * _ZebraBeatSpeed +
        floor(_Beat) * _ZebraBeatInvert;

    phase *= PI;
    o.diffuse = saturate(sign(sin(phase)));

    float fog = saturate(_FogIntensity * pow(ray.totalLength, _FogPower));
    o.diffuse = lerp(o.diffuse, _FogColor, fog);
    o.specular = lerp(o.specular, _FogColor, fog);
    o.emission = lerp(o.emission, _FogColor, fog);
}

#endif
