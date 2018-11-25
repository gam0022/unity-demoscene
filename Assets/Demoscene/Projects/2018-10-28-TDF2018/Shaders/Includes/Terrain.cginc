#ifndef __TDF2018_TERRAIN__
#define __TDF2018_TERRAIN__

#include "UnityCG.cginc"

float _Beat;

half4 _FogColor;
float _FogIntensity;
float _FogPower;

float _TERRAINBeatSpeed = 1.0;
float _TERRAINBeatInvert = 0.0;
float4 _TERRAINXYZSpeed = float4(0.0, 6.0, 0.0, 0.0);

/*
//
float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }
float noise(vec2 x) {
	vec2 i = floor(x), f = fract(x);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
// https://www.shadertoy.com/view/4sKGWt
float fbm(vec2 p) {
	const mat2 m2 = mat2(0.8, -0.6, 0.6, 0.8);
	p.xy += 0.1 * _Beat;
	float f = 0.5000 * noise(p);
	p = mul(p, m2) * 2.02;// m2 * p * 2.02;
	f += 0.2500 * noise(p);p = mul(p, m2) * 2.03;// p = m2 * p * 2.03;
	f += 0.1250 * noise(p);p = mul(p, m2) * 2.01;// p = m2 * p * 2.01;
	f += 0.0625 * noise(p);
	return f / 0.9375;
}
*/

/*
sampler2D _Terrain1Tex;
sampler2D _Terrain2Tex;

// https://www.shadertoy.com/view/MdBGzG
float terrain( in vec2 q ) {
	//float th = smoothstep( 0.0, 0.7, textureLod( iChannel0, 0.001 * q, 0.0 ).x );
    //float rr = smoothstep( 0.1, 0.5, textureLod( iChannel1, 2.0 * 0.03 * q, 0.0 ).y );
    float th = smoothstep(0.0, 0.7, tex2D(_Terrain1Tex, 0.001 * q).x);
    float rr = smoothstep(0.1, 0.5, tex2D(_Terrain2Tex, 2.0 * 0.03 * q).y );
	float h = 1.9;
	//#ifndef LOWDETAIL
	//h += -0.15 + (1.0 - 0.6 * rr) * (1.5 - 1.0 * th) * 0.3 * (1.0 - tex2D(_Terrain1Tex, 0.04 * q*vec2(1.2, 0.5)).x);
	//#endif
	h += th * 7.0;
    h += 0.3 * rr;
    return -h;
}

vec4 map( in vec3 p )
{
	float h = terrain(p.xz);
	float dis = 1.0;//displacement( 0.25*p*vec3(1.0,4.0,1.0) );
	dis *= 3.0;
	return vec4((dis + p.y - h) * 0.25, p.x, h, 0.0);
}
*/

float DistanceFunction(float3 pos)
{
    return dPlane(pos, -3.0);
}

inline float3 calcNormal(float3 pos, float d)
{
    return normalize(float3(
        DistanceFunction(pos + float3(  d, 0.0, 0.0)) - DistanceFunction(pos),
        DistanceFunction(pos + float3(0.0,   d, 0.0)) - DistanceFunction(pos),
        DistanceFunction(pos + float3(0.0, 0.0,   d)) - DistanceFunction(pos)));
}

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    //float snow = saturate(dot(vec3(0.0, 1.0, 0.0), calcNormal(ray.endPos, 0.01)));
    //o.diffuse.rgb = lerp(o.diffuse.rgb, vec3(1.0, 0.0, 0.0), snow);

    //float fog = saturate(_FogIntensity * pow(ray.totalLength, _FogPower));
    //bcol = 0.7*mix( vec3(0.2,0.5,1.0)*0.82, bcol, 0.15+0.8*sun );
    //col = mix( col, bcol, 1.0-exp(-0.02*tmat.x) );
    float fog = 1.0 - exp(-0.02 * ray.lastDistance);
    o.diffuse = lerp(o.diffuse, _FogColor, fog);
    o.specular = lerp(o.specular, _FogColor, fog);
    o.emission = lerp(o.emission, _FogColor, fog);
}

#endif
