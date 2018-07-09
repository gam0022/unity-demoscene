Shader "Unlit/Cellular"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float3 mod_emu(float3 x, float y)
            {
                return x - y * floor(x / y);
            }
            
            float3 f_permute(in float3 _x)
            {
                return mod_emu((((34.0 * _x) + 1.0) * _x), 289.0);
            }
            
            float2 f_cellular(in float3 _P)
            {
                float3 _Pi = mod_emu(floor(_P), 289.0);
                float3 _Pf = (frac(_P) - 0.5);
                float3 _Pfx = (_Pf.x + float3(1.0, 0.0, -1.0));
                float3 _Pfy = (_Pf.y + float3(1.0, 0.0, -1.0));
                float3 _Pfz = (_Pf.z + float3(1.0, 0.0, -1.0));
                float3 _p = f_permute((_Pi.x + float3(-1.0, 0.0, 1.0)));
                float3 _p1 = f_permute(((_p + _Pi.y) - 1.0));
                float3 _p2 = f_permute((_p + _Pi.y));
                float3 _p3 = f_permute(((_p + _Pi.y) + 1.0));
                float3 _p11 = f_permute(((_p1 + _Pi.z) - 1.0));
                float3 _p12 = f_permute((_p1 + _Pi.z));
                float3 _p13 = f_permute(((_p1 + _Pi.z) + 1.0));
                float3 _p21 = f_permute(((_p2 + _Pi.z) - 1.0));
                float3 _p22 = f_permute((_p2 + _Pi.z));
                float3 _p23 = f_permute(((_p2 + _Pi.z) + 1.0));
                float3 _p31 = f_permute(((_p3 + _Pi.z) - 1.0));
                float3 _p32 = f_permute((_p3 + _Pi.z));
                float3 _p33 = f_permute(((_p3 + _Pi.z) + 1.0));
                float3 _ox11 = (frac((_p11 * 0.14285715)) - 0.42857143);
                float3 _oy11 = ((mod_emu(floor((_p11 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz11 = ((floor((_p11 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox12 = (frac((_p12 * 0.14285715)) - 0.42857143);
                float3 _oy12 = ((mod_emu(floor((_p12 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz12 = ((floor((_p12 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox13 = (frac((_p13 * 0.14285715)) - 0.42857143);
                float3 _oy13 = ((mod_emu(floor((_p13 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz13 = ((floor((_p13 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox21 = (frac((_p21 * 0.14285715)) - 0.42857143);
                float3 _oy21 = ((mod_emu(floor((_p21 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz21 = ((floor((_p21 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox22 = (frac((_p22 * 0.14285715)) - 0.42857143);
                float3 _oy22 = ((mod_emu(floor((_p22 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz22 = ((floor((_p22 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox23 = (frac((_p23 * 0.14285715)) - 0.42857143);
                float3 _oy23 = ((mod_emu(floor((_p23 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz23 = ((floor((_p23 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox31 = (frac((_p31 * 0.14285715)) - 0.42857143);
                float3 _oy31 = ((mod_emu(floor((_p31 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz31 = ((floor((_p31 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox32 = (frac((_p32 * 0.14285715)) - 0.42857143);
                float3 _oy32 = ((mod_emu(floor((_p32 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz32 = ((floor((_p32 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _ox33 = (frac((_p33 * 0.14285715)) - 0.42857143);
                float3 _oy33 = ((mod_emu(floor((_p33 * 0.14285715)), 7.0) * 0.14285715) - 0.42857143);
                float3 _oz33 = ((floor((_p33 * 0.020408163)) * 0.16666667) - 0.41666666);
                float3 _dx11 = (_Pfx + (1.0 * _ox11));
                float3 _dy11 = (_Pfy.x + (1.0 * _oy11));
                float3 _dz11 = (_Pfz.x + (1.0 * _oz11));
                float3 _dx12 = (_Pfx + (1.0 * _ox12));
                float3 _dy12 = (_Pfy.x + (1.0 * _oy12));
                float3 _dz12 = (_Pfz.y + (1.0 * _oz12));
                float3 _dx13 = (_Pfx + (1.0 * _ox13));
                float3 _dy13 = (_Pfy.x + (1.0 * _oy13));
                float3 _dz13 = (_Pfz.z + (1.0 * _oz13));
                float3 _dx21 = (_Pfx + (1.0 * _ox21));
                float3 _dy21 = (_Pfy.y + (1.0 * _oy21));
                float3 _dz21 = (_Pfz.x + (1.0 * _oz21));
                float3 _dx22 = (_Pfx + (1.0 * _ox22));
                float3 _dy22 = (_Pfy.y + (1.0 * _oy22));
                float3 _dz22 = (_Pfz.y + (1.0 * _oz22));
                float3 _dx23 = (_Pfx + (1.0 * _ox23));
                float3 _dy23 = (_Pfy.y + (1.0 * _oy23));
                float3 _dz23 = (_Pfz.z + (1.0 * _oz23));
                float3 _dx31 = (_Pfx + (1.0 * _ox31));
                float3 _dy31 = (_Pfy.z + (1.0 * _oy31));
                float3 _dz31 = (_Pfz.x + (1.0 * _oz31));
                float3 _dx32 = (_Pfx + (1.0 * _ox32));
                float3 _dy32 = (_Pfy.z + (1.0 * _oy32));
                float3 _dz32 = (_Pfz.y + (1.0 * _oz32));
                float3 _dx33 = (_Pfx + (1.0 * _ox33));
                float3 _dy33 = (_Pfy.z + (1.0 * _oy33));
                float3 _dz33 = (_Pfz.z + (1.0 * _oz33));
                float3 _d11 = (((_dx11 * _dx11) + (_dy11 * _dy11)) + (_dz11 * _dz11));
                float3 _d12 = (((_dx12 * _dx12) + (_dy12 * _dy12)) + (_dz12 * _dz12));
                float3 _d13 = (((_dx13 * _dx13) + (_dy13 * _dy13)) + (_dz13 * _dz13));
                float3 _d21 = (((_dx21 * _dx21) + (_dy21 * _dy21)) + (_dz21 * _dz21));
                float3 _d22 = (((_dx22 * _dx22) + (_dy22 * _dy22)) + (_dz22 * _dz22));
                float3 _d23 = (((_dx23 * _dx23) + (_dy23 * _dy23)) + (_dz23 * _dz23));
                float3 _d31 = (((_dx31 * _dx31) + (_dy31 * _dy31)) + (_dz31 * _dz31));
                float3 _d32 = (((_dx32 * _dx32) + (_dy32 * _dy32)) + (_dz32 * _dz32));
                float3 _d33 = (((_dx33 * _dx33) + (_dy33 * _dy33)) + (_dz33 * _dz33));
                float3 _d1a = min(_d11, _d12);
                (_d12 = max(_d11, _d12));
                (_d11 = min(_d1a, _d13));
                (_d13 = max(_d1a, _d13));
                (_d12 = min(_d12, _d13));
                float3 _d2a = min(_d21, _d22);
                (_d22 = max(_d21, _d22));
                (_d21 = min(_d2a, _d23));
                (_d23 = max(_d2a, _d23));
                (_d22 = min(_d22, _d23));
                float3 _d3a = min(_d31, _d32);
                (_d32 = max(_d31, _d32));
                (_d31 = min(_d3a, _d33));
                (_d33 = max(_d3a, _d33));
                (_d32 = min(_d32, _d33));
                float3 _da = min(_d11, _d21);
                (_d21 = max(_d11, _d21));
                (_d11 = min(_da, _d31));
                (_d31 = max(_da, _d31));
                float2 s452 = {0, 0};
                if ((_d11.x < _d11.y))
                {
                (s452 = _d11.xy);
                }
                else
                {
                (s452 = _d11.yx);
                }
                (_d11.xy = s452);
                float2 s453 = {0, 0};
                if ((_d11.x < _d11.z))
                {
                (s453 = _d11.xz);
                }
                else
                {
                (s453 = _d11.zx);
                }
                (_d11.xz = s453);
                (_d12 = min(_d12, _d21));
                (_d12 = min(_d12, _d22));
                (_d12 = min(_d12, _d31));
                (_d12 = min(_d12, _d32));
                (_d11.yz = min(_d11.yz, _d12.xy));
                (_d11.y = min(_d11.y, _d12.z));
                (_d11.y = min(_d11.y, _d11.z));
                return sqrt(_d11.xy);
            }
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				
				float2 _st = i.uv;
                (_st *= 10.0);
                float2 _F = f_cellular(float3(_st, _Time.y));
                float _dots = smoothstep(0.050000001, 0.1, _F.x);
                float _n = (_F.y - _F.x);
                (_n *= _dots);
                
				return fixed4(_n, _n, _n, 1.0);
			}
			ENDCG
		}
	}
}
