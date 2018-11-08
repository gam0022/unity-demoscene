﻿#ifndef FRAGS_SHADOW_H
#define FRAGS_SHADOW_H

#include "UnityCG.cginc"
#include "./Structs.cginc"
#include "./Raymarching.cginc"
#include "./Utils.cginc"

float _ShadowExtraBias;
float _ShadowMinDistance;
int _ShadowLoop;

float4 ApplyLinearShadowBias(float4 clipPos)
{
#if defined(UNITY_REVERSED_Z)
    clipPos.z += max(-1.0, min((unity_LightShadowBias.x - _ShadowExtraBias) / clipPos.w, 0.0));
    float clamped = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#else
    clipPos.z += saturate((unity_LightShadowBias.x + _ShadowExtraBias) / clipPos.w);
    float clamped = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
#endif
    clipPos.z = lerp(clipPos.z, clamped, unity_LightShadowBias.y);
    return clipPos;
}

VertShadowOutput Vert(VertShadowInput v)
{
    VertShadowOutput o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.screenPos = o.pos;
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.normal = mul(unity_ObjectToWorld, v.normal);
    return o;
}

#ifdef SHADOWS_CUBE

float4 Frag(VertShadowOutput i) : SV_Target
{
    RaymarchInfo ray;
    UNITY_INITIALIZE_OUTPUT(RaymarchInfo, ray);
    ray.rayDir = GetCameraDirectionForShadow(i.screenPos);
    ray.startPos = i.worldPos;
    ray.minDistance = _ShadowMinDistance;
    ray.maxDistance = GetCameraMaxDistance();
    ray.maxLoop = _ShadowLoop;

    if (!_Raymarch(ray)) discard;

    // i.vec = ray.endPos - _LightPositionRange.xyz;
    SHADOW_CASTER_FRAGMENT(i);
}

#else

void Frag(
    VertShadowOutput i,
    out float4 outColor : SV_Target,
    out float  outDepth : SV_Depth)
{
    RaymarchInfo ray;
    UNITY_INITIALIZE_OUTPUT(RaymarchInfo, ray);
    ray.startPos = i.worldPos;
    ray.minDistance = _ShadowMinDistance;
    ray.maxDistance = GetCameraMaxDistance();
    ray.maxLoop = _ShadowLoop;

    // light direction of spot light
    if ((UNITY_MATRIX_P[3].x != 0.0) ||
        (UNITY_MATRIX_P[3].y != 0.0) ||
        (UNITY_MATRIX_P[3].z != 0.0)) {
        ray.rayDir = GetCameraDirectionForShadow(i.screenPos);
    }
    // light direction of directional light
    else {
        ray.rayDir = -UNITY_MATRIX_V[2].xyz;
    }

    if (!_Raymarch(ray)) discard;

    float4 opos = mul(unity_WorldToObject, float4(ray.endPos, 1.0));
    float3 worldNormal = DecodeNormal(ray.normal);
    opos = UnityClipSpaceShadowCasterPos(opos, worldNormal);
    opos = ApplyLinearShadowBias(opos);
    outColor = outDepth = EncodeDepth(opos);
}

#endif


#endif
