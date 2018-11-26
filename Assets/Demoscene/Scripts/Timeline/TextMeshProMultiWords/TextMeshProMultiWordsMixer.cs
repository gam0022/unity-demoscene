using TMPro;
using UnityEngine.Playables;

namespace Demoscene
{
    public class TextMeshProMultiWordsMixer : DemoMixerBase<TextMeshProMultiWordsBehaviour, TextMeshPro>
    {
        float maxWeight;
        float time;
        string[] words;

        protected override void PreProcess(Playable playable, FrameData info, TextMeshPro component)
        {
            maxWeight = 0;
            time = 0f;
            words = new string[] { };
        }

        protected override void Process(Playable playable, FrameData info, TextMeshPro component,
            ScriptPlayable<TextMeshProMultiWordsBehaviour> input, float weight, int inputPort)
        {
            var clip = input.GetBehaviour().Clip;

            if (weight > maxWeight)
            {
                maxWeight = weight;
                time = (float) input.GetTime();
                words = clip.words;
            }
        }

        protected override void PostProcess(Playable playable, FrameData info, TextMeshPro component)
        {
            if (words.Length > 0)
            {
                component.text = words[0];
            }
        }
    }
}
