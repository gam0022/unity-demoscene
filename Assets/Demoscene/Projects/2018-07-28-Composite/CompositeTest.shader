Shader "Demoscene/Composite/Test"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags
        {
            "RenderType" = "Opaque"
            // "Queue" = "Overlay"
            "DisableBatching" = "True"
        }

        Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			#include "Assets/uRaymarching/Shaders/Include/Common.cginc"
            #include "Assets/uRaymarchingCustom/Common.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = v.vertex;
				o.uv = v.vertex;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				// fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = fixed4(i.vertex.x, i.vertex.y, 1.0, 1.0);
				col = fixed4(i.uv.x, i.uv.y, 1.0, 1.0);
				return col;
			}
			ENDCG
		}
	}
}
