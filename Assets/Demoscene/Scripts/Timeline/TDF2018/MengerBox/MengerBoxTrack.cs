using UnityEngine.Timeline;

namespace Demoscene.TDF2018
{
    [TrackColor(0.855f, 0.8623f, 0.87f)]
    [TrackClipType(typeof(MengerBoxClip))]
    [TrackBindingType(typeof(MengerBoxComponet))]
    public class MengerBoxTrack : DemoTrackBase<MengerBoxMixer>
    {
    }
}
