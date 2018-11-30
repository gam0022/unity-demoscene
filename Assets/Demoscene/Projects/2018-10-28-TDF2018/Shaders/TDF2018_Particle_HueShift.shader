Shader "Particles/TDF2018_HueShift"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}

        [Header(Emissive)]
        _EmissionHsv("HSV", Vector) = (0.0, 1.0, 1.0, 2.0)
        _EmissionHueShiftZ("Hue Shift Z", Range(0.0, 10.0)) = 0.0
        _EmissionHueShiftXY("Hue Shift XY", Range(0.0, 10.0)) = 0.0
        _EmissionHueShiftBeat("Hue Shift Beat", Range(0.0, 10.0)) = 0.0
        _EmissionHueShiftRandom("Hue Shift Random", Range(0.0, 10.0)) = 0.0
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
                float4 color : COLOR;
            };

            float _Beat;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            half4 _EmissionHsv;
            float _EmissionHueShiftZ;
            float _EmissionHueShiftXY;
            float _EmissionHueShiftBeat;
            float _EmissionHueShiftRandom;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float random = v.uv.z + v.uv.w;
                float hue = _EmissionHsv.r + _EmissionHueShiftBeat * _Beat + _EmissionHueShiftRandom * random;
                o.color.rgb = hsvToRgb(float3(hue, _EmissionHsv.gb)) * _EmissionHsv.a;
                o.color.a = 1.0;

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
                //float scale = exp(-1.0 * fract(_Beat));
                //float d = dTriangle(i.uv.xy - float2(0.5, 0.5), float2(0.24, 0.2) * scale);
                //float alpha = saturate(-100.0 * d);
                //if (alpha < 0.001) discard;

                return i.color;
            }
            ENDCG
        }
    }
}
