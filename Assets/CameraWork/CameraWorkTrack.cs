using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[TrackColor(0f, 0.4866645f, 1f)]
[TrackClipType(typeof(CameraWorkClip))]
public class CameraWorkTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        return ScriptPlayable<CameraWorkMixerBehaviour>.Create (graph, inputCount);
    }
}
