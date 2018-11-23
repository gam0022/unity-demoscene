Shader "Demoscene/ImageEffect/TDF2018/ImageEffectComposer"
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
		Fog { Mode off }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

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

            uniform sampler2D _MainTex;
            uniform sampler2D _DispTex;
            float _Intensity;
            float _ColorIntensity;

            fixed4 direction;

            float filterRadius = 1;
            float flip_up = 1, flip_down = 1;
            float displace = 1;
            float scale = 1;

			fixed4 frag (v2f i) : SV_Target
			{
                half4 normal = tex2D (_DispTex, i.uv.xy * scale);

                i.uv.y -= (1 - (i.uv.y + flip_up)) * step(i.uv.y, flip_up) + (1 - (i.uv.y - flip_down)) * step(flip_down, i.uv.y);

                i.uv.xy += (normal.xy - 0.5) * displace * _Intensity;

                half4 color = tex2D(_MainTex,  i.uv.xy);
                half4 redcolor = tex2D(_MainTex, i.uv.xy + direction.xy * 0.01 * filterRadius * _ColorIntensity);
                half4 greencolor = tex2D(_MainTex,  i.uv.xy - direction.xy * 0.01 * filterRadius * _ColorIntensity);

                color += fixed4(redcolor.r, redcolor.b, redcolor.g, 1) *  step(filterRadius, -0.001);
                color *= 1 - 0.5 * step(filterRadius, -0.001);

                color += fixed4(greencolor.g, greencolor.b, greencolor.r, 1) *  step(0.001, filterRadius);
                color *= 1 - 0.5 * step(0.001, filterRadius);

                return color;
			}
			ENDCG
		}
	}
}
