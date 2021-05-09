Shader "NPR/Convolution"
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
            #pragma vertex vert
            #pragma fragment frag_box

            #include "UnityCG.cginc"

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
            int boxKernelWidth;

            float4 frag_box (v2f i) : SV_Target {
                float4 col = float4(0,0,0,0);
                float weight = 1.0 / (float)boxKernelWidth / (float)boxKernelWidth;

                for (int u = -boxKernelWidth / 2; u <= boxKernelWidth / 2; ++u) {
                    for (int v = -boxKernelWidth / 2; v <= boxKernelWidth / 2; ++v) {
                        col += weight * tex2D(_MainTex, i.uv + float2(u*_MainTex_TexelSize.x, v*_MainTex_TexelSize.y));
                    }
                }
                return col;
            }


            float4 frag (v2f i) : SV_Target
            {
                float4 col = float4(0,0,0,0);

                const int kernelWidth = 3;

                float weights[kernelWidth*kernelWidth] =  {
                    0, -1, 0,
                    -1, 5, -1,
                    0, -1, 0
                };

                float weightSum = 0;
                float weight = 0;

                for (int u = -kernelWidth / 2; u <= kernelWidth / 2; ++u) {
                    for (int v = -kernelWidth / 2; v <= kernelWidth / 2; ++v) {
                        weight = weights[(u + kernelWidth / 2) * kernelWidth + (v + kernelWidth / 2)];
                        col += weight * tex2D(_MainTex, i.uv + float2(u*_MainTex_TexelSize.x, v*_MainTex_TexelSize.y));

                        weightSum += weight;
                    }
                }

                col /= weightSum + 0.001;

                return col;
            }
            ENDCG
        }
    }
}
