using UnityEngine;

namespace Demoscene
{
    public class LocalTimeComponet : MonoBehaviour
    {
        readonly int timeId = Shader.PropertyToID("_LocalTime");
        readonly int durationId = Shader.PropertyToID("_LocalDuration");

        [SerializeField] Material material;

        public void ApplyTime(float time, float duration)
        {
            material.SetFloat(timeId, time);
            material.SetFloat(durationId, duration);
        }
    }
}
