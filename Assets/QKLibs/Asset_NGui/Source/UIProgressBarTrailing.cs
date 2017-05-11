using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;


/// <summary>
/// 实现掉血血条渐变效果
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(UIProgressBar))]
[AddComponentMenu("QK/UI/UIProgressBarTrailing")]
public class UIProgressBarTrailing : MonoBehaviour
{
    /// <summary>
    /// 参考进度条
    /// </summary>
    public UIProgressBar ReferenceBar;
   
    /// <summary>
    /// 每秒减少速度
    /// </summary>
    public float Speed = 0.3f;

    void Start()
    {
        if (ReferenceBar == null) return;
        //记录原血量
        m_ProgressBar.value = ReferenceBar.value - 0.001f;
    }

    void Awake()
    {
        if (ReferenceBar == null) return;

        m_ProgressBar = GetComponent<UIProgressBar>();
        EventDelegate.Add(ReferenceBar.onChange, OnChange); 
    }

     
    //进度条值发生改变
    void OnChange()
    { 
        if (ReferenceBar.value > m_ProgressBar.value)//参考血量大于当前
        { 
            KillTweeners();
            m_ProgressBar.value = ReferenceBar.value;//直接设置血量
        }
        else if(ReferenceBar.value < m_ProgressBar.value)
        {
            KillTweeners();
            var c = (m_ProgressBar.value - ReferenceBar.value);
            var duration = c / Speed;
            m_Tweener = DOTween.To(() => m_ProgressBar.value, (v) => m_ProgressBar.value = v, ReferenceBar.value, duration).SetAutoKill().SetEase(Ease.OutQuart);
        }
        
    }

    void OnDestroy()
    {
        KillTweeners();
    }

    void KillTweeners()
    {
        if (m_Tweener != null && m_Tweener.IsActive()) {m_Tweener.Kill(); m_Tweener = null;}
    }
     
    Tweener m_Tweener = null; 
    UIProgressBar m_ProgressBar;
}  