Shader "QK/QKCloud"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_Line("Line0", Color) = (1,0,0,1)
		_Line1("Line1", Color) = (0,1,0,1)
		_TimeScale ("TimeScale", Range (0,5)) = 2
		_TimeDelay("TimeDelay",float) = 1  
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		LOD 200

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
			#pragma target 3.0

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Line;
			float4 _Line1;
				float _MaxTime;
			float _TimeScale;
			half _TimeDelay;  
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
			fixed4 frag (v2f IN) : SV_Target
			{
				fixed4 original = tex2D(_MainTex, IN.texcoord);

				float a = original.a;
				half time = (_Time.y + _TimeDelay) * _TimeScale;  
				_MaxTime = sin(time);
				original =  _Line*(1-_MaxTime)+ _Line1*_MaxTime;;
				original.a = a*0.5;
				return original;
			}
			
			ENDCG
		}
	}
	SubShader
	{
		LOD 100

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
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
