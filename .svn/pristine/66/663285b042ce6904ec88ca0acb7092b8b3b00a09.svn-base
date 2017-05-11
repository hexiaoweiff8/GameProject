using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine; 
public class wnd_poptip : wnd_base
{
    public const string ResName = "ui_poptip";
    public const string DependPacks = "rom_share";

    class TipItem
    {
        public GameObject obj;
        public float lostTime;
    }

    public wnd_poptip()
        : base(ResName)
    {
        WndManage.Single.RegWnd(ResName, DependPacks,  15, WndFadeMode.Alpha, WndAnimationMode.situ);
        Single = this;
        Show(1);
    }

    protected override void OnLostInstance()
    { 
    }

    void OnDestroyItem(object param)
    {
        GameObject obj = param as GameObject;
        if (obj == null) return;
        for (int nIndex = 0; nIndex < m_PopingObjs.Count;nIndex++ )
        {
            if(m_PopingObjs[nIndex].obj == obj)
            {
                m_PopingObjs.RemoveAt(nIndex);
                break;
            }
        }
        GameObject.Destroy(obj);
    }

    protected override void OnNewInstance()
    {
        

        //将模板隐藏掉
        m_ItemMB = m_instance.FindWidget("item");
        m_ItemMB.SetActive(false);

        m_HideposObj= m_instance.FindWidget("hidepos");
        m_HideposObj.SetActive(false);


        UIWidget itemWidget = m_ItemMB.GetComponent<UIWidget>();
        m_ItemHeight = itemWidget.height;

        m_StartY = itemWidget.transform.localPosition.y;

        m_EndY = m_HideposObj.transform.localPosition.y;
        //item/Label
        //hidepos
    }

    public void PopMsg(string msg)
    {
        PopMsg(  msg,Color.white);
    }
    public bool IsSameItem(string msg)
    {
        bool isSame = false;
        for (int nIndex = 0; nIndex < m_PopingObjs.Count;nIndex++ )
        {
            TipItem pItem = m_PopingObjs[nIndex];
            UILabel lbl = pItem.obj.GetComponentInChildren<UILabel>();
            if (lbl == null) continue;
            if(lbl.text == msg)
            {
                isSame = true;
                pItem.lostTime = 0.0f;
                break;
            }
        }

        return isSame;
    }
    //弹出一个消息
    public void PopMsg(string msg,Color color)
    {
        float minY = m_StartY + (float)m_PopingObjs.Count* m_ItemHeight;

        if (IsSameItem(msg))
            return;

        //将一些过矮的元素提升
        foreach(TipItem curr in m_PopingObjs)
        {
            GameObject obj = curr.obj;
            if (obj.transform.localPosition.y < minY)
            {
                Vector3 pos = obj.transform.localPosition;
                pos.y = minY;
                obj.transform.localPosition = pos;
            }

            minY -= m_ItemHeight;
        }

        //创建item对象
        GameObject item = GameObjectExtension.InstantiateFromPreobj(m_ItemMB, m_ItemMB.transform.parent.gameObject);
        item.SetActive(true);
        NGUITools.MarkParentAsChanged(item);

        TipItem newItem = new TipItem() { lostTime = 0, obj = item };

        m_PopingObjs.Add(newItem);

        //设置标签
        string[] findpath = new string[1];
        findpath[0] = "Label";

        GameObject lableObj = GameObjectExtension.FindChild(item.transform, findpath).gameObject;
        UILabel cmlabel = lableObj.GetComponent<UILabel>();
        cmlabel.text = msg;
        cmlabel.color = color;

        //解除位置绑定关系
        UIRect cm_rect = item.GetComponent<UIRect>();
        cm_rect.SetAnchor((GameObject)null);

        if (!m_CoroutineIsDoing)
            CoroutineManage.Single.StartCoroutine(coUpdate());
    }


    const float waitTime = 3;//等待时间
    const float movespeed = 100.0f;//移动速度
    //更新popTip位置
    IEnumerator coUpdate()
    {
        m_CoroutineIsDoing = true;

        while (m_PopingObjs.Count>0)
        {
            //List<TipItem> needRemove = new List<TipItem>();
            float deltaTime = Time.deltaTime;
            for (int nIndex = 0; nIndex < m_PopingObjs.Count; nIndex++ )
            {
                m_PopingObjs[nIndex].lostTime += deltaTime; 
            }
            //foreach (TipItem curr in m_PopingObjs)
            //{
            //    curr.lostTime += deltaTime;
            //}
            //foreach (TipItem curr in m_PopingObjs)
            for (int nIndex = 0; nIndex < m_PopingObjs.Count; nIndex++)
            {
                TipItem curr = m_PopingObjs[nIndex];
                if (curr.lostTime < waitTime) continue;
                if (curr.obj == null) continue;
                GameObject obj = curr.obj;
               
                UIWidget cm_widget = obj.GetComponent<UIWidget>();

                //计算tween起始和结束位置
                Vector3 endpos = obj.transform.localPosition;
                endpos.y = m_EndY;

                Vector3 frompos = obj.transform.localPosition;

                //防止poptip反向移动
                if (endpos.y < frompos.y) endpos.y = frompos.y + 10;

                float hideDuration = (endpos.y - frompos.y) / movespeed;

                //设置位置tween参数
                {
                    TweenPosition tweenPositionCM = obj.GetComponent<TweenPosition>();
                    tweenPositionCM.from = frompos;
                    tweenPositionCM.to = endpos;
                    tweenPositionCM.duration = hideDuration;
                    tweenPositionCM.style = TweenAlpha.Style.Once;
                    tweenPositionCM.enabled = true; 
                }

                //设置alpha tween参数
                {
                    TweenAlpha alphaCM = obj.GetComponent<TweenAlpha>();
                    alphaCM.from = cm_widget.alpha;
                    alphaCM.to = 0;
                    alphaCM.duration = hideDuration;
                    alphaCM.style = TweenAlpha.Style.Once;
                    alphaCM.enabled = true;
                }

                //m_PopingObjs.Remove(curr);

                //定时销毁这个对象 
                new MonoEX.Timer(hideDuration + 1).Play().OnComplete(() => OnDestroyItem(curr.obj));
                break;
            }

             

            yield return null;
        }

        m_CoroutineIsDoing = false;
    }

    
    List<TipItem> m_PopingObjs = new List<TipItem>();
   // List<TipItem> m_RemoveCache = new List<TipItem>();
    GameObject m_HideposObj;
    GameObject m_ItemMB;
    float m_ItemHeight;
    float m_StartY;
    float m_EndY;
    bool m_CoroutineIsDoing = false;
    public static wnd_poptip Single = null;
} 