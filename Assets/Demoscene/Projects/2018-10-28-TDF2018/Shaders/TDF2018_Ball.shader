Shader "Raymarching/TDF2018_Ball"
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

    [Header(Ball)]
    _PlaneRate("Plane Rate",  Range(0.0, 1.0)) = 0.0

// @block Properties
// _Color2("Color2", Color) = (1.0, 1.0, 1.0, 1.0)
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

#define OBJECT_SCALE

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
#include "Assets/Demoscene/Shaders/Includes/Common.cginc"

// @block DistanceFunction
float _Beat;

float _PlaneRate;

inline float DistanceFunction(float3 pos)
{
    float r = 0.05;
    //r += 0.04 * exp(-8.0 * frac(_Beat + 0.01));
    //r += 0.05 * pow(1.0 + sin(_Beat * PI2), 4.0);
    float sphere = Sphere(pos, r);

    float3 plane_offset = float3(0, 0.0, 0.0);

    float fbm = 0.2 * cos(PI2 * _Beat / 6) + 0.01 * cos(4.0 * _Beat) + 0.0025 * cos(16.0 * _Beat);
    pos.xy = mul(pos.xy, rotate(fbm));

    float nz = pos.z + 0.5;
    float w = 0.03 * abs(sin(0.5 + 2.8 * nz));
    float3 body_size = float3(w, w, 0.4);
    float body = sdBox(pos - float3(0.0, -0.08 * nz, 0.0) - plane_offset, body_size);

    float3 wing_size = float3(0.3, 0.01 * cos(abs(6.0 * pos.x)), 0.2 * cos(abs(5.0 * pos.x)));
    float wing = sdBox(pos - float3(0.0, -0.06, -0.1 - 0.9 * abs(pos.x)) - plane_offset, wing_size);

    float3 vwing_size = float3(0.005, 0.1 - 0.3 * nz, 0.1);
    float vwing = sdBox(pos - float3(0.0, 0.06, -0.3) - plane_offset, vwing_size);

    float plane = sminCubic(body, wing, 0.2);
    plane = sminCubic(plane, vwing, 0.2);

    return mix(sphere, plane, _PlaneRate);
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
    #include "Assets/uRaymarching/Shaders/Include/VertFragDirectObject.cginc"
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
