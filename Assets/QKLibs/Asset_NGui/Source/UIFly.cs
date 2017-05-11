using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//UI控件飞行组件
[AddComponentMenu("QK/UI/UIFly")]
public class UIFly : MonoBehaviour
{
    //飞行的目的地
    public Vector3 target = Vector3.zero;

    //强度
    public float strength = 10f;

    //是否采用世界空间坐标
    public bool worldSpace = true;

    //飞行过程中，是否将物体归属层变化到FlyRoot上
    public bool InFlyLayer = true;

    public delegate void OnFlyEnd();

    //飞行完成后的行为
    public enum FlyFinishedAction
    {
        Nothing = 0,//什么也不做
        DestroyComponet = 1,//销毁组件
        DestroyGameobject =  2,//销毁游戏物体
    }

    //飞行完成时的行为
    public FlyFinishedAction flyFinishedAction = FlyFinishedAction.Nothing; 
 
    //飞行完成时的事件回调
    /*public IQKEvent evt_Finished {
        get { return _evt_Finished; }
        set { if (_evt_Finished != null) _evt_Finished.Dispose(); _evt_Finished = value; }
    } 
  
    IQKEvent _evt_Finished = null;
     */

    public void StartFly(OnFlyEnd callBack)
    {
        if (InFlyLayer)
        {
            m_bakParent = gameObject.transform.parent;
            gameObject.transform.parent = UIFlyRoot.Single.transform;
            NGUITools.MarkParentAsChanged(gameObject);
        }

        //禁用物体上的碰检盒
        gameObject.EnableCollider(false);

        SpringPosition sp = SpringPosition.Begin(gameObject, target, strength);
        sp.worldSpace = worldSpace;
        sp.onFinished = ()=>onFinished(callBack);
    }

    static public UIFly Go(GameObject go, Vector3 pos, float strength)
    {
        UIFly sp = go.GetComponent<UIFly>();
        if (sp == null) sp = go.AddComponent<UIFly>();
        sp.target = pos;
        sp.strength = strength;
        //sp.evt_Finished = null; 
        sp.worldSpace = true;
        sp.InFlyLayer = true;
        sp.flyFinishedAction = FlyFinishedAction.Nothing; 
         
        return sp;
    }

    void onFinished(OnFlyEnd callBack)
    {
        if (m_bakParent != null)
        {
            gameObject.transform.parent = m_bakParent;
            NGUITools.MarkParentAsChanged(gameObject);
        }

        //if (evt_Finished != null) evt_Finished.Call(null);
        if (callBack != null) callBack();

        switch(flyFinishedAction)
        {
            case FlyFinishedAction.DestroyComponet:
                GameObject.Destroy(this);
                break;
            case FlyFinishedAction.DestroyGameobject:
                GameObject.Destroy(this.gameObject);
                break;
            default:
                {
                    //启用物体上的碰检盒 
                   gameObject.EnableCollider(  true); 
                }
                break;
        }
    }
     
    void OnDestroy()
    { 
        //evt_Finished = null;
    } 

    Transform m_bakParent = null;
}
 
