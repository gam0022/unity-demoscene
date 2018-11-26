using TMPro;
using UnityEngine;
using UnityEngine.Playables;

namespace Demoscene
{
    public class TextMeshProMultiWordsMixer : DemoMixerBase<TextMeshProMultiWordsBehaviour, TextMeshPro>
    {
        float maxWeight;
        float time;
        int bpm;
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
                bpm = clip.bpm;
                words = clip.words;
            }
        }

        protected override void PostProcess(Playable playable, FrameData info, TextMeshPro component)
        {
            if (words.Length > 0)
            {
                component.transform.gameObject.SetActive(true);

                var beat = time * bpm / 60;
                var index = Mathf.Clamp((int) beat, 0, words.Length - 1);
                component.text = words[index];
            }
            else
            {
                component.transform.gameObject.SetActive(false);
            }
        }
    }
}
