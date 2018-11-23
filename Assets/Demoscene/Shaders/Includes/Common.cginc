#ifndef __COMMON__
#define __COMMON__

// #define PI 3.14159265359
#define PI2 6.28318530718
#define EPS 0.0001

// TODO: uRaymarching への依存を断ち切る
#include "Assets/uRaymarching/Shaders/Include/Common.cginc"

#include "PortingFromGLSL.cginc"

float remap(float s, float a1, float a2, float b1, float b2)
{
    return b1 + (s - a1 ) * (b2 - b1) / (a2 - a1);
}

float remap(float s, float a1, float a2)
{
    return (s - a1 ) / (a2 - a1);
}

vec3 hsvToRgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, saturate(p - K.xxx), c.y);
}


// Hash without Sine
// Creative Commons Attribution-ShareAlike 4.0 International Public License
// Created by David Hoskins.
// https://www.shadertoy.com/view/4djSRW
// Trying to find a Hash function that is the same on ALL systens
// and doesn't rely on trigonometry functions that change accuracy
// depending on GPU.
// New one on the left, sine function on the right.
// It appears to be the same speed, but I suppose that depends.
// * Note. It still goes wrong eventually!
// * Try full-screen paused to see details.
// *** Change these to suit your range of random numbers..
// *** Use this for integer stepped ranges, ie Value-Noise/Perlin noise functions.
#define HASHSCALE1 .1031
#define HASHSCALE3 vec3(.1031, .1030, .0973)
#define HASHSCALE4 vec4(1031, .1030, .0973, .1099)
// For smaller input rangers like audio tick or 0-1 UVs use these...
//#define HASHSCALE3 443.8975
//#define HASHSCALE3 vec3(443.897, 441.423, 437.195)
//#define HASHSCALE3 vec3(443.897, 441.423, 437.195, 444.129)
//  1 out, 1 in...
float hash11(float p)
{
	vec3 p3  = fract(p.xxx * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract((p3.x + p3.y) * p3.z);
}
//  1 out, 2 in...
float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract((p3.x + p3.y) * p3.z);
}
//  1 out, 3 in...
float hash13(vec3 p3)
{
	p3  = fract(p3 * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract((p3.x + p3.y) * p3.z);
}
//  2 out, 1 in...
vec2 hash21(float p)
{
	vec3 p3 = fract(p.xxx * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return fract((p3.xx+p3.yz)*p3.zy);
}
///  2 out, 2 in...
vec2 hash22(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * HASHSCALE3);
	p3 += dot(p3, p3.yzx+19.19);
	return fract((p3.xx+p3.yz)*p3.zy);
}
///  2 out, 3 in...
vec2 hash23(vec3 p3)
{
	p3 = fract(p3 * HASHSCALE3);
	p3 += dot(p3, p3.yzx+19.19);
	return fract((p3.xx+p3.yz)*p3.zy);
}
//  3 out, 1 in...
vec3 hash31(float p)
{
   vec3 p3 = fract(p.xxx * HASHSCALE3);
   p3 += dot(p3, p3.yzx+19.19);
   return fract((p3.xxy+p3.yzz)*p3.zyx);
}
///  3 out, 2 in...
vec3 hash32(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * HASHSCALE3);
	p3 += dot(p3, p3.yxz+19.19);
	return fract((p3.xxy+p3.yzz)*p3.zyx);
}
///  3 out, 3 in...
vec3 hash33(vec3 p3)
{
	p3 = fract(p3 * HASHSCALE3);
	p3 += dot(p3, p3.yxz+19.19);
	return fract((p3.xxy + p3.yxx)*p3.zyx);
}
// 4 out, 1 in...
vec4 hash41(float p)
{
	vec4 p4 = fract(p.xxxx * HASHSCALE4);
	p4 += dot(p4, p4.wzxy+19.19);
	return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}
// 4 out, 2 in...
vec4 hash42(vec2 p)
{
	vec4 p4 = fract(vec4(p.xyxy) * HASHSCALE4);
	p4 += dot(p4, p4.wzxy+19.19);
	return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}
// 4 out, 3 in...
vec4 hash43(vec3 p)
{
	vec4 p4 = fract(vec4(p.xyzx)  * HASHSCALE4);
	p4 += dot(p4, p4.wzxy+19.19);
	return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}
// 4 out, 4 in...
vec4 hash44(vec4 p4)
{
	p4 = fract(p4  * HASHSCALE4);
	p4 += dot(p4, p4.wzxy+19.19);
	return fract((p4.xxyz+p4.yzzw)*p4.zywx);
	//return fract(vec4((p4.x + p4.y)*p4.z, (p4.x + p4.z)*p4.y, (p4.y + p4.z)*p4.w, (p4.z + p4.w)*p4.x));
}

#include "DistanceFunction.cginc"

#endif
