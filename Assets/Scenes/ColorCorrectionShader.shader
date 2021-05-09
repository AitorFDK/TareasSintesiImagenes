Shader "NPR/ColorCorrectionShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma multi_compile __ ATTENUATE_SATURATION
            #pragma multi_compile __ ATTENUATE_BRIGHTNESS
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "colorspaces.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float hueShift;
            float saturationScaler;
            float brightnessScaler;
            float2 attenuationCenter;
            float attenuationRadius;

            float attenuation(float2 uv) {
                float2 aspectCorrection = float2(1.0, _MainTex_TexelSize.x / _MainTex_TexelSize.y);
                float dist = length((uv-attenuationCenter) * aspectCorrection);
                return smoothstep(0, 1, 1.0 - dist / attenuationRadius);
            }


            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float3 hsv = rgb_to_hsv(col.xyz);

                hsv.x = frac(hsv.x + hueShift);
                hsv.y *= saturationScaler;
                hsv.z *= brightnessScaler;

                #ifdef ATTENUATE_SATURATION
                    hsv.y *= attenuation(i.uv);
                #endif

                #ifdef ATTENUATE_BRIGHTNESS
                    hsv.z *= attenuation(i.uv);
                #endif


                col.xyz = hsv_to_rgb(hsv);

                return col;
            }
            ENDCG
        }
    }
}
