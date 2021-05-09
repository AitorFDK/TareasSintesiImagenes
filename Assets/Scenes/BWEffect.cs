using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class BWEffect : PostEffectBase
{

    public float luminanceThreshold = .5f;
    public bool adaptive = false;

    // Start is called before the first frame update
    void Start()
    {
        shader = Shader.Find("NPR/BWShader");
        CreateMaterial();
    }

    void Update() {
        if (adaptive) material.EnableKeyword("ADAPTIVE");
        else material.DisableKeyword("ADAPTIVE");
    }

    
    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (CreateMaterial()) {
            material.SetFloat("luminanceThreshold", luminanceThreshold);
            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }
}
