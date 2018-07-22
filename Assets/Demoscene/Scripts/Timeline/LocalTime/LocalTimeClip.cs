using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    [Serializable]
    public class LocalTimeClip : PlayableAsset, ITimelineClipAsset
    {
        public LocalTimeBehaviour template = new LocalTimeBehaviour();

        public ClipCaps clipCaps
        {
            get { return ClipCaps.None; }
        }

        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            var playable = ScriptPlayable<LocalTimeBehaviour>.Create(graph, template);
            LocalTimeBehaviour clone = playable.GetBehaviour();
            return playable;
        }
    }
}
