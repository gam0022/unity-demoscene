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
inline float DistanceFunction(float3 pos)
{
    float3 p = pos;
    p.xz = Repeat(p.xz, float2(3, 3));
    float d = HexagonalPrismY(p, float2(0.3, 3.0));
    d = min(Plane(pos, float3(0, 1, 0)), d);
    return d;
}
// @endblock

// @block PostEffect
sampler2D _Grid;
float4 _Grid_ST;

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    o.emission = half4(3.0, 3.0, 5.0, 1.0) * abs(sin(PI * 5.0 * _Time.x)) * step(frac(ray.endPos.y - 2.0 * _Time.x), 0.02);
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