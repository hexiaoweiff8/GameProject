using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class PVPloopGrid : MonoBehaviour
{

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
    /// 第一item的起始位置
    /// </summary>
    public Vector3 itemStartPos = Vector3.zero;
    /// <summary>
    /// 菜单项间隙
    /// </summary>
    public float gapDis = 0f;



    ////容器里面最多放多少个Item
    //private int maxItemNun = 10;
    //预制体
    public GameObject itemPrefab;
    //Item存放的列表
    public List<PVPListItem> itemsList;
    //所有Item的数据放这里
    public List<PVPListData> datasList;


    /// <summary>
    /// itemsList的第一个元素
    /// </summary>
    public PVPListItem firstItem;
    /// <summary>
    /// itemsList的最后一个元素
    /// </summary>
    public PVPListItem lastItem;

    public delegate void DelegateHandler(PVPListItem item, PVPListData data);
    /// <summary>
    /// 响应
    /// </summary>
    public DelegateHandler OnItemInit;

    private UIScrollView m_SV;
    private UIGrid m_grid;
    //private float upBoundary = 208 ;//上边界
    //private float downBoundary = -208;//下边界
    public float scrollViewMoveY = 0;//滑动板移动的坐标
    public float lastSVpositonY = 0;//上一帧滑动块的坐标 算坐标差来判断 交换位置

    void Awake()
    {
        

        itemPrefab = transform.parent.parent.parent.FindChild("pvpRankItemPerfab").gameObject;

        m_SV = transform.parent.GetComponent<UIScrollView>();

        if (itemPrefab == null || m_SV == null) //itemParent == null)
        {
            Debug.LogError("Lzh_LoopScrollView.Awake() 有属性没有在inspector中赋值");
        }

        arrangeDirection = ArrangeDirection.Up_to_Down;
        gapDis = 0f;

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

        InitScrollView();
    }

    void Start()
    {

    }

    void Update()
    {
       Validate();

       
    }


    // 对象池
    // 再次优化，频繁的创建与销毁
    Queue<PVPListItem> itemLoop = new Queue<PVPListItem>();
    #region 对象池性能相关
    /// <summary>
    /// 从对象池中取行一个item
    /// </summary>
    /// <returns>The item from loop.</returns>
    PVPListItem GetItemFromLoop()
    {
        PVPListItem item;
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
    void PutItemToLoop(PVPListItem item)
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

    /// <summary>
    /// 构造一个 item 对象
    /// </summary>
    /// <returns>The item.</returns>
    PVPListItem CreateItem()
    {
        GameObject go = NGUITools.AddChild(this.gameObject, itemPrefab);
        UIWidget widget = go.GetComponent<UIWidget>();
        PVPListItem item = go.GetComponent<PVPListItem>();//new LoopItemObject();
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
    void InitItem(PVPListItem item, int dataIndex, PVPListData data)
    {
        item.dataIndex = dataIndex;

        // print(item.gameObject.name);
        if (OnItemInit != null)
        {
            OnItemInit(item, data);
        }
        //item.widget.transform.localPosition = itemStartPos;
    }

    /// <summary>
    /// 在itemsList前面补上一个item
    /// </summary>
    void AddToFront(PVPListItem priorItem, PVPListItem newItem, int newIndex, PVPListData newData)
    {
        InitItem(newItem, newIndex, newData);

        // 计算新item的位置
        if (m_SV.movement == UIScrollView.Movement.Vertical)
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
        newItem.transform.SetAsFirstSibling();
        //m_grid.repositionNow = true;
        //m_grid.Reposition();
    }

    /// <summary>
    /// 在itemsList后面补上一个item
    /// </summary>
    void AddToBack(PVPListItem backItem, PVPListItem newItem, int newIndex, PVPListData newData)
    {
        InitItem(newItem, newIndex, newData);
        // 计算新item的位置
        if (m_SV.movement == UIScrollView.Movement.Vertical)
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
        newItem.transform.SetAsLastSibling();
        //m_grid.repositionNow = true;
        //m_grid.Reposition();
    }

    void Validate()
    {
        if (datasList == null || datasList.Count == 0)
        {
            return;
        }

        // 如果itemsList还不存在
        if (itemsList == null || itemsList.Count == 0)
        {
            itemsList = new List<PVPListItem>();

            PVPListItem item = GetItemFromLoop();
            InitItem(item, 0, datasList[0]);
            firstItem = lastItem = item;
            itemsList.Add(item);
            m_SV.ResetPosition();
            //Validate();
        }

        // 
        bool all_invisible = true;
        foreach (PVPListItem item in itemsList)
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
                PVPListItem item = GetItemFromLoop();

                // 初化：数据索引、大小、位置、显示
                int index = firstItem.dataIndex - 1;
                //InitItem(item, index, datasList[index]);
                AddToFront(firstItem, item, index, datasList[index]);
                firstItem = item;
                itemsList.Insert(0, item);

                //Validate();
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
                PVPListItem item = GetItemFromLoop();

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



    }



    public void InitScrollView()
    {
        this.OnItemInit = OnInitItem;
        datasList = new List<PVPListData>();

        Validate();
    }

    private void OnInitItem(PVPListItem item, PVPListData data)
    {
        PVPListData myData = data as PVPListData;
        PVPListItem itemComp = item.widget.GetComponent<PVPListItem>();
    }

    public void insertdateInBack()
    {
        PVPListData data = new PVPListData();
        //this.datasList.Insert(0, data);
        this.datasList.Add(data);
    }

    public void insertdateInBack(LuaTable tb)
    {
        //print(tb.ToString()+"123123213213123213213213");

       //print(tb[1]);
        for (int i = 1; i <= tb.Length; i++)
        {
            LuaTable userdata = tb[i] as LuaTable;
            //print("名次：" + userdata["minci"]+"积分：" + userdata["jifen"] +"用户名"+ userdata["username"]);
            PVPListData data = new PVPListData();
            this.datasList.Add(data);
        }
    }
    public void insertdateInBack(int minci,int jifen ,string name)
    {
        PVPListData data = new PVPListData();
        //this.datasList.Insert(0, data);
        this.datasList.Add(data);
        //print("名次：" + minci + "积分：" + jifen + "用户名" + name);
    }

    //public void GoToIndex(int index)
    //{
    //    //SpringPanel sp = m_SV.GetComponent<SpringPanel>();
    //    //SpringPanel.Begin(m_SV.gameObject, itemsList[0].transform.localPosition, 8f);
    //}

}
