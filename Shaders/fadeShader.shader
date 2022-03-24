Shader "Hidden/fadeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Distance ("Fade Distance", Float) = 1
        _Offset("Shader Offset", Float) = 0.5175
    }
    SubShader
    {
        // No culling or depth
        Tags { "Queue"="Overlay+1" "RenderType"="Overlay" }
	    Blend SrcAlpha OneMinusSrcAlpha
	    ColorMask RGBA
	    ZTest Off
	    Cull Off 
        Lighting Off 
        ZWrite On

        Pass
        {
            Stencil 
            {
                Ref 1
                Comp Greater
                Pass keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Distance;
            float _Offset;
            fixed4 _TintColor;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float left = ((i.uv.x - _Offset) * _Distance);
                left = clamp(left, 0, 1);

                float right = (((1 - i.uv.x) + _Offset) * _Distance);
                right = clamp(right, 0, 1);
                
                float alpha = left * right;
                alpha = clamp(alpha,0,1);
                col.a *= alpha;

                return col;
            }
            ENDCG
        }
    }
}
