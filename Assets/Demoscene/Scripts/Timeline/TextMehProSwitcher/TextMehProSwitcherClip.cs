using UnityEngine;

namespace Demoscene
{
    public class TextMehProSwitcherClip : DemoClipBase<TextMehProSwitcherBehaviour>
    {
        public string text;
        public Color color = Color.white;
        public float fontSize = 20f;

        protected override TextMehProSwitcherBehaviour CreateTemplate()
        {
            return new TextMehProSwitcherBehaviour(this);
        }
    }
}
