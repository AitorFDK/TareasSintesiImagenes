using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PixelizeManualEffect : PostEffectBase
{

    [Range(0,4)]
    public int level = 1;

    // Start is called before the first frame update
    void Start()
    {
        shader = Shader.Find("NPR/PixelizeManualShader");
        CreateMaterial();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (CreateMaterial()) {
            RenderTexture inTex = src;
            for (int i = 0; i < level; i++ )
            {
                
                RenderTexture outTex = RenderTexture.GetTemporary(inTex.width / 2, inTex.height / 2);
                
                inTex.filterMode = FilterMode.Bilinear;
                Graphics.Blit(inTex, outTex);
                inTex = outTex;
            }

            inTex.filterMode = FilterMode.Bilinear;
            Graphics.Blit(inTex, dest);
        } else {
            Graphics.Blit(src, dest);
        }
    }
}
