Shader "Raymarching/Tunel"
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
    _ShadowExtraBias("Shadow Extra Bias", Range(0.0, 1.0)) = 0.01

// @block Properties
    [Header(Fog)]
    _FogColor("Color", Color) = (0.0, 0.0, 0.0, 0.0)
    _FogPower("Power", Range(0.0, 5.0)) = 2.0
    _FogIntensity("Intensity", Range(0.0, 1.0)) = 0.02

    [Header(Menger)]
    _MengerScale("Scale", Range(0, 10)) = 2.46
    _MengerOffset("Offset", Vector) = (0.785,1.1,0.46)
    //[MaterialToggle] _Bcolor("Bcolor", Float) = 0.0
    _MengerFold("Fold", Range(0, 20)) = 8.0
    _MengerTwistZ("Twist Z", Range(-1.0, 1.0)) = 0.0

    [Header(Emissive)]
    _EmissionHsv("HSV", Vector) = (0.0, 1.0, 1.0, 2.0)
    _EmissionHueShiftZ("Hue Shift Z", Range(0.0, 10.0)) = 0.0
    _EmissionHueShiftXY("Hue Shift XY", Range(0.0, 10.0)) = 0.0
    _EmissionHueShiftBeat("Hue Shift Beat", Range(0.0, 10.0)) = 0.0
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

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"

// @block DistanceFunction
#define PI2 6.28318530718

float _Beat;

float3 _MengerOffset;
float _MengerScale;
float _MengerFold;
float _MengerTwistZ;

half4 _FogColor;
float _FogIntensity;
float _FogPower;

half4 _EmissionHsv;
float _EmissionHueShiftZ;
float _EmissionHueShiftXY;
float _EmissionHueShiftBeat;

// Menger spongeの距離関数の定義
float dMenger(float3 z0, float3 offset, float scale) {
    float4 z = float4(z0, 1.0);
    for (int n = 0; n < 4; n++) {
        z = abs(z);

        if (z.x < z.y) z.xy = z.yx;
        if (z.x < z.z) z.xz = z.zx;
        if (z.y < z.z) z.yz = z.zy;

        z *= scale;
        z.xyz -= offset * (scale - 1.0);

        if (z.z < -0.5 * offset.z * (scale - 1.0))
            z.z += offset.z * (scale - 1.0);
    }
    return (length(max(abs(z.xyz) - float3(1.0, 1.0, 1.0), 0.0)) - 0.05) / z.w;
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
    pos.yx = foldRotate(pos.yx, _MengerFold);

    return dMenger(pos, _MengerOffset, _MengerScale);
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
