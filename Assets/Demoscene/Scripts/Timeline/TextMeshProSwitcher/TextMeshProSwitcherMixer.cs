using UnityEngine;
using UnityEngine.Playables;
using TMPro;

namespace Demoscene
{
    public class TextMeshProSwitcherMixer : DemoMixerBase<TextMeshProSwitcherBehaviour, TextMeshProUGUI>
    {
        float maxWeight;
        Color color;
        string text;
        float fontSize;

        protected override void PreProcess(Playable playable, FrameData info, TextMeshProUGUI component)
        {
            maxWeight = 0;
            color = Color.clear;
            text = "";
            fontSize = 20f;
        }

        protected override void Process(Playable playable, FrameData info, TextMeshProUGUI component,
            ScriptPlayable<TextMeshProSwitcherBehaviour> input, float weight, int inputPort)
        {
            var clip = input.GetBehaviour().Clip;

            if (weight > maxWeight)
            {
                text = clip.text;
                maxWeight = weight;
            }

            color += clip.color * weight;
            fontSize += clip.fontSize * weight;
        }

        protected override void PostProcess(Playable playable, FrameData info, TextMeshProUGUI component)
        {
            component.color = color;
            component.text = text;
            component.fontSize = fontSize;
        }
    }
}
