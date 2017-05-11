using UnityEngine;
using System.Collections.Generic;
using System;

[RequireComponent(typeof(UIWidget))]
[AddComponentMenu("QK/UI/UISizeAlignment")]
public class UISizeAlignment : MonoBehaviour
{
    public UIWidget ReferenceWidget = null;

    UIWidget m_cmWidget = null;
    void Start()
    {
        m_cmWidget = GetComponent<UIWidget>();
    }

    void Update()
    {
        if (ReferenceWidget == null || m_cmWidget == null) return;

        if(m_cmWidget.width!=ReferenceWidget.width)
            m_cmWidget.width=ReferenceWidget.width;

        if (m_cmWidget.height != ReferenceWidget.height)
            m_cmWidget.height = ReferenceWidget.height; 
    }
}
 
