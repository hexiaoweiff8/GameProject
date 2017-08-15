using System;
using UnityEngine;
using System.Collections;
using LuaInterface;
using System.Collections.Generic;

public class MailLoopGrid : LoopGrid {


    void Awake()
    {

        itemPrefab = transform.parent.parent.parent.FindChild("mailItem").gameObject;

        m_SV = transform.GetComponent<UIScrollView>();

        m_parent = transform.FindChild("parent").gameObject;

        if (itemPrefab == null || m_SV == null || m_parent == null) //itemParent == null)
        {
            Debug.LogError("Lzh_LoopScrollView.Awake() 有属性没有在inspector中赋值");
        }
        m_SV.onDragStarted += dragStart;
        m_SV.onDragFinished += dragFinished;

        arrangeDirection = ArrangeDirection.Up_to_Down;
        //itemStartPos = Vector3.up*300;
        gapDis = 5f;

        // 设置scrollview的movement
        if (arrangeDirection == ArrangeDirection.Up_to_Down ||
           arrangeDirection == ArrangeDirection.Down_to_Up)
        {
            m_SV.movement = UIScrollView.Movement.Vertical;
        }
        else
        {
            m_SV.movement = UIScrollView.Movement.Horizontal;
        }

        InitScrollView(OnInitItemFC);
    }

    //Item根据数据更新的委托
      void OnInitItemFC(ItemObj item, ItemData data)
    {
        MailData myData = data as MailData;
        MailItem itemComp = item.m_widget.GetComponent<MailItem>();

        itemComp.SendUserNameLabel.text = myData.sender;
        itemComp.titleContentLabel.text = myData.title;
        itemComp.expirationTimeLabel.text = itemComp.DaoqiTime(myData.time);

        itemComp.DaoqiTime(myData.time);
        itemComp.ShowItemTypeAndzuoSP(myData._new, myData.isHaveFujian);
        itemComp.ShowFujianNum(myData.fujianNum, myData._new);
        //是否开启选中图标
          if (MailItem.choseMailID == myData._id)
          {
              itemComp.choseSP.SetActive(true);
          }
          else
          {
              itemComp.choseSP.SetActive(false);
          }


        UIEventListener.Get(itemComp.gameObject).onClick
            = (go) =>
            {
                //选中item更换
                if (MailItem.beChoseSP)
                {
                    MailItem.beChoseSP.SetActive(false);
                }
                itemComp.choseSP.SetActive(true);
                MailItem.choseMailID = myData._id;
                MailItem.beChoseSP = itemComp.choseSP.gameObject;

                //初始化左边的栏目信息//print(myData._id);
                Tools.CallMethod("mailCall", "InitRightWindow", myData._id, myData.isHaveFujian);
                //播放动画
                Tools.CallMethod("mailCall", "ShowRightWindow");
                //发送读取信息  无附件的状态1了就不用发阅读请求  有附件的状态为2了不用发阅读请求
                if (myData.isHaveFujian)
                {
                    if (myData._new != 2)
                    {
                        if (myData._new != 2) myData._new = 1;
                        Tools.CallMethod("mailCall", "SendReadMail", myData._id, myData._new);
                    }
                }
                else
                {
                    if (myData._new != 1)
                    {
                        if (myData._new != 1) myData._new = 1;
                        Tools.CallMethod("mailCall", "SendReadMail", myData._id, myData._new);
                        //删除自动删除的无附件邮件
                        if (myData.autoDel == 1)
                        {       
                        Tools.CallMethod("mailCall", "SendDelMail", myData._id);
                        }
                    }
                }  
                //更新信息界面按钮的功能
                Tools.CallMethod("mailCall", "UpdateRight_Btn_lingqufujian", myData._id,myData.isHaveFujian,myData._new,myData.autoDel);
                //无附件的是否需要重置背景
                if (!myData.isHaveFujian)
                {
                    itemComp.ShowItemTypeAndzuoSP(myData._new , myData.isHaveFujian);
                }

            };
    }

    /// <summary>
    /// 数据插入数据表后面
    /// </summary>
    public void InsertDataBack(LuaTable dataTable)
    {
        List<ItemData> newdatalist = new List<ItemData>();
        for (int i = 1; i <=dataTable.Length; i++)//LUA表的排序是从1开始
        {
            LuaTable mdataTable = dataTable[i] as LuaTable;
            //print("寄件人：" + mdata["SendUserName"] + "----标题：" + mdata["titleContent"]);
            string _id = Convert.ToString(mdataTable["id"]);
            string title = Convert.ToString(mdataTable["title"]);
            string sender = Convert.ToString(mdataTable["sender"]);
            int receiver = Convert.ToInt32(mdataTable["receiver"]);
            string content = Convert.ToString(mdataTable["content"]);
            LuaTable rewards = mdataTable["rewards"] as LuaTable;
            int time = Convert.ToInt32(mdataTable["time"]);
            string way = Convert.ToString(mdataTable["way"]);
            int _new = Convert.ToInt32(mdataTable["new"]);
            int autoDel = Convert.ToInt32(mdataTable["autoDel"]);


            ItemData mdata = new MailData(_id,title,sender,receiver,content,rewards,time,way,_new,autoDel);
            MailData d = mdata as MailData;
            newdatalist.Add(mdata);
            //print("邮件ID:"+ d._id+"状态："+d._new + "是否含有附件："+d.isHaveFujian + "是否自动删除："+d.autoDel);
        }
 
        datasList = DataSorting(newdatalist);
        print("排序后的邮件信息");
        foreach (ItemData data in datasList)
        {
            MailData d = data as MailData;
            print("邮件ID:" + d._id + "状态：" + d._new + "是否含有附件：" + d.isHaveFujian + "是否自动删除：" + d.autoDel);
        }
       
    }
    private void InsertDataList(List<ItemData> datalist)
    {
        datasList = DataSorting(datalist);
    }
    
    /// <summary>
    /// 邮箱的数据排序。根据先展示未读，已读。分别两部分按时间先后排序
    /// </summary>
    private List<ItemData> DataSorting(List<ItemData> list)
    {
        List<ItemData> yiduList = new List<ItemData>();
        List<ItemData> weiduList = new List<ItemData>();

        foreach (ItemData d in list)
        {
            MailData md = d as MailData;
            if (md.isHaveFujian)
            {
                if (md._new == 2)
                {
                    yiduList.Add(md);
                }
                else
                {
                    weiduList.Add(md);
                }
            }
            else
            {
                if (md._new == 0)
                {
                   weiduList.Add(md); 
                }
                else
                {
                    yiduList.Add(md);
                }
            }
        }

        //排序

        weiduList.Sort(delegate(ItemData d1, ItemData d2)
        {

            return (d2 as MailData).time.CompareTo((d1 as MailData).time);
        });
        yiduList.Sort(delegate(ItemData d1, ItemData d2)
        {

            return (d2 as MailData).time.CompareTo((d1 as MailData).time);
        });

        List<ItemData> sortDataList = new List<ItemData>();
        foreach (ItemData v in weiduList)
        {
            sortDataList.Add(v);
        }
        foreach (ItemData v in yiduList)
        {
            sortDataList.Add(v);
        }

        return sortDataList;
    }


    /// <summary>
    /// 领取奖励过后需要更新这一个数据且改变左Item显示
    /// </summary>
    /// <param name="mailID">邮件ID</param>
    /// <param name="dataTable">更新后的数据</param>
    public void UpOneData(string mailID,LuaTable dataTable)
    {
        print("邮件ID：" + mailID + "被领取");

        //遍历数据表找到对应数据,变更状态
        for (int index = 0; index < datasList.Count; index++)
        {
            MailData d = datasList[index] as MailData;
            if (d._id == mailID)
            {
                d._new = Convert.ToInt32(dataTable["new"]);
                foreach (MailItem it in itemsList)
                {
                    if (it.dataIndex == index)
                    {
                        //OnInitItemFC(it,d);
                        it.ShowItemTypeAndzuoSP(d._new,d.isHaveFujian);
                        it.ShowFujianNum(d.fujianNum, d._new);
                    }
                }
                break;
            }
        }
       
        

    }

    /// <summary>
    /// 删除已读和已领取的邮件
    /// </summary>
    public void DelYDorYLQ_Mail()
    {
        List<ItemData> WDDataList = new List<ItemData>();//没有读过也没有领取的邮件

        foreach (MailData d in datasList)
        {
            if (d._new == 0)
            {
                WDDataList.Add(d);
            }
            else //状态只能为1 或者 2
            {
                if (d.isHaveFujian)
                {
                    if (d._new == 2)
                    {
                        if (d.autoDel != 1)//不是自动删除的邮件需要通知服务器删除
                        {
                            Tools.CallMethod("mailCall", "SendDelMail", d._id);
                        }
                    }
                    else
                    {
                        WDDataList.Add(d);
                    }
                }
                else
                {
                    if (d.autoDel != 1)//不是自动删除的邮件需要通知服务器删除
                    {
                        Tools.CallMethod("mailCall", "SendDelMail", d._id);
                    }
                }
            }
        }

        //重置界面1.关闭右侧界面播放移回动画2.清除全部Item用新的数据更新Item
        Tools.CallMethod("mailCall", "HideRightWindow");

        InitWindow();

        //压入新的数据
        InsertDataList(WDDataList);
        //新数据传入LUA端保存 先处理成LUA表在传

        Tools.CallMethod("mailCall", "ClearDataList");
        foreach (MailData d in WDDataList)
        {
            Tools.CallMethod("mailCall", "UpdaNewDataList", d._id, d.title,d.sender,d.receiver,d.content
                , d.rewards, d.time, d.way, d._new, d.autoDel);
        }
        


    }

    /// <summary>
    /// 重置左边窗口
    /// </summary>
    public void InitWindow()
    {
        datasList = new List<ItemData>();
        firstItem = null;
        lastItem = null;
        MailItem.beChoseSP = null;
        MailItem.choseMailID = "";

        if (itemsList!=null)
        {
            foreach (ItemObj obj in itemsList)
            {
                PutItemToLoop(obj);
            }
        }
        
        itemsList = new List<ItemObj>();
        DelAllLoop();

        SpringPanel.Begin(m_SV.gameObject, Vector3.zero, 8);

    }

    /// <summary>
    /// 一键领取
    /// </summary>
    public void OneBtnGet()
    {
        //播放收回动画
        Tools.CallMethod("mailCall", "HideRightWindow");
        //遍历数据表吧有附件没领取的全部领取
        foreach (MailData d in datasList)
        {
            if (d.isHaveFujian)
            {
                if (d._new != 2)
                {
                    //d._new = 2;
                    Tools.CallMethod("mailCall", "LingquFujian",d._id,d.autoDel);
                }
            }
        }
        //领取完了过后需要把显示的Item的显示更改
        foreach (MailItem mi in itemsList)
        {
            OnInitItemFC(mi,datasList[mi.dataIndex]);
        }
    }



#region 当Item没满时拖拽回弹置顶端
    private Vector3 startPos = new Vector3(0,168,0);
    private void dragFinished()
    {
        if (m_SV != null)
        {
            if (!m_SV.shouldMoveVertically)
            {

                if (m_SV.dragEffect == UIScrollView.DragEffect.MomentumAndSpring)
                {
                    // Spring back into place
                    SpringPanel.Begin(m_SV.GetComponent<UIPanel>().gameObject, startPos, 13f).strength = 8f;
                }

            }
        }
        else
        {
            Debug.Log("grid or scroll view is null FUNC:dragFinished POS:PackageTypeClick.cs");
        }
    }

   

    private void dragStart()
    {
        //startPos = m_SV.gameObject.transform.localPosition;
    }
#endregion
    
}
