Shader "Raymarching/TDF2018_ZebraWorld"
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
    _FogColor("Color", Color) = (1.0, 1.0, 1.0, 0.0)
    _FogPower("Power", Range(0.0, 5.0)) = 2.0
    _FogIntensity("Intensity", Range(0.0, 1.0)) = 0.01

    [Header(Zebra)]
    _ZebraTranslate("_ZebraTranslate", Vector) = (0.0, 0.1, 0.0, 0.0)
    _ZebraSminK("SminK", Range(0.0, 1.0)) = 0.1
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
#define DISABLE_DISCARD

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
#include "Assets/Demoscene/Shaders/Includes/Common.cginc"

float _Beat;

float dTube(float2 p, float width) {
    return length(p) - width;
}

float dPillar(float3 p, float3 offset) {
    p.xz = Repeat(p.xz, float2(4.0, 4.0));
    //p.xz += 1.0;
    p.xz = mul(p.xz, rotate(_Beat + 2.0 * p.y));
    //foldRotate(p.xz, 8.0);

    //p.x += offset.x * cos(p.z + _Beat + offset.y);
    //p.y += offset.x * sin(p.z + _Beat + offset.y);

    float d = dTube(p.xz, 0.2 * abs(p.x + p.y + p.z));
    return d;
}

// https://www.shadertoy.com/view/MsfGzr
float dTunnel(vec3 p)
{
	return cos(p.x) + cos(p.y) + cos(p.z);
}

float3 _ZebraTranslate;
float _ZebraSminK;

// @block DistanceFunction
inline float DistanceFunction(float3 pos)
{
    float3 offset = float3(0.1, 0.0, 0.3);

    float beat = PI2 * _Beat / 8;
    float3 trans = float3(1.0, 0.0, 1.0) * 0.5;

    //float d = dPillar(pos - trans.xyz, offset);
    //d = sminCubic(d, dPillar(pos - trans.yxz, offset), _ZebraSminK);
    //d = sminCubic(d, dPillar(pos + trans.xzy, offset), _ZebraSminK);
    //d = sminCubic(d, dPillar(pos + trans.xyz, offset), _ZebraSminK);

    float d = dTunnel(pos -2.0);

    return d;
}
// @endblock

// @block PostEffect
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

Fallback "Diffuse"

CustomEditor "uShaderTemplate.MaterialEditor"

}
