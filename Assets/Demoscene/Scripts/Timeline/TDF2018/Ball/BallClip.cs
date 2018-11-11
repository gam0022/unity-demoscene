using UnityEngine;

namespace Demoscene.TDF2018
{
    public class BallClip : DemoClipBase<BallBehaviour>
    {
        public Vector3 position;

        protected override BallBehaviour CreateTemplate()
        {
            return new BallBehaviour(this);
        }
    }
}
