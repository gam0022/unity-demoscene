Shader "Skybox/TDF2018 Skybox"
{
    Properties
    {
        _Color1 ("Top Color", Color) = (1, 1, 1, 0)
        _Color2 ("Horizon Color", Color) = (1, 1, 1, 0)
        _Color3 ("Bottom Color", Color) = (1, 1, 1, 0)
        _Exponent1 ("Exponent Factor for Top Half", Float) = 1.0
        _Exponent2 ("Exponent Factor for Bottom Half", Float) = 1.0
        _CloudColor ("Cloud Color", Color) = (1, 1, 1, 1)
        _Intensity ("Intensity Amplifier", Range(0, 5)) = 1.0
    }

    CGINCLUDE

    #include "UnityCG.cginc"
    #include "Lighting.cginc"
    #include "Assets/Demoscene/Shaders/Includes/Common.cginc"

    struct appdata
    {
        float4 position : POSITION;
        float3 texcoord : TEXCOORD0;
    };

    struct v2f
    {
        float4 position : SV_POSITION;
        float3 texcoord : TEXCOORD0;
    };

    half4 _Color1;
    half4 _Color2;
    half4 _Color3;
    half _Exponent1;
    half _Exponent2;
    half4 _CloudColor;
    half _Intensity;

    float _Beat;

    v2f vert (appdata v)
    {
        v2f o;
        o.position = UnityObjectToClipPos (v.position);
        o.texcoord = v.texcoord;
        return o;
    }

    float hash(vec2 p) {
        return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x))));
    }

    float noise(vec2 x) {
        vec2 i = floor(x), f = fract(x);
        float a = hash(i);
        float b = hash(i + vec2(1.0, 0.0));
        float c = hash(i + vec2(0.0, 1.0));
        float d = hash(i + vec2(1.0, 1.0));
        vec2 u = f * f * (3.0 - 2.0 * f);
        return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
    }

    // https://www.shadertoy.com/view/4sKGWt
    float fbm(vec2 p) {
        mat2 m2 = mat2(0.8, -0.6, 0.6, 0.8);
        p.xy += 0.1 * _Beat;
        float f = 0.5000 * noise(p); p = mul(p, m2 * 2.02);
        f += 0.2500 * noise(p); p = mul(p, m2 * 2.03);
        f += 0.1250 * noise(p); p = mul(p, m2 * 2.01);
        f += 0.0625 * noise(p);
        return f / 0.9375;
    }

    half4 frag (v2f i) : COLOR
    {
        vec3 rd = normalize(i.texcoord);
        half4 color = (1.0).xxxx;

        // Sky
        float p = rd.y;
        float p1 = 1.0f - pow (min (1.0f, 1.0f - p), _Exponent1);
        float p3 = 1.0f - pow (min (1.0f, 1.0f + p), _Exponent2);
        float p2 = 1.0f - p1 - p3;
        vec3 base = (_Color1 * p1 + _Color2 * p2 + _Color3 * p3);

		// Sun
		float sundot = saturate(dot(rd, _WorldSpaceLightPos0.xyz));
		base += 0.25 * vec3(1.0, 0.7, 0.4) * pow(sundot, 16.0);
		base += 0.75 * vec3(1.0, 0.8, 0.5) * pow(sundot, 128.0);

		// Clouds
		vec3 rdo = rd.y + 0.3;
		color.rgb = mix(base, _CloudColor, smoothstep(0.5, 0.8, fbm((rd.xz + rd.xz * (250000.0 - 0.0) / rdo) * 0.000008)));

	    return color * _Intensity;
    }

    ENDCG

    SubShader
    {
        Tags { "RenderType"="Background" "Queue"="Background" }
        Pass
        {
            ZWrite Off
            Cull Off
            Fog { Mode Off }
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
