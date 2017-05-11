using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//属性页组件
[AddComponentMenu("QK/UI/UIAttributePage")]
public class UIAttributePage : MonoBehaviour
{
    public GameObject ActivityButton = null;//选中时显示的按钮
    public GameObject InactiveButton = null;//未选中时显示的按钮
    //页面
    public GameObject Page= null;

    [SerializeField]
    [HideInInspector] 
    int _TabGrop = 0;//组


    public bool Activity = false;//是否激活
    public bool IsHide = false;//是否处于隐藏状态
    
    public int TabGrop //组
    {
        get{
            return _TabGrop;
        }
        set{
            if (_TabGrop != 0 && g_TabGroups.ContainsKey(_TabGrop))
            {  
                g_TabGroups[_TabGrop].Remove(this);
                if (g_TabGroups[_TabGrop].Count == 0)
                    g_TabGroups.Remove(_TabGrop);
            }

            _TabGrop = value;

            RegTabGrop();
        }
    }

    void RegTabGrop()
    {
        if (_TabGrop == 0) return;

        if (!g_TabGroups.ContainsKey(_TabGrop))
            g_TabGroups.Add(_TabGrop, new HashSet<UIAttributePage>());
        g_TabGroups[_TabGrop].Add(this);

    }
   

    public float FadeTime = 0.3f;//过渡时间

    /// <summary>
    /// 设为活动页
    /// </summary>
    public void SetActivity()
    {
        UpdateFace(this);

    }

    void Start()
    {
        if (InactiveButton != null)
        {
            UIEventListener listener = UIEventListener.Get(InactiveButton);
            listener.onClick += OnInactiveButtonClick;
        }

        if (Activity) UpdateFace(this);
    }

    public void SetHide(bool hide)
    {
        IsHide = hide;
        if (!g_TabGroups.ContainsKey(_TabGrop)) return;
        HashSet<UIAttributePage> attributePages = g_TabGroups[_TabGrop];
        foreach(UIAttributePage curr in attributePages)
        {
            if(curr.Activity)
            {
                UpdateFace(curr);
                break;
            }
        }
    }

    
    void OnEnable() {
        RegTabGrop(); 
    }
     
/*
    void OnDisable()
    {
       
    }*/

    void OnDestroy()
    {
        TabGrop = 0;
    }

    void UpdateFace(UIAttributePage activePage)
    { 
        if (TabGrop == 0) return; 
        HashSet<UIAttributePage> attributePages = g_TabGroups[TabGrop];
        foreach (UIAttributePage curr in attributePages)
        {
            bool needActive = (curr == activePage);
           
            curr.Activity = needActive;

            if(curr.IsHide)
            {
                NGuiHelper.FadeHide(curr.Page, FadeTime);
                if (curr.ActivityButton != null) curr.ActivityButton.SetActive(false);
                if (curr.InactiveButton != null) curr.InactiveButton.SetActive(false);
            }
            else if (needActive)
            {
                NGuiHelper.AlphaTo(curr.Page, 1, FadeTime, null);

                if (curr.InactiveButton != null) curr.InactiveButton.SetActive(false);
                if (curr.ActivityButton != null) curr.ActivityButton.SetActive(true);
            }
            else
            {
                NGuiHelper.FadeHide(curr.Page, FadeTime);


                if (curr.ActivityButton != null) curr.ActivityButton.SetActive(false);
                if (curr.InactiveButton != null) curr.InactiveButton.SetActive(true);
            }
        }
    }

    void OnInactiveButtonClick(GameObject obj)
    { 
        UpdateFace(this); 
    }

    static Dictionary<int, HashSet<UIAttributePage>> g_TabGroups = new Dictionary<int, HashSet<UIAttributePage>>();
}