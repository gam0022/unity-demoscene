using UnityEngine;
using UnityEngine.Timeline;

public class TimelineTimeControl : MonoBehaviour, ITimeControl
{
    [SerializeField] int bpm = 120;

    readonly int timelineTimeId = Shader.PropertyToID("_TimelineTime");
    readonly int beatId = Shader.PropertyToID("_Beat");

    public void SetTime(double time)
    {
        Shader.SetGlobalFloat(timelineTimeId, (float) time);
        Shader.SetGlobalFloat(beatId, (float) time * bpm / 60);
    }

    public void OnControlTimeStart()
    {
    }

    public void OnControlTimeStop()
    {
#if !UNITY_EDITOR
        Application.Quit();
#endif
    }

}
