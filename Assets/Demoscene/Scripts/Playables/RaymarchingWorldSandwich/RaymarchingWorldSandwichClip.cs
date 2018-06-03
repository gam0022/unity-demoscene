using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class RaymarchingWorldSandwichClip : PlayableAsset, ITimelineClipAsset
{
    public RaymarchingWorldSandwichBehaviour template = new RaymarchingWorldSandwichBehaviour ();
    public ExposedReference<GameObject> newExposedReference;

    public ClipCaps clipCaps
    {
        get { return ClipCaps.SpeedMultiplier | ClipCaps.Blending; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<RaymarchingWorldSandwichBehaviour>.Create (graph, template);
        RaymarchingWorldSandwichBehaviour clone = playable.GetBehaviour ();
        clone.newExposedReference = newExposedReference.Resolve (graph.GetResolver ());
        return playable;
    }
}
