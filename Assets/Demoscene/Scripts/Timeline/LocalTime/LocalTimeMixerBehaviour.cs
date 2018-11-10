using System;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    public class LocalTimeMixerBehaviour : PlayableBehaviour
    {
        // NOTE: This function is called at runtime and edit time.  Keep that in mind when setting the values of properties.
        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
            LocalTimeComponet trackBinding = playerData as LocalTimeComponet;

            if (!trackBinding)
                return;

            int inputCount = playable.GetInputCount();

            var maxWeight = 0f;
            var time = 0f;
            var duration = 0f;

            for (int i = 0; i < inputCount; i++)
            {
                var weight = playable.GetInputWeight(i);
                if (Mathf.Approximately(weight, 0))
                {
                    continue;
                }

                ScriptPlayable<LocalTimeBehaviour> inputPlayable =
                    (ScriptPlayable<LocalTimeBehaviour>) playable.GetInput(i);
                LocalTimeBehaviour input = inputPlayable.GetBehaviour();

                // Use the above variables to process each frame of this playable.
                // NOTE: gam0022 単純なブレンドが難しい値は最もウェイトが高いクリップを採用
                if (weight > maxWeight)
                {
                    time = (float) inputPlayable.GetTime();
                    duration = (float) inputPlayable.GetDuration();
                    maxWeight = weight;
                }
            }

            trackBinding.ApplyTime(time, duration);
        }
    }
}
