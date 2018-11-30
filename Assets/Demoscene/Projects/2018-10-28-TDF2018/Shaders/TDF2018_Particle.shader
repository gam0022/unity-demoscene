Shader "Particles/TDF2018"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaxRotAng ("Max Rotation Angle Per Frame", Float) = 12
        _TarCol ("Target Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

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
            float _MaxRotAng;
            fixed4 _TarCol;
            float _Beat;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float rate = 0.5 + 0.5 * sin(PI2 * 4 * v.uv.w);
                rate = v.uv.w > 0.666 ? 1.0 : 0.0;
                o.color = lerp(fixed4(0.1,0.1,0.1,1), _TarCol, rate );
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

                return fixed4(i.color.rgb, alpha * 0.8);
            }
            ENDCG
        }
    }
}
