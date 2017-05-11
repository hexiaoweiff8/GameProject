using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public static class NGuiHelper
{
    //深度对齐到某个参考物
    //mode 小于0表示，低于参考物
    //     等于0表示，和参考物保持一致
    //     大于0表示，高于参考物
    //
    //IgnoreReferenceChild 忽略参考物的子物体
    public static void DepthAlignment(GameObject tagetobj, GameObject referenceObject, int mode, bool IgnoreReferenceChild)
    {
        int tagetDepth;
        int referenceDepth;
        if (mode == 0)
        {
            tagetDepth = tagetobj.GetComponent<UIWidget>().depth;
            referenceDepth = referenceObject.GetComponent<UIWidget>().depth;
        }
        else if (mode > 0)
        {
            tagetDepth = tagetobj.GetComponent<UIWidget>().depth;

            if (IgnoreReferenceChild)
                referenceDepth = referenceObject.GetComponent<UIWidget>().depth + 1;
            else
                referenceDepth = GetMaxDepth(referenceObject) + 1;
        }
        else
        {
            tagetDepth = GetMaxDepth(tagetobj);
            referenceDepth = referenceObject.GetComponent<UIWidget>().depth - 1;
        }
        DepthUpward(tagetobj, referenceDepth - tagetDepth);
    }

    public static void MarkParentAsChanged(GameObject obj)
    {
        NGUITools.MarkParentAsChanged(obj);
    }

    //无条件提升某个GameObject的深度
    public static void DepthUpward(GameObject obj, int v)
    {
        UIWidget[] widgets = obj.GetComponents<UIWidget>();
        foreach (UIWidget curr in widgets)
        {
            curr.depth += v;
        }

        int count = obj.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            DepthUpward(obj.transform.GetChild(i).gameObject, v);
        }
    }

    public static float GetAlpha(GameObject obj)
    {
        UIRect mRect = obj.GetComponent<UIRect>();
        SpriteRenderer mSr = obj.GetComponent<SpriteRenderer>();
        Material mMat = null;
        if (mRect == null && mSr == null)
        {
            Renderer ren = obj.GetComponent<Renderer>();
            if (ren != null) mMat = ren.material;
            if (mMat == null) mRect = obj.GetComponentInChildren<UIRect>();
        }

        {
            if (mRect != null) return mRect.alpha;
            if (mSr != null) return mSr.color.a;
            return mMat != null ? mMat.color.a : 1f;
        }
    }



    /// <summary>
    /// 获取最大深度
    /// </summary>
    /// <param name="obj"></param>
    /// <returns></returns>
    static int GetMaxDepth(GameObject obj)
    {
        int maxDepth = -999999;
        UIWidget[] widgets = obj.GetComponents<UIWidget>();
        foreach (UIWidget curr in widgets)
        {
            if (curr.depth > maxDepth) maxDepth = curr.depth;
        }

        int count = obj.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            int childMax = GetMaxDepth(obj.transform.GetChild(i).gameObject);
            if (childMax > maxDepth) maxDepth = childMax;
        }
        return maxDepth;
    }


    public static void AlphaTo(GameObject obj, float toAlpha, float duration, EventDelegate onFinished)
    {
        if (obj == null) return;


        float currAlpha = NGuiHelper.GetAlpha(obj);
        TweenAlpha alphaCM = obj.GetComponent<TweenAlpha>();
        if (alphaCM != null)
        {
            //alphaCM.RemoveAllOnFinished();
            GameObject.Destroy(alphaCM);
        }


        alphaCM = obj.AddComponent<TweenAlpha>();

        alphaCM.from = currAlpha;
        alphaCM.to = toAlpha;

        alphaCM.duration = duration;
        alphaCM.style = TweenAlpha.Style.Once;

        if (onFinished != null) EventDelegate.Add(alphaCM.onFinished, onFinished, true);

        if (!obj.activeInHierarchy)
            obj.SetActive(true);
        alphaCM.PlayForward();
    }

    public static void FadeHide(GameObject obj, float duration)
    {
        if (obj == null) return;


        GameObjectExtensionRecall cmReCall = obj.AutoInstance<GameObjectExtensionRecall>();  

        EventDelegate eventDelegate = new EventDelegate(cmReCall, "OnFadeHideEnd");
        // eventDelegate.parameters[0] = new EventDelegate.Parameter(obj);
        AlphaTo(obj, 0, duration, eventDelegate);
    } 
     

    
} 