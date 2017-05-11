using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;


[ExecuteInEditMode]
[RequireComponent(typeof(UIProgressBar))]
[AddComponentMenu("QK/UI/UIProgressBarTX")]
public class UIProgressBarTX : MonoBehaviour
{
   
    /// <summary>
    /// 渐显/渐隐过渡时间
    /// </summary>
    public float Duration = 0.1f;

    //当大于某值时显示对象
    public float GreaterV;
    public UIWidget GreaterEffect = null;

    //当小于某值时显示对象
    public float LessV;
    public UIWidget LessEffect = null;


    void Awake()
    {
        m_ProgressBar = GetComponent<UIProgressBar>();
        EventDelegate.Add(m_ProgressBar.onChange, OnChange);

         if(LessEffect!=null)
             m_LessIsShow = LessEffect.isActiveAndEnabled;

         if(GreaterEffect!=null)
            m_GreaterIsShow = GreaterEffect.isActiveAndEnabled;
    }


    void Start() { OnChange(); }

    //进度条值发生改变
    void OnChange()
    {
        if (LessEffect != null)
        { 
            if (m_ProgressBar.value <= LessV)
                Show(ref m_LessTweener, ref m_LessIsShow, LessEffect); 
            else 
                Hide(ref m_LessTweener,ref m_LessIsShow, LessEffect);
        }


        if (GreaterEffect != null)
        {
            if (m_ProgressBar.value >= GreaterV)
                Show(ref m_GreaterTweener,ref m_GreaterIsShow, GreaterEffect);
            else
                Hide(ref m_GreaterTweener,ref m_GreaterIsShow, GreaterEffect);
        }
         
    }

    void OnDestroy()
    {
        if (m_LessTweener != null && m_LessTweener.IsActive()) m_LessTweener.Kill();
        if (m_GreaterTweener != null && m_GreaterTweener.IsActive()) m_GreaterTweener.Kill();
    }

    void Show(ref Tweener tweener, ref bool isShow, UIWidget effectObj)
    {
        if (isShow) return;
        isShow = true;
        if (tweener != null && tweener.IsActive()) tweener.Kill();
        effectObj.gameObject.SetActive(true);
        tweener = DOTween.To(() => effectObj.alpha, (v) => effectObj.alpha = v, 1, Duration).SetAutoKill();
    }

    void Hide(ref Tweener tweener,ref bool isShow, UIWidget effectObj)
    {
        if (!isShow) return;
        isShow = false;
        if (tweener != null && tweener.IsActive()) tweener.Kill();

        tweener = DOTween.To(() => effectObj.alpha, (v) => effectObj.alpha = v, 0, Duration)
            .SetAutoKill()
            .OnKill( () => effectObj.gameObject.SetActive(false) );
    }

    bool m_LessIsShow = false;
    bool m_GreaterIsShow = false;
    Tweener m_LessTweener = null;
    Tweener m_GreaterTweener = null ;
    UIProgressBar m_ProgressBar;
}  