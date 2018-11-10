using UnityEngine.Playables;

namespace Demoscene
{
    /// <summary>
    /// タイムラインで扱うBehaviourの基底クラス
    /// </summary>
    public abstract class DemoBehaviourBase : PlayableBehaviour
    {
    }

    /// <summary>
    /// タイムラインで扱うBehaviourの基底クラス
    /// </summary>
    /// <typeparam name="TClip">操作対象となるClip</typeparam>
    public abstract class DemoBehaviourBase<TClip> : DemoBehaviourBase
        where TClip : DemoClipBase
    {
        /// <summary>
        /// 操作対象となるClip
        /// </summary>
        public TClip Clip { get; private set; }

        /// <summary>
        /// Constructor
        /// </summary>
        protected DemoBehaviourBase()
        {
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="clip">Clip</param>
        protected DemoBehaviourBase(TClip clip)
        {
            Clip = clip;
        }
    }
}
