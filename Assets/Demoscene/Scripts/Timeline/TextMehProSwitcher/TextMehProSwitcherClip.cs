using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using TMPro;

[Serializable]
public class TextMehProSwitcherClip : PlayableAsset, ITimelineClipAsset
{
    public TextMehProSwitcherBehaviour template = new TextMehProSwitcherBehaviour ();
    public ExposedReference<GUIText> newExposedReference;

    public ClipCaps clipCaps
    {
        get { return ClipCaps.Blending; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<TextMehProSwitcherBehaviour>.Create (graph, template);
        TextMehProSwitcherBehaviour clone = playable.GetBehaviour ();
        clone.newExposedReference = newExposedReference.Resolve (graph.GetResolver ());
        return playable;
    }
}
