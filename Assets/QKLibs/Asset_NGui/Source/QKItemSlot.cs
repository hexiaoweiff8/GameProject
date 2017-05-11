using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 道具插槽
/// </summary>
[AddComponentMenu("QK/QKItemSlot")]
class QKItemSlot : UIWidgetContainer
{
    /// <summary>
    /// 弹出强度
    /// </summary>
    public float strength = 15f;

    void Start()
    {
        _Reposition(9999999);
    }

    //重新排列道具
    public void Reposition()
    {
        _Reposition(strength);
    }

    void _Reposition(float sth)
    {
        UIWidget uiWidget = gameObject.GetComponent<UIWidget>();
        if (uiWidget == null)
        {
            Debug.LogError("UIItemSlot 组件必须绑定在UIWidget 或 UIWidget的子类 上");
            return;
        }

        int depth = uiWidget.depth + 1;


        int childCount = gameObject.transform.childCount;

        for (int i = 0; i < childCount; i++)
        {
            GameObject obj = gameObject.transform.GetChild(i).gameObject;

            //重排深度
            UIWidget cmWidget = obj.GetComponent<UIWidget>();
            if (cmWidget != null) cmWidget.depth = depth++;

            //用动画方式移动对象到指定位置
            var sp = SpringPosition.Begin(obj, Vector3.zero, sth);
            sp.worldSpace = false;
        }
    }
}
 
