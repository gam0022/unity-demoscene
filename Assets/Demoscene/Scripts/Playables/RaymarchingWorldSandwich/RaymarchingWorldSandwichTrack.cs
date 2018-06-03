using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.855f, 0.8623f, 0.87f)]
[TrackClipType(typeof(RaymarchingWorldSandwichClip))]
[TrackBindingType(typeof(MonoBehaviour))]
public class RaymarchingWorldSandwichTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        return ScriptPlayable<RaymarchingWorldSandwichMixerBehaviour>.Create (graph, inputCount);
    }
}
