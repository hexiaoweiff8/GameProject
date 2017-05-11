using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine; 
public class wnd_MsgBox : wnd_base
{
    public delegate void OnMsgBoxClose(int result);

    public const string ResName = "ui_msgbox";
    public const string DependPacks = "rom_share";
    public wnd_MsgBox()
        : base(ResName)
    {
        WndManage.Single.RegWnd(ResName, DependPacks, 15, WndFadeMode.Alpha, WndAnimationMode.situ);
        Single = this;
    }

    protected override void OnLostInstance()
    {
        lable1 = lable2 = null;
    } 

     protected override void OnNewInstance()
    {

    }
    protected override void OnShowfinish()
    {
        GameObject lableObj1 = m_instance.FindWidget("btLabel1");
        GameObject lableObj2 = m_instance.FindWidget("btLabel2");
        GameObject pClose = m_instance.FindWidget("back_btn"); 
        GameObject btnObj1 = m_instance.FindWidget("btn1");
        GameObject btnObj2 = m_instance.FindWidget("btn2");
        GameObject msgObj = m_instance.FindWidget("msg");
        lable1 = lableObj1.GetComponent<UILabel>();
        lable2 = lableObj2.GetComponent<UILabel>(); 
        UILabel msgLable = msgObj.GetComponent<UILabel>();

        GameObject TempTitle = m_instance.FindWidget("title_bg/txt");
        UILabel TitleLable = TempTitle.GetComponent<UILabel>();
        TitleLable.text = m_Title;

        UIEventListener listener0 = UIEventListener.Get(pClose);
        listener0.onClick = OnBtn1Click;

        UIEventListener listener1 = UIEventListener.Get(btnObj1);
        listener1.onClick = OnBtn1Click;

        UIEventListener listener2 = UIEventListener.Get(btnObj2);
        listener2.onClick = OnBtn2Click;

        lable1.text = m_btn1_text;
        lable2.text = m_btn2_text;
        msgLable.text = m_msg;
        btnObj1.SetActive(!string.IsNullOrEmpty( m_btn1_text) );

        UITweenEnable(true);
    }
    
    void UITweenEnable(bool _isEnable)
    {
        if (m_instance == null) return;
        GameObject backGround = m_instance.FindWidget("bg");
        UITweener[] cpn = backGround.GetComponents<UITweener>();
        UITweener nIndex = _isEnable ? cpn[0] : cpn[1];

        nIndex.ResetToBeginning();
        nIndex.PlayForward();
    }
    //取消
    void OnBtn1Click(GameObject obj)
    {
        UITweenEnable(false);
        CallCloseEvt(1);
        Hide(Wnd.DefaultDuration);
    }

    //确定
    void OnBtn2Click(GameObject obj)
    {
        UITweenEnable(false);
        CallCloseEvt(2);
        Hide(Wnd.DefaultDuration);
    }

    void CallCloseEvt(int result)
    {
        if (m_OnClose != null) 
            m_OnClose(result); 
    }
    public void SetTitle(string _Str)
    {
        m_Title = _Str;
    }
    public void ShowMsgBox(string msg, string btn1_text, string btn2_text, OnMsgBoxClose onClose)
    {
        CoroutineManage.Single.StartCoroutine(_ShowMsgBox( msg,  btn1_text,  btn2_text, onClose));
    }

    IEnumerator _ShowMsgBox(string msg, string btn1_text, string btn2_text, OnMsgBoxClose onClose)
    {
        //等待上一个msgbox结束
        while (m_isVisible) yield return null;
        
        m_OnClose = onClose;
        m_msg = msg;
        m_btn1_text = btn1_text;
        m_btn2_text = btn2_text;

        //显示窗体
        Show(Wnd.DefaultDuration);
        
        
    }

    public static wnd_MsgBox Single = null;

    UILabel lable1 = null;
    UILabel lable2 = null;

    OnMsgBoxClose m_OnClose = null;
    string m_msg;
    string m_btn1_text;
    string m_btn2_text;
    string m_Title;
} 