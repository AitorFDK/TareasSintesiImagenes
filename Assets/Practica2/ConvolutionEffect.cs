using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ConvolutionEffect : PostEffectBase
{

    [Range(3,301)]
    public int boxKernelWindowWidth = 3;

    // Start is called before the first frame update
    void Start()
    {
        shader = Shader.Find("NPR/Convolution");
        CreateMaterial();
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (CreateMaterial()) {
            material.SetInt("boxKernelWidth", boxKernelWindowWidth);
            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }
}
