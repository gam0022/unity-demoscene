using System;
using UnityEngine;
using UnityEngine.Timeline;

public class DemoCameraWork : MonoBehaviour, ITimeControl
{
    [SerializeField] private Transform target;

    public void SetTime(double time)
    {
        float t = (float) time;
        
        if (t < 3f)
        {
            float rate = t / 3f;
            transform.position = target.position + new Vector3(0f, 0f, Mathf.Lerp(2f, 1f, rate * rate));
            transform.LookAt(target);
        }
        else if (t < 5f)
        {
            float rate = (t - 3f) / (5f - 3f);
            transform.position = target.position + new Vector3(Mathf.Sin(rate * rate), 0f, Mathf.Cos(rate * rate));
            transform.LookAt(target);
        }
        else if (t < 6f)
        {
            transform.position = new Vector3(1f, 2f, 10f);
            transform.LookAt(target);
        }
        else
        {
            float rate = (t - 6f) / (13f - 6f);
            transform.position = new Vector3(0f, Mathf.Lerp(2f, 20f, rate * rate * rate), 11f);
            transform.LookAt(new Vector3(0f, 1f, 11f + rate * 23f));
        }
    }

    public void OnControlTimeStart()
    {
    }

    public void OnControlTimeStop()
    {
    }
}