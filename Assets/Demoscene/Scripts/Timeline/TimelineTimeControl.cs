using UnityEngine;
using UnityEngine.Timeline;

public class TimelineTimeControl : MonoBehaviour, ITimeControl
{
    readonly int timelineTimeId = Shader.PropertyToID("_TimelineTime");

    public void SetTime(double time)
    {
        Shader.SetGlobalFloat(timelineTimeId, (float) time);
    }

    public void OnControlTimeStart()
    {
    }

    public void OnControlTimeStop()
    {
    }
}
