Shader "Particles/TDF2018"
{
    Properties
    {
        [Header(GBuffer)]
        _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
        _Specular("Specular", Color) = (0.0, 0.0, 0.0, 0.0)
        _Emission("Emission", Color) = (0.0, 0.0, 0.0, 0.0)
    }
    SubShader
    {
       Tags
        {
            "RenderType" = "Opaque"
            "DisableBatching" = "True"
        }

        Cull Off

        Pass
        {
            Tags { "LightMode" = "Deferred" }

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            #include "Assets/uRaymarching/Shaders/Include/Common.cginc"
            #include "Assets/Demoscene/Shaders/Includes/Common.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Diffuse;
            float4 _Specular;
            float4 _Emission;
            float _Beat;

            float dBox(vec2 p, vec2 b) {
                vec2 d = abs(p) - b;
                return max(d.x, d.y);
            }

            float dTriangle(vec2 p, vec2 s) {
                return dBox(p, vec2(s.x - p.y * s.x / s.y, s.y));
            }

            VertObjectOutput Vert(VertObjectInput i)
            {
                VertObjectOutput o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.screenPos = o.vertex;
                o.worldPos = mul(unity_ObjectToWorld, i.vertex);
                o.worldNormal = mul(unity_ObjectToWorld, i.normal);
                return o;
            }

            GBufferOut Frag(VertObjectOutput i)
            {
                float scale = exp(-1.0 * fract(_Beat));
                float d = dTriangle(i.screenPos.xy - float2(0.5, 0.5), float2(0.24, 0.2) * scale);
                float alpha = saturate(-100.0 * d);
                //if (alpha < 0.001) discard;

                GBufferOut o;
                o.diffuse  = _Diffuse;
                o.specular = _Specular;
                o.emission = _Emission;
                o.normal   = float4(i.worldNormal, 1.0);
                //o.depth    = ray.depth;

            #ifndef UNITY_HDR_ON
                o.emission = exp2(-o.emission);
            #endif

                return o;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
