Shader "Raymarching/TDF_Cut1"
{

Properties
{
    [Header(GBuffer)]
    _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    _Specular("Specular", Color) = (0.0, 0.0, 0.0, 0.0)
    [HDR] _Emission("Emission", Color) = (0.0, 0.0, 0.0, 0.0)

    [Header(Raymarching Settings)]
    _Loop("Loop", Range(1, 100)) = 30
    _MinDistance("Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowLoop("Shadow Loop", Range(1, 100)) = 10
    _ShadowMinDistance("Shadow Minimum Distance", Range(0.001, 0.1)) = 0.01
    _ShadowExtraBias("Shadow Extra Bias", Range(0.0, 1.0)) = 0.01

    [Header(Menger)]
    _MengerScale("Scale", Range(0, 10)) = 2.46
    _MengerOffset("Offset", Vector) = (0.785,1.1,0.46)
    //[MaterialToggle] _Bcolor("Bcolor", Float) = 0.0

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

#define WORLD_SPACE

#define DISTANCE_FUNCTION DistanceFunction
#define POST_EFFECT PostEffect
#define PostEffectOutput GBufferOut

#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
#include "Assets/Demoscene/Shaders/Includes/Common.cginc"

float _Beat;

// @block DistanceFunction

float dMenger(vec3 z0, vec3 offset, float scale) {
    vec4 z = vec4(z0, 1.0);
    for (int n = 0; n < 4; n++) {
        z = abs(z);

        if (z.x < z.y) {
            z.xy = z.yx;
        }

        if (z.x < z.z) {
            z.xz = z.zx;
        }

        if (z.y < z.z) {
            z.yz = z.zy;
        }

        z = z * scale;
        z.xyz -= offset * (scale - 1.0);

        if (z.z < -0.5 * offset.z * (scale - 1.0)) {
            z.z += offset.z * (scale - 1.0);
        }
    }
    return (length(max(abs(z.xyz) - vec3(1.0, 1.0, 1.0), 0.0)) - 0.05) / z.w;
}

vec3 _MengerOffset;
float _MengerScale;

inline float DistanceFunction(float3 pos)
{
    pos.z = min(pos.z, 50.0);
    pos = Repeat(pos, 4.0);

    pos.yx = foldHex(pos.yx);
    // pos.yx = foldRotate(pos.yx, 8.0);

    return dMenger(pos, _MengerOffset, _MengerScale);
}
// @endblock

inline float3 calcNormal(float3 pos, float d)
{
    return normalize(float3(
        DistanceFunction(pos + float3(  d, 0.0, 0.0)) - DistanceFunction(pos),
        DistanceFunction(pos + float3(0.0,   d, 0.0)) - DistanceFunction(pos),
        DistanceFunction(pos + float3(0.0, 0.0,   d)) - DistanceFunction(pos)));
}

#define map DistanceFunction

// https://www.shadertoy.com/view/lttGDn
float calcEdge(vec3 p) {
    float edge = 0.0;
    vec2 e = vec2(.001, 0);

    // Take some distance function measurements from either side of the hit point on all three axes.
	float d1 = map(p + e.xyy), d2 = map(p - e.xyy);
	float d3 = map(p + e.yxy), d4 = map(p - e.yxy);
	float d5 = map(p + e.yyx), d6 = map(p - e.yyx);
	float d = map(p)*2.;	// The hit point itself - Doubled to cut down on calculations. See below.

    // Edges - Take a geometry measurement from either side of the hit point. Average them, then see how
    // much the value differs from the hit point itself. Do this for X, Y and Z directions. Here, the sum
    // is used for the overall difference, but there are other ways. Note that it's mainly sharp surface
    // curves that register a discernible difference.
    edge = abs(d1 + d2 - d) + abs(d3 + d4 - d) + abs(d5 + d6 - d);
    //edge = max(max(abs(d1 + d2 - d), abs(d3 + d4 - d)), abs(d5 + d6 - d)); // Etc.

    // Once you have an edge value, it needs to normalized, and smoothed if possible. How you
    // do that is up to you. This is what I came up with for now, but I might tweak it later.
    edge = smoothstep(0., 1., sqrt(edge/e.x*2.));

    // Return the normal.
    // Standard, normalized gradient mearsurement.
    return edge;
}

// @block PostEffect
inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    float edgeWidth = .0015;

    //float normal = calcNormal(ray.endPos);
    //float edge = dot(normal, calcNormal(ray.endPos + normal * edgeWidth));
    //o.diffuse = half4(ray.normal, 1.0);//vec4(1.0, 0.0, 0.0, 1.0) * edge;
    //o.specular = o.diffuse = half4(ray.normal, 1.0);

    // FMS_Cat edge
    // https://github.com/FMS-Cat/shift/blob/gh-pages/src/script/shader/shader.glsl#L472
    //float edge = smoothstep(0.0, 0.1, length(calcNormal(ray.endPos, 1e-3) - calcNormal(ray.endPos, 1e-4)));

    float beat = _Beat * PI2;
    float edge = calcEdge(ray.endPos) * saturate(cos(beat - Mod(0.5 * ray.endPos.z, PI2)));

    o.emission *= edge;
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
