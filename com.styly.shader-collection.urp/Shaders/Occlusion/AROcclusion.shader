Shader "AR/Occlusion"
{
    Properties {}  // No exposed properties – mask is always invisible.

    // ─── Built-in Render Pipeline ────────────────────────────
    SubShader
    {
        Tags { "RenderType" = "Opaque"
               "Queue"      = "Geometry-1" }  // Renders just before ordinary opaque objs.

        Cull Back
        ZWrite On
        ColorMask 0
        ZTest LEqual

        Pass
        {
            CGPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            struct appdata { float4 vertex : POSITION; };
            struct v2f     { float4 pos    : SV_POSITION; };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return 0;  // No color output
            }
            ENDCG
        }
    }

    // ─── Universal Render Pipeline (URP) variant ───────────────
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline"
               "RenderType"    = "Opaque"
               "Queue"         = "Geometry-1" }

        Cull Back
        ZWrite On
        ColorMask 0
        ZTest LEqual

        Pass
        {
            Name "OcclusionMask"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS.xyz);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return 0;  // No color output
            }
            ENDHLSL
        }
    }

    // from PolySpatial
        // URP SubShader
    SubShader
    {
        PackageRequirements
        {
            "com.unity.render-pipelines.universal": "13.0"
        }

        Tags
        {
            "RenderType"="Opaque"
            "Queue" = "Geometry-1"
            "RenderPipeline" = "UniversalPipeline"
        }
        ZWrite On
        ZTest LEqual
        ColorMask 0

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;

                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                ZERO_INITIALIZE(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = TransformObjectToHClip(v.vertex);
                return o;
            }

            real4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                return real4(0.0, 0.0, 0.0, 0.0);
            }
            ENDHLSL
        }
    }
    // Built-in Render Pipeline Subshader
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Tags { "Queue" = "Geometry-1" }
        ZWrite On
        ZTest LEqual
        ColorMask 0

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;

                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                return fixed4(0.0, 0.0, 0.0, 0.0);
            }
            ENDCG
        }
    }
    
    FallBack Off
}