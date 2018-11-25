Shader "Raymarching/TDF2018_TerrainWorld"
{

Properties
{
    [Header(GBuffer)]
    _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    _Specular("Specular", Color) = (0.0, 0.0, 0.0, 0.0)
    _Emission("Emission", Color) = (0.0, 0.0, 0.0, 0.0)

    [Header(Raymarching Settings)]
    _Loop("Loop", Range(1, 256)) = 30
    _MinDistance("Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowLoop("Shadow Loop", Range(1, 100)) = 10
    _ShadowMinDistance("Shadow Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowExtraBias("Shadow Extra Bias", Range(0.0, 1.0)) = 0.01

// @block Properties
    [Header(Fog)]
    _FogColor("Color", Color) = (1.0, 1.0, 1.0, 0.0)
    _FogPower("Power", Range(0.0, 5.0)) = 2.0
    _FogIntensity("Intensity", Range(0.0, 1.0)) = 0.01

    [Header(Terrain)]
    _TerrainBeatSpeed("Beat Speed", Range(-1.0, 1.0)) = 0.0
    [Toggle]_TerrainBeatInvert("Beat Invert", Float) = 0.0
    _TerrainXYZSpeed("XYZ Speed", Vector) = (0.0, 6.0, 0.0, 0.0)

    _Terrain1Tex ("Texture", 2D) = "white" {}
    _Terrain2Tex ("Texture", 2D) = "white" {}
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
//#define DISABLE_DISCARD

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
#include "Assets/Demoscene/Shaders/Includes/Common.cginc"

// @block DistanceFunction
#include "Assets/Demoscene/Projects/2018-10-28-TDF2018/Shaders/Includes/Terrain.cginc"
// @endblock

// @block PostEffect
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
    #pragma exclude_renderers d3d11_9x
    #pragma exclude_renderers d3d9
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
    #pragma exclude_renderers d3d11_9x
    #pragma exclude_renderers d3d9
    ENDCG
}

}

Fallback "Diffuse"

CustomEditor "uShaderTemplate.MaterialEditor"

}
