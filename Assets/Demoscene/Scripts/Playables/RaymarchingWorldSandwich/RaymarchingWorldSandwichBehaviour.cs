using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class RaymarchingWorldSandwichBehaviour : PlayableBehaviour
{
    public GameObject newExposedReference;
    public float newBehaviourVariable;

    public override void OnGraphStart (Playable playable)
    {
        
    }
}
