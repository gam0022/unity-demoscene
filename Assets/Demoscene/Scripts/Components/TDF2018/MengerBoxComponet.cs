using UnityEngine;

namespace Demoscene.TDF2018
{
    public class MengerBoxComponet : MonoBehaviour
    {
        readonly int mengerScaleId = Shader.PropertyToID("_MengerScale");
        readonly int mengerOffsetId = Shader.PropertyToID("_MengerOffset");

        [SerializeField] Material material;

        public void ApplyMengerParams(float scale, Vector3 offset)
        {
            material.SetFloat(mengerScaleId, scale);
            material.SetVector(mengerOffsetId, offset);
        }
    }
}
