using UnityEngine;

namespace Demoscene.TDF2018
{
    public class MengerBoxClip : DemoClipBase<MengerBoxBehaviour>
    {
        public float mengerScale = 2.6f;
        public Vector3 mengerOffset = new Vector3(1.54f, 1.89f, 0.77f);

        protected override MengerBoxBehaviour CreateTemplate()
        {
            return new MengerBoxBehaviour(this);
        }
    }
}
