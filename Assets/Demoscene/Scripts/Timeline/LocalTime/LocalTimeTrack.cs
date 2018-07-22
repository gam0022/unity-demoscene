using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    [TrackColor(0.855f, 0.8623f, 0.87f)]
    [TrackClipType(typeof(LocalTimeClip))]
    [TrackBindingType(typeof(LocalTimeComponet))]
    public class LocalTimeTrack : TrackAsset
    {
        public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
        {
            return ScriptPlayable<LocalTimeMixerBehaviour>.Create(graph, inputCount);
        }
    }
}
