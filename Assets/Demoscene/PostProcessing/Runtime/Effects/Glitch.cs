using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

namespace Demoscene.PostProcessing
{
    [Serializable]
    [PostProcess(typeof(GlitchRenderer), PostProcessEvent.AfterStack, "Demoscene/Glitch")]
    public sealed class Glitch : PostProcessEffectSettings
    {
        [Range(0f, 1f), Tooltip("Glitch effect intensity.")]
        public FloatParameter intensity = new FloatParameter { value = 0.5f };

        public override bool IsEnabledAndSupported(PostProcessRenderContext context)
        {
            return enabled.value && intensity.value > 0f;
        }
    }

    public sealed class GlitchRenderer : PostProcessEffectRenderer<Glitch>
    {
        public override void Render(PostProcessRenderContext context)
        {
            var sheet = context.propertySheets.Get(Shader.Find("Hidden/Demoscene/Glitch"));
            sheet.properties.SetFloat("_Intensity", settings.intensity);
            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        }
    }
}
