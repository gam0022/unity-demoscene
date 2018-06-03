using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using Demoscene;

[Serializable]
public class RaymarchingWolrdSandwichClip : PlayableAsset, ITimelineClipAsset
{
    public RaymarchingWolrdSandwichBehaviour template = new RaymarchingWolrdSandwichBehaviour ();

    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<RaymarchingWolrdSandwichBehaviour>.Create (graph, template);
        RaymarchingWolrdSandwichBehaviour clone = playable.GetBehaviour ();
        return playable;
    }
}
