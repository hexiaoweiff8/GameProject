 

using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using System.Xml;
using DG.Tweening;

class wnd_prefight : wnd_base
{
    public const string ResName = "ui_prefight";
    public wnd_prefight()
        : base(ResName)
    { 
        Single = this; 
    }

     
    protected override void OnLostInstance()
    {
        
    }

    protected override void OnNewInstance()
    {
        var animObj = m_instance.FindWidget("anim_widget");
        tweeners = animObj.GetComponents<UITweener>();
    }
    UITweener[] tweeners;
      
    protected override void OnShowfinish() {
         
    }

    public void Reset()
    {
       
    }


    /// <summary>
    /// 挥动旗帜，逐渐显露场景
    /// </summary>
    public void ShowFightScene()
    {

    }

    public static wnd_prefight Single = null;
    
} 
 
 