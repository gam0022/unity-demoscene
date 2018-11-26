namespace Demoscene
{
    public class TextMeshProMultiWordsClip : DemoClipBase<TextMeshProMultiWordsBehaviour>
    {
        public int bpm = 120;
        public string[] words;

        protected override TextMeshProMultiWordsBehaviour CreateTemplate()
        {
            return new TextMeshProMultiWordsBehaviour(this);
        }
    }
}
