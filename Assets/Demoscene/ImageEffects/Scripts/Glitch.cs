using System;
using UnityEngine;

namespace Demoscene.ImageEffect
{
    [ExecuteInEditMode]
    public class Glitch : MonoBehaviour
    {
        readonly int alwaysId = Shader.PropertyToID("_Always");
        readonly int glitchUvIntensityId = Shader.PropertyToID("_GlitchUvIntensity");
        readonly int distortionIntensityId = Shader.PropertyToID("_DistortionIntensity");
        readonly int rgbShiftIntensityId = Shader.PropertyToID("_RgbShiftIntensity");
        readonly int noiseIntensityId = Shader.PropertyToID("_NoiseIntensity");
        readonly int blendColorId = Shader.PropertyToID("_BlendColor");

        [SerializeField] Material material;
        [SerializeField, Range(0, 1.0f)] float always;
        [SerializeField, Range(0, 0.2f)] float glitchUvIntensity;
        [SerializeField, Range(0, 0.2f)] float distortionIntensity;
        [SerializeField, Range(0, 0.2f)] float rgbShiftIntensity;
        [SerializeField, Range(0, 0.2f)] float noiseIntensity;
        [SerializeField] Color blendColor = Color.clear;

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            material.SetFloat(alwaysId, always);
            material.SetFloat(glitchUvIntensityId, glitchUvIntensity);
            material.SetFloat(distortionIntensityId, distortionIntensity);
            material.SetFloat(rgbShiftIntensityId, rgbShiftIntensity);
            material.SetFloat(noiseIntensityId, noiseIntensity);
            material.SetColor(blendColorId, blendColor);

            Graphics.Blit(source, destination, material);
        }
    }
}

