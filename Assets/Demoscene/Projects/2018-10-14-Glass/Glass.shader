Shader "Unlit/Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_f0 ("f0", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 normal: NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _f0;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			float fresnel(float f0, float cosine)
            {
                return f0 + (1.0 - f0) * pow(1.0 - cosine, 5.0);
            }

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				half3 worldViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

                half3 reflDir = reflect(-worldViewDir, i.worldNormal);
                half4 refColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir, 0);
                refColor.rgb = DecodeHDR(refColor, unity_SpecCube0_HDR);

                half3 refractDir = refract(-worldViewDir, i.worldNormal, 0.5);
                half4 refractColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, refractDir, 0);
                refractColor.rgb = DecodeHDR(refractColor, unity_SpecCube0_HDR);

                float f = fresnel(_f0, dot(worldViewDir, i.worldNormal));
                col.rgb = lerp(refractColor.rgb, refColor.rgb, f);

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
