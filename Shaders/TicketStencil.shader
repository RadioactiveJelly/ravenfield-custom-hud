Shader "Hidden/TicketStencil"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    }
    SubShader
    {
        // No culling or depth
        Tags { "Queue"="Overlay" "RenderType"="Overlay" }
	    //Blend SrcAlpha OneMinusSrcAlpha
	    ColorMask 0
        ZWrite Off
        

        Pass
        {
            Stencil 
            {
                Ref 1
                Comp always
                Pass replace
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            sampler2D _MainTex;
            float _Distance;
            float _Offset;
            fixed4 _TintColor;

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(0,0,0,0);
            }
            ENDCG
        }
    }
}
    
