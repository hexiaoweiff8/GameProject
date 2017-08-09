using UnityEngine;
using System.Collections;
using LuaInterface;

public class MailData : ItemData
{

    public MailData(string _id, string title, string sender, int receiver
        , string content, LuaTable rewards, int time
        ,string way,int _new, int autoDel)
    {
        this._id = _id;
        this.title = title;
        this.sender = sender;
        this.receiver = receiver;
        this.content = content;
        this.rewards = rewards;
        //Debug.Log("奖励列表长度："+rewards.Length);
        if (rewards.Length > 0 )
        {
            isHaveFujian = true;
            fujianNum = rewards.Length;
        }
        this.time = time;
        this.way = way;
        this._new = _new;
        this.autoDel = autoDel;
    }

    //邮件ID
    public string _id;
    //邮件标题
    public string title;
    //发件人名称
    public string sender;
    //收件人角色ID
    public int receiver;
    //邮件内容
    public string content;
    //邮件奖励列表
    public LuaTable rewards;
    //发件时间
    public int time;
    //奖励途径
    public string way;
    //是否是新邮件
    public int _new;
    //是否自动删除
    public int autoDel;

    //是否有附件
    public bool isHaveFujian = false;
    //附件数
    public int fujianNum = 0;
}
