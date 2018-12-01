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
                float4 uv : TEXCOORD0;// z: age_percent, w: random
            };
            struct v2f
            {
                float4 uv : TEXCOORD0;// z: age_percent, w: hue
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
                o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
                o.uv.z = v.uv.z;

                float random = v.uv.z + v.uv.w;
                float hue = fract(_EmissionHsv.r + _EmissionHueShiftBeat * _Beat + _EmissionHueShiftRandom * random);
                o.color.rgb = hsvToRgb(float3(hue, _EmissionHsv.gb)) * _EmissionHsv.a;
                o.color.a = 1.0;

                o.uv.w = hue;

                return o;
            }

            float dSphere(vec2 p, float r) {
                return length(p) - r;
            }

            float dBox(vec2 p, vec2 b) {
                vec2 d = abs(p) - b;
                return max(d.x, d.y);// + min(max(d.x, d.y), 0.0);
            }

            // TODO: gam0022 これだと s = (1,1) とのきに (1.5, 1) となるので治す
            float dTriangle(vec2 p, vec2 s) {
                return dBox(p, vec2(s.x - p.y * s.x / s.y, s.y));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float hue = i.uv.w;// hue
                float d = -1.0;

                float step = 0.25;
                float2 uv = i.uv.xy;
                if (hue > step * 3.0 ) {
                    // Triangle
                    float2 size = float2(0.25, 0.43301270189);
                    float2 center = float2(0.5, 0.3556624327);// y: 1 / 2 - sqrt(3) / 12
                    d = dTriangle(uv - center, size);
                    d = max(d, -dTriangle(uv - center, size * 0.3));
                } else if (hue > step * 2.0) {
                    // Box
                    float2 center = float2(0.5, 0.5);
                    d = dBox(uv - center, 0.5);
                    d = max(d, -dBox(uv - center, 0.25));
                } else if (hue > step * 1.0) {
                    float2 center = float2(0.5, 0.5);
                    d = dSphere(uv - center, 0.5);
                    d = max(d, -dSphere(uv - center, 0.25));
                } else {
                    float2 center = float2(0.5, 0.5);
                    d = dBox(uv - center, float2(0.15, 0.5));
                    d = min(d, dBox(uv - center, float2(0.5, 0.15)));
                }

                float alpha = saturate(-100.0 * d);
                if (alpha < 0.001) discard;

                return i.color;
            }
            ENDCG
        }
    }
}
