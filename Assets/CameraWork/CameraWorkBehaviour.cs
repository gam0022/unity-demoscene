using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[Serializable]
public class CameraWorkBehaviour : PlayableBehaviour
{
    public Camera Camera;
    
    public override void OnGraphStart (Playable playable)
    {
        
    }
}
