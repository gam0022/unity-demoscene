#ifndef __TDF2018_TUNEL__
#define __TDF2018_TUNEL__

#include "Assets/Demoscene/Shaders/Includes/Noise.cginc"
#include "UnityCG.cginc"

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

        z *= scale;
        z.xyz -= offset * (scale - 1.0);

        if (z.z < -0.5 * offset.z * (scale - 1.0)) {
            z.z += offset.z * (scale - 1.0);
        }
    }
    return (length(max(abs(z.xyz) - vec3(1.0, 1.0, 1.0), 0.0)) - 0.05) / z.w;
}

inline float DistanceFunction(float3 pos)
{
    pos -= float3(2.0, 2.0, 2.0);

    // pos.z = min(pos.z, 50.0);
    pos = Repeat(pos, 4.0);
    pos.xy = mul(pos.xy, rotate(pos.z * _MengerTwistZ));

    // pos.yx = foldOctagon(pos.yx);
    pos.yx = foldRotate(pos.yx, _MengerFold);

    return dMenger(pos, _MengerOffset, _MengerScale);
}

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

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o)
{
    float hue = _EmissionHsv.r + _EmissionHueShiftZ * ray.endPos.z + _EmissionHueShiftXY * length(ray.endPos.xy - float2(2.0, 2.0)) + _EmissionHueShiftBeat * _Beat;
    o.emission.rgb = hsvToRgb(float3(hue, _EmissionHsv.gb)) * _EmissionHsv.a;

    float edgeWidth = .0015;

    // FMS_Cat edge
    // https://github.com/FMS-Cat/shift/blob/gh-pages/src/script/shader/shader.glsl#L472
    //float edge = smoothstep(0.0, 0.1, length(calcNormal(ray.endPos, 1e-3) - calcNormal(ray.endPos, 1e-4)));

    float beat = _Beat * PI2;
    float edge = calcEdge(ray.endPos) * saturate(cos(beat - Mod(0.5 * ray.endPos.z, PI2)));

    o.emission *= edge;

    float fog = saturate(_FogIntensity * pow(ray.totalLength, _FogPower));
    o.diffuse = lerp(o.diffuse, _FogColor, fog);
    o.specular = lerp(o.specular, _FogColor, fog);
    o.emission = lerp(o.emission, _FogColor, fog);
}

#endif
