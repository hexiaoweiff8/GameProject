using System;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using LuaInterface;


public class Wnd : IDisposable
{
    /// <summary>
    /// show destroy hide preload（预加载） 分别对应wndmanager 最重要的四个对外接口的枚举
    /// </summary>
    public static LuaFunction OnShowFinish = LuaClient.GetMainState().GetFunction("OnShowFinish");
    public static LuaFunction OnDestroyFinish = LuaClient.GetMainState().GetFunction("OnDestroyFinish");
    public static LuaFunction OnHideFinish = LuaClient.GetMainState().GetFunction("OnHideFinish");
    public static LuaFunction OnPreLoadFinish = LuaClient.GetMainState().GetFunction("OnPreLoadFinish");
    /// <summary>
    /// 在wnd未被释放之前调用show 会触发此方法
    /// </summary>
    public static LuaFunction OnReOpenWnd = LuaClient.GetMainState().GetFunction("OnReOpenWnd");

    /// <summary>
    /// 对应缓动结束后的回调 主要处理一些界面动画播放完之后的刷新等操作
    /// </summary>
    public static LuaFunction OnShowFinishEnd = LuaClient.GetMainState().GetFunction("OnShowFinishEnd");
    public static LuaFunction OnDestroyFinishEnd = LuaClient.GetMainState().GetFunction("OnDestroyFinishEnd");
    public const float DefaultDuration = 0.5f;
    public Wnd(GameObject panelObj, GameObject baffleObj, wndInfo wInfo)
    {
        m_panelObj = panelObj;
        m_baffleObj = baffleObj;
        m_wInfo = wInfo;

        m_wndObj = panelObj.transform.GetChild(0).gameObject;
    }

    public void _Hide(float duration, WShowType wt, int depth)
    {
        _ShowHide(false, duration, wt, depth);
    }

    public void _Show(float duration)
    {
        _ShowHide(true, duration, WShowType.show);
    }

    public string Name { get { return m_wInfo.name; } }

    void tweenShowHide(bool isShow, float t)
    {
        if (m_wndObj == null) return;

        if (m_wInfo.fade == WndFadeMode.Alpha || m_wInfo.fade == WndFadeMode.ScaleAlpha)//补间alpha
        {
            if (isShow)
                m_wndObj.GetComponent<UIWidget>().alpha = DP_TweenFuncs.Tween_Linear_Float(0, 1, t);
            else
                m_wndObj.GetComponent<UIWidget>().alpha = DP_TweenFuncs.Tween_Linear_Float(m_TweenStartAlpha, 0, t);
        }

        if (m_wInfo.fade == WndFadeMode.Scale || m_wInfo.fade == WndFadeMode.ScaleAlpha)//补间缩放
        {
            if (isShow)
            {
                var s = WndConfig.Single.WndScaleEnterCurve.Evaluate(t);
                m_wndObj.transform.localScale = new Vector3(s, s, s);
            }
            else
            {
                var x = DP_TweenFuncs.Tween_Linear_Float(m_TweenStartScale.x, 0, t);
                var y = DP_TweenFuncs.Tween_Linear_Float(m_TweenStartScale.y, 0, t);
                var z = DP_TweenFuncs.Tween_Linear_Float(m_TweenStartScale.z, 0, t);
                m_wndObj.transform.localScale = new Vector3(x, y, z);
            }
        }

        if (m_wInfo.animaMode != WndAnimationMode.situ)
        {
            Vector3 startPos = Vector3.zero;
            UIWidget widget = m_wndObj.GetComponent<UIWidget>();
            //处理出场模式
            switch (m_wInfo.animaMode)
            {
                case WndAnimationMode.down:
                    {
                        startPos.y = widget.height;
                    }
                    break;
                case WndAnimationMode.up:
                    {
                        startPos.y = -widget.height;
                    }
                    break;
                case WndAnimationMode.left:
                    {
                        startPos.x = -widget.width;
                    }
                    break;
                case WndAnimationMode.right:
                    {
                        startPos.x = widget.width;
                    }
                    break;
            }

            if (isShow)
            {

                m_wndObj.transform.localPosition = new Vector3(
                   DP_TweenFuncs.Tween_Linear_Float(startPos.x, 0, t),
                   DP_TweenFuncs.Tween_Linear_Float(startPos.y, 0, t),
                   DP_TweenFuncs.Tween_Linear_Float(startPos.z, 0, t)
                   );

            }
            else
            {
                m_wndObj.transform.localPosition = new Vector3(
                   DP_TweenFuncs.Tween_Linear_Float(m_TweenStartPos.x, startPos.x, t),
                   DP_TweenFuncs.Tween_Linear_Float(m_TweenStartPos.y, startPos.y, t),
                   DP_TweenFuncs.Tween_Linear_Float(m_TweenStartPos.z, startPos.z, t)
                   );
            }
        }
    }


    Vector3 m_TweenStartScale;
    Vector3 m_TweenStartPos;
    float m_TweenStartAlpha;

    void _ShowHide(bool isShow, float duration, WShowType wt,int depth = 0)
    {
        //移除所有现有的显示效果
        StopAllTweener();

        if (isShow && !m_panelObj.activeSelf)
        {
            m_panelObj.SetActive(true);
        }

        if (isShow) m_Visible = true;

        if (duration > 0)//需要做动画
        {
            //显示挡板
            m_baffleObj.GetComponent<UIWidget>().depth = 99999;

            UIWidget widget = m_wndObj.GetComponent<UIWidget>();
            if (widget)
            {
                widget.SetAnchor((GameObject) null); //解除锚点

                m_TweenStartScale = m_wndObj.transform.localScale;
                m_TweenStartPos = m_wndObj.transform.localPosition;
                m_TweenStartAlpha = m_wndObj.GetComponent<UIWidget>().alpha;
                var t = 0f;
                m_Tween = DOTween.To(() => t, (v) =>
                {
                    t = v;
                    tweenShowHide(isShow, v);
                }, 1, duration).SetAutoKill(true).SetEase(Ease.Linear)
                    .OnComplete(() =>
                    {
                        m_baffleObj.GetComponent<UIWidget>().depth = -99;

                        if (isShow)
                        {
                            OnShowFinishEnd.Call(this);
                        }
                        else
                        {
                            _DoHide(wt, depth);
                        }
                    }
                    );
                m_Tween.SetUpdate(true);
            }
            else
            {
                if (isShow)
                {
                    OnShowFinishEnd.Call(this);
                }
                else
                {
                    _DoHide(wt, depth);
                }
            }
            

        }
        else//瞬间完成
        {
            if (isShow)
            {
                m_wndObj.GetComponent<UIWidget>().alpha = 1;
                m_wndObj.transform.localScale = Vector3.one;
                OnShowFinishEnd.Call(this);
            }
            else
                _DoHide(wt,depth);
        }
    }


    public GameObject FindWidget(string objName)
    {
        string[] name_path = objName.Split('/');

        Transform tf = GameObjectExtension.FindChild(m_wndObj.transform, name_path);
        return (tf == null) ? null : tf.gameObject;
    }

    public GameObject GetGameObject()
    {
        return m_wndObj;
    }


    void _DoHide(WShowType wt,int depth)
    {
        if (m_panelObj == null) return;
        if (wt == WShowType.hide)
        {
            m_panelObj.SetActive(false); //关闭一切逻辑，并隐藏
            UIPanel[] panels = m_panelObj.transform.GetComponentsInChildren<UIPanel>(true);
            for (int i = 0; i < panels.Length; i++)
            {
                panels[i].depth -= depth;
            }
            m_Visible = false;
            WndManage.Single._OnWndHide(m_wInfo.name);//通知界面隐藏
        }
        else
        {
            WndManage.Single.DestroyWnd(WndManage.Single._GetWnd(m_wInfo.name));
            OnDestroyFinishEnd.Call(this);
        }
        
    }


    public void Dispose()
    {

        StopAllTweener();

        //if (m_Visible)
        //    _DoHide(WShowType.hide);


        if (m_panelObj != null)
        {
            GameObject.Destroy(m_panelObj);
            m_panelObj = null;
            //showCount = 0;
        }
    }
    void StopAllTweener()
    {
        if (m_Tween != null && m_Tween.IsActive())
        { m_Tween.Kill(); m_Tween = null; }
    }

    public bool IsVisible { get { return m_Visible; } }

    bool m_Visible = false;
    public GameObject m_wndObj = null;
    public GameObject m_panelObj = null;
    public GameObject m_baffleObj = null;
    wndInfo m_wInfo = null;
    Tweener m_Tween = null;

}

public class wndShowHideInfo
{
    public string name;
    //逻辑当前是希望它显示还是隐藏,还是预加载
    public WShowType needVisible = WShowType.hide;
    public float duration;//延迟
    //基础深度
    public int PlantfromDetph;
    public bool isWithBg;
}
public enum WShowType
{
    hide,
    show,
    preLoad,
    destroy,
}


public class wndInfo : ICloneable
{
    public string name;
    public List<string> dependPackets = null;
    public WndFadeMode fade;
    public WndAnimationMode animaMode;
    public bool isVisible = false;//当前是否处于显示状态
    public int cacheTime;
    public object Clone()
    {
        return this.MemberwiseClone();
    }
}


//渐显渐隐模式
public enum WndFadeMode
{
    None = 0,//没有渐显效果
    ScaleAlpha = 1,//一边缩放，一边半透
    Alpha = 2,//半透
    Scale = 3, //缩放
}

//窗体动画模式
public enum WndAnimationMode
{
    situ = 0,//原地不动的
    down = 1,//从上方掉下来
    up = 2,//从下方升起
    left = 3,//从左边拉出
    right = 4,//从右边拉出
}

