#ifndef __TDF2018_OUTLINE__
#define __TDF2018_OUTLINE__

#include "UnityCG.cginc"
#include "Assets/uRaymarching/Shaders/Include/Structs.cginc"

VertObjectOutput VertOutline(VertObjectInput i)
{
    VertObjectOutput o;
    o.vertex = UnityObjectToClipPos(i.vertex * 1.1);
    o.screenPos = o.vertex;
    o.worldPos = mul(unity_ObjectToWorld, i.vertex * 1.1);
    o.worldNormal = mul(unity_ObjectToWorld, i.normal);
    return o;
}

GBufferOut FragOutline(VertObjectOutput i)
{
    GBufferOut o;
    o.diffuse  = _Diffuse;
    o.specular = _Specular;
    o.emission = float4(1.0, 2.0, 2.0, 1.0);//_Emission;
    o.normal   = float4(i.worldNormal, 1.0);
#ifndef DO_NOT_OUTPUT_DEPTH
    //o.depth    = ray.depth;
#endif

#ifndef UNITY_HDR_ON
    o.emission = exp2(-o.emission);
#endif

    return o;
}

#endif
