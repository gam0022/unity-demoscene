﻿using System;
using UnityEngine;
using UnityEngine.Events;

public class PlayerMove : MonoBehaviour 
{
    public float speed = 5;
    public bool worldDirection;
    public bool rotatePlayer = true;

    public Action spaceAction;
    public Action enterAction;

	void Update() 
    {
        Vector3 input = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
		if (input.magnitude > 0)
        {
            Vector3 fwd = worldDirection 
                ? Vector3.forward : transform.position - Camera.main.transform.position;
            fwd.y = 0;
            fwd = fwd.normalized;
            if (fwd.magnitude > 0.001f)
            {
                Quaternion inputFrame = Quaternion.LookRotation(fwd, Vector3.up);
                input = inputFrame * input;
                if (input.magnitude > 0.001f)
                {
                    transform.position += input * (speed * Time.deltaTime);
                    if (rotatePlayer)
                        transform.rotation = Quaternion.LookRotation(input.normalized, Vector3.up);
                }
            }
        }
        if (Input.GetKeyDown(KeyCode.Space) && spaceAction != null)
            spaceAction();
        if (Input.GetKeyDown(KeyCode.Return) && enterAction != null)
            enterAction();
	}
}
