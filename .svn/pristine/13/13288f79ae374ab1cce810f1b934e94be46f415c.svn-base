using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[AddComponentMenu("QK/UI/UIGrabTexture")]
public class UIGrabTexture : UITexture
{
  
    public UITexture[] OutTextures = null;
    public FilterMode _FilterMode = FilterMode.Bilinear;
    public RenderTexture TargetTexture { get { return targetTexture; } }

    [SerializeField]
    [HideInInspector] 
    public int RenderLayer = -1;//渲染输出层 

    protected override void OnStart()
    {
        base.OnStart();


        int mask_RenderLayer = 1 << RenderLayer;

        Camera[] cameras = GameObject.FindObjectsOfType<Camera>();
        foreach (Camera curr in cameras)
        {
           // Debug.Log("curr.cullingMas:" + curr.cullingMask.ToString());
           // Debug.Log("mask_RenderLayer:" + mask_RenderLayer.ToString());

            if ((curr.cullingMask & mask_RenderLayer) > 0)
            {
                m_Camera = curr; break;
            }
        } 

        CreateRenderTexture();

        //绑定回调事件 
        BindRenderCallback();
    }
  
    protected override  void OnEnable()
    {
        base.OnEnable();

        BindRenderCallback();
    }

    void BindRenderCallback()
    {
        UIWidget cmWidget = GetComponent<UIWidget>();
        if (cmWidget != null)
        {
            cmWidget.onRender -= OnRenderCallback;
            cmWidget.onRender += OnRenderCallback;
        }
    }
 
    
    protected override void OnDisable ()
    { 
        UIWidget cmWidget = GetComponent<UIWidget>();
        if (cmWidget != null)
        {
            cmWidget.onRender -= OnRenderCallback;
        }

        if(lastPanels!=null)
        {
            int thisLayer = gameObject.layer;
            foreach(UIPanel curr in lastPanels )
            {
                if (curr.gameObject.layer == thisLayer|| !curr.isActiveAndEnabled)
                    continue; 
                
                SetLayer(curr.transform, thisLayer);//还原归属层
            }
        }
    }

    int m_ScreenWidth = 0;
    int m_ScreenHeight = 0;

    protected override void OnUpdate() {
        base.OnUpdate();
         
        if (m_ScreenWidth != Screen.width || m_ScreenHeight != Screen.height)
            CreateRenderTexture();
    }
  

    void CreateRenderTexture()
    {

        m_ScreenWidth = Screen.width;
        m_ScreenHeight = Screen.height;
        targetTexture = new RenderTexture((int)(Screen.width), (int)(Screen.height), 24); //, ,RenderTextureFormat.RGB565,RenderTextureReadWrite
        targetTexture.filterMode = _FilterMode;

        if (OutTextures == null) return;

        foreach (UITexture uiTexture in OutTextures)
        {
            uiTexture.mainTexture = targetTexture;
        } 
    }
     


    void OnRenderCallback(Material mat)
    {
        if (g_IsRendering) return;
        if (RenderLayer < 0) return; 
        m_Camera.targetTexture = targetTexture;

        //渲染
        {
            g_IsRendering = true;
            m_Camera.enabled = true;
            m_Camera.Render();//立即渲染一帧
            m_Camera.enabled = false;
            g_IsRendering = false;
        }
         
    }

    public void Reposition()
    { 
        int panelDepth = this.panel.depth;
        int thisLayer = gameObject.layer;

        //将不符合条件的层还原
        if (lastPanels != null)
        {
            foreach (UIPanel curr in lastPanels)
            {
                if (curr.transform.parent == null || curr.depth < panelDepth || !curr.isActiveAndEnabled)
                    continue;

                SetLayer(curr.transform, thisLayer);
            }
        }

        //所有比本对象所属panel低的放入渲染
        lastPanels = GameObject.FindObjectsOfType<UIPanel>();
        foreach (UIPanel curr in lastPanels)
        {
            if (curr.transform.parent == null || curr.depth >= panelDepth||!curr.isActiveAndEnabled)
                continue; 
                
            SetLayer(curr.transform, RenderLayer);
        }

    }

    void SetLayer(Transform transform, int layer)
    { 
        transform.gameObject.layer = layer;

        int childCount = transform.childCount;
        for (int i = 0; i < childCount; i++)
        {
            SetLayer(transform.GetChild(i),   layer);
        }
    }
     
    RenderTexture targetTexture;
    Camera m_Camera;
    UIPanel[] lastPanels = null;
    static bool g_IsRendering = false; 
} 