using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    /// <summary>
    /// タイムラインで扱うClipの基底クラス
    /// </summary>
    public abstract class DemoClipBase : PlayableAsset, ITimelineClipAsset
    {
        /// <summary>
        /// クリップでサポートするタイムライン機能
        /// ※大体の機能がBlendingを使っているので基底クラスでデフォルトの挙動として定義している
        /// </summary>
        public virtual ClipCaps clipCaps
        {
            get { return ClipCaps.Blending; }
        }
    }

    /// <summary>
    /// タイムラインで扱うClipの基底クラス
    /// </summary>
    /// <typeparam name="TBehaviour">Clip単位で扱うBehaviour</typeparam>
    public abstract class DemoClipBase<TBehaviour> : DemoClipBase
        where TBehaviour : DemoBehaviourBase, new()
    {
        /// <summary>
        /// Playable生成時に使用するテンプレートBehaviourを生成します
        /// </summary>
        /// <returns>Clip単位で扱うBehaviour</returns>
        protected abstract TBehaviour CreateTemplate();

        /// <summary>
        /// Clip単位のPlayable(Behaviourのガワ)を生成します
        /// </summary>
        /// <param name="graph">各Behaviour(Playable)の関連付けが定義されているGraph</param>
        /// <param name="owner">PlayableGraphを要求しているGameObject</param>
        /// <returns>Clip単位のPlayable</returns>
        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            return ScriptPlayable<TBehaviour>.Create(graph, CreateTemplate());
        }
    }
}
