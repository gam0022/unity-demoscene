Shader "Raymarching/TDF_Cut1"
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

    [Header(IFS)]
    _Offset("Offset", Vector) = (0.785,1.1,0.46)

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
#include "Assets/uRaymarchingCustom/Common.cginc"

#include "Assets/Demoscene/Shaders/Includes/PortingFromGLSL.cginc"

// @block DistanceFunction

// KIFS
// https://www.shadertoy.com/view/MdlSRM

 void ry(inout vec3 p, float a){
 	float c,s;vec3 q=p;
  	c = cos(a); s = sin(a);
  	p.x = c * q.x + s * q.z;
  	p.z = -s * q.x + c * q.z;
 }
 void rx(inout vec3 p, float a){
 	float c,s;vec3 q=p;
  	c = cos(a); s = sin(a);
  	p.y = c * q.y - s * q.z;
  	p.z = s * q.y + c * q.z;
 }

 void rz(inout vec3 p, float a){
 	float c,s;vec3 q=p;
  	c = cos(a); s = sin(a);
  	p.x = c * q.x - s * q.y;
  	p.y = s * q.x + c * q.y;
 }
float plane(vec3 p, float y) {
    return length(vec3(p.x, y, p.z) - p);
}

// folding hex from nimitz: https://www.shadertoy.com/view/XtdGDB
vec2 fold(vec2 p)
{
    p.xy = abs(p.xy);
    const vec2 pl1 = vec2(-0.5, 0.8657);
    const vec2 pl2 = vec2(-0.8657, 0.4);
    p -= pl1*2.*min(0., dot(p, pl1));
    p -= pl2*2.*min(0., dot(p, pl2));
    return p;
}

vec3 mat=vec3(0.0, 0.0, 0.0);
bool bcolor = false;
vec3 _Offset;

float menger_spone(in vec3 z0){
	vec4 z=vec4(z0,1.0);
    vec3 offset = _Offset;
    float scale = 2.46;
	for (int n = 0; n < 4; n++) {
		z = abs(z);
		if (z.x<z.y)z.xy = z.yx;
		if (z.x<z.z)z.xz = z.zx;
		if (z.y<z.z)z.yz = z.zy;
		z = z*scale;
		z.xyz -= offset*(scale-1.0);
       	if(bcolor && n==2)
            mat+=vec3(0.5, 0.5, 0.5)+sin(z.xyz)*vec3(1.0, 0.24, 0.245);
		if(z.z<-0.5*offset.z*(scale-1.0))
            z.z+=offset.z*(scale-1.0);
	}
	return (length(max(abs(z.xyz)-vec3(1.0, 1.0, 1.0),0.0))-0.05)/z.w;
}

inline float DistanceFunction(float3 pos)
{
    pos.yx = fold(pos.yx);
    pos = Mod(pos, 3.0);
    return menger_spone(pos);
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

Fallback "Diffuse"

CustomEditor "uShaderTemplate.MaterialEditor"

}
