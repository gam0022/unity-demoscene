using UnityEngine.Timeline;
using TMPro;

namespace Demoscene
{
    [TrackColor(0.855f, 0.8623f, 0.87f)]
    [TrackClipType(typeof(TextMeshProSwitcherClip))]
    [TrackBindingType(typeof(TextMeshProUGUI))]
    public class TextMeshProSwitcherTrack : DemoTrackBase<TextMeshProSwitcherMixer>
    {
    }
}
