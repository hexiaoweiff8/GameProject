using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using System.Xml;
class wnd_update : wnd_base
{
    public const string ResName = "ui_update";
    public const string DependPacks = "rom_upd";
    public wnd_update()
        : base(ResName)
    {
        WndManage.Single.RegWnd(ResName, DependPacks,  1, WndFadeMode.Alpha, WndAnimationMode.situ);
        Single = this; 
    }

    protected override void OnLostInstance()
    {
        m_Slider = null;
    }

    protected override void OnNewInstance()
     {
         GameObject jdObj = m_instance.FindWidget("ui_update_jd");
         m_Slider = jdObj.GetComponent<UISlider>();
         SetJD(m_JD);
     }
     
    public IEnumerator Go()
    {
         HotUpdate hotUpdate = GameObject.FindObjectOfType<HotUpdate>();
         bool isComplate = false;
         int tryNum = 0;
         hotUpdate.Go(
             //进度变更
             (float progress) =>
             {
                 if (progress > 0.04f && progress < 0.5f && !this.IsVisible) Show(Wnd.DefaultDuration);
                 SetJD(progress); tryNum = 0;
             },

             //更新完成事件回调
             () => { isComplate = true; },

             //应用升级事件回调
             AppUpgrade,

             //网络错误
             (HotUpdate.ErrorNo errorNo, string errorMsg) =>
             {
                 if (tryNum++ < 3)
                 {
                     wnd_MsgBox.Single.ShowMsgBox("更新遇到网络异常，是否重试?", "重试", "退出",
                         (r) => { if (r == 1) hotUpdate.ReTry(); else Application.Quit(); }
                         );
                 }
                 else
                 {
                     wnd_MsgBox.Single.ShowMsgBox(
                         "网络异常!", null, "退出",
                         (r) => { Application.Quit(); }
                         );
                 }
             }
             );

         while (!isComplate) yield return null;
         Hide(Wnd.DefaultDuration);

    }
    
    void AppUpgrade()
    {
        CoroutineManage.Single.StartCoroutine(coAppUpgrade());
    }

    IEnumerator coAppUpgrade()
    {
        HotUpdate ht = GameObject.FindObjectOfType<HotUpdate>();
        string urlAddr = ht.url + "/app_upgrade.xml";//从web获取更新下载地址
        string appDownUrl = null;
        do
        {
            WWW www = new WWW(urlAddr);
            while (!www.isDone && www.error == null) yield return null;
            if (www.error != null)
            {
                int msgBoxResult = -1;
                wnd_MsgBox.Single.ShowMsgBox("获取应用下载地址遇到网络异常，是否重试?", "重试", "退出",
                             (r) => msgBoxResult = r
                             );

                while (msgBoxResult == -1) yield return null;//等待消息框被点击

                if (msgBoxResult == 2)//用户选择退出
                {
                    Application.Quit();
                    yield return null;
                }
            } else
            {
                try
                {
                    string xmlstr = FileSystem.byte2string(www.bytes);
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xmlstr);
                    XmlElement downurlEl = doc.SelectSingleNode("xml/downurl") as XmlElement;
                    appDownUrl = downurlEl.GetAttribute("v");
                }catch(Exception)
                {

                }

                if(appDownUrl==null)
                {
                    int msgBoxResult = -1;
                    wnd_MsgBox.Single.ShowMsgBox("获取应用下载地址遇到未知错误！", null, "退出",
                                 (r) => msgBoxResult = r
                                 );

                    while (msgBoxResult == -1) yield return null;//等待消息框被点击
                     
                    Application.Quit();
                    yield return null; 
                }
            }
        } while (appDownUrl == null);


        {
            int msgBoxResult = -1;
            wnd_MsgBox.Single.ShowMsgBox("应用有新版本！", "更新","退出" ,
                         (r) => msgBoxResult = r
                         );

            while (msgBoxResult == -1) yield return null;//等待消息框被点击

            if(msgBoxResult==1)//用户选择更新
            {
                //弹出下载页并退出游戏
                Application.OpenURL(appDownUrl);
            }

            Application.Quit();
            yield return null; 
        }

        
        
       
    }

    public void SetJD(float jd)
    {
        m_JD = jd;
        if (m_Slider == null) return;
         m_Slider.value = jd;
    }

    public static wnd_update Single = null;
    UISlider m_Slider = null;
    float m_JD = 0;
} 