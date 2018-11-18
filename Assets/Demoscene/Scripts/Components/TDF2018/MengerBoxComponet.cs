using UnityEngine;

namespace Demoscene.TDF2018
{
    public class MengerBoxComponet : MonoBehaviour
    {
        readonly int mengerScaleId = Shader.PropertyToID("_MengerScale");
        readonly int mengerOffsetId = Shader.PropertyToID("_MengerOffset");
        readonly int mengerFoldId = Shader.PropertyToID("_MengerFold");
        readonly int mengerTwistZ = Shader.PropertyToID("_MengerTwistZ");

        readonly int emissionHsv = Shader.PropertyToID("_EmissionHsv");
        readonly int emissionHueShiftZ = Shader.PropertyToID("_EmissionHueShiftZ");
        readonly int emissionHueShiftXY = Shader.PropertyToID("_EmissionHueShiftXY");
        readonly int emissionHueShiftBeat = Shader.PropertyToID("_EmissionHueShiftBeat");

        readonly int fogColor = Shader.PropertyToID("_FogColor");
        readonly int fogIntensity = Shader.PropertyToID("_FogIntensity");
        readonly int fogPower = Shader.PropertyToID("_FogPower");

        [SerializeField] Material material;

        public void ApplyMengerParams(float scale, Vector3 offset, float fold, float twistZ)
        {
            material.SetFloat(mengerScaleId, scale);
            material.SetVector(mengerOffsetId, offset);
            material.SetFloat(mengerFoldId, fold);
            material.SetFloat(mengerTwistZ, twistZ);
        }

        public void ApplyEmissionParams(Color hsv, float shiftZ, float shiftXY, float shiftBeat)
        {
            material.SetColor(emissionHsv, hsv);
            material.SetFloat(emissionHueShiftZ, shiftZ);
            material.SetFloat(emissionHueShiftXY, shiftXY);
            material.SetFloat(emissionHueShiftBeat, shiftBeat);
        }

        public void ApplyFogParams(Vector4 color, float intensity, float power)
        {
            material.SetVector(fogColor, color);
            material.SetFloat(fogIntensity, intensity);
            material.SetFloat(fogPower, power);
        }
    }
}
