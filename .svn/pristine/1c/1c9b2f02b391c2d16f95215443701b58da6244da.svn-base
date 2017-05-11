using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[AddComponentMenu("QK/UI/UITextureEffect_Blur")]
[RequireComponent(typeof(UITexture))]
class UITextureEffect_Blur : MonoBehaviour
{
    void Start()
    {
        UpdateShaderParam();
    }

     void Update()
    {
       
        if (m_ScreenWidth != Screen.width || m_ScreenHeight != Screen.height)
            UpdateShaderParam();
    }


    void UpdateShaderParam()
    {
        m_ScreenWidth = Screen.width;
        m_ScreenHeight = Screen.height;

        UITexture cmTexture = GetComponent<UITexture>();
        cmTexture.material.SetFloat("_textureWidth", m_ScreenWidth);
        cmTexture.material.SetFloat("_textureHeight", m_ScreenHeight);
    }

    int m_ScreenWidth = 0;
    int m_ScreenHeight = 0;
} 
