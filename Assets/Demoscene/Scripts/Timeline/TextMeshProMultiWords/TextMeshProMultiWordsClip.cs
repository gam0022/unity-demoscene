namespace Demoscene
{
    public class TextMeshProMultiWordsClip : DemoClipBase<TextMeshProMultiWordsBehaviour>
    {
        public string[] words;

        protected override TextMeshProMultiWordsBehaviour CreateTemplate()
        {
            return new TextMeshProMultiWordsBehaviour(this);
        }
    }
}
