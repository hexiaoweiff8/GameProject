Shader "QK/Transparent Colored Gray"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {} 
	}
	  
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex; 

			float4 _MainTex_ST; 
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0; 
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0; 
				fixed4 color : COLOR;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{ 
				half4 c = tex2D(_MainTex, IN.texcoord);
				float grey = dot(c.rgb, float3(0.299, 0.587, 0.114));//得到灰度
				c.rgb = IN.color.rgb * grey;//偏色
				c.a = c.a* IN.color.a;
				return c;
			}
			ENDCG
		}
	}
	 
  FallBack "Diffuse" 
}