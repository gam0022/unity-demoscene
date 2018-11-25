#ifndef __TDF2018_TERRAIN__
#define __TDF2018_TERRAIN__

#include "Assets/Demoscene/Shaders/Includes/Noise.cginc"
#include "UnityCG.cginc"

float _Beat;

half4 _FogColor;
float _FogIntensity;
float _FogPower;

sampler2D _Noise256Tex;

// https://www.shadertoy.com/view/4sXGRM

// random/hash function
// float hash( float n )
//{
//  return fract(cos(n)*41415.92653);
//}

// 2d noise function
float texNoise(vec2 p) {
  return tex2Dlod(_Noise256Tex, float4(p * vec2(1. / 256., 1. / 256.), 0.0, 0.0)).x;
}

// 3d noise function
// float noise( in vec3 x )
//{
//  vec3 p  = floor(x);
//  vec3 f  = smoothstep(0.0, 1.0, fract(x));
//  float n = p.x + p.y*57.0 + 113.0*p.z;
//
//  return mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
//    mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
//    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
//    mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
//}

// mat3 m = mat3( 0.00,  1.60,  1.20, -1.60,  0.72, -0.96, -1.20, -0.96,  1.28
// );

// Fractional Brownian motion
// float fbm( vec3 p )
//{
//  /*float f = 0.5000 * noise(p); p = m*p*1.1;
//  f += 0.2500*noise( p ); p = m*p*1.2;
//  f += 0.1666*noise( p ); p = m*p;
//  f += 0.0834*noise( p );*/
//
//  float f = 0.5000 * noise(p); p = mul(p, 1.1 * m);
//  f += 0.2500*noise( p ); p = mul(p, 1.2 * m);
//  f += 0.1666*noise( p ); p = mul(p, m);
//  f += 0.0834*noise( p );
//
//  return f;
//}

#define m2 mat2(1.6, -1.2, 1.2, 1.6)
#define waterlevel 1.0
#define wavegain 1.0
#define large_waveheight 1.0
#define small_waveheight 1.0

//// Fractional Brownian motion
float fbm(vec2 p) {
  float f = 0.5000 * texNoise(p);
  p = mul(p, m2);
  f += 0.2500 * texNoise(p);
  p = mul(p, m2);
  f += 0.1666 * texNoise(p);
  p = mul(p, m2);
  f += 0.0834 * texNoise(p);
  return f;
}

// this calculates the water as a height of a given position
float water(vec2 p) {
  float height = waterlevel;

  float iTime = _Beat * 0.25;
  vec2 shift1 = 0.001 * vec2(iTime * 160.0 * 2.0, iTime * 120.0 * 2.0);
  vec2 shift2 = 0.001 * vec2(iTime * 190.0 * 2.0, -iTime * 130.0 * 2.0);

  // coarse crossing 'ocean' waves...
  float wave = 0.0;
  wave += sin(p.x * 0.021 + shift2.x) * 4.5;
  wave += sin(p.x * 0.0172 + p.y * 0.010 + shift2.x * 1.121) * 4.0;
  wave -= sin(p.x * 0.00104 + p.y * 0.005 + shift2.x * 0.121) * 4.0;
  // ...added by some smaller faster waves...
  wave += sin(p.x * 0.02221 + p.y * 0.01233 + shift2.x * 3.437) * 5.0;
  wave += sin(p.x * 0.03112 + p.y * 0.01122 + shift2.x * 4.269) * 2.5;
  wave *= large_waveheight;
  wave -= fbm(p * 0.004 - shift2 * .5) * small_waveheight * 24.;
  // ...added by some distored random waves (which makes the water looks like
  // water :)

  float amp = 6. * small_waveheight;
  shift1 *= .3;
  for (int i = 0; i < 7; i++) {
    wave -= abs(sin((texNoise(p * 0.01 + shift1) - .5) * 3.14)) * amp;
    amp *= .51;
    shift1 *= 1.841;
    // p *= m2*0.9331;
    p = mul(p, m2 * 0.9331);
  }

  height += wave;
  return height;
}

// https://www.shadertoy.com/view/XdsGDB
int ITER_GEOMETRY = 3;
int ITER_FRAGMENT = 5;
float SEA_HEIGHT = 0.6;
float SeaChoppy = 4.0;
float SEA_SPEED = 0.8;
float SEA_FREQ = 0.16;

vec3 SEA_BASE = vec3(0.1, 0.19, 0.22);
vec3 SEA_WATER_COLOR = vec3(0.8, 0.9, 0.6);
mat2 octave_m = mat2(1.6, 1.2, -1.2, 1.6);

// math
float hash(vec2 p) {
  float h = dot(p, vec2(127.1, 311.7));
  return fract(sin(h) * 43758.5453123);
}

float noise(in vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return -1.0 +
         2.0 * mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
                   mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
                   u.y);
}

float sea_octave(vec2 uv, float choppy) {
  uv += noise(uv);
  vec2 wv = 1.0 - abs(sin(uv));
  vec2 swv = abs(cos(uv));
  wv = mix(wv, swv, wv);
  return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);
}

float waterDetail(vec2 p) {
  // return pow(snoise(p) + snoise(p + _Beat), 2.2);
  // return sea_octave(p, 4.0) + sea_octave(p * 2, 2.0);

  vec2 uv = p;
  uv.x *= 0.75;

  float freq = 0.16; // SEA_FREQ;
  float amp = 0.6;   // SEA_HEIGHT;
  float choppy = 4.0;

  float d, h = 0.0;
  for (int i = 0; i < 5; i++) {
    d = sea_octave((uv + _Beat * 4.0) * freq, choppy);
    d += sea_octave((uv - _Beat * 4.0) * freq, choppy);
    h += d * amp;
    uv = mul(uv, octave_m);
    freq *= 1.9;
    amp *= 0.22;
    choppy = mix(choppy, 1.0, 0.2);

    break;
  }

  return h;
}

float DistanceFunction(float3 pos) {
  // return pos.y + water(pos.xz);
  return dPlane(pos, -10.0);
}

float dWater(vec3 p) {
  // return DistanceFunction(p) - waterDetail(p.xz);
  return DistanceFunction(p) - water(p.xz);
}

inline float3 calcNormal(float3 pos, float d) {
  return normalize(float3(dWater(pos + float3(d, 0.0, 0.0)) - dWater(pos),
                          dWater(pos + float3(0.0, d, 0.0)) - dWater(pos),
                          dWater(pos + float3(0.0, 0.0, d)) - dWater(pos)));
}

inline void PostEffect(RaymarchInfo ray, inout PostEffectOutput o) {
  // vec3 normal = EncodeNormal(calcNormal(ray.endPos, 0.001));

  vec3 wpos = ray.endPos;
  vec2 xdiff = vec2(0.1, 0.0) * wavegain * 4.;
  vec2 ydiff = vec2(0.0, 0.1) * wavegain * 4.;
  vec3 normal = EncodeNormal(
      normalize(vec3(water(wpos.xz - xdiff) - water(wpos.xz + xdiff), 1.0,
                     water(wpos.xz - ydiff) - water(wpos.xz + ydiff))));

  o.normal.rgb = normal;
  // o.diffuse.rgb = normal;
  // o.specular.rgb = normal;

  // o.specular.r = abs(water(ray.endPos.xz)) < 0.0000001 ? 1.0 : 0.0;

  // float fog = 1.0 - exp(-0.02 * ray.lastDistance);
  // o.diffuse = lerp(o.diffuse, _FogColor, fog);
  // o.specular = lerp(o.specular, _FogColor, fog);
  // o.emission = lerp(o.emission, _FogColor, fog);
}

#endif
