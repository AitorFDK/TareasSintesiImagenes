Shader "NPR/ColorTransferShader"
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
            int singlePixelLevel;

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float4 mean = tex2Dlod(_MainTex, float4(0.5, 0.5, 0, singlePixelLevel));

                float4 diff = col-mean;

                return diff*diff;
            }
            ENDCG
        }

        Pass {
            CGPROGRAM
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
            sampler2D meanTexTarget;
            sampler2D meanTexExemplar;
            sampler2D varianceTexTarget;
            sampler2D varianceTexExemplar;
            int singlePixelLevelTarget;
            int singlePixelLevelExemplar;

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

                float4 targetMean = tex2Dlod(meanTexTarget, float4(0.5,0.5,0,singlePixelLevelTarget));
                float4 sourceMean = tex2Dlod(meanTexExemplar, float4(0.5,0.5,0,singlePixelLevelExemplar));
                float4 targetVariance = tex2Dlod(varianceTexTarget, float4(0.5,0.5,0,singlePixelLevelTarget));
                float4 sourceVariance = tex2Dlod(varianceTexExemplar, float4(0.5,0.5,0,singlePixelLevelExemplar));

                col = col - targetMean;
                float4 varianceScale = sourceVariance / targetVariance;

                col *= varianceScale;
                col += sourceMean;

                return col;
            }
            ENDCG
        }
    }
}
