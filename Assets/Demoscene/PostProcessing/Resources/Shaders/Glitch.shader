Shader "Hidden/Demoscene/Glitch"
{
    HLSLINCLUDE

        #include "Assets/PostProcessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        float _Intensity;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
            float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750));
            color.rgb = lerp(color.rgb, luminance.xxx, _Intensity.xxx);
            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}
