using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine; 
using System.Diagnostics;
 
/// <summary>
/// 滚动容器拖拽组件
/// </summary>
public class ScrollContainerDrag : MonoBehaviour
{
    public GameObject ScrollContainerObj = null;

    void OnDrag (Vector2 delta)
    {
        if (ScrollContainerObj != null)
        {
            ScrollContainer cm = ScrollContainerObj.GetComponent<ScrollContainer>();
            if (cm != null) cm.OnDrag(delta);
        }
    }
    void OnPress(bool isPressed)
    {
        if (ScrollContainerObj != null)
        {
            ScrollContainer cm = ScrollContainerObj.GetComponent<ScrollContainer>();
            if (cm != null) cm.OnPress(isPressed);
        }
    }
}

/// <summary>
/// 滚动容器
/// </summary>
public class ScrollContainer : MonoBehaviour
{
    public Vector2 Momentum = new Vector2(1,1);//惯性

    public Vector2 SpringSpeed = new Vector2(1, 1);//回弹速度

    public float SpringRange_Left = 0;//弹性范围  
    public float SpringRange_Right = 0;//弹性范围  
    public float SpringRange_Top = 0;//弹性范围  
    public float SpringRange_Bottom = 0;//弹性范围  

    public float Margin_Left = 0;//内容留边
    public float Margin_Right = 0;//内容留边
    public float Margin_Top = 0;//内容留边
    public float Margin_Bottom = 0;//内容留边

    public Vector2 ScrollScale = new Vector2(1,1);//滚动缩放系数
    public Vector2 ContainerSize = new Vector2(100,100);//容器尺寸

    public Flip DragFlip = Flip.Nothing;

    public void Reposition()
    {
        //取得所有条目
        items = GetComponentsInChildren<ScrollItem>();

        //计算包围盒
        {
            m_BoundingBox.Reset();

            if (items != null && items.Length >0)
            {
                foreach (ScrollItem curr in items)
                    m_BoundingBox.Merge(curr.pos.x, curr.pos.y, curr.size.x, curr.size.y); //合并条目

                //包围盒剪掉边
                m_BoundingBox.CutMargin(Margin_Left, Margin_Top, Margin_Right, Margin_Bottom);
            }
        }
        m_Scroll = new Vector2(m_BoundingBox.left, m_BoundingBox.top);
        UpdateItemPos();
    }

    void Start()
    {
        Reposition();
    }

    void UpdateItemPos()
    {
        //应用新偏移量
        foreach (ScrollItem curr in items)
            curr.Scroll = m_Scroll;
    }
     

    float DistanceDamping(float distance)
    {
        //将线性距离变为减速运动的距离
        if (distance < 0)
            return  -Mathf.Sqrt(-distance / 8);
        else
            return Mathf.Sqrt(distance / 8); 
    }


    /*
    void OnHover(bool isHover)
    {
        Debug.Log("OnHover#1"  );
    }*/
    public void OnDrag (Vector2 delta)
    {   

        switch(DragFlip)
        {
            case Flip.Horizontally:
                delta.x = -delta.x;
                break;
            case Flip.Vertically:
                delta.y = -delta.y;
                break;
            case Flip.Both:
                delta.x = -delta.x;
                delta.y = -delta.y;
                break;
        }

        m_toucheOffset += delta; 
        Vector2 toucheOffset = m_toucheOffset;//拖拽偏移量 

        if (!m_isDraging)
        {
            if (Mathf.Abs(toucheOffset.x) > 10.0f || Mathf.Abs(toucheOffset.y) > 10.0f)
                m_isDraging = true;
            else
                return;//未满足拖拽条件
        }

        toucheOffset.x *= ScrollScale.x;
        toucheOffset.y *= ScrollScale.y;

        m_lastMomentum = delta / (Time.deltaTime <= 0 ? 0.000001f : Time.deltaTime);

        m_lastMomentumTime = Process.GetCurrentProcess().TotalProcessorTime.TotalSeconds;

        Vector2 scroll = m_StartScroll + toucheOffset;//算出新的拖拽偏移

        //处理新偏移量
        {
             
            //对弹性范围区域应用阻尼
            if (scroll.x > m_BoundingBox.right - ContainerSize.x)
            {
                float distance = scroll.x - (m_BoundingBox.right - ContainerSize.x);
                float newDistance = DistanceDamping(distance);//将线性距离变为减速运动的距离

                float cz = newDistance - distance; 
                scroll.x += cz;
            }

            if (scroll.x < m_BoundingBox.left)
            {
                float distance = scroll.x - m_BoundingBox.left;
                float newDistance = DistanceDamping(distance);//将线性距离变为减速运动的距离

                float cz = newDistance - distance; 
                scroll.x += cz;
            }

            if (scroll.y > m_BoundingBox.bottom - ContainerSize.y)
            {
                float distance = scroll.y - (m_BoundingBox.bottom - ContainerSize.y);
                float newDistance = DistanceDamping(distance);//将线性距离变为减速运动的距离

                float cz = newDistance - distance; 
                scroll.y += cz;
            }

            if (scroll.y < m_BoundingBox.top)
            {
                float distance = scroll.y - m_BoundingBox.top;
                float newDistance = DistanceDamping(distance);//将线性距离变为减速运动的距离

                float cz = newDistance - distance; 
                scroll.y += cz;
            }



            //对拖拽偏移进行纠错
            if (scroll.x > m_BoundingBox.right + SpringRange_Right - ContainerSize.x)
                scroll.x = m_BoundingBox.right + SpringRange_Right - ContainerSize.x;


            if (scroll.x < m_BoundingBox.left - SpringRange_Left)
                scroll.x = m_BoundingBox.left - SpringRange_Left;


            if (scroll.y > m_BoundingBox.bottom + SpringRange_Bottom - ContainerSize.y  )
                scroll.y = m_BoundingBox.bottom + SpringRange_Bottom - ContainerSize.y  ;


            if (scroll.y < m_BoundingBox.top - SpringRange_Top)
                scroll.y = m_BoundingBox.top - SpringRange_Top;

        }

        m_Scroll = scroll;
        //Debug.Log("c#Scroll:" + m_Scroll.ToString());

        UpdateItemPos();
    }


    public void OnPress(bool isPressed)
    {
        if(isPressed)
        {
            //Debug.Log("ScrllContainer.OnMouseDown#1" + Input.touches.Length.ToString());
            //if (Input.touches.Length != 1) return;
            //Debug.Log("ScrllContainer.OnMouseDown#2");
            m_toucheOffset = Vector2.zero; //Input.touches[0].position;
            m_StartScroll = m_Scroll;
            m_isDraging = false;

            //停止协程
            if (m_Coroutine != null)
            {
                StopCoroutine(m_Coroutine);
                m_Coroutine = null;
            }
        }else
        {
            _OnMouseUp();
        }
    }

    void _OnMouseUp()
    {
        if (!m_isDraging) return;
        m_isDraging = false;

        Vector2 endScroll = m_Scroll;
        Vector2 speed = SpringSpeed;
        if (speed.x < 0.0001f) speed.x = 0.0001f;
        if (speed.y < 0.0001f) speed.y = 0.0001f;

        //距离上次拖拽的时间间隔
        float timeSpan =(float)( Process.GetCurrentProcess().TotalProcessorTime.TotalSeconds - m_lastMomentumTime);

        float tspanXS = (0.5f - timeSpan) / 0.5f;//时间差量系数

        //处理x惯性
        if (
            Momentum.x > 0&&//x方向存在惯性
            tspanXS > 0 &&//时间衰减，不至于完全阻止惯性
            endScroll.x > m_BoundingBox.left&&
            endScroll.x < m_BoundingBox.right - ContainerSize.x
            )
        {
            float gx = m_lastMomentum.x * Momentum.x * tspanXS;
            endScroll.x = m_Scroll.x + gx;  //计算落点

            speed.x = gx;
        }

        //处理y惯性
        if (
            Momentum.y > 0 &&//y方向存在惯性
            tspanXS > 0 &&//时间衰减，不至于完全阻止惯性
            endScroll.y > m_BoundingBox.top&&
            endScroll.y < m_BoundingBox.bottom - ContainerSize.y
            )
        {
            float gx = m_lastMomentum.y * Momentum.y * tspanXS;
            endScroll.y = m_Scroll.y + gx;  //计算落点

            speed.y = gx;
        } 

        //对x落点进行纠错
        if (endScroll.x < m_BoundingBox.left)
            endScroll.x = m_BoundingBox.left;
        else if (endScroll.x > m_BoundingBox.right - ContainerSize.x )
            endScroll.x = m_BoundingBox.right - ContainerSize.x ;


        //对y落点进行纠错
        if (endScroll.y < m_BoundingBox.top)
            endScroll.y = m_BoundingBox.top;
        else if (endScroll.y > m_BoundingBox.bottom - ContainerSize.y )
            endScroll.y = m_BoundingBox.bottom - ContainerSize.y;

        //启动协程来处理位移
        if (m_Coroutine == null) m_Coroutine = StartCoroutine(coScrollTo(endScroll, speed));
    }

     IEnumerator coScrollTo(Vector2 endScroll, Vector2 speed)
     {

         Vector2 startScroll = m_Scroll;  //记录当前Scroll
         float xtime = speed.x==0?0: Mathf.Abs((endScroll.x - startScroll.x) / speed.x);//计算出线性插值需要的时间
         float ytime =  speed.y==0?0: Mathf.Abs( (endScroll.y - startScroll.y) / speed.y);
         float countTime = Mathf.Max(ytime, xtime);
         float lostTime = 0;

         if (countTime <= 0)
         {
             m_Coroutine = null;
             yield break;
         }

         while (true)
         {
             m_Scroll = Vector2.Lerp(startScroll, endScroll,(float)Math.Sqrt(lostTime / countTime) );//减速插值
             
             UpdateItemPos();//应用偏移量 

             if (lostTime == countTime) break ;

             yield return null;

             lostTime += Time.deltaTime;
             if (lostTime > countTime) lostTime = countTime;
         }

         m_Coroutine = null;
     }
     

    ScrollItem[] items = null;


    /// <summary>
    /// 滚动偏移，位移量
    /// </summary>
    Vector2 m_Scroll = Vector2.zero;
    Vector2 m_StartScroll = Vector2.zero;
    BoundingBox2D m_BoundingBox = new BoundingBox2D(); 
    Vector2 m_toucheOffset;
    bool m_isDraging = false;
    Vector2 m_lastMomentum;
    double m_lastMomentumTime;
    Coroutine m_Coroutine = null;
}


interface ScrollItem //
{
    Vector2 pos { get; }

    Vector2 size { get; }

    /// <summary>
    /// 滚动偏移，位移量
    /// </summary>
    Vector2 Scroll { get; set; }
}

public class LuaScrollItem : MonoBehaviour, ScrollItem
{
    int m_refLuaClass = 0;
    /*
    public void SetLuaClass(ILuaState lua, int luaClass)
    {
        if (m_refLuaClass != 0) lua.L_Unref(LuaDef.LUA_REGISTRYINDEX, m_refLuaClass);
        m_refLuaClass = luaClass;
    }
    */
    void OnDestroy()
    {
        //SetLuaClass(LuaRoot._Lua, 0);
    }


    public Vector2 pos
    {
        get
        {
            if (m_refLuaClass != 0)
            {
                return new Vector2(0,0);
                //return LuaCall.CallLuaInterfaceRV2(m_refLuaClass, "GetItemPos"); 
            }
            else
            {
                return Vector2.zero;
            }
        }
    }

    public Vector2 size
    {
        get
        {
            if (m_refLuaClass != 0)
            {
               // return LuaCall.CallLuaInterfaceRV2(m_refLuaClass, "GetItemSize");
                return new Vector2(0, 0);
            }
            else
            {
                return Vector2.zero;
            }
        }
    }

    /// <summary>
    /// 滚动偏移，位移量
    /// </summary>
    public Vector2 Scroll
    {
        get
        {
            if (m_refLuaClass != 0)
            {
                //return LuaCall.CallLuaInterfaceRV2(m_refLuaClass, "GetItemScroll");
                return new Vector2(0, 0);
            }
            else
            {
                return Vector2.zero;
            }
        }
        set
        {
            if (m_refLuaClass != 0)
            {
                /*
                LuaVector2Lib._wrap(LuaRoot._Lua, value);
                int luaV2Ref = LuaRoot._Lua.L_Ref(LuaDef.LUA_REGISTRYINDEX);
                using (LuaValue_Any luaV2 = new LuaValue_Any(luaV2Ref))
                {
                    LuaCall.CallLuaInterface(m_refLuaClass, "SetItemScroll", luaV2);
                }*/
            }
        }
    }
}
 
