using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ColorTransferEffect : PostEffectBase
{
    public Texture exemplarTexture;

    private void Start()
    {
        shader = Shader.Find("NPR/ColorTransferShader");
        CreateMaterial();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (CreateMaterial() && exemplarTexture != null)
        {
            RenderTexture meanTexExemplar = RenderTexture.GetTemporary(exemplarTexture.width, exemplarTexture.height);
            meanTexExemplar.useMipMap = true;
            Graphics.Blit(exemplarTexture, meanTexExemplar);
            RenderTexture varianceTexExemplar = CreateVarianceTexture(meanTexExemplar);           

            RenderTexture meanTexTarget = RenderTexture.GetTemporary(src.width, src.height);
            meanTexTarget.useMipMap = true;
            Graphics.Blit(src, meanTexTarget);
            RenderTexture varianceTexTarget = CreateVarianceTexture(meanTexTarget);


            int maxLevelTarget = (int)Mathf.Log(Mathf.Max(meanTexTarget.width, meanTexTarget.height), 2);
            int maxLevelExemplar = (int)Mathf.Log(Mathf.Max(meanTexExemplar.width, meanTexExemplar.height), 2);

            material.SetInt("singlePixelLevelTarget", maxLevelTarget);
            material.SetInt("singlePixelLevelExemplar", maxLevelExemplar);
            material.SetTexture("meanTexTarget", meanTexTarget);
            material.SetTexture("meanTexExemplar", meanTexExemplar);
            material.SetTexture("varianceTexExemplar", varianceTexExemplar);
            material.SetTexture("varianceTexTarget", varianceTexTarget);

            Graphics.Blit(src, dest, material, 1);

            RenderTexture.ReleaseTemporary(meanTexTarget);
            RenderTexture.ReleaseTemporary(meanTexExemplar);
            RenderTexture.ReleaseTemporary(varianceTexExemplar);
            RenderTexture.ReleaseTemporary(varianceTexTarget);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    RenderTexture CreateVarianceTexture(Texture meanTex) {
        RenderTexture varianceTex = RenderTexture.GetTemporary(meanTex.width, meanTex.height, 0, RenderTextureFormat.DefaultHDR);

        // varianceTex.useMipMap = true;

        int maxLevel = (int)Mathf.Log(Mathf.Max(meanTex.width, meanTex.height), 2);
        material.SetInt("singlePixelLevel", maxLevel);

        Graphics.Blit(meanTex, varianceTex, material, 0);
        return varianceTex;
    }
}
