using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using Demoscene;

public class RaymarchingWolrdSandwichMixerBehaviour : PlayableBehaviour
{
    // NOTE: This function is called at runtime and edit time.  Keep that in mind when setting the values of properties.
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        RaymarchingWorldSandwichComponet trackBinding = playerData as RaymarchingWorldSandwichComponet;

        if (!trackBinding)
            return;

        int inputCount = playable.GetInputCount ();

        for (int i = 0; i < inputCount; i++)
        {
            float inputWeight = playable.GetInputWeight(i);
            ScriptPlayable<RaymarchingWolrdSandwichBehaviour> inputPlayable = (ScriptPlayable<RaymarchingWolrdSandwichBehaviour>)playable.GetInput(i);
            RaymarchingWolrdSandwichBehaviour input = inputPlayable.GetBehaviour ();
            
            // Use the above variables to process each frame of this playable.
            
        }
    }
}
