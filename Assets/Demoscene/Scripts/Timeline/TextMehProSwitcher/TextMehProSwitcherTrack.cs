using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using TMPro;

namespace Demoscene
{
    [TrackColor(0.855f, 0.8623f, 0.87f)]
    [TrackClipType(typeof(TextMehProSwitcherClip))]
    [TrackBindingType(typeof(TextMeshProUGUI))]
    public class TextMehProSwitcherTrack : DemoTrackBase<TextMehProSwitcherMixer>
    {
    }
}
