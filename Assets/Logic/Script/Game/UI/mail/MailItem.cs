using System;
using UnityEngine;
using System.Collections;
using System.Text;
using UnityEngine.Networking;

public class MailItem : ItemObj {

    //用送人名字Label
    public UILabel SendUserNameLabel;

    //题目Label
    public UILabel titleContentLabel;


    //到期时间Label
    public UILabel expirationTimeLabel;

    //附件数目Label
    public UILabel fujianLabel;

    //有无附件邮件的类型模板
    public GameObject yiduGo;
    public GameObject weiduGo;

    //Item  4 个邮件图标 YD已读 WD未读
    public GameObject YDyoujiansp;
    public GameObject YDfujiansp;
    public GameObject WDyoujiansp;
    public GameObject WDfujiansp;

    //选中图标
    public GameObject choseSP;
    public static GameObject beChoseSP;//被选中的Item
    public static string choseMailID = ""; 
    void Awake()
    {
        SendUserNameLabel = transform.FindChild("sendPeopleLabel/peopleName").GetComponent<UILabel>();
        titleContentLabel = transform.FindChild("title").GetComponent<UILabel>();
        expirationTimeLabel = transform.FindChild("expirationTime").GetComponent<UILabel>();
        fujianLabel = transform.FindChild("fujianLabel").GetComponent<UILabel>();

        yiduGo = transform.FindChild("yiduItem").gameObject;
        weiduGo = transform.FindChild("weiduItem").gameObject;

        YDyoujiansp = yiduGo.transform.FindChild("zuo/youjiansp").gameObject;
        YDfujiansp = yiduGo.transform.FindChild("zuo/fujiansp").gameObject;
        WDyoujiansp = weiduGo.transform.FindChild("zuo/youjiansp").gameObject;
        WDfujiansp = weiduGo.transform.FindChild("zuo/fujiansp").gameObject;

        choseSP = transform.FindChild("chosesp").gameObject;
    }

    /// <summary>
    /// 根据是否已读属性展示不同背景,和Item左边图标领取情况
    /// </summary>
    /// <param name="type">0未读 1已读未领取 2已领取</param>
    public void ShowItemTypeAndzuoSP(int type, bool isHavefujian)
    {
        yiduGo.SetActive(false);
        weiduGo.SetActive(false);
        YDyoujiansp.SetActive(false);
        YDfujiansp.SetActive(false);
        WDyoujiansp.SetActive(false);
        WDfujiansp.SetActive(false);

        if (isHavefujian)
        {
            if (type == 0)
            {
                weiduGo.SetActive(true);
                WDfujiansp.SetActive(true);
            }
            else if (type == 1)
            {
                weiduGo.SetActive(true);
                WDfujiansp.SetActive(true);
            }
            else if (type == 2)
            {
                yiduGo.SetActive(true);
                YDfujiansp.SetActive(true);
            }
        }
        else
        {
            if (type == 0)
            {
                weiduGo.SetActive(true);
                WDyoujiansp.SetActive(true);
            }
            else if (type == 1)
            {
                yiduGo.SetActive(true);
                YDyoujiansp.SetActive(true);
            }
            else
            {
                print("mail背景类型设置有问题");
            }
        }

        
    }

    

    /// <summary>
    /// 是否有附件
    /// </summary>
    /// <param name="fujianNum">附件数量</param>
    /// <param name="type">状态</param>
    public void ShowFujianNum(int fujianNum, int type)
    {
        if (fujianNum == 0)
        {
            fujianLabel.gameObject.SetActive(false);
        }
        else
        {
            fujianLabel.gameObject.SetActive(true);
            if (type == 2)
            {
                fujianLabel.text = "内含" + fujianNum + "个附件";
            }
            else
            {
                fujianLabel.text = "内含[00ff0c]" + fujianNum + "个[-]附件";
            }
        }
    }

    /// <summary>
    /// 到期时间文本显示
    /// </summary>
    /// <param name="time">邮件发送的时间</param>
    public string DaoqiTime(int time)
    {
        int daoqiTime = time + (3600*24*15);
        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);  
    //return 
        int nowTime = Convert.ToInt32(ts.TotalSeconds); 
        //print("发件时间戳:"+time+"当前时间戳："+nowTime);

        int timeC = daoqiTime - nowTime;
        if (timeC >= 86400)
        {
           
            int day = (timeC/86400);
            int h = ((timeC - (86400*day))/3600);
            return day + "天" + h + "小时到期";
        }
        else if (timeC >= 3600)
        {
            //int day = (timeC / 86400);
            int h = ((timeC ) / 3600);
            return  h + "小时到期";
        }
        else if (timeC > 0 )
        {
            return "1小时到期";
        }

        return "已到期";
    }
}
