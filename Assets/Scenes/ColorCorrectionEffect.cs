using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ColorCorrectionEffect : PostEffectBase
{

    [Range(0f, 1f)]
    public float hueShift = 0f;
    [Range(0f, 3f)]
    public float saturationScaler = 1f;
    [Range(0f,3f)]
    public float brightnessScaler = 1f;

    public bool attenuateSaturation = true;
    public bool attenuateBrightness = true;
    public Vector2 attenuationCenter = new Vector2(.5f, .5f);
    [Range(0f , 1f)]
    public float attenuationRadius = .3f;

    public float luminanceThreshold = .3f;

    public Transform followObject;

    // Start is called before the first frame update
    void Start()
    {
        shader = Shader.Find("NPR/ColorCorrectionShader");
        CreateMaterial();
    }

    void Update() {
        if (followObject != null) {
            Vector3 screenPoint = GetComponent<Camera>().WorldToScreenPoint(followObject.position);

            attenuationCenter = new Vector2 (
                screenPoint.x / Screen.width,
                screenPoint.y / Screen.height
            );
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        if (CreateMaterial()) {
            material.SetFloat("hueShift", hueShift);
            material.SetFloat("saturationScaler", saturationScaler);
            material.SetFloat("brightnessScaler", brightnessScaler);
            material.SetVector("attenuationCenter", attenuationCenter);
            material.SetFloat("attenuationRadius", attenuationRadius);
            material.SetFloat("luminanceThreshold", luminanceThreshold);

            if (attenuateSaturation) material.EnableKeyword("ATTENUATE_SATURATION");
            else material.DisableKeyword("ATTENUATE_SATURATION");

            if (attenuateBrightness) material.EnableKeyword("ATTENUATE_BRIGHTNESS");
            else material.DisableKeyword("ATTENUATE_BRIGHTNESS");

            Graphics.Blit(source, destination, material);
        } else {
            Graphics.Blit(source, destination);
        }
    }
}
