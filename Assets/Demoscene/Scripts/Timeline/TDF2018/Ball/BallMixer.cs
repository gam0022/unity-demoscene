using UnityEngine;
using UnityEngine.Playables;

namespace Demoscene.TDF2018
{
    public class BallMixer : DemoMixerBase<BallBehaviour, BallComponet>
    {
        float maxWeight;
        Vector3 position;

        protected override void PreProcess(Playable playable, FrameData info, BallComponet component)
        {
            maxWeight = 0;
            position = Vector3.zero;
        }

        protected override void Process(Playable playable, FrameData info, BallComponet component,
            ScriptPlayable<BallBehaviour> input, float weight, int inputPort)
        {
            var clip = input.GetBehaviour().Clip;

            if (weight > maxWeight)
            {
                maxWeight = weight;
            }

            position += clip.position * weight;
        }

        protected override void PostProcess(Playable playable, FrameData info, BallComponet component)
        {
            component.ApplyPosition(position);
        }
    }
}
