using UnityEngine;
using UnityEngine.Playables;

namespace Demoscene.TDF2018
{
    public class MengerBoxMixer : DemoMixerBase<MengerBoxBehaviour, MengerBoxComponet>
    {
        float maxWeight;
        float mengerScale;
        Vector3 mengerOffset;

        protected override void PreProcess(Playable playable, FrameData info, MengerBoxComponet component)
        {
            maxWeight = 0;
            mengerScale = 0;
            mengerOffset = Vector3.zero;
        }

        protected override void Process(Playable playable, FrameData info, MengerBoxComponet component,
            ScriptPlayable<MengerBoxBehaviour> input, float weight, int inputPort)
        {
            var clip = input.GetBehaviour().Clip;

            if (weight > maxWeight)
            {
                maxWeight = weight;
            }

            mengerScale += clip.mengerScale * weight;
            mengerOffset += clip.mengerOffset * weight;
        }

        protected override void PostProcess(Playable playable, FrameData info, MengerBoxComponet component)
        {
            component.ApplyMengerParams(mengerScale, mengerOffset);
        }
    }
}
