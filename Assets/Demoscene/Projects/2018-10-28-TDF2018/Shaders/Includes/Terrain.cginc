#ifndef __TDF2018_TERRAIN__
#define __TDF2018_TERRAIN__

#include "UnityCG.cginc"

float _Beat;

// https://www.shadertoy.com/view/MsfGzr
float dBase(vec3 p)
{
	return cos(p.x) + cos(p.y) + cos(p.z) + cos(p.y * 20.0) * 0.0;
}

half4 _FogColor;
float _FogIntensity;
float _FogPower;

float _TERRAINBeatSpeed = 1.0;
float _TERRAINBeatInvert = 0.0;
float4 _TERRAINXYZSpeed = float4(0.0, 6.0, 0.0, 0.0);

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

inline float DistanceFunction(float3 pos)
{
    return dPlane(pos, -5.0) - saturate(sin(pos.x)) - saturate(sin(pos.z));
}

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    //float phase =
    //    abs(ray.endPos.x) * _TERRAINXYZSpeed.x +
    //    abs(ray.endPos.y) * _TERRAINXYZSpeed.y +
    //    abs(ray.endPos.z) * _TERRAINXYZSpeed.z +
    //    _Beat * _TERRAINBeatSpeed +
    //    floor(_Beat) * _TERRAINBeatInvert;
//
    //phase *= PI;
    //o.diffuse = saturate(sign(sin(phase)));
//

    float fog = saturate(_FogIntensity * pow(ray.totalLength, _FogPower));
    o.diffuse = lerp(o.diffuse, _FogColor, fog);
    o.specular = lerp(o.specular, _FogColor, fog);
    //o.emission = lerp(o.emission, _FogColor, fog);

    return;

    if (abs(DistanceFunction(ray.endPos)) > 10.0) {
        vec3 sunnySky = vec3(0.4, 0.55, 0.8);
        vec3 cloud = vec3(1.0, 0.95, 1.0);
        vec3 base = sunnySky * (1.0 - 0.8 * ray.rayDir.y) * 0.9;

        // Sun
        //vec3 lightDir = vec3( -0.48666426339228763, 0.8111071056538127, -0.3244428422615251 );
        //float sundot = saturate(dot(ray.rayDir, lightDir));
        //base += 0.25 * vec3(1.0, 0.7, 0.4) * pow(sundot, 8.0);
        //base += 0.75 * vec3(1.0, 0.8, 0.5) * pow(sundot, 64.0);

        // Clouds
        float rd = ray.rayDir.y + 0.3;
        o.emission.rgb = mix(base, cloud, 0.5 * smoothstep(0.5, 0.8, fbm((ray.startPos.xz + ray.rayDir.xz * (250000.0 - ray.startPos.y) / rd) * 0.000008)));
        o.emission.rgb = mix((1.0).xxx, vec3(0.7, 0.75, 0.8), pow(1.0 - max(rd, 0.0), 4.0));
        o.emission.rgb *= 0.2;
        o.emission.a = 0.0;

        //o.emission.rgb = vec3(1.0, 0.0, 0.0);
    }
}

#endif
