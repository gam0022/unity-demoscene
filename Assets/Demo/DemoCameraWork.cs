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
            transform.position = new Vector3(4f, 2f, 20f);
            transform.LookAt(target);
        }
        else
        {
            float rate = (t - 6f) / (10f - 6f);
            transform.position = new Vector3(0f, Mathf.Lerp(2f, 20f, rate * rate), 20f);
            transform.LookAt(new Vector3(0f, 0f, 25f + rate * 20f));
        }
    }

    public void OnControlTimeStart()
    {
    }

    public void OnControlTimeStop()
    {
    }
}