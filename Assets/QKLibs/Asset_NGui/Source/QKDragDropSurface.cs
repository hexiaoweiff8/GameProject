using UnityEngine;
using System;
/*
interface IDragDropSurface
{
    bool Dock(GameObject obj);//停靠，成功返回true,失败返回false
}*/


[AddComponentMenu("QK/QKDragDropSurface")]
public class QKDragDropSurface : MonoBehaviour//,IDragDropSurface
{
    public string[] ItemTags = null;//定义Item tag,只有队列包含的tag可以被放进这个容器
    public GameObject WidgetContainer = null;//容器

    //飞行动画插值曲线
    //public int flyAnimationCurveID=0;

    //飞行强度
    public float FlyStrength = 15;

    /// <summary>
    /// 当无法抵达目的容器时，是否采用飞行的方式，回到起始处
    /// </summary>
    public bool FlyOnCancel = true;

    [System.NonSerialized] 
    IQKEvent m_evt_DragDropEnd = null;

    [System.NonSerialized] 
    IQKEvent m_evt_DragDropMoveing = null;

    [System.NonSerialized] 
    IQKEvent m_evt_DragDropJoinItem = null;

    [System.NonSerialized]
    IQKEvent m_evt_DragDropLeaveItem = null;

    [System.NonSerialized] 
    IQKEvent m_evt_DragDropStart = null;

    [System.NonSerialized] 
    IQKEvent m_evt_DragDropCancel = null;

    [System.NonSerialized]
    IQKEvent m_evt_DragDropCancelling = null;

    [System.NonSerialized] 
    IQKDelegate m_delegate_DockCheck = null;
    
    public IQKDelegate delegate_DockCheck
    {
        get {
            return m_delegate_DockCheck;
        }
        set
        {
            if (m_delegate_DockCheck != null) { m_delegate_DockCheck.Dispose(); }
            m_delegate_DockCheck = value;
        }
    }
     
    public IQKEvent evt_DragDropEnd {
        get { 
            return m_evt_DragDropEnd; 
        }
        set {
            if (m_evt_DragDropEnd != null) { m_evt_DragDropEnd.Dispose();}
            m_evt_DragDropEnd = value; 
        }
    }

    public IQKEvent evt_DragDropMoveing
    {
        get {
            return m_evt_DragDropMoveing; 
        }
        set {
            if (m_evt_DragDropMoveing != null) { m_evt_DragDropMoveing.Dispose(); }
            m_evt_DragDropMoveing = value; 
        }
    }
    
     
    public IQKEvent evt_DragDropJoinItem
    {
        get
        {
            return m_evt_DragDropJoinItem;
        }
        set
        {
            if (m_evt_DragDropJoinItem != null) { m_evt_DragDropJoinItem.Dispose();  }
            m_evt_DragDropJoinItem = value;
        }
    }

    public IQKEvent evt_DragDropLeaveItem
    {
        get
        {
            return m_evt_DragDropLeaveItem;
        }
        set
        {
            if (m_evt_DragDropLeaveItem != null) { m_evt_DragDropLeaveItem.Dispose(); }
            m_evt_DragDropLeaveItem = value;
        }
    }
     
     
    public IQKEvent evt_DragDropStart
    {
        get
        {
            return m_evt_DragDropStart;
        }
        set
        {
            if (m_evt_DragDropStart != null) { m_evt_DragDropStart.Dispose(); }
            m_evt_DragDropStart = value; 
        }
    }
     
    public IQKEvent evt_DragDropCancel
    {
        get
        {
            return m_evt_DragDropCancel;
        }
        set
        {
            if (m_evt_DragDropCancel != null) { m_evt_DragDropCancel.Dispose(); }
            m_evt_DragDropCancel = value;
        }
    }

    public IQKEvent evt_DragDropCancelling
    {
        get
        {
            return m_evt_DragDropCancelling;
        }
        set
        {
            if (m_evt_DragDropCancelling != null) { m_evt_DragDropCancelling.Dispose(); }
            m_evt_DragDropCancelling = value;
        }
    }

    void OnDestroy()
    {
        evt_DragDropEnd = null;
        evt_DragDropJoinItem  = null;
        evt_DragDropStart = null;
        evt_DragDropCancel = null;
        delegate_DockCheck = null;
        evt_DragDropMoveing = null;
        evt_DragDropLeaveItem = null;
        evt_DragDropCancelling = null;
    }


    //拖拽完成
    public void OnDragDropEnd(QKDragDropItem dragDropItem)
    {
        if (evt_DragDropEnd != null) evt_DragDropEnd.Call(dragDropItem); 
    }

    public void OnDragDropMoveing(QKDragDropItem dragDropItem)
    {
        if (evt_DragDropMoveing != null) evt_DragDropMoveing.Call(dragDropItem); 
    }
            
    //有新对象加入
    public void OnDragDropJoinItem( QKDragDropItem dragDropItem)
     { 
         if (evt_DragDropJoinItem != null) evt_DragDropJoinItem.Call(dragDropItem);   
     }

    //有对象离开
    public void OnDragDropLeaveItem( QKDragDropItem dragDropItem)
    {
        if (evt_DragDropLeaveItem != null) evt_DragDropLeaveItem.Call(dragDropItem);   
    }

    //拖拽开始
    public void OnDragDropStart( QKDragDropItem dragDropItem)
    { 
        if (evt_DragDropStart != null)  evt_DragDropStart.Call(dragDropItem); 
    }

    //拖拽取消
    public void OnDragDropCancel(QKDragDropItem dragDropItem)
    { 
        if (evt_DragDropCancel != null) evt_DragDropCancel.Call(dragDropItem);  
    }

    public void OnDragDropCancelling(QKDragDropItem dragDropItem)
    {
        if (evt_DragDropCancelling != null) evt_DragDropCancelling.Call(dragDropItem);
    }


    /// <summary>
    /// 指针是否悬停在该表面上
    /// </summary>
    public bool IsHovered
    {
        get {
            var obj = QKDragDropItem.hoveredObject;

            if (obj == null) return false;  
            QKDragDropSurface dropSurface = NGUITools.FindInParents<QKDragDropSurface>(obj); 
            return dropSurface == this;
        }
    }
   
     

    public  bool CanDock(GameObject obj)
    {
        if (WidgetContainer == null) return false;

        QKDragDropItem dropItem = obj.GetComponent<QKDragDropItem>();
        if(dropItem==null) { return false;}

        if (ItemTags == null || dropItem.tags==null) return false;

        bool isok = false;
        foreach(string tag1 in ItemTags)
        {
            foreach(string tag2 in dropItem.tags)
            {
                if(tag1 == tag2)
                {
                    isok = true;
                    break;
                }
            }
        }

        if (isok == false) return false;
        
        
        if(m_delegate_DockCheck!=null)
        { 
            //调用脚本的检查函数
            object re = m_delegate_DockCheck.Call(dropItem);
            if (re == null)  return false; 
          
            //释放返回值
            IDisposable disp = re as IDisposable;
            if (disp != null) disp.Dispose();

            if(Type.GetTypeCode(re.GetType())==TypeCode.Boolean)
            { 
                if ((bool)re == false) return false;
            }
        } 
        return true;
    }
    

    public bool Dock(GameObject obj)
    {
        if (!CanDock(obj))
            return false;
 
        //进行停靠

        //尝试 道具槽模式
        QKItemSlot itemSlot = WidgetContainer.GetComponent<QKItemSlot>();
        if(itemSlot!=null)
        {
            //将对象加入
            obj.transform.parent = itemSlot.gameObject.transform;

            //通知父亲改变
            NGUITools.MarkParentAsChanged(obj);

            //重新算item位置
            itemSlot.Reposition();

            DockItemDone(obj);
            return true;
        }

        //尝试 grid模式
        UIGrid grid = WidgetContainer.GetComponent<UIGrid>();
        if(grid!=null)
        {
            grid.AddChild(obj.transform);

            NGUITools.MarkParentAsChanged(obj);

            DockItemDone(obj);
            return true;
        }
        
        //尝试 table模式
        UITable table = WidgetContainer.GetComponent<UITable>();
        if (table!=null)
        {
            //将对象加入到table中
            obj.transform.parent = table.gameObject.transform;

            NGUITools.MarkParentAsChanged(obj);

            //重新算item位置
            table.Reposition();

            DockItemDone(obj);
            return true;
        }

        return false;
    } 

    void DockItemDone(GameObject item)
    {
        //UIRect uirect = item.GetComponent<UIRect>();
        //if (uirect != null) {uirect.enabled = false;  uirect.enabled = true;}//刷新下uirect,否则有时候会有剪裁错误


        //自动启用碰检器
        Collider collider = item.GetComponent<Collider>();
        if(collider!=null) collider.enabled = true;

        //自动启用滚动view组件
        UIDragScrollView scrollView = item.GetComponent<UIDragScrollView>();
        if (scrollView != null) scrollView.enabled = true;
         
    }


}
