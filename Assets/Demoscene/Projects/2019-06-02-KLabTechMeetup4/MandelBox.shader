Shader "Raymarching/MandelBox"
{

Properties
{
    [Header(GBuffer)]
    _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    _Specular("Specular", Color) = (0.0, 0.0, 0.0, 0.0)
    _Emission("Emission", Color) = (0.0, 0.0, 0.0, 0.0)

    [Header(Raymarching Settings)]
    _Loop("Loop", Range(1, 500)) = 30
    [PowerSlider(10.0)]_MinDistance("Minimum Distance", Range(0.0001, 0.1)) = 0.01
    _ShadowLoop("Shadow Loop", Range(1, 100)) = 10
    _ShadowMinDistance("Shadow Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowExtraBias("Shadow Extra Bias", Range(0.0, 1.0)) = 0.01
    _HitScale("HIt Scale", Range(1, 10000)) = 10

// @block Properties
    [Header(Menger)]
    _MengerScale("Scale", Range(-4, 4)) = 2.7
    _MengerRepeat("Repeat", Range(0, 20)) = 12
// @endblock
}

SubShader
{

Tags
{
    "RenderType" = "Opaque"
    "DisableBatching" = "True"
}

Cull Off

CGINCLUDE

#define WORLD_SPACE
#define _HIT_SCALE_ON

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

float _HitScale;
#include "Assets/uRaymarching/Shaders/Include/Common.cginc"

// @block DistanceFunction
#define PI2 6.28318530718

float _Beat;

float _MengerScale;
float _MengerRepeat;

// Menger spongeの距離関数の定義
float dMandel(float3 p, float scale, int n) {
    float4 q0 = float4 (p, 1.);
    float4 q = q0;

    for ( int i = 0; i < n; i++ ) {
        q.xyz = clamp( q.xyz, -1.0, 1.0 ) * 2.0 - q.xyz;
        q = q * scale / clamp( dot( q.xyz, q.xyz ), 0.5, 1.0 ) + q0;
    }

    return length( q.xyz ) / abs( q.w );
}

// 2Dの回転行列の生成
float2x2 rotate(in float a) {
    float s = sin(a), c = cos(a);
    return float2x2(c, s, -s, c);
}

// 回転 fold
// https://www.shadertoy.com/view/Mlf3Wj
float2 foldRotate(in float2 p, in float s) {
    float a = PI / s - atan2(p.x, p.y);
    float n = PI2 / s;
    a = floor(a / n) * n;
    p = mul(rotate(a), p);
    return p;
}

inline float DistanceFunction(float3 pos) {
    //pos -= float3(2.0, 2.0, 2.0);

    // modをつかった図形の繰り返し
    //pos = Repeat(pos, 4.0);

    // Z座標に応じた回転
    //pos.xy = mul(pos.xy, rotate(pos.z * _MengerTwistZ));

    // 回転foldの適用
    //pos.yx = foldRotate(pos.yx, _MengerFold);

    return dMandel(pos, _MengerScale, _MengerRepeat);
}
// @endblock

// @block PostEffect
inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
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

Pass
{
    Tags { "LightMode" = "ShadowCaster" }

    CGPROGRAM
    #include "Assets/uRaymarching/Shaders/Include/VertFragShadowObject.cginc"
    #pragma target 3.0
    #pragma vertex Vert
    #pragma fragment Frag
    #pragma fragmentoption ARB_precision_hint_fastest
    #pragma multi_compile_shadowcaster
    #pragma multi_compile OBJECT_SHAPE_CUBE OBJECT_SHAPE_SPHERE ___
    ENDCG
}

}

Fallback Off

CustomEditor "uShaderTemplate.MaterialEditor"

}
