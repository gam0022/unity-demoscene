using UnityEngine;

namespace Demoscene
{
    public class LocalTimeComponet : MonoBehaviour
    {
        readonly int timePropertyId = Shader.PropertyToID("_LocalTime");

        [SerializeField] Material material;

        /// <summary>
        /// 再生時間を適用します
        /// </summary>
        /// <param name="time">時間</param>
        public void ApplyTime(float time)
        {
            material.SetFloat(timePropertyId, time);
        }
    }
}
