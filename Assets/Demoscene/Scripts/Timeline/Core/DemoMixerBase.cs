using UnityEngine.Playables;

namespace Demoscene
{
    /// <summary>
    /// タイムラインで扱うMixerの基底クラス
    /// </summary>
    public class DemoMixerBase : PlayableBehaviour
    {
        /// <summary>
        /// 制御元のPlayableDirector
        /// </summary>
        protected PlayableDirector Director { get; private set; }

        /// <summary>
        /// PlayableCreate時の処理
        /// </summary>
        /// <param name="playable">Behaviour</param>
        public override void OnPlayableCreate(Playable playable)
        {
            Director = playable.GetGraph().GetResolver() as PlayableDirector;
        }
    }

    /// <summary>
    /// Mixerの基底クラス
    /// </summary>
    /// <typeparam name="TBehaviour">Clip単位に生成されるBehaviour</typeparam>
    /// <typeparam name="TComponent">TrackにBindingされる操作対象となるComponent</typeparam>
    /// TODO: kikuchi-j TComponentの型制約 LiveComponentBase的な
    public abstract class DemoMixerBase<TBehaviour, TComponent> : DemoMixerBase
        where TBehaviour : DemoBehaviourBase, new()
        where TComponent : class
    {
        /// <summary>
        /// 直近のProcessFrameで本処理が実行されたかどうか
        /// </summary>
        protected bool IsProcessed { get; private set; }

        /// <summary>
        /// フレームを処理します
        /// </summary>
        /// <param name="playable">Clip単位のBehaviourを持っているPlayable</param>
        /// <param name="info">現在のフレーム情報</param>
        /// <param name="playerData">任意のオブジェクト</param>
        public override void ProcessFrame(Playable playable, FrameData info, object playerData)
        {
            IsProcessed = false;
            var component = playerData as TComponent;
            if (component == null || !IsValidComponent(component))
            {
                return;
            }

            PreProcess(playable, info, component);

            var inputCount = playable.GetInputCount();
            for (var i = 0; i < inputCount; i++)
            {
                var weight = playable.GetInputWeight(i);
                if (UnityEngine.Mathf.Approximately(weight, 0))
                {
                    ProcessZeroWeight(playable, info, component, i);
                    continue;
                }

                var input = GetInput(playable, i);
                Process(playable, info, component, input, weight, i);
                IsProcessed = true;
            }

            PostProcess(playable, info, component);
        }

        /// <summary>
        /// 前処理を行います
        /// </summary>
        /// <param name="playable">Clip単位のBehaviourを持っているPlayable</param>
        /// <param name="info">現在のフレーム情報</param>
        /// <param name="component">TrackBindingされるの操作対象となるComponent</param>
        protected virtual void PreProcess(Playable playable, FrameData info, TComponent component)
        {
        }

        /// <summary>
        /// 本処理を行います
        /// </summary>
        /// <param name="playable">Clip単位のBehaviourを持っているPlayable</param>
        /// <param name="info">現在のフレーム情報</param>
        /// <param name="component">TrackBindingされるの操作対象となるComponent</param>
        /// <param name="input">InputBehaviour</param>
        /// <param name="weight">ウェイト値</param>
        /// <param name="inputPort">ScritPlayableの番号</param>
        protected abstract void Process(Playable playable, FrameData info,
            TComponent component, ScriptPlayable<TBehaviour> input, float weight, int inputPort);

        /// <summary>
        /// ゼロウェイトのインプットに対して処理を行います
        /// </summary>
        /// <param name="playable">Clip単位のBehaviourを持っているPlayable</param>
        /// <param name="info">現在のフレーム情報</param>
        /// <param name="component">TrackBindingされるの操作対象となるComponent</param>
        /// <param name="inputPort">ScritPlayableの番号</param>
        protected virtual void ProcessZeroWeight(Playable playable, FrameData info, TComponent component, int inputPort)
        {
        }

        /// <summary>
        /// 後処理を行います
        /// </summary>
        /// <param name="playable">Clip単位のBehaviourを持っているPlayable</param>
        /// <param name="info">現在のフレーム情報</param>
        /// <param name="component">TrackBindingされるの操作対象となるComponent</param>
        protected virtual void PostProcess(Playable playable, FrameData info, TComponent component)
        {
        }

        /// <summary>
        /// TrackBindingされるの操作対象となるComponentのデータが妥当であるかを判別します
        /// </summary>
        /// <param name="component">TrackBindingされるの操作対象となるComponent</param>
        /// <returns>妥当であればtrue、そうでなければfalse</returns>
        protected virtual bool IsValidComponent(TComponent component)
        {
            return true;
        }

        /// <summary>
        /// 指定のScriptablePlayable(Behaviourのガワ)を取得します
        /// ※各種PlayableBehaviourで定義されているイベント内で使用される想定
        /// </summary>
        /// <param name="playable">各種PlayableBehaviourで定義されているイベントから渡されるPlayableをそのまま渡してください</param>
        /// <param name="inputPort">取得したいScritPlayableの番号</param>
        /// <returns>ScriptPlayable</returns>
        protected ScriptPlayable<TBehaviour> GetInput(Playable playable, int inputPort)
        {
            return (ScriptPlayable<TBehaviour>) playable.GetInput(inputPort);
        }
    }
}
