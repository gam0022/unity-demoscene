Shader "Raymarching/World"
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
// _Color2("Color2", Color) = (1.0, 1.0, 1.0, 1.0)
[Header(Additional Parameters)]
_Grid("Grid", 2D) = "" {}
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

#include "Assets/Raymarching/Shaders/Include/Common.cginc"

// @block DistanceFunction
#define PI2 (2.0 * PI)

float2x2 rotate(in float a)
{
    float s = sin(a), c = cos(a);
    return float2x2(c, s, -s, c);
}

// https://www.shadertoy.com/view/Mlf3Wj
float2 foldRotate(in float2 p, in float s)
{
    float a = PI / s - atan2(p.x, p.y);
    float n = PI2 / s;
    a = floor(a / n) * n;
    p = mul(rotate(a), p);
    return p;
}

float HoleBox(float3 pos, float3 outer, float3 inner)
{
    return max(sdBox(pos, outer), -sdBox(pos, inner));
}

float BoxBox(float3 pos)
{
    float3 p = pos;
    p.y = Repeat(p.y, 0.5);
    float d = HoleBox(p, float3(0.3 + 0.1 * sin(36.0 * _Time.x + 2.0 * Rand(float2(floor(pos.y * 2), 0))), 0.2, 0.3), float3(0.5, 0.15, 0.25));
    
    p = pos;
    p.y = Repeat(p.y, 0.2);
    d = min(d, Box(p, float3(0.3 * abs(sin(36.0 * _Time.x)), 0.2, 0.15)));
    return d;
}

inline float DistanceFunction(float3 pos)
{
    float3 p = pos;
    p.xz = Repeat(p.xz, float2(3, 3));
    p.xz = foldRotate(p.xz, 12.0 * sin(_Time.x));
    float d = BoxBox(p);
    d = min(Plane(pos, float3(0, 1, 0)), d);
    return d;
}
// @endblock

// @block PostEffect
sampler2D _Grid;
float4 _Grid_ST;

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    o.emission = half4(3.0, 3.0, 5.0, 1.0) * abs(sin(PI * 12.0 * _Time.x)) * step(frac(ray.endPos.y - 4.0 * _Time.x), 0.02);
}
// @endblock

#include "Assets/Raymarching/Shaders/Include/Raymarching.cginc"

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
    #include "Assets/Raymarching/Shaders/Include/VertFragDirectScreen.cginc"
    #pragma target 3.0
    #pragma vertex Vert
    #pragma fragment Frag
    #pragma multi_compile_prepassfinal
    #pragma multi_compile OBJECT_SHAPE_CUBE OBJECT_SHAPE_SPHERE ___
    #pragma exclude_renderers nomrt
    ENDCG
}

Pass
{
    Tags { "LightMode" = "ShadowCaster" }

    CGPROGRAM
    #include "Assets/Raymarching/Shaders/Include/VertFragShadowObject.cginc"
    #pragma target 3.0
    #pragma vertex Vert
    #pragma fragment Frag
    #pragma multi_compile_shadowcaster
    #pragma multi_compile OBJECT_SHAPE_CUBE OBJECT_SHAPE_SPHERE ___
    #pragma fragmentoption ARB_precision_hint_fastest
    ENDCG
}

}

Fallback Off

CustomEditor "Raymarching.MaterialEditor"

}