using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class PostEffectBase : MonoBehaviour
{
    public Shader shader = null;
    protected Material material = null;

    protected bool CreateMaterial() {
        
        if (shader == null) {
            Debug.LogWarning("No shader is set in " +  ToString());
            enabled = false;
            return false;
        }

        if (!shader.isSupported) {
            Debug.LogWarning("Unsupported shader in " + ToString());
            enabled = false;
            return false;
        }

        if (material != null && material.shader == shader) return true;

        material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;

        return material != null;
    }
}
