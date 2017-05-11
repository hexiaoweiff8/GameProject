using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using System.Xml;
using UnityEngine.SceneManagement;

class wnd_scene : wnd_base
{
    public const string ResName = "ui_scene"; 
    public wnd_scene()
        : base(ResName)
    { 
        Single = this; 
    }

    protected override void OnLostInstance()
    { 
        BelowPrefab = null;
        OverheadPrefab = null;
    }

    protected override void OnNewInstance()
     {
         BelowPrefab = m_instance.FindWidget("BelowPrefab");
         OverheadPrefab = m_instance.FindWidget("OverheadPrefab");
         OverheadPrefab.SetActive(false);//禁用 
         BelowPrefab.SetActive(false);//禁用 
     }


    //创建头顶面板
    public GameObject CreateOverhead() {

       // var activeScene = SceneManager.GetActiveScene();
        //SceneManager.SetActiveScene(SceneManager.GetSceneByName("sc_main"));

        var obj = GameObject.Instantiate(OverheadPrefab);
        obj.transform.parent = OverheadPrefab.transform.parent;
        obj.transform.localScale = OverheadPrefab.transform.localScale;
        obj.transform.localRotation = OverheadPrefab.transform.localRotation;

        NGUITools.MarkParentAsChanged(obj);


        //SceneManager.SetActiveScene(activeScene); 

        return obj;
    }

    //创建脚下面板
    public GameObject CreateBelow()
    {
        //var activeScene = SceneManager.GetActiveScene();
       // SceneManager.SetActiveScene(SceneManager.GetSceneByName("sc_main"));

        var obj = GameObject.Instantiate(BelowPrefab);
        obj.transform.parent = BelowPrefab.transform.parent;
        obj.transform.localScale = BelowPrefab.transform.localScale;
        obj.transform.localRotation = BelowPrefab.transform.localRotation;

        NGUITools.MarkParentAsChanged(obj);

        //SceneManager.SetActiveScene(activeScene); 
        return obj;
    }
     
    public bool IsInitd
    {
        get
        {
            return OverheadPrefab != null;
        }
    }

    GameObject OverheadPrefab;//头顶面板预置
    GameObject BelowPrefab;//脚下面板
    public static wnd_scene Single = null; 
} 
 