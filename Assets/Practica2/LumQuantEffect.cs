using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class LumQuantEffect : PostEffectBase
{
    [Range(1,50)]
    public int levels = 8;

    void Start()
    {
        shader = Shader.Find("NPR/LuminanceQuantization");
        CreateMaterial();
    }


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (CreateMaterial())
        {
            material.SetInt("levels", levels);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
