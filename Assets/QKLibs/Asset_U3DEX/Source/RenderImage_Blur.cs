using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[AddComponentMenu("QK/RenderImage_Blur")]
[RequireComponent(typeof(Camera))]
class RenderImage_Blur : MonoBehaviour
{
    /*void OnRenderImage(RenderTexture src, RenderTexture dest )
    {
        Graphics.Blit()
    }*/


    public Shader blurShader;
    private Material blurMat = null;
 
    
    void Start()
    {
        blurMat = new Material(blurShader);
    }

    ///    
    /// 在所有渲染完成后被调用，来渲染图片的后期处理效果   
    /// source理解为进入shader过滤器的纹理   
    /// destination理解为渲染完成的纹理   
    ///    
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
         float onePixelWidth = 1.0f / Screen.width;
         float onePixelHeight = 1.0f / Screen.height; 

         blurMat.SetVector("offsets", new Vector4(onePixelWidth, onePixelHeight));
        
         for (int i = 0; i < 10; i++)
             Graphics.Blit(source, source, blurMat);
         
         Graphics.Blit(source, destination, blurMat);
    }   
} 