using UnityEngine;

namespace Demoscene.TDF2018
{
    public class MengerBoxClip : DemoClipBase<MengerBoxBehaviour>
    {
        [Header("Menger")]
        public float mengerScale = 2.6f;
        public Vector3 mengerOffset = new Vector3(1.54f, 1.89f, 0.77f);
        public float mengerFold = 8f;
        public float mengerTwistZ = 0f;

        [Header("Emission")]
        public Vector4 emissionHsv = Vector4.one;
        public float emissionHueShiftZ = 0f;
        public float emissionHueShiftXY = 0f;
        public float emissionHueShiftBeat = 0f;

        [Header("Fog")]
        public Color fogColor = Color.black;
        public float fogPower = 2f;
        public float fogIntensity = 0.01f;

        protected override MengerBoxBehaviour CreateTemplate()
        {
            return new MengerBoxBehaviour(this);
        }
    }
}
