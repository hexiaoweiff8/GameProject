using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
[AddComponentMenu("QK/UI/UIPopMenu")]
class UIPopMenu:MonoBehaviour
{
    /// <summary>
    /// 用于弹出菜单的按钮
    /// </summary>
    public GameObject PopButton = null;
    public GameObject PackButton = null;

    //public UISprite 

    public IQKEvent Evt_PopStateChanged {
        get {
            return _Evt_PopStateChanged;
        }

        set {
            if (_Evt_PopStateChanged != null) {_Evt_PopStateChanged.Dispose(); _Evt_PopStateChanged = null;}
            _Evt_PopStateChanged = value;
        }
    }

    public bool StartPop = false;

    void OnDestroy()
    {
        Evt_PopStateChanged = null;
    } 

    /// <summary>
    /// 弹出强度
    /// </summary>
    public float strength = 15f;

    class PopMenuItem
    {
        public GameObject obj;//对象
        public Vector3 InitialPos;//初始位置
        //public UITweener Tweener = null;//tween句柄
    }
    List<PopMenuItem> m_Items = new List<PopMenuItem>();

    public void Start()
    {
        int childCount = gameObject.transform.childCount;
        for(int i=0;i<childCount;i++)
        {
            PopMenuItem item = new PopMenuItem();
            item.obj = gameObject.transform.GetChild(i).gameObject;
            item.InitialPos = item.obj.transform.localPosition;
            m_Items.Add(item);
        }

        //绑定弹出按钮事件
        if(PopButton!=null)
        {
            UIEventListener listener = UIEventListener.Get(PopButton);
            listener.onClick += OnPopBtnClick;
        }

        if(PackButton!=null)
        {
            UIEventListener listener = UIEventListener.Get(PackButton);
            listener.onClick += OnPopBtnClick;
        }

      

        if(StartPop)
        {
            pop(9999999);
        }else
        {
            pack(9999999);
        }
    }


    public void pack()
    {
        pack(strength);
    }

    public void pack(float sth)
    {
        if (PackButton != null) PackButton.SetActive(false);  
        if (PopButton != null) PopButton.SetActive(true);
        

        m_IsPopd = false;
        if (_Evt_PopStateChanged != null)
            _Evt_PopStateChanged.Call(m_IsPopd);

        UIWidget cmWidght = gameObject.GetComponent<UIWidget>();
        if (cmWidght == null)
        {
            Debug.LogError("UIPopMenu必须绑定在一个Widget上");
            return;
        }

       UIWidget.Pivot pivot = cmWidght.pivot;

        float maxX = -9999999.0f;
        float minX = 9999999.0f;
        float maxY = -9999999.0f;
        float minY = 9999999.0f;
       foreach (PopMenuItem curr in m_Items)
       {
           float InitialPos_X = curr.InitialPos.x;
           float InitialPos_Y = curr.InitialPos.y;
           if (InitialPos_X > maxX) maxX = InitialPos_X;
           if (InitialPos_X < minX) minX = InitialPos_X;
           if (InitialPos_Y > maxY) maxY = InitialPos_Y;
           if (InitialPos_Y < minY) minY = InitialPos_Y;

           curr.obj.EnableCollider(  false); 
            curr.obj.EnableComponent<UIButtonOffset>(  false); 
       } 

        float xoffset = 0;
        float yoffset = 0;
        switch (pivot)
        {
            case UIWidget.Pivot.Left:
                xoffset = -maxX - 10;
                break;
            case UIWidget.Pivot.Right:
                xoffset = -minX + 10;
                break;
            case UIWidget.Pivot.Bottom:
                yoffset = -maxY - 10;
                break;
            case UIWidget.Pivot.Top:
                yoffset = -minY + 10;
                break;
        }

        foreach (PopMenuItem curr in m_Items)
        {
            //计算收起后的位置
            Vector3 endPos = curr.InitialPos;

            endPos.x += xoffset;
            endPos.y += yoffset;


            SpringPosition.Begin(curr.obj, endPos, sth);
        }
         
    }

    public void pop()
    {
        pop(strength);
    }

    public void pop(float sth)
    {
        if (PopButton != null) PopButton.SetActive(false);
        if (PackButton != null) PackButton.SetActive(true);


        m_IsPopd = true;
        if (_Evt_PopStateChanged != null)
            _Evt_PopStateChanged.Call(m_IsPopd);


        foreach (PopMenuItem curr in m_Items)
        { 
            curr.obj.EnableCollider( true); 
            curr.obj.EnableComponent<UIButtonOffset>(true);
            SpringPosition.Begin(curr.obj, curr.InitialPos, sth);
        }

    }


    void OnPopBtnClick(GameObject obj)
    {
        if (m_IsPopd)
            pack();
        else
            pop();
    }

    bool m_IsPopd = false;
    IQKEvent _Evt_PopStateChanged = null;
}
 
