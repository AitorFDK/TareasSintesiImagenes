using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PixelizeMipMapEffect : PostEffectBase
{
    [Range(0,4)]
    public int level = 1;

    void Start() {
        shader = Shader.Find("NPR/PixelizeMipMapShader");
        CreateMaterial();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (CreateMaterial()) {
            RenderTexture renderTex = RenderTexture.GetTemporary(src.width, src.height);
            renderTex.useMipMap = true;
            Graphics.Blit(src, renderTex);

            renderTex.filterMode = FilterMode.Point;
            material.SetInt("lodLevel", level);

            Graphics.Blit(renderTex, dest, material);

            RenderTexture.ReleaseTemporary(renderTex);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
