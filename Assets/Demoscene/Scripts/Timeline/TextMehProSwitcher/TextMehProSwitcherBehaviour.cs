using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using TMPro;

[Serializable]
public class TextMehProSwitcherBehaviour : PlayableBehaviour
{
    public GUIText newExposedReference;
    public string text;

    public override void OnPlayableCreate (Playable playable)
    {
        
    }
}
