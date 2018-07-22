using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    [Serializable]
    public class LocalTimeBehaviour : PlayableBehaviour
    {
        public float param1;
        public float param2;
        public Vector3 vec1;

        public override void OnPlayableCreate(Playable playable)
        {
        }
    }
}
