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
        readonly int flashSpeedId = Shader.PropertyToID("_FlashSpeed");
        readonly int flashColorID = Shader.PropertyToID("_FlashColor");
        readonly int blendColorId = Shader.PropertyToID("_BlendColor");

        [SerializeField] Material material;
        [SerializeField, Range(0, 1.0f)] float always;
        [SerializeField, Range(0, 0.2f)] float glitchUvIntensity;
        [SerializeField, Range(0, 0.2f)] float distortionIntensity;
        [SerializeField, Range(0, 0.2f)] float rgbShiftIntensity;
        [SerializeField, Range(0, 0.2f)] float noiseIntensity;
        [SerializeField, Range(0, 100f)] float flashSpeed;
        [SerializeField] Color flashColor = Color.clear;
        [SerializeField] Color blendColor = Color.clear;

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            material.SetFloat(alwaysId, always);
            material.SetFloat(glitchUvIntensityId, glitchUvIntensity);
            material.SetFloat(distortionIntensityId, distortionIntensity);
            material.SetFloat(rgbShiftIntensityId, rgbShiftIntensity);
            material.SetFloat(noiseIntensityId, noiseIntensity);
            material.SetFloat(flashSpeedId, flashSpeed);
            material.SetColor(flashColorID, flashColor);
            material.SetColor(blendColorId, blendColor);

            Graphics.Blit(source, destination, material);
        }
    }
}

