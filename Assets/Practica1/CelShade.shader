Shader "Unlit/CelShade"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _ToonTex("Toon map", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_toon
            // #pragma fragment frag_normals
            #pragma fragment frag_toon

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f_toon
            {
                float3 normal : NORMAL;
                float3 ligthDir: TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _ToonTex;

            v2f_toon vert_toon (appdata v)
            {
                v2f_toon o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                float3 wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.ligthDir = normalize(_WorldSpaceLightPos0.xyz - wPos * _WorldSpaceLightPos0.w);
                
                return o;
            }

            fixed4 frag_normals (v2f_toon i) : SV_Target
            {
                float3 N = normalize(i.normal);
                return float4(N,1);
            }

            fixed4 frag_toon (v2f_toon i) : SV_Target
            {
                float3 N = normalize(i.normal);
                float3 L = normalize(i.ligthDir);
                float NdL = dot(N,L);

                fixed4 col = tex2D(_ToonTex, float2(NdL, 0.5));
                return col;
            }
            ENDCG
        }
    }
}
