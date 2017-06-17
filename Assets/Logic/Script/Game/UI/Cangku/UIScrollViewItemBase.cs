using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIScrollViewItemBase : MonoBehaviour {

    #region HANDLER Selected(回调)

    public delegate void OnSelectedHandler(UIScrollViewItemBase item);

    public OnSelectedHandler onSelected;

    public void Selected(bool clear = false)
    {
        if (onSelected != null)
        {
            onSelected(this);

            if (clear)
            {
                onSelected = null;
            }
        }
    }

    #endregion
    /// <summary>
    /// 用于确定Item在UI界面中的大小
    /// </summary>
    [SerializeField]
    public UIWidget _widgetTransform;

    public int Index
    {
        get;
        set;
    }

    public Vector2 Size
    {
        get{ return new Vector2(_widgetTransform.width,_widgetTransform.height); }
        set{ _widgetTransform.width = (int)value.x; _widgetTransform.height = (int)value.y; }
    }

    public Vector2 Position
    {
        get
        {
            return new Vector2(transform.localPosition.x, transform.localPosition.y);
        }

        set
        {
            transform.localPosition = new Vector3(value.x,value.y, transform.localPosition.z);
        }
    }

}
