using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Runtime.Remoting.Messaging;


/// <summary>
/// 这个类主要做了一件事,就是优化了,NGUI UIScrollView 在数据量很多都时候,
/// 创建过多都GameObject对象,造成资源浪费.
/// </summary>
public class LoopItemScrollView : MonoBehaviour {

    public enum ArrangeDirection
    {
        Left_to_Right,
        Right_to_Left,
        Up_to_Down,
        Down_to_Up,
    }

    /// <summary>
    /// items的排列方式
    /// </summary>
    public ArrangeDirection arrangeDirection = ArrangeDirection.Up_to_Down;

    /// <summary>
    /// 列表单项模板
    /// </summary>
    public GameObject itemPrefab;

    /// <summary>
    /// The items list.
    /// </summary>
    public List<LoopItemObject> itemsList;
    /// <summary>
    /// The datas list.
    /// </summary>
    public List<LoopItemData> datasList;

    /// <summary>
    /// 列表脚本
    /// </summary>
    public UIScrollView scrollView;

    public GameObject itemParent;

    /// <summary>
    /// itemsList的第一个元素
    /// </summary>
    public LoopItemObject firstItem;
    /// <summary>
    /// itemsList的最后一个元素
    /// </summary>
    public LoopItemObject lastItem;


    public delegate void DelegateHandler(LoopItemObject item, LoopItemData data);
    /// <summary>
    /// 响应
    /// </summary>
    public DelegateHandler OnItemInit;

    /// <summary>
    /// 第一item的起始位置
    /// </summary>
    public Vector3 itemStartPos = Vector3.zero;
    /// <summary>
    /// 菜单项间隙
    /// </summary>
    public float gapDis = 0f;

    // 对象池
    // 再次优化，频繁的创建与销毁
    Queue<LoopItemObject> itemLoop = new Queue<LoopItemObject>();


    public static float panelHeight;

    void Awake()
    {
        itemPrefab = transform.parent.parent.FindChild("ChatItem").gameObject;

        //itemPrefab.GetComponent<UIWidget>().pivot = UIWidget.Pivot.Bottom;

        scrollView = GetComponent<UIScrollView>();
        itemParent = transform.FindChild("Parent").gameObject;

        if (itemPrefab == null || scrollView == null || itemParent == null)
        {
            Debug.LogError("Lzh_LoopScrollView.Awake() 有属性没有在inspector中赋值");
        }

        arrangeDirection = ArrangeDirection.Down_to_Up;
        gapDis = 10f;
        panelHeight = scrollView.GetComponent<UIPanel>().height;
        itemStartPos = new Vector3(0, -panelHeight / 2+gapDis, 0);
        

        // 设置scrollview的movement
        if (arrangeDirection == ArrangeDirection.Up_to_Down ||
           arrangeDirection == ArrangeDirection.Down_to_Up)
        {
            scrollView.movement = UIScrollView.Movement.Vertical;
        }
        else
        {
            scrollView.movement = UIScrollView.Movement.Horizontal;
        }


        InitScrollView();
    }

    void Start()
    {
        
    }

    void Update()
    {
        //if(scrollView.isDragging)
        {
            Validate();
         
            //this.GetComponent<UIScrollView>().ResetPosition();
        }

        ////是否处于最后一条数据已经显示出来，显示出来则请求更久之前的数据
        //if (lastItem != null && lastItem.dataIndex == datasList.Count - 1)
        //{
        //    Tools.CallMethod("chatWindow_controller", "sendOldData", new object());

        //}
    }

    /// <summary>
    /// 检验items的两端是否要补上或删除
    /// </summary>
    void Validate()
    {
        if (datasList == null || datasList.Count == 0)
        {
            return;
        }

        // 如果itemsList还不存在
        if (itemsList == null || itemsList.Count == 0)
        {
            itemsList = new List<LoopItemObject>();

            LoopItemObject item = GetItemFromLoop();
            
            Vector3 v3 = new Vector3(0,itemStartPos.y,0);
            chatItemData d = datasList[0] as chatItemData;
            if (d.ItemType != 3)
            {
                itemStartPos = new Vector3(0,itemStartPos.y+50,0);
            }

            InitItem(item, 0, datasList[0]);
            itemStartPos = v3;//还原
            firstItem = lastItem = item;
            itemsList.Add(item);

            //Validate();
        }

        // 
        bool all_invisible = true;
        foreach (LoopItemObject item in itemsList)
        {
            if (item.widget.isVisible == true)
            {
                all_invisible = false;
            }
        }
        if (all_invisible == true)
            return;

        // 先判断前端是否要增减
        if (firstItem.widget.isVisible)
        {
            // 判断要不要在它的前面补充一个item
            if (firstItem.dataIndex > 0)
            {
                LoopItemObject item = GetItemFromLoop();

                // 初化：数据索引、大小、位置、显示
                int index = firstItem.dataIndex - 1;
                //InitItem(item, index, datasList[index]);
                AddToFront(firstItem, item, index, datasList[index]);
                firstItem = item;
                itemsList.Insert(0, item);

                //Validate();
                //SpringPanel.Begin
             
            }
        }
        else
        {
            // 判断要不要将它移除
            // 条件：自身是不可见的；且它后一个item也是不可见的（或被被裁剪过半的）.
            // 		这有个隐含条件是itemsList.Count>=2.
            if (itemsList.Count >= 2
               && itemsList[0].widget.isVisible == false
               && itemsList[1].widget.isVisible == false)
            {
                itemsList.Remove(firstItem);
                PutItemToLoop(firstItem);
                firstItem = itemsList[0];
               
                //Validate();
            }
        }

        // 再判断后端是否要增减
        if (lastItem.widget.isVisible)
        {
            // 判断要不要在它的后面补充一个item
            if (lastItem.dataIndex < datasList.Count - 1)
            {
                LoopItemObject item = GetItemFromLoop();

                // 初化：数据索引、大小、位置、显示
                int index = lastItem.dataIndex + 1;
                AddToBack(lastItem, item, index, datasList[index]);
                lastItem = item;
                itemsList.Add(item);

                //Validate();
              
            }
           
        }
        else
        {
            // 判断要不要将它移除
            // 条件：自身是不可见的；且它前一个item也是不可见的（或被被裁剪过半的）.
            // 		这有个隐含条件是itemsList.Count>=2.
            if (itemsList.Count >= 2
                && itemsList[itemsList.Count - 1].widget.isVisible == false
                && itemsList[itemsList.Count - 2].widget.isVisible == false)
            {
                itemsList.Remove(lastItem);
                PutItemToLoop(lastItem);
                lastItem = itemsList[itemsList.Count - 1];
                 //UIGrid ug =new UIGrid();
                //Validate();
              
            }
        }

        //防止还没到底的时候就回弹BUG（效果不好）
        if (firstItem.dataIndex!=0 && lastItem.dataIndex!=datasList.Count-1)
        {
            SpringPanel sp = gameObject.GetComponent<SpringPanel>();
            if (sp != null)
            {
                sp.enabled = false;
            }
        }
     

    }

    /// <summary>
    /// Init the specified datas.
    /// </summary>
    /// <param name="datas">Datas.</param>
    public void Init(List<LoopItemData> datas, DelegateHandler onItemInitCallback)
    {
        datasList = datas;
        this.OnItemInit = onItemInitCallback;

        Validate();
    }

    public void InitScrollView()
    {
        this.OnItemInit = OnInitItem;
        datasList = new List<LoopItemData>();

        Validate();
    }

    /// <summary>
    /// 构造一个 item 对象
    /// </summary>
    /// <returns>The item.</returns>
    LoopItemObject CreateItem()
    {
        GameObject go = NGUITools.AddChild(itemParent, itemPrefab);
        UIWidget widget = go.GetComponent<UIWidget>();
        LoopItemObject item = go.GetComponent<LoopItemObject>();//new LoopItemObject();
        item.widget = widget;
        go.SetActive(true);
        return item;
    }

    /// <summary>
    /// 用数据列表来初始化scrollview
    /// </summary>
    /// <param name="item">Item.</param>
    /// <param name="indexData">Index data.</param>
    /// <param name="data">Data.</param>
    void InitItem(LoopItemObject item, int dataIndex, LoopItemData data)
    {
        item.dataIndex = dataIndex;
        
       // print(item.gameObject.name);
        if (OnItemInit != null)
        {
            OnItemInit(item, data);
        }
        item.widget.transform.localPosition = itemStartPos;
    }

    /// <summary>
    /// 在itemsList前面补上一个item
    /// </summary>
    void AddToFront(LoopItemObject priorItem, LoopItemObject newItem, int newIndex, LoopItemData newData)
    {
        InitItem(newItem, newIndex, newData);
        newItem.transform.SetAsFirstSibling();
        // 计算新item的位置
        if (scrollView.movement == UIScrollView.Movement.Vertical)
        {
            float offsetY = priorItem.widget.height * 0.5f + gapDis + newItem.widget.height * 0.5f;
            if (arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *= -1f;
            newItem.widget.transform.localPosition = priorItem.widget.cachedTransform.localPosition + new Vector3(0f, offsetY, 0f);
        }
        else
        {
            float offsetX = priorItem.widget.width * 0.5f + gapDis + newItem.widget.width * 0.5f;
            if (arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *= -1f;
            newItem.widget.transform.localPosition = priorItem.widget.cachedTransform.localPosition - new Vector3(offsetX, 0f, 0f);
        }
    }

    /// <summary>
    /// 在itemsList后面补上一个item
    /// </summary>
    void AddToBack(LoopItemObject backItem, LoopItemObject newItem, int newIndex, LoopItemData newData)
    {
        InitItem(newItem, newIndex, newData);
        newItem.transform.SetAsLastSibling();
        // 计算新item的位置
        if (scrollView.movement == UIScrollView.Movement.Vertical)
        {
            float offsetY = backItem.widget.height * 0.5f + gapDis + newItem.widget.height * 0.5f;
            if (arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *= -1f;
            newItem.widget.transform.localPosition = backItem.widget.cachedTransform.localPosition - new Vector3(0f, offsetY, 0f);
        }
        else
        {
            float offsetX = backItem.widget.width * 0.5f + gapDis + newItem.widget.width * 0.5f;
            if (arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *= -1f;
            newItem.widget.transform.localPosition = backItem.widget.cachedTransform.localPosition + new Vector3(offsetX, 0f, 0f);
        }
    }


    #region 对象池性能相关
    /// <summary>
    /// 从对象池中取行一个item
    /// </summary>
    /// <returns>The item from loop.</returns>
    LoopItemObject GetItemFromLoop()
    {
        LoopItemObject item;
        if (itemLoop.Count <= 0)
        {
            item = CreateItem();
        }
        else
        {
            item = itemLoop.Dequeue();
        }
        item.widget.gameObject.SetActive(true);
        return item;
    }
    /// <summary>
    /// 将要移除的item放入对象池中
    /// --这个里我保证这个对象池中存在的对象不超过3个
    /// </summary>
    /// <param name="item">Item.</param>
    void PutItemToLoop(LoopItemObject item)
    {
        if (itemLoop.Count >= 3)
        {
            Destroy(item.widget.gameObject);
            return;
        }
        item.dataIndex = -1;
        item.widget.gameObject.SetActive(false);
        itemLoop.Enqueue(item);
    }
    #endregion


    void OnInitItem(LoopItemObject item, LoopItemData data)
    {
        chatItemData myData = data as chatItemData;
        chatItem itemComp = item.widget.GetComponent<chatItem>();

        itemComp.showItemByType(myData.ItemType);

        switch (myData.ItemType)
        {
            case 1:
                itemComp.selfContent.text = myData.content;
                itemComp.selfUserNameLabel.text = myData.username;
                break;
            case 2:
                itemComp.otherContent.text = myData.content;
                itemComp.ohterUserNameLabel.text = myData.username;
                GameObject go = itemComp.transform.FindChild("otherChatItem/headImgBg/headImg").gameObject;
                //go.name = "headImg" + myData.uid;
                UIEventListener.Get(go).onClick
                    = (g) => { print(myData.uid); };
                break;
            case 3:
                itemComp.timeLable.text = myData.content;
                
                break;

        }

    }

    

    public void UpdateInBack(int uid, string username, string content, string time, int type)
    {

        //myLoopSV.datasList

        
        LoopItemData data = new chatItemData(uid,username,content,time,type);
        this.datasList.Insert(0,data);
        //this.datasList.Add(data);
        if (this.itemsList != null)
        {
            foreach (LoopItemObject lio in itemsList)
            {
                lio.dataIndex++;
            }

            if (firstItem != null && firstItem.dataIndex == 1)
            {
                //float distance = -panelHeight / 2 - (firstItem.transform.localPosition.y + scrollView.transform.localPosition.y)+gapDis;
                //float distance = -scrollView.transform.localPosition.y; //-panelHeight/2 + gapDis - firstItem.transform.localPosition.y;//+scrollView.transform.localPosition.y; //第一个距离底部的高
                //print("distance:" + distance);
                //往上面顶
                foreach (LoopItemObject lio in itemsList)
                {
                    if (type == 3)
                    {
                        lio.transform.localPosition = new Vector3(0, lio.transform.localPosition.y  + 30 + 10, 0);
                    }
                    else
                    {
                        lio.transform.localPosition = new Vector3(0, lio.transform.localPosition.y  + 100 + 10, 0);
                    }
                    //scrollView.ResetPosition();

                }
            }

        }
       //UITable
    }

    public void UpdateInFront(int uid, string username, string content, string time, int type)
    {


        LoopItemData data = new chatItemData(uid,username,content,time,type);
        this.datasList.Add(data);

    }

    /// <summary>
    /// 重置聊天记录
    /// </summary>
    public void InitScollerView()
    {
        datasList = new List<LoopItemData>();
        if (itemsList!=null)
        {
            foreach (LoopItemObject v in itemsList)
            {
                PutItemToLoop(v);//全部放入释放池中 但最多储存3个
            }
            itemsList = new List<LoopItemObject>();
        }
        firstItem = null;
        lastItem = null;
        print("重置数据完成");
    }
    

    /// <summary>
    /// lua端调用判断是不是要请求更老的数据
    /// </summary>
    /// <returns></returns>
    public bool isSendOldData()
    {
        if (lastItem != null && datasList != null)
        {
            if (lastItem.dataIndex == datasList.Count - 1)//最后条数据是最后一行，且总数据不少于5行
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        } 
    }
}
