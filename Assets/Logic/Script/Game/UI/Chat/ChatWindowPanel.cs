using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChatWindowPanel : MonoBehaviour {


    public LoopItemScrollView myLoopSV;

    public List<int> typeList = new List<int>();
    public List<string> contentList = new List<string>();
    //public List<int> timeList = new List<int>();

    //public static int[] typeArr =
    //{
    //    1,1,1,2,2,2,3,1,1,1
    //};
    //public static string[] contentArr =
    //{
    //    "测试1","测试2","测试3","测试4",
    //    "测试5","测试6","20:55:10","测试8",
    //    "测试9","测试10",
    //};

    //public static int[] typeArr1 =
    //{
    //    1,1,1,2,2,2,3,1,1,1
    //};
    //public static string[] contentArr1 =
    //{
    //    "测试11","测试12","测试13","测试14",
    //    "测试15","测试16","20:55:05","测试18",
    //    "测试19","测试20",
    //};
    //public static int[] typeArr2 =
    //{
    //    1,1,3,2,2,2,3,1,1,1
    //};
    //public static string[] contentArr2 =
    //{
    //    "测试21","测试22","15:44:11","测试24",
    //    "测试25","测试26","20:55:05","测试28",
    //    "测试29","测试30",
    //};


    void Start()
    {
        //foreach (int type in typeArr)
        //{
        //    typeList.Add(type);
        //}
        //foreach (string content in contentArr)
        //{
        //    contentList.Add(content);
        //}


        InitScrollview();

    }


    void InitScrollview()
    {
        List<LoopItemData> datas = new List<LoopItemData>();
        //for (int i = 0; i < contentArr.Length; i++)
        //{
        //    LoopItemData data = new chatItemData(contentArr[i], typeArr[i]);
        //    datas.Add(data);
        //}
        myLoopSV.Init(datas, OnItemInit);
        //UpdateInFront(typeArr,contentArr,typeArr.Length);

        
    }

    void OnItemInit(LoopItemObject item, LoopItemData data)
    {
        chatItemData myData = data as chatItemData;
        chatItem itemComp = item.widget.GetComponent<chatItem>();

        itemComp.showItemByType(myData.ItemType);
        itemComp.otherContent.text = myData.content;
        itemComp.selfContent.text = myData.content;
        itemComp.timeLable.text = myData.content;
        item.gameObject.name = "Item" + item.dataIndex;
        //item.widget.gameObject.SetActive(false);
        //print(myData.content +"  " +item.widget.isVisible);
    }

    /// <summary>
    /// 这些数据是插在之前的(插入之前的数据 用户啦新信息)
    /// </summary>
    void UpdateInFront(int[] typeArr, string[] contentArr, int num)
    {
        if (num > 0)
        {
            foreach (LoopItemObject t in myLoopSV.itemsList)
            {
                t.dataIndex += num;
            }
            for (int i = 0; i < num; i++)
            {
                //LoopItemData data = new chatItemData(contentArr[i], typeArr[i]);
                //myLoopSV.datasList.Insert(0, data);
            }
            if (myLoopSV.firstItem!=null)
            {
                print(myLoopSV.firstItem.dataIndex);
            }
            //
        }

    }
    /// <summary>
    /// 这些数据是插在之后的
    /// </summary>
    void UpdateInBack(int type,string content)
    {

        //myLoopSV.datasList
        //LoopItemData data = new chatItemData(content,type);
        //myLoopSV.datasList.Add(data);
    }


    //private float timer = 0f;
    //private bool haveUpdate = true;
    //private int datanum = 1;
    void Update()
    {
        //if (haveUpdate)
        //{
        //    timer += Time.deltaTime;
        //    if (timer > 5f)
        //    {
        //        if (datanum == 1)
        //        {
        //            UpdateInFront(typeArr1, contentArr1, typeArr1.Length);
        //            timer = 0;
        //            datanum++;
        //        }
        //        else
        //        {
        //            UpdateInFront(typeArr2, contentArr2, typeArr2.Length);
        //            haveUpdate = false;
        //        }
                
        //        //haveUpdate = false;
        //    }
        //}
    }
}
