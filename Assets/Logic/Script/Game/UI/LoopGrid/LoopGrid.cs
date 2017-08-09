using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LoopGrid : MonoBehaviour
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
    public List<ItemObj> itemsList;
    //所有Item的数据放这里
    public List<ItemData> datasList;


    /// <summary>
    /// itemsList的第一个元素
    /// </summary>
    public ItemObj firstItem;
    /// <summary>
    /// itemsList的最后一个元素
    /// </summary>
    public ItemObj lastItem;

    public delegate void DelegateHandler(ItemObj item, ItemData data);
    /// <summary>
    /// 响应重置Item显示回调
    /// </summary>
    public DelegateHandler OnItemInit;

    public UIScrollView m_SV;

    public GameObject m_parent;

    void Awake()
    {
        print("老的Awake");

        itemPrefab = transform.parent.parent.parent.FindChild("pvpRankItemPerfab").gameObject;

        m_SV = transform.parent.GetComponent<UIScrollView>();

        m_parent = transform.FindChild("parent").gameObject;

        if (itemPrefab == null || m_SV == null || m_parent == null) //itemParent == null)
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

        InitScrollView(OnInitItem);
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
    Queue<ItemObj> itemLoop = new Queue<ItemObj>();
    #region 对象池性能相关
    /// <summary>
    /// 从对象池中取行一个item
    /// </summary>
    /// <returns>The item from loop.</returns>
    protected ItemObj GetItemFromLoop()
    {
        ItemObj item;
        if (itemLoop.Count <= 0)
        {
            item = CreateItem();
        }
        else
        {
            item = itemLoop.Dequeue();
        }
        item.m_widget.gameObject.SetActive(true);
        return item;
    }
    /// <summary>
    /// 将要移除的item放入对象池中
    /// --这个里我保证这个对象池中存在的对象不超过3个
    /// </summary>
    /// <param name="item">Item.</param>
    protected void PutItemToLoop(ItemObj item)
    {
        if (itemLoop.Count >= 3)
        {
            Destroy(item.m_widget.gameObject);
            return;
        }
        item.dataIndex = -1;
        //item.m_widget.gameObject.SetActive(false);
        //item.m_widget.gameObject.transform.localPosition = new Vector3(0,1000,0);
        itemLoop.Enqueue(item);
    }

    protected void DelAllLoop()
    {
        int loopCount = itemLoop.Count;
        for (int i = 0; i < loopCount; i++)
        {
            ItemObj item = itemLoop.Dequeue();
            Destroy(item.m_widget.gameObject);
        }
    }
    #endregion

    /// <summary>
    /// 构造一个 item 对象
    /// </summary>
    /// <returns>The item.</returns>
    ItemObj CreateItem()
    {
        GameObject go = NGUITools.AddChild(m_parent, itemPrefab);
        UIWidget m_widget = go.GetComponent<UIWidget>();
        ItemObj item = go.GetComponent<ItemObj>();//new LoopItemObject();
        item.m_widget = m_widget;
        go.SetActive(true);
        return item;
    }

    /// <summary>
    /// 用数据列表来初始化scrollview
    /// </summary>
    /// <param name="item">Item.</param>
    /// <param name="indexData">Index data.</param>
    /// <param name="data">Data.</param>
    void InitItem(ItemObj item, int dataIndex, ItemData data)
    {
        item.dataIndex = dataIndex;

        // print(item.gameObject.name);
        if (OnItemInit != null)
        {
            OnItemInit(item, data);
        }
        item.m_widget.transform.localPosition = itemStartPos;
    }

    /// <summary>
    /// 在itemsList前面补上一个item
    /// </summary>
    void AddToFront(ItemObj priorItem, ItemObj newItem, int newIndex, ItemData newData)
    {
        InitItem(newItem, newIndex, newData);

        // 计算新item的位置
        if (m_SV.movement == UIScrollView.Movement.Vertical)
        {
            float offsetY = priorItem.m_widget.height * 0.5f + gapDis + newItem.m_widget.height * 0.5f;
            if (arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *= -1f;
            newItem.m_widget.transform.localPosition = priorItem.m_widget.cachedTransform.localPosition + new Vector3(0f, offsetY, 0f);
        }
        else
        {
            float offsetX = priorItem.m_widget.width * 0.5f + gapDis + newItem.m_widget.width * 0.5f;
            if (arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *= -1f;
            newItem.m_widget.transform.localPosition = priorItem.m_widget.cachedTransform.localPosition - new Vector3(offsetX, 0f, 0f);
        }
        newItem.transform.SetAsFirstSibling();
        //m_grid.repositionNow = true;
        //m_grid.Reposition();
    }

    /// <summary>
    /// 在itemsList后面补上一个item
    /// </summary>
    void AddToBack(ItemObj backItem, ItemObj newItem, int newIndex, ItemData newData)
    {
        InitItem(newItem, newIndex, newData);
        // 计算新item的位置
        if (m_SV.movement == UIScrollView.Movement.Vertical)
        {
            float offsetY = backItem.m_widget.height * 0.5f + gapDis + newItem.m_widget.height * 0.5f;
            if (arrangeDirection == ArrangeDirection.Down_to_Up) offsetY *= -1f;
            newItem.m_widget.transform.localPosition = backItem.m_widget.cachedTransform.localPosition - new Vector3(0f, offsetY, 0f);
        }
        else
        {
            float offsetX = backItem.m_widget.width * 0.5f + gapDis + newItem.m_widget.width * 0.5f;
            if (arrangeDirection == ArrangeDirection.Right_to_Left) offsetX *= -1f;
            newItem.m_widget.transform.localPosition = backItem.m_widget.cachedTransform.localPosition + new Vector3(offsetX, 0f, 0f);
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
            itemsList = new List<ItemObj>();

            ItemObj item = GetItemFromLoop();
            InitItem(item, 0, datasList[0]);
            firstItem = lastItem = item;
            itemsList.Add(item);
            m_SV.ResetPosition();
            //Validate();
        }

        // 
        bool all_invisible = true;
        foreach (ItemObj item in itemsList)
        {
            if (item.m_widget.isVisible == true)
            {
                all_invisible = false;
            }
        }
        if (all_invisible == true)
            return;

        // 先判断前端是否要增减
        if (firstItem.m_widget.isVisible)
        {
            // 判断要不要在它的前面补充一个item
            if (firstItem.dataIndex > 0)
            {
                ItemObj item = GetItemFromLoop();

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
               && itemsList[0].m_widget.isVisible == false
               && itemsList[1].m_widget.isVisible == false)
               //&& itemsList[2].m_widget.isVisible == false
               //&& itemsList[3].m_widget.isVisible == false)
            {
                itemsList.Remove(firstItem);
                PutItemToLoop(firstItem);
                firstItem = itemsList[0];

                //Validate();
            }
        }

        // 再判断后端是否要增减
        if (lastItem.m_widget.isVisible)
        {
            // 判断要不要在它的后面补充一个item
            if (lastItem.dataIndex < datasList.Count - 1)
            {
                ItemObj item = GetItemFromLoop();

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
                && itemsList[itemsList.Count - 1].m_widget.isVisible == false
                && itemsList[itemsList.Count - 2].m_widget.isVisible == false)
                //&& itemsList[itemsList.Count - 3].m_widget.isVisible == false
                //&& itemsList[itemsList.Count - 4].m_widget.isVisible == false)
            {
                itemsList.Remove(lastItem);
                PutItemToLoop(lastItem);
                lastItem = itemsList[itemsList.Count - 1];

            }
        }



    }



    public void InitScrollView( DelegateHandler initFC)
    {
        this.OnItemInit = initFC;
        datasList = new List<ItemData>();

        Validate();
    }

    public virtual void OnInitItem(ItemObj item, ItemData data)
    {
        ItemData myData = data as ItemData;
        ItemObj itemComp = item.m_widget.GetComponent<ItemObj>();
    }
    
}
