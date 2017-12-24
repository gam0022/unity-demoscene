using System;
using UnityEngine;
using UnityEngine.Timeline;

public class TheGlowCameraWork : MonoBehaviour, ITimeControl
{
    [SerializeField]
    Transform target;

    const float c1 = 3f;
    const float c2 = 5f;
    const float c3 = 6f;
    const float c4 = 13f;

    public void SetTime(double time)
    {
        var t = (float) time;
        
        if (t < c1)
        {
            float rate = t / c1;
            transform.position = target.position + new Vector3(0f, 0f, Mathf.Lerp(2f, 1f, rate * rate));
            transform.LookAt(target);
        }
        else if (t < c2)
        {
            float rate = (t - c1) / (c2 - c1);
            transform.position = target.position + new Vector3(Mathf.Sin(rate * rate), 0f, Mathf.Cos(rate * rate));
            transform.LookAt(target);
        }
        else if (t < c3)
        {
            transform.position = new Vector3(1f, 2f, 10f);
            transform.LookAt(target);
        }
        else if (t < c4)
        {
            float rate = (t - c3) / (c4 - c3);
            transform.position = new Vector3(0f, Mathf.Lerp(2f, 25f, Mathf.Pow(rate, 3f)), 10f);
            transform.LookAt(new Vector3(0f, 1f, 11f + rate * 11f));
        }
    }

    public void OnControlTimeStart()
    {
    }

    public void OnControlTimeStop()
    {
    }
}