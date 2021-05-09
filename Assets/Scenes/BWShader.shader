Shader "NPR/BWShader"
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
            #pragma multi_compile __ ADAPTIVE
            #pragma vertex vert
            #pragma fragment frag

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
            float luminanceThreshold;

            float luminance(float3 rgb) {
                return 0.2126*rgb.r + 0.7152*rgb.g + 0.0722 * rgb.b;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

                #if ADAPTIVE

                    float lum = luminance(col);

                    if (lum < luminanceThreshold) return float4(0,0,0,1);
            
                #else
                    
                    float4 colAvg= float4(0,0,0,0); // average colorof the neighbourhood
                    
                    int kernelWidth= 9;
                    float weight = 1.0 / (float)kernelWidth/ (float)kernelWidth;
                    
                    for(int u = -kernelWidth/ 2; u <= kernelWidth/ 2; ++u) { // visit neighbours (horizontal)
                        for(int v = -kernelWidth/ 2; v <= kernelWidth/ 2; ++v) { // visit neighbours (vertical)
                            colAvg += weight * tex2D(_MainTex, i.uv+ float2(u*_MainTex_TexelSize.x, v*_MainTex_TexelSize.y));
                        }
                    }
                    // if the coloris darker than the neighbourhood average -> black, else white
                    if(luminance(col) < luminance(colAvg)*luminanceThreshold) return float4(0, 0, 0, 1);
                    
                #endif

                return float4(1, 1, 1, 1);
            }
            ENDCG
        }
    }
}
