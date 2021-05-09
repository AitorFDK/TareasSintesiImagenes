using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class BackgroundEffect : PostEffectBase
{
    public Texture2D backgroundTex;
    [Range(0,1)]
    public float mixRate = 0.6f;

    void Start() {
        shader = Shader.Find("NPR/Background");
        CreateMaterial();
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (CreateMaterial()) {
            material.SetTexture("backgroundTex", backgroundTex);
            material.SetFloat("mixRate", mixRate);
            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }
}
