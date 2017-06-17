using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(UIScrollView))]
public class UIScrollViewAdapter : MonoBehaviour , ObjectPool<GameObject>
{

    #region HANDLER ItemLoaded(回调，加载列表项时被执行)

    public delegate void OnItemLoadedHandler(UIScrollViewItemBase item);

    public OnItemLoadedHandler onItemLoaded;

    public void ItemLoaded(UIScrollViewItemBase item, bool clear = false)
    {
        if (onItemLoaded != null)
        {
            onItemLoaded(item);

            if (clear)
            {
                onItemLoaded = null;
            }
        }
    }

    #endregion
    #region HANDLER ItemSelected(回调，与UGUI事件配合使用，在此项目中用于切换页卡时选中第一项)

    public delegate void OnItemSelectedHandler(UIScrollViewItemBase item);

    public OnItemSelectedHandler onItemSelected;

    public void ItemSelected(UIScrollViewItemBase item, bool clear = false)
    {
        if (onItemSelected != null)
        {
            onItemSelected(item);

            if (clear)
            {
                onItemSelected = null;
            }
        }
    }

    #endregion
    #region HANDLER ListMoved(回调，)
    public delegate void OnListMovedHandler();
    public OnListMovedHandler onListMoved;
    public void ListMoved()
    {
        if(onListMoved != null)
            onListMoved();
    }
    #endregion

    private UIScrollView _scrollView;//NGUI控件
    private UIPanel _panel; //NGUI控件UIScrollView中的Panel实例

    public ScrollOrientation _scrollOrientation;

    [SerializeField][Header("Multi Line")]
    private bool EnableMultiLine;//多行多列
    [SerializeField]
    public int _spacing_row, _spacing_line;//行间距/列间距
    private int _itemsVisible_row, _itemsVisible_line;//每行每列可显示的总数

    private UIPanel _viewport;//视口范围控件

    private Transform _content;//列表项容器控件

    private float _spacing;//列表项间距，单行或单列

    private List<UIScrollViewItemBase> _itemsList;//列表项数组

    private float _itemSize;//列表项占大小
    private Vector2 _itemSize_ml;//列表项占大小,EnableMultiLine == true

    private float _lastPosition;//记录滚动前的位置

    private int _itemsTotal;//当Create(...)被调用时确定列表项总数
    private int _itemsVisible;//列表显示项的个数

    private int _itemsToRecycleBefore;
    private int _itemsToRecycleAfter;

    private int _firstItemIndex;
    private int _lastItemIndex;//列表末尾项的index

    #region MonoBehaviour
    void Awake () {
        _scrollView = GetComponent<UIScrollView>();
        _viewport = _panel = GetComponent<UIPanel>();
        _content = transform.GetChild(0);
    }
    bool isActived = false;//状态开关
    int displacedRows;//记录单次拖动的行/列数
    void Update()
    {
        if (!isActived || GetContentPosition() == _lastPosition)
            return;

        displacedRows = Mathf.FloorToInt(Mathf.Abs(GetContentPosition() - _lastPosition) / (EnableMultiLine ? _itemSize_ml.x : _itemSize));

        if (displacedRows != 0)
        {
            ListMoved();//触发列表项移动事件
        }
    }
    #endregion
    /// <summary>
    /// 初始化方法
    /// 步骤：
    /// 1.AddComponent<此组件>()
    /// 2.设置EnableMultiLine属性值
    ///   例如：多行多列
    ///     EnableMultiLine = true
    ///     _spacing_row = 行间距
    ///     _spacing_line = 列间距
    /// 3.预制继承自UIScrollViewItemBase的子类
    /// 4.调用Create(列表项总数，预制体)方法
    /// </summary>
    /// <param name="items">实例化项目个数</param>
    /// <param name="listItemPrefab">实例化的模板</param>
    public void Create(int items, UIScrollViewItemBase listItemPrefab)
    {
        _itemsTotal = items;
        p_prefab = listItemPrefab.gameObject;

        switch (_scrollOrientation)
        {
            case ScrollOrientation.HORIZONTAL:
                if (!EnableMultiLine)
                {
                    _itemSize = listItemPrefab.Size.x;
                    _itemsVisible = Mathf.CeilToInt(GetViewportSize() / (_itemSize + _spacing));
                }
                else
                {
                    _itemSize_ml = new Vector2(listItemPrefab.Size.x, listItemPrefab.Size.y);

                    _itemsVisible_row = Mathf.CeilToInt(_viewport.width / (_itemSize_ml.x + _spacing_line));
                    _itemsVisible_line = Mathf.FloorToInt(_viewport.height / (_itemSize_ml.y + _spacing_row));
                }
                break;

            case ScrollOrientation.VERTICAL:
                if (!EnableMultiLine)
                {
                    _itemSize = listItemPrefab.Size.y;
                    _itemsVisible = Mathf.CeilToInt(GetViewportSize() / (_itemSize + _spacing));
                } 
                else
                {
                    _itemSize_ml = new Vector2(listItemPrefab.Size.x, listItemPrefab.Size.y);
                    //垂直方向时，row可显示item数量使用向下舍位取整
                    _itemsVisible_row = Mathf.FloorToInt(_viewport.width / (_itemSize_ml.x + _spacing_line));
                    _itemsVisible_line = Mathf.CeilToInt(_viewport.height / (_itemSize_ml.y + _spacing_row));

                    //print("_itemsVisible_row = " + _itemsVisible_row);
                    //print("_itemsVisible_line = " + _itemsVisible_line);
                }
                break;
        }//end Switch

        //Debug.LogWarning("GetViewportSize() "+ GetViewportSize()+"  "+ _itemSize
        //    +"  Mathf.CeilToInt()"+ Mathf.CeilToInt(GetViewportSize() / _itemSize)
        //    );

        int itemsToInstantiate = EnableMultiLine ? _itemsVisible_row * _itemsVisible_line : _itemsVisible;

        if (itemsToInstantiate < items)
            itemsToInstantiate *= 2;
        else 
            itemsToInstantiate = items;

        _itemsList = new List<UIScrollViewItemBase>();

        for(int i = 0;i < itemsToInstantiate; i++)
        {
            UIScrollViewItemBase item = EnableMultiLine ?
                CreateNewItem(i, _itemSize_ml) : CreateNewItem(i, _itemSize);
            item.onSelected = HandleOnSelectedHandler;
            item.Index = i;

            _itemsList.Add(item);
            ItemLoaded(item);//列表项加载完成Callback
        }

        _firstItemIndex = 0;
        _lastItemIndex = _itemsList.Count - 1;

        _itemsToRecycleAfter = EnableMultiLine ?
            _itemsList.Count / _itemsVisible_row - _itemsVisible_line :
            _itemsList.Count - _itemsVisible;
  
        //Debug.LogWarning("_itemSize = " + _itemSize);
        //Debug.LogWarning("_itemsVisible = " + _itemsVisible);
        //Debug.LogWarning("_itemsVisibles = " + _itemsVisible_row + " " + _itemsVisible_line);
        //Debug.LogWarning("itemsToInstantiate = " + itemsToInstantiate);
        //Debug.LogWarning("_itemsTotal = " + _itemsTotal);
        //Debug.LogWarning("_lastItemIndex = " + _lastItemIndex);

        //注册事件
        onListMoved += Recycle;//在列表向某方向移动了一整行后触发

        //List<EventDelegate> events_OnChange = new List<EventDelegate>();
        //events_OnChange.Add(new EventDelegate(HandleOnScrollBarValueChangedHandler));
        //_scrollBar.onChange = events_OnChange;
        isActived = true;
    }//end Create()
    /// <summary>
    /// 用于重新加载ScrollView，配合项目中的页卡切换时刷新ScrollView的功能实现
    /// </summary>
    /// <param name="items">参数等同于Create(int items,...)</param>
    public void Reload(int items)
    {
        Clear();
        Create(items, p_prefab.GetComponent<UIScrollViewItemBase>());
        //Optional
        if (_itemsList.Count != 0)
        {
            var first = _itemsList[0];
            first.Index = 0;
            ItemSelected(first);
        }
    }
    /// <summary>
    /// ScrollView变量初期化
    /// </summary>
    public void Clear()
    {
        isActived = false;

        _scrollView.DisableSpring();
        _scrollView.restrictWithinPanel = false;
        _scrollView.MoveRelative(new Vector3(0, _scrollView.panel.clipOffset.y, 0));

        for (int i = _itemsList.Count - 1; i >= 0; i--)
        {
            (this as ObjectPool<GameObject>).Store(_itemsList[i].gameObject);
        }

        _itemsList = null;
        _lastPosition = 0;
        _itemsToRecycleBefore = 0;

        onListMoved = null;

        _scrollView.restrictWithinPanel = true;
    }

    #region 对象池接口实现 
    private GameObject p_prefab;//对象模板
    private Stack<GameObject> Pool = new Stack<GameObject>();
    GameObject ObjectPool<GameObject>.Get()
    {
        return Pool.Count == 0 ? Instantiate(p_prefab.gameObject) : Pool.Pop();
    }

    void ObjectPool<GameObject>.Store(GameObject item)
    {
        Pool.Push(item);
        item.SetActive(false);
    }

    void ObjectPool<GameObject>.Clear()
    {
        Pool.Clear();
    }
    #endregion
    /// <summary>
    /// 用于实例化ScrollViewItemBase
    /// </summary>
    /// <param name="index">在索引表中的索引值</param>
    /// <param name="dimension">Item尺寸大小</param>
    /// <returns>返回计算好位置的UIScrollViewItemBase实例</returns>
    private UIScrollViewItemBase CreateNewItem(int index, float dimension)
    {
        GameObject instance = (this as ObjectPool<GameObject>).Get();
        instance.name = "item_" + index;
        instance.transform.SetParent(_content);
        instance.transform.localScale = Vector3.one;
        instance.SetActive(true);

        float position = index * (dimension + _spacing);// + (index != 0 ? (dimension / 2) : 0)

        //print("_itemSize = " + dimension);
        //print(instance.name+"    offset:"+position);

        switch (_scrollOrientation)
        {
            case ScrollOrientation.HORIZONTAL:
                instance.transform.localPosition =
                        new Vector3(instance.transform.position.x + position, instance.transform.position.y, instance.transform.position.z);
                break;

            case ScrollOrientation.VERTICAL:
                instance.transform.localPosition =
                        new Vector3(instance.transform.position.x, instance.transform.position.y - position, instance.transform.position.z);
                break;
        }

        return instance.GetComponent<UIScrollViewItemBase>();
    }
    private UIScrollViewItemBase CreateNewItem(int index, Vector2 dimension)
    {
        GameObject instance = (this as ObjectPool<GameObject>).Get();
        instance.name = "item_" + index;
        instance.transform.SetParent(_content.transform);
        instance.transform.localScale = Vector3.one;
        instance.SetActive(true);

        float position_x = 0, position_y = 0;

        position_x = (index % (_itemsVisible_line + 1)) * (dimension.y + _spacing_line);
        position_y = Mathf.FloorToInt(index / (_itemsVisible_row)) * (dimension.x + _spacing_row);

        switch (_scrollOrientation)
        {
            case ScrollOrientation.HORIZONTAL:
                //instance.transform.localPosition =
                //     new Vector3(instance.transform.position.x + position, instance.transform.position.y, instance.transform.position.z);
                break;

            case ScrollOrientation.VERTICAL:
                instance.transform.localPosition =
                        new Vector3(instance.transform.position.x + position_x, instance.transform.position.y - position_y, instance.transform.position.z);
                break;
        }

        return instance.GetComponent<UIScrollViewItemBase>();
    }

    #region Callback
    void HandleOnSelectedHandler(UIScrollViewItemBase item)
    {
        ItemSelected(item);
    }

    void HandleOnScrollBarValueChangedHandler()//当ScrollBar被拖动时调用
    {

    }

    #endregion

    /// <summary>
    /// 列表项发生位置改变时执行
    /// </summary>
    private void Recycle()
    {
        ScrollDirection direction = GetScrollDirection();

        //print("Recycle()  = "+ direction);

        for (int i = 0; i < displacedRows; i++)
        {
            switch (direction)
            {
                case ScrollDirection.NEXT:

                    NextItem();
                    //print("_lastItemIndex = "+ _lastItemIndex);

                    break;

                case ScrollDirection.PREVIOUS:

                    PreviousItem();

                    break;
            }

            if ((direction == ScrollDirection.NEXT && _scrollOrientation == ScrollOrientation.VERTICAL) ||
                (direction == ScrollDirection.PREVIOUS && _scrollOrientation == ScrollOrientation.HORIZONTAL))
            {
                _lastPosition += EnableMultiLine ? _itemSize_ml.x + _spacing_row : _itemSize + _spacing;
            }
            else
                _lastPosition -= EnableMultiLine ? _itemSize_ml.x + _spacing_line: _itemSize + _spacing;
        }
    }//end Recycle()
    /// <summary>
    /// 判断向后滑动时是否进行回收项目操作
    /// </summary>
    private void NextItem()
    {
        if (!EnableMultiLine)
        {
            //print("_itemsList.Count = " + _itemsList.Count);
            //print("_itemsVisible = " + _itemsVisible);
            //print("条件1：" + _itemsToRecycleBefore + " >= " + (_itemsList.Count - _itemsVisible) / 2 + "?");
            //print("_lastItemIndex = " + _lastItemIndex);
            //print("条件2：_lastItemIndex < _itemsTotal - 1 = " + (_lastItemIndex < _itemsTotal - 1));
            //print("==========================================");
            if (_itemsToRecycleBefore >= (_itemsList.Count - _itemsVisible) / 2 && _lastItemIndex < _itemsTotal - 1)
            {
                _lastItemIndex++;

                RecycleItem(ScrollDirection.NEXT);
            }
            else
            {
                _itemsToRecycleBefore++;
                _itemsToRecycleAfter--;
            }
        }
        else
        {
            //print("_itemsList.Count = " + _itemsList.Count);
            //print("_itemsVisible_row = " + _itemsVisible_row);
            //Debug.LogWarning("条件1：" + _itemsToRecycleBefore + " >= " + ((_itemsList.Count / _itemsVisible_row - _itemsVisible_line) / 2) + "?");
            //print("_lastItemIndex = " + _lastItemIndex);
            //Debug.LogWarning("条件2：_lastItemIndex < _itemsTotal - 1 = " + (_lastItemIndex < _itemsTotal - 1));
            //print("==========================================");
            if (_itemsToRecycleBefore >= (_itemsList.Count / _itemsVisible_row - _itemsVisible_line) / 2 && _lastItemIndex < _itemsTotal - 1)
            {
                _firstItemIndex += _itemsVisible_row;
                _lastItemIndex += _itemsVisible_row;

                RecycleItem(ScrollDirection.NEXT);
            }
            else
            {
                //print("无操作");
                _itemsToRecycleBefore ++;
                _itemsToRecycleAfter --;
            }
        }

    }//end NextItem()
    /// <summary>
    /// 判断向前滑动时是否进行回收项目操作
    /// </summary>
    private void PreviousItem()
    {
        if (!EnableMultiLine)
        {
            //print("_itemsList.Count = " + _itemsList.Count);
            //print("_itemsVisible = " + _itemsVisible);
            //print("条件1：" + _itemsToRecycleBefore + " >= " + (_itemsList.Count - _itemsVisible) / 2 + "?");
            //print("条件2：_lastItemIndex > _itemsList.Count - 1 = " + (_lastItemIndex > _itemsList.Count - 1));
            //print("_lastItemIndex = " + _lastItemIndex);
            //print("_itemsList.Count" + _itemsList.Count);
            //print("==========================================");

            if (_itemsToRecycleAfter >= ((_itemsList.Count / _itemsVisible_row - _itemsVisible_line) / 2) && _lastItemIndex > _itemsList.Count - 1)
            {
                RecycleItem(ScrollDirection.PREVIOUS);

                _lastItemIndex -= _itemsVisible_row;
            }
            else
            {
                //print("无操作");
                _itemsToRecycleBefore--;
                _itemsToRecycleAfter++;
            }
        }
        else
        {
            //print("_itemsList.Count = " + _itemsList.Count);
            //print("_itemsVisible_row = " + _itemsVisible_row);
            //Debug.LogWarning("条件1：" + _itemsToRecycleBefore + " >= " + ((_itemsList.Count / _itemsVisible_row - _itemsVisible_line) / 2) + "?");
            //Debug.LogWarning("条件2：_lastItemIndex > _itemsList.Count - 1 = " + (_lastItemIndex > _itemsList.Count - 1));
            //print("_lastItemIndex = " + _lastItemIndex);
            //print("_itemsList.Count" + _itemsList.Count);
            //print("==========================================");
            if (_itemsToRecycleAfter >= (_itemsList.Count / _itemsVisible_row - _itemsVisible_line) / 2 && _lastItemIndex > _itemsList.Count - 1)
            {
                RecycleItem(ScrollDirection.PREVIOUS);

                _firstItemIndex -= _itemsVisible_row;
                _lastItemIndex -= _itemsVisible_row;
            }
            else
            {
                _itemsToRecycleBefore --;
                _itemsToRecycleAfter ++;
            }
        }

    }//end PreviousItem()
    /// <summary>
    /// 进行回收项目操作
    /// </summary>
    /// <param name="direction">回收方向(用于判断回收头/尾部)</param>
    private void RecycleItem(ScrollDirection direction)
    {
        if(!EnableMultiLine)
        {
            #region SingleLine
            UIScrollViewItemBase firstItem = _itemsList[0];
            UIScrollViewItemBase lastItem = _itemsList[_itemsList.Count - 1];

            float targetPosition = (_itemSize + _spacing);

            switch (direction)
            {
                case ScrollDirection.NEXT:
                    //向后滚动时，将首元素移至队尾
                    switch (_scrollOrientation)
                    {
                        case ScrollOrientation.HORIZONTAL://水平滚动方向，只改变x值
                            //firstItem.Position = new Vector2(lastItem.Position.x + targetPosition, firstItem.Position.y);
                            break;

                        case ScrollOrientation.VERTICAL://垂直滚动方向，只改变y值
                            firstItem.Position = new Vector2(firstItem.Position.x, lastItem.Position.y + targetPosition);
                            break;
                    }
                    //print(firstItem.gameObject.name + "移至队尾");
                    firstItem.Index = _lastItemIndex;
                    firstItem.transform.SetAsLastSibling();

                    _itemsList.RemoveAt(0);
                    _itemsList.Add(firstItem);

                    ItemLoaded(firstItem);
                    break;

                case ScrollDirection.PREVIOUS:
                    //向前滚动时，将列表末元素移至队头
                    switch (_scrollOrientation)
                    {
                        case ScrollOrientation.HORIZONTAL:
                            lastItem.Position = new Vector2(firstItem.Position.x - targetPosition, lastItem.Position.y);
                            break;

                        case ScrollOrientation.VERTICAL:
                            lastItem.Position = new Vector2(lastItem.Position.x, firstItem.Position.y - targetPosition);
                            break;
                    }
                    //print(lastItem.gameObject.name+ "移至队头");
                    lastItem.Index = _lastItemIndex - _itemsList.Count;
                    lastItem.transform.SetAsFirstSibling();

                    _itemsList.RemoveAt(_itemsList.Count - 1);
                    _itemsList.Insert(0, lastItem);

                    ItemLoaded(lastItem);
                    break;
            }//end switch
            #endregion
        }
        else
        {
            UIScrollViewItemBase[] firstRowItems = new UIScrollViewItemBase[_itemsVisible_row];
            UIScrollViewItemBase[] lastItems = new UIScrollViewItemBase[firstRowItems.Length];
            for (int i = 0; i < _itemsVisible_row; ++i)
            {
                firstRowItems[i] = _itemsList[0 + i];
                lastItems[i] = _itemsList[_itemsList.Count - 1 - i];
            }
                
            float targetPosition = firstRowItems[0].Size.y + _spacing_row;
            
            switch (direction)
            {
                case ScrollDirection.NEXT:
                    //向后滚动时，将首元素移至队尾
                    switch (_scrollOrientation)
                    {
                        case ScrollOrientation.HORIZONTAL://水平滚动方向，只改变x值
                            //firstItem.Position = new Vector2(lastItem.Position.x + targetPosition, firstItem.Position.y);
                            break;

                        case ScrollOrientation.VERTICAL://垂直滚动方向，只改变y值
                            for(int i = 0;i < firstRowItems.Length; ++i)
                            {
                                firstRowItems[i].Position = new Vector2(firstRowItems[i].Position.x, lastItems[i].Position.y - targetPosition);
                                //print(firstRowItems[i].gameObject.name + "移至队尾");
                                //print(firstRowItems[i].gameObject.name + " y轴坐标-" + targetPosition);
                            }
                            break;
                    }
                    
                    for(int i = 0;i < firstRowItems.Length; ++i)
                    {
                        firstRowItems[i].Index = _lastItemIndex + i;
                        firstRowItems[i].transform.SetAsLastSibling();

                        _itemsList.RemoveAt(0);
                        _itemsList.Add(firstRowItems[i]);

                        ItemLoaded(firstRowItems[i]);
                    }
                    break;

                case ScrollDirection.PREVIOUS:
                    //向前滚动时，将列表末元素移至队头
                    switch (_scrollOrientation)
                    {
                        case ScrollOrientation.HORIZONTAL:
                            //lastItem.Position = new Vector2(firstItem.Position.x - targetPosition, lastItem.Position.y);
                            break;

                        case ScrollOrientation.VERTICAL:
                            for (int i = 0; i < lastItems.Length; ++i)
                            {
                                lastItems[i].Position = new Vector2(lastItems[i].Position.x, firstRowItems[i].Position.y + targetPosition);
                                //print(lastItems[i].gameObject.name + "移至队头");
                                //print(firstRowItems[i].gameObject.name + " y轴坐标+" + targetPosition);
                            }
                            break;
                    }
                    for (int i = 0; i < lastItems.Length; ++i)
                    {
                        lastItems[i].Index = _lastItemIndex - _itemsList.Count + i;
                        lastItems[i].transform.SetAsFirstSibling();

                        _itemsList.RemoveAt(_itemsList.Count - 1);
                        _itemsList.Insert(0, lastItems[i]);

                        ItemLoaded(lastItems[i]);
                    }
                    break;
            }//end switch
        }
        _scrollView.InvalidateBounds();
    }//end RecycleItem()

    #region UTILS
    /// <summary>
    /// 计算向某方向滚动时的偏移值，基于NGUI的UIPanel的localCorners属性
    /// </summary>
    /// <returns></returns>
    private float GetContentPosition()
    {
        Vector3[] corners = _panel.localCorners;
        switch (_scrollOrientation)
        {
            
            case ScrollOrientation.HORIZONTAL:
                //print("GetContentPosition() = " + ((corners[0] + corners[2]) * 0.5f).x);
                return -((corners[0]+ corners[2]) * 0.5f).x;

            case ScrollOrientation.VERTICAL:
                //print("GetContentPosition() = "+ _content.anchoredPosition.y);
                return -((corners[0] + corners[2]) * 0.5f).y;

            default:
                return 0;
        }
    }
    /// <summary>
    /// 获取视口的大小
    /// </summary>
    /// <returns>滚动方向是水平，则返回UIPanel宽度；滚动方向是垂直，则返回UIPanel高度</returns>
    private float GetViewportSize()
    {
        switch (_scrollOrientation)
        {
            case ScrollOrientation.HORIZONTAL:
                return _viewport.width;

            case ScrollOrientation.VERTICAL:
                return _viewport.height;

            default:
                return 0;
        }
    }
    /// <summary>
    /// 获取单次产生滚动的方向
    /// </summary>
    /// <returns>滚动方向(逻辑上)</returns>
    private ScrollDirection GetScrollDirection()
    {
        switch (_scrollOrientation)
        {
            case ScrollOrientation.HORIZONTAL:
                //水平滚动时，GetContentPosition()返回x值，x轴向右为+，
                //上次的位置值(x)小于当前位置值则是向后移动(逻辑上)
                //print("_lastPosition < GetContentPosition() ? ScrollDirection.PREVIOUS : ScrollDirection.NEXT");
                print("_lastPosition = "+ _lastPosition);
                print("GetContentPosition() = " + GetContentPosition());
                return _lastPosition < GetContentPosition() ? ScrollDirection.PREVIOUS : ScrollDirection.NEXT;

            case ScrollOrientation.VERTICAL:
                //垂直滚动时，GetContentPosition()返回y值，y轴向上为+，
                //上次的位置值(y)大于当前位置值则是向前移动(逻辑上)
                return _lastPosition > GetContentPosition() ? ScrollDirection.PREVIOUS : ScrollDirection.NEXT;

            default:
                return ScrollDirection.NEXT;
        }
    }

    #endregion
}
public enum ScrollOrientation//滚动方向(实际)，水平和垂直
{
    HORIZONTAL,
    VERTICAL
}
public enum ScrollDirection//滚动方向(逻辑上)，后和前
{
    NEXT,
    PREVIOUS
}
/// <summary>
/// 对象池接口
/// </summary>
/// <typeparam name="T">此项目中使用GameObject作为泛型类</typeparam>
public interface ObjectPool<T>
{
    /// <summary>
    /// 从对象池拿对象实例
    /// </summary>
    /// <returns>对象实例</returns>
    T Get();
    /// <summary>
    /// 将对象实例放回对象池
    /// </summary>
    /// <param name="item">暂时不用的对象实例</param>
    void Store(T item);
    /// <summary>
    /// 清空对象池
    /// </summary>
    void Clear();
}