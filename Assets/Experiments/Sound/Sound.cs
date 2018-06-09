using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Sound : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
        int length = 600;
        var se = gameObject.AddComponent<AudioSource>();
        (se.clip = AudioClip.Create("test",length, 1, 44100, false))
            .SetData(Enumerable.Range(0, length).Select(t => Mathf.Sin(t * 0.2f)).ToArray(), 0);
        se.loop = true;
        se.Play();
    }

    // Update is called once per frame
    void Update()
    {
    }
}