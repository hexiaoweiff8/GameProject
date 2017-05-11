
using UnityEngine;
using System;
[AddComponentMenu("QK/QKDragDropItem")]
public class QKDragDropItem : UIDragDropItem
{ 
    public string[] tags;//定义tag
    public GameObject OwnerSurface;//所属的容器
    public bool EnableDragDropOffset = false;//是否启用拖拽偏移，如果启用会记录鼠标按下时与控件之间的距离差，拖拽过程中将一直保持这个距离差

    Vector3 m_DragDropOffset;
    Plane m_DragDropItemPlane;

    /*
    public object UserData//用户数据，一般用于辨别拖拽物的身份
    {
        get { return m_UserData; }
        set { 
            if(m_UserData!=null)
            {
                IDisposable disposableObj = m_UserData as IDisposable;
                if (disposableObj != null) disposableObj.Dispose();
            }
            m_UserData = value;
        }
    }
     */

    //void OnDestroy()
    //{
        //UserData = null;
    //}
    /// <summary>
    /// 开始拖拽
    /// </summary>
    protected override void OnDragDropStart ()
    {
        //记录起始位置
        if(UIFlyRoot.Single!=null) m_StartPos = gameObject.transform.position;  

        //通知容器 开始拖
        NotifyDragDropStart(OwnerSurface,this);

        //通知拖拽开始
        base.OnDragDropStart();
         

        //提升widget深度
        NGuiHelper.DepthUpward(gameObject, 50);

       //记录鼠标位置和拖拽物之间的偏移量
       m_DragDropItemPlane = new Plane(new Vector3(0, 0, 1), mTrans.position.z);

       if (EnableDragDropOffset)
       {
           Ray ray = UICamera.currentRay;
           float enter;
           if (m_DragDropItemPlane.Raycast(ray, out enter))
           {
               m_DragDropOffset = ray.GetPoint(enter) - mTrans.position;
           }
       }
       else
           m_DragDropOffset = Vector3.zero;
      

        ////////////////////////////////////////////////////////////////////////////////////
       if (!draggedItems.Contains(this))
           draggedItems.Add(this);

       // Automatically disable the scroll view
       if (mDragScrollView != null) mDragScrollView.enabled = false;

       // Disable the collider so that it doesn't intercept events
       if (mButton != null) mButton.isEnabled = false;
       else if (mCollider != null) mCollider.enabled = false;
       else if (mCollider2D != null) mCollider2D.enabled = false;

       mParent = mTrans.parent;
       mRoot = NGUITools.FindInParents<UIRoot>(mParent);
       mGrid = NGUITools.FindInParents<UIGrid>(mParent);
       mTable = NGUITools.FindInParents<UITable>(mParent);

       // Re-parent the item
       if (UIDragDropRoot.root != null)
           mTrans.parent = UIDragDropRoot.root;

       Vector3 pos = mTrans.localPosition;
       pos.z = 0f;
       mTrans.localPosition = pos;

       TweenPosition tp = GetComponent<TweenPosition>();
       if (tp != null) tp.enabled = false;

       SpringPosition sp = GetComponent<SpringPosition>();
       if (sp != null) sp.enabled = false;

       // Notify the widgets that the parent has changed
       NGUITools.MarkParentAsChanged(gameObject);

       if (mTable != null) mTable.repositionNow = true;
       if (mGrid != null) mGrid.repositionNow = true;
    }

    protected override void OnDragDropMove(Vector2 delta)
    {
        Ray ray = UICamera.currentRay;
        float enter;
        if (m_DragDropItemPlane.Raycast(ray, out enter))
        {
            mTrans.position = ray.GetPoint(enter) - m_DragDropOffset;
        }

       
        NotifyDragDropMoveing(OwnerSurface, this); 
    }

     

    public override void StartDragging()
    {
        if (!interactable||
            IsDraging//当前有其它拖拽发生
            ) return;

      

        if (!mDragging)
        {
            IsDraging = true;//同时只允许启动唯一一个拖拽
           
            if (cloneOnDrag)
            {
                mPressed = false;
                GameObject clone = NGUITools.AddChild(transform.parent.gameObject, gameObject);
                clone.transform.localPosition = transform.localPosition;
                clone.transform.localRotation = transform.localRotation;
                clone.transform.localScale = transform.localScale;

                UIButtonColor bc = clone.GetComponent<UIButtonColor>();
                if (bc != null) bc.defaultColor = GetComponent<UIButtonColor>().defaultColor;

                if (mTouch != null && mTouch.pressed == gameObject)
                {
                    mTouch.current = clone;
                    mTouch.pressed = clone;
                    mTouch.dragged = clone;
                    mTouch.last = clone;
                }

                QKDragDropItem item = clone.GetComponent<QKDragDropItem>();//wenchuan
                item.mTouch = mTouch;
                item.mPressed = true;
                item.mDragging = true;

                //wenchuan begin
                //QKDragDropItem oldItem = gameObject.GetComponent<QKDragDropItem>();
                //处理用户参数

                //if (oldItem.CloneUserDataDelegateFunc != null)
                //    item.UserData =  oldItem.CloneUserDataDelegateFunc(oldItem.UserData);
                //else
                    item.UserData = //oldItem.
                        UserData;
                //wenchuan end

                item.m_bkCloneOnDrag = cloneOnDrag;
                item.m_bkDropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
                item.Start();
                item.OnDragDropStart();

                if (UICamera.currentTouch == null)
                    UICamera.currentTouch = mTouch;

                mTouch = null;

                UICamera.Notify(gameObject, "OnPress", false);
                UICamera.Notify(gameObject, "OnHover", false);
            }
            else
            {
                m_bkCloneOnDrag = cloneOnDrag;//记录
                m_bkDropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();

                mDragging = true;
                OnDragDropStart();
            }
        }
    }

     

    //拖拽释放，没有落在停靠表面的处理
    void DragDropReleaseLostSurface ()
    { 

        QKDragDropSurface cm_ownersurface = null;
        {
            if (OwnerSurface != null) cm_ownersurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        }

        NotifyDragDropCancelling(OwnerSurface, this);

        if (cm_ownersurface != null && cm_ownersurface.FlyOnCancel && UIFlyRoot.Single != null)//飞回
        { 
            UIFly cmFly = UIFly.Go(gameObject, m_StartPos, cm_ownersurface.FlyStrength);
            //cmFly.flyFinishedAction = UIFly.FlyFinishedAction.DestroyGameobject; 
            cmFly.StartFly(OnFlyEnd);
        }
        else//直接销毁
        {
            if (!m_bkCloneOnDrag)//拖拽的时候没有进行克隆
                NotifyDragDropLeaveItem(m_bkDropSurface, this);//通知旧容器 对象离开

            //通知容器 拖拽取消
            NotifyDragDropCancel(OwnerSurface, this);

            //销毁物体
            NGUITools.Destroy(gameObject);
        }
    }

	/// <summary>
	/// 拖拽释放鼠标
	/// </summary>
	protected override void OnDragDropRelease (GameObject surface)
    {
        surface = QKDragDropItem.hoveredObject;

        //降低widget深度
        NGuiHelper.DepthUpward(gameObject, -50);


        if (surface == null)
        {
            DragDropReleaseLostSurface();
            return;
        }

        QKDragDropSurface dropSurface = NGUITools.FindInParents<QKDragDropSurface>(surface);
        if (
            dropSurface == null||//没有落在停靠表面上
            (dropSurface == m_bkDropSurface && m_bkCloneOnDrag) //停靠表面和拖动前是同一个 且 采用克隆方式拖出
            )
        {
            DragDropReleaseLostSurface();
            return;
        }

        

        if (dropSurface.Dock(gameObject))//停靠成功了
        {
            //通知原容器 拖拽完成
            NotifyDragDropEnd(OwnerSurface,this);

            //变更所属容器
            OwnerSurface = dropSurface.gameObject;

            //自动处理UIScrollView
            var dragScrollView = gameObject.GetComponent<UIDragScrollView>();
            if (dragScrollView != null)//绑定了滚动视图拖动组件
            {
                //设置新的滚动视图
                dragScrollView.scrollView = NGUITools.FindInParents<UIScrollView>(gameObject.transform.parent);
            }

            bool isGird = NGUITools.FindInParents<UIGrid>(gameObject.transform.parent);

            //如没拖出当前平面则不需要发起通知并且重新排序
            if (isGird || (!m_bkCloneOnDrag && dropSurface != m_bkDropSurface))//拖拽的时候没有进行克隆
                NotifyDragDropLeaveItem(m_bkDropSurface, this);//通知旧容器 对象离开
            if (isGird || dropSurface != m_bkDropSurface)
            {
                //通知新容器 有新的对象进入
                NotifyDragDropJoinItem(OwnerSurface, this);
            }
        }else
            DragDropReleaseLostSurface();
    }

    void OnFlyEnd()
    {
        QKDragDropItem dragDropItem = this;

        if (!m_bkCloneOnDrag)//拖拽的时候没有进行克隆
        {
            //物品放回原位置
            QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
            if (dropSurface != null) dropSurface.Dock(gameObject);
        }  

        NotifyDragDropCancel(dragDropItem.OwnerSurface, dragDropItem);

        if(m_bkCloneOnDrag)
        {
            GameObject.Destroy(gameObject);//销毁实例
        }
    }

    //通知容器 拖拽即将被取消
    static void NotifyDragDropCancelling(GameObject OwnerSurface, QKDragDropItem dragDropItem)
    {
        QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        if (dropSurface == null) return;

        dropSurface.OnDragDropCancelling(dragDropItem);
    }


    //通知容器 拖拽取消
    static void NotifyDragDropCancel(GameObject OwnerSurface, QKDragDropItem dragDropItem)
    {
        IsDraging = false;

        ShowBaffle(false);

        QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        if (dropSurface == null) return;
         

        dropSurface.OnDragDropCancel(dragDropItem);
    }

    //通知容器 拖拽开始
    static void NotifyDragDropStart(GameObject OwnerSurface, QKDragDropItem dragDropItem)
    {
        ShowBaffle(true);

        QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        if (dropSurface == null) return;
        dropSurface.OnDragDropStart(dragDropItem);
    }

    static void   NotifyDragDropEnd( GameObject OwnerSurface,QKDragDropItem dragDropItem)
    {
        IsDraging = false;

        ShowBaffle(false);

        QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        if (dropSurface == null) return;

        dropSurface.OnDragDropEnd(dragDropItem);
    }

    static bool IsDraging = false;


    static void ShowBaffle(bool isShow)
    {
        if (UIDragDropRoot.root == null) return;
        var Baffle = UIDragDropRoot.root.Find("Baffle");
        if (Baffle == null) return;
        Baffle.gameObject.SetActive(isShow); 
    }

    static bool IsBaffleVisible
    {
        get
        {
            if (UIDragDropRoot.root == null) return false;
            var Baffle = UIDragDropRoot.root.Find("Baffle");
            if (Baffle == null) return false;
            return Baffle.gameObject.activeInHierarchy;
        }
    }

    public static GameObject hoveredObject
    {
        get
        {
            bool v = IsBaffleVisible;
            if (v) ShowBaffle(false);

            tmpTouch.pos = Input.mousePosition;
            tmpTouch.current = null;
            UICamera.Raycast(tmpTouch);
            
            if (v) ShowBaffle(true);

            return tmpTouch.current;
        }
    }
    static UICamera.MouseOrTouch tmpTouch = new UICamera.MouseOrTouch(); 

    static void NotifyDragDropMoveing(GameObject OwnerSurface, QKDragDropItem dragDropItem)
    {
        //using (new MonoEX.SafeCall(() => { ShowBaffle(false);  }, () => {  ShowBaffle(true);   }))
        {
            QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
            if (dropSurface == null) return;

            dropSurface.OnDragDropMoveing(dragDropItem);
        }
    }
            
    static void NotifyDragDropJoinItem(GameObject OwnerSurface, QKDragDropItem dragDropItem)
    {
        QKDragDropSurface dropSurface = OwnerSurface.GetComponent<QKDragDropSurface>();
        if (dropSurface == null) return;

        dropSurface.OnDragDropJoinItem(dragDropItem);
    }

    static void NotifyDragDropLeaveItem(QKDragDropSurface dropSurface, QKDragDropItem dragDropItem)
    {
        if (dropSurface == null) return;

        dropSurface.OnDragDropLeaveItem(dragDropItem);
    }

    
    delegate object CloneUserDataDelegate(object userdata);

    //用户参数克隆处理函数
    //[System.NonSerialized]
    //CloneUserDataDelegate CloneUserDataDelegateFunc = null;

    
    public string UserData;//用户数据，一般用于辨别拖拽物的身份

    [System.NonSerialized] 
    Vector3 m_StartPos = new Vector3();

    [System.NonSerialized]
    bool m_bkCloneOnDrag;//记录开始移动前的CloneOnDrag属性

    [System.NonSerialized]
    QKDragDropSurface m_bkDropSurface;
}
