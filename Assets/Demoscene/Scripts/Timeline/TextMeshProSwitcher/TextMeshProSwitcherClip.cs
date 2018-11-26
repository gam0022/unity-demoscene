using UnityEngine;

namespace Demoscene
{
    public class TextMeshProSwitcherClip : DemoClipBase<TextMeshProSwitcherBehaviour>
    {
        public string text;
        public Color color = Color.white;
        public float fontSize = 20f;

        protected override TextMeshProSwitcherBehaviour CreateTemplate()
        {
            return new TextMeshProSwitcherBehaviour(this);
        }
    }
}
