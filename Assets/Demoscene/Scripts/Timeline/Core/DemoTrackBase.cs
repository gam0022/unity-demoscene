using System.Linq;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Demoscene
{
    /// <summary>
    /// タイムラインで扱うTrackの基底クラス
    /// </summary>
    /// <typeparam name="TMixer">ミキサー</typeparam>
    public abstract class DemoTrackBase<TMixer> : TrackAsset
        where TMixer : DemoMixerBase, new()
    {
        /// <summary>
        /// Track内にあるClip全体を評価するためのMixerを生成します
        /// </summary>
        /// <param name="graph">各Mixer(Playable)の関連付けが定義されているGraph</param>
        /// <param name="go">PlayableGraphを要求しているGameObject</param>
        /// <param name="inputCount">このTrackで扱うClip数</param>
        /// <returns>MixerをラップしているPlayable</returns>
        public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
        {
            ApplyClipDisplayNames();
            return ScriptPlayable<TMixer>.Create(graph, inputCount);
        }

        /// <summary>
        /// TimelineWindow上で表示するClipの表示名を決めます
        /// ※任意の名前を付けたい場合は継承先で定義すること
        /// </summary>
        /// <param name="clip">対象となるTimelineClip</param>
        /// <returns>表示名</returns>
        protected virtual string GetClipDisplayName(TimelineClip clip)
        {
            return clip.displayName;
        }

        void ApplyClipDisplayNames()
        {
            var clips = GetClips().ToArray();
            for (var i = 0; i < clips.Length; ++i)
            {
                clips[i].displayName = GetClipDisplayName(clips[i]);
            }
        }
    }
}
