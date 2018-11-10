using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using TMPro;

[TrackColor(0.855f, 0.8623f, 0.87f)]
[TrackClipType(typeof(TextMehProSwitcherClip))]
[TrackBindingType(typeof(TextMeshProUGUI))]
public class TextMehProSwitcherTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        return ScriptPlayable<TextMehProSwitcherMixerBehaviour>.Create (graph, inputCount);
    }
}
