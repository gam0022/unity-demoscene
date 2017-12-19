using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class CameraWorkClip : PlayableAsset, ITimelineClipAsset
{
  public CameraWorkBehaviour template = new CameraWorkBehaviour ();
  public ExposedReference<Transform> startLocation;
  public ExposedReference<Transform> endLocation;
    
  public ClipCaps clipCaps
  {
    get { return ClipCaps.Blending; }
  }

  public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
  {
    var playable = ScriptPlayable<CameraWorkBehaviour>.Create (graph, template);
    CameraWorkBehaviour clone = playable.GetBehaviour ();
    clone.startLocation = startLocation.Resolve (graph.GetResolver ());
    clone.endLocation = endLocation.Resolve (graph.GetResolver ());
    return playable;
  }
}