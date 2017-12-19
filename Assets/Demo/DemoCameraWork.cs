using UnityEngine;
using UnityEngine.Timeline;

public class DemoCameraWork : MonoBehaviour, ITimeControl
{
    [SerializeField] private Transform target;

    // 何度も呼ばれる
    public void SetTime(double time)
    {
        transform.position = target.position + new Vector3(0.0f, 0.0f, 2.0f);
        transform.LookAt(target);
    }

    // クリップ開始時に呼ばれる
    public void OnControlTimeStart()
    {
    }

    // クリップから抜ける時に呼ばれる
    public void OnControlTimeStop()
    {
    }
}