using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[AddComponentMenu("QK/YQ2/BathQuad")]
[RequireComponent(typeof(MeshRenderer))]
public class YQ2BathQuad : MonoBehaviour
{
    public float width;//阴影宽度
    public float height;//阴影高度
    public float lt_u;//左上角u
    public float lt_v;//左上角v
    public float rb_u;//右下角u
    public float rb_v;//右下角v
     
    public YQ2BatchRender OwnerBatch;
     
    void OnEnable () {
        if (OwnerBatch!=null) OwnerBatch.RegShadow(this);
	}

    void Start()
    {
        m_Renderer = GetComponent<Renderer>();
        OwnerBatch.RegShadow(this);
    }

    void OnDisable()
    { 
        OwnerBatch.UnRegShadow(this); 
    }

    /*
    void OnDestroy()
    {
        OwnerBatch.UnRegShadow(this);
        //if (enabled) enabled = false;
    }*/

    public bool isVisible { get { return m_Renderer==null?false:m_Renderer.isVisible; } }


    Renderer m_Renderer; 
}
