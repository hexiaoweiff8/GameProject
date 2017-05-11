Shader "QK/QKDriftingCloud"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_DriftTex ("DrigtTex (RGB), Alpha (A)", 2D) = "black" {}
		_DriftTex2 ("DrigtTex2 (RGB), Alpha (A)", 2D) = "black" {}
		_MaxTime ("MaxTime", Range (-5,5)) = 1
		_Color("Color",Color) = (1,1,1,1)
		_ScrollXSpeed ("X Scroll Speed", Range(-10, 10)) = 2  
		_ScrollYSpeed ("Y Scroll Speed", Range(-10, 10)) = 2 
		_TimeScale("TimeScale",float) = 1  
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
			sampler2D _DriftTex;
			sampler2D _DriftTex2;
			float4 _MainTex_ST;
			float4 _DriftTex_ST;
			fixed _ScrollXSpeed;  
			fixed _ScrollYSpeed;  
			float _MaxTime;
			half _TimeScale;  
			half _TimeDelay;  
			float4 _Color;

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
				fixed xScrollValue = _ScrollXSpeed * _Time.y; 
				fixed yScrollValue = _ScrollYSpeed * _Time.y; 
				fixed2 scrolledUV = IN.texcoord;   
				 
				scrolledUV += fixed2(xScrollValue, yScrollValue);
				fixed4 original3 = fixed4(0.9,0.9,0.9,0.9);
				fixed4 original = tex2D(_DriftTex, scrolledUV)*_Color;
				fixed4 original2 = tex2D(_DriftTex2, scrolledUV);

				fixed4 _texCol0 = tex2D(_MainTex, IN.texcoord) * original;

				half time = (_Time.y + _TimeDelay) * _TimeScale;  
				
				//_MaxTime = sin(time);
				//original = (original*(1-_MaxTime)+original2*_MaxTime)*original3;
				
				original.a = _texCol0.a*2;

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
