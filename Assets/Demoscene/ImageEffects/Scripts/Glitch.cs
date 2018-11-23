using System;
using UnityEngine;

namespace Demoscene.ImageEffect
{
    [ExecuteInEditMode]
    public class Glitch : MonoBehaviour
    {
        [SerializeField] Material material;

        [SerializeField, Range(0, 1)] float intensity;

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            material.SetFloat("_Intensity", intensity);
            Graphics.Blit(source, destination, material);
        }
    }
}

