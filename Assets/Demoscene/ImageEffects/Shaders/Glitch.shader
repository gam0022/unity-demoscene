Shader "Demoscene/ImageEffect/TDF2018/Glitch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DispTex ("Base (RGB)", 2D) = "bump" {}
        _Intensity("Intensity", Range(0, 1)) = 1
        _ColorIntensity("Color Bleed Intensity", Range(0.1, 1.0)) = 0.2
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/Demoscene/Shaders/Includes/Common.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float _Beat;

            uniform sampler2D _MainTex;
            uniform sampler2D _DispTex;
            float _Intensity;
            float _ColorIntensity;

            fixed4 direction;

            fixed4 frag (v2f i) : SV_Target
            {
                half2 uv = i.uv;
                uv += _Intensity * sin(PI2 * _Beat) * (1.0 - 2.0 * hash23(vec3(floor(half2(uv.x * 32.0, uv.y * 32.0)), _Beat)));
                uv.x += _Intensity * sin(uv.y * 4.0 + _Beat);

                //fixed4 color = tex2D(_MainTex, uv);

                float angle = 0.5;
                half2 offset = 0.01 * half2(cos(angle), sin(angle));
                fixed4 cr = tex2D(_MainTex, uv - offset);
                fixed4 cg = tex2D(_MainTex, uv);
                fixed4 cb = tex2D(_MainTex, uv + offset);

                return fixed4(cr.r, cg.g, cb.b, 1.0);
            }
            ENDCG
        }
    }
}
