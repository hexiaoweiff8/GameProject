using UnityEngine;
using System.Collections;

public class chatItem : LoopItemObject  
{
    public chatItem():base()
    {
        
    }

    //private UIWidget widget;
    public GameObject OtherItem;
    public GameObject SelfItem;
    public GameObject TimeItem;


    //聊天信息文本
    public UILabel selfContent;
    public UILabel otherContent;
    public UILabel timeLable;

    //username
    public UILabel selfUserNameLabel;
    public UILabel ohterUserNameLabel;
    //public UILabel UserNameLabel;

    void Awake()
    {
        this.widget = GetComponent<UIWidget>();
        OtherItem = transform.FindChild("otherChatItem").gameObject;
        SelfItem = transform.FindChild("selfChatItem").gameObject;
        TimeItem = transform.FindChild("timeItem").gameObject;

        otherContent = OtherItem.transform.FindChild("messageBg/messageLabel").GetComponent<UILabel>();
        selfContent = SelfItem.transform.FindChild("messageBg/messageLabel").GetComponent<UILabel>();
        timeLable = TimeItem.transform.FindChild("Label").GetComponent<UILabel>();

        selfUserNameLabel = SelfItem.transform.FindChild("userName").GetComponent<UILabel>();
        ohterUserNameLabel = OtherItem.transform.FindChild("guildName/userName").GetComponent<UILabel>();
    }

    public void showItemByType(int type)
    {

        OtherItem.SetActive(false);
        SelfItem.SetActive(false);
        TimeItem.SetActive(false);
        switch (type)
        {
            case 1:
                SelfItem.SetActive(true);
                this.widget.height = 100;
                break;
            case 2:
                OtherItem.SetActive(true);
                this.widget.height = 100;
                break;
            case 3:
                TimeItem.SetActive(true);
                this.widget.height = 30;
                break;
        }
    }

}

public class chatItemData : LoopItemData
{
    public int ItemType = 1;//聊天界面的Item类型1为自己说的话2为别人说的话3为时间标签
    public int uid;
    public string content = "test";
    public string username = "";
    public string time = "";

    public chatItemData(int uid, string username , string content,string time , int type)
        
    {
        this.content = content;
        this.ItemType = type;
        this.uid = uid;
        this.username = username;
        this.time = time;
    }

}
