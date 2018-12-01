Shader "Particles/TDF2018_TDF2018Logo"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        [HDR]_Color1("Target Color", Color) = (1,1,1,1)
        [HDR]_Color2("Target Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        // Reflection Probeがバグったのでコメントアウト
        // Cull Off

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
                float4 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color1;
            float4 _Color2;

            float _Beat;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float rate = v.uv.w > 0.666 ? 1.0 : 0.0;
                o.color = lerp(_Color1, _Color2, rate );

                return o;
            }

            float dBox(vec2 p, vec2 b) {
                vec2 d = abs(p) - b;
                return max(d.x, d.y);
            }

            float dTriangle(vec2 p, vec2 s) {
                return dBox(p, vec2(s.x - p.y * s.x / s.y, s.y));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float scale = exp(-1.0 * fract(_Beat));
                float d = dTriangle(i.uv.xy - float2(0.5, 0.5), float2(0.24, 0.2) * scale);
                float alpha = saturate(-100.0 * d);
                if (alpha < 0.001) discard;

                return fixed4(i.color.rgb, i.color.a * alpha * 0.8);
            }
            ENDCG
        }
    }
}
