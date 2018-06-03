Shader "Raymarching/TheGlowWorld"
{

Properties
{
    [Header(GBuffer)]
    _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    _Specular("Specular", Color) = (0.0, 0.0, 0.0, 0.0)
    _Emission("Emission", Color) = (0.0, 0.0, 0.0, 0.0)

    [Header(Raymarching Settings)]
    _Loop("Loop", Range(1, 100)) = 30
    _MinDistance("Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowLoop("Shadow Loop", Range(1, 100)) = 10
    _ShadowMinDistance("Shadow Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowExtraBias("Shadow Extra Bias", Range(0.0, 1.0)) = 0.02

// @block Properties
_FloorDiffuse("Floor Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
_FloorSpecular("Floor Specular", Color) = (1.0, 1.0, 1.0, 1.0)
_SlideEmission("Slide Emission", Vector) = (2.0, 2.0, 5.0, 1.0)
_InnerEmission("Inner Emission", Vector) = (3.0, 1.0, 1.0, 1.0)
// @endblock
}

SubShader
{

Tags
{
    "RenderType" = "Opaque"
    "DisableBatching" = "True"
}

CGINCLUDE

#define WORLD_SPACE

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
#include "Assets/uRaymarchingCustom/Common.cginc"

// @block DistanceFunction
#define PI2 (2.0 * PI)

float2x2 opRotate(in float a)
{
    float s = sin(a), c = cos(a);
    return float2x2(c, s, -s, c);
}

// https://www.shadertoy.com/view/Mlf3Wj
float2 opFoldRotate(in float2 p, in float s)
{
    float a = PI / s - atan2(p.x, p.y);
    float n = PI2 / s;
    a = floor(a / n) * n;
    p = mul(opRotate(a), p);
    return p;
}

float sdHoleBox(float3 pos, float3 outer, float3 inner)
{
    return max(sdBox(pos, outer), -sdBox(pos, inner));
}

float dOuterPillar(float3 pos)
{
    float3 p = pos;
    p.xz = Repeat(p.xz, float2(3, 3));
    p.xz = opFoldRotate(p.xz, 12.0 * sin(_Time.x));
    p.y = Repeat(p.y, 0.5);
    return sdHoleBox(p, float3(0.3 + 0.1 * sin(36.0 * _Time.x + 2.0 * Rand(float2(floor(pos.y * 2), 0))), 0.2, 0.3), float3(0.5, 0.15, 0.25));
}

float dInnerPillar(float3 pos)
{
    float3 p = pos;
    p.xz = Repeat(p.xz, float2(3, 3));
    p.xz = opFoldRotate(p.xz, 12.0 * cos(12.0 * _Time.x));
    p.y = Repeat(p.y, 0.2);
    return Box(p, float3(0.3 * abs(sin(36.0 * _Time.x)), 0.2, 0.15));
}

float dFloor(float3 pos)
{
    float3 p = pos;
    p.xz = Repeat(p.xz, 0.5);
    p.y += 1 + 0.1 * sin(36.0 * _Time.x + 2.0 * Rand(floor(2.0 * pos.xz)));
    return sdBox(p, float3(0.2, 0.2, 0.2));
}

inline float DistanceFunction(float3 pos)
{
    float d = dFloor(pos);
    d = min(dOuterPillar(pos), d);
    d = min(dInnerPillar(pos), d);
    return d;
}
// @endblock

// @block PostEffect
float4 _FloorDiffuse;
float4 _FloorSpecular;
float4 _SlideEmission;
float4 _InnerEmission;

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    float a = frac(4.0 * ray.endPos.y - 2.0 * _Time.x - 0.5);
    float width = 0.04;
    o.emission = _SlideEmission * abs(sin(PI * 12.0 * _Time.x)) * step(a, width) * ((a + 0.5 * width) / width);
 
    if (abs(dInnerPillar(ray.endPos)) < ray.minDistance)
    {
        o.emission = _InnerEmission * abs(sin(PI * 24.0 * _Time.x));
    }
 
    if (abs(dFloor(ray.endPos)) < ray.minDistance)
    {
        o.diffuse = _FloorDiffuse;
        o.specular =_FloorSpecular;
    }
}
// @endblock

#include "Assets/uRaymarching/Shaders/Include/Raymarching.cginc"

ENDCG

Pass
{
    Tags { "LightMode" = "Deferred" }

    Stencil
    {
        Comp Always
        Pass Replace
        Ref 128
    }

    CGPROGRAM
    #include "Assets/uRaymarching/Shaders/Include/VertFragDirectScreen.cginc"
    #pragma target 3.0
    #pragma vertex Vert
    #pragma fragment Frag
    #pragma exclude_renderers nomrt
    #pragma multi_compile_prepassfinal
    #pragma multi_compile ___ UNITY_HDR_ON
    #pragma multi_compile OBJECT_SHAPE_CUBE OBJECT_SHAPE_SPHERE ___
    ENDCG
}

}

Fallback Off

CustomEditor "uShaderTemplate.MaterialEditor"

}