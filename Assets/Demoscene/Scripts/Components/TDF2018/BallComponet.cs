using UnityEngine;

namespace Demoscene.TDF2018
{
    public class BallComponet : MonoBehaviour
    {
        readonly int timeId = Shader.PropertyToID("_LocalTime");
        readonly int durationId = Shader.PropertyToID("_LocalDuration");

        [SerializeField] Material material;

        public void ApplyTime(float time, float duration)
        {
        }

        public void ApplyPosition(Vector3 position)
        {
            transform.position = position;
        }
    }
}
