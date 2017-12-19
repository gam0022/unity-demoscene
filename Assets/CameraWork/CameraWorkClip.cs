using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[Serializable]
public class CameraWorkClip : PlayableAsset, ITimelineClipAsset
{
    public CameraWorkBehaviour template = new CameraWorkBehaviour ();
    public ExposedReference<Camera> Camera;

    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<CameraWorkBehaviour>.Create (graph, template);
        CameraWorkBehaviour clone = playable.GetBehaviour ();
        clone.Camera = Camera.Resolve (graph.GetResolver ());
        return playable;
    }
}
