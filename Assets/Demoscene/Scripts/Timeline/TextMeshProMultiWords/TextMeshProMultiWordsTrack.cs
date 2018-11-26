using TMPro;
using UnityEngine.Timeline;

namespace Demoscene
{
    [TrackColor(0.855f, 0.8623f, 0.87f)]
    [TrackClipType(typeof(TextMeshProMultiWordsClip))]
    [TrackBindingType(typeof(TextMeshPro))]
    public class TextMeshProMultiWordsTrack : DemoTrackBase<TextMeshProMultiWordsMixer>
    {
    }
}
