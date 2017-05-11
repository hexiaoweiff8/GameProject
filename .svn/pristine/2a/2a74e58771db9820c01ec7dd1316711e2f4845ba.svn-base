using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 变换混合器
/// </summary> 
[ExecuteInEditMode]
public class TransformMixer : MonoBehaviour
{ 
    void Awake()
    {
        //自动创建主位置变换
         AutoCreateMainPositionTransform();
         AutoCreateMainRotationTransform();
         AutoCreateMainScaleTransform();
         ManualUpdate();//立即刷新值
     } 

    public void ManualUpdate()
    {
        if (m_PositionTransformChanged)
        {
            m_PositionTransformChanged = false;

            m_TotalPositionTransform = Vector3.zero;
            foreach (PositionTransform curr in m_PositionTransforms) m_TotalPositionTransform += curr.Value;

            transform.localPosition = m_TotalPositionTransform;
        }

        if (m_RotationTransformChanged)
        {
            m_RotationTransformChanged = false;

            m_TotalRotationTransform = Quaternion.identity;
            foreach (RotationTransform curr in m_RotationTransforms) m_TotalRotationTransform *= curr.Value;

            transform.localRotation = m_TotalRotationTransform;
        }

        if (m_ScaleTransformChanged)
        {
            m_ScaleTransformChanged = false;

            m_TotalScaleTransform = Vector3.one;
            foreach (ScaleTransform curr in m_ScaleTransforms) m_TotalScaleTransform.Scale(curr.Value);

            transform.localScale = m_TotalScaleTransform;
        }
    }

    void LateUpdate() { ManualUpdate(); }

    public Vector3 TotalPositionTransform { get { return m_TotalPositionTransform; } }
    public Quaternion TotalRotationTransform { get { return m_TotalRotationTransform; } }

    public Vector3 TotalScaleTransform { get { return m_TotalScaleTransform; } }

    /// <summary>
    /// 根据tag获取位置变换器
    /// </summary> 
    public PositionTransform GetPositionTransform(string tag)
    {
       PositionTransform[] tlist =  GetComponents<PositionTransform>();
       int len = tlist.Length;
       for (int i = 0; i < len;i++ )
       {
           PositionTransform curr = tlist[i];
           if (curr.tag == tag) return curr;
       }
           
       return null;
    }

    public RotationTransform GetRotationTransform(string tag)
    {
        RotationTransform[] tlist = GetComponents<RotationTransform>();
        int len = tlist.Length;
        for (int i = 0; i < len; i++)
        {
            RotationTransform curr = tlist[i];
            if (curr.tag == tag) return curr;
        }

        return null;
    }

    public ScaleTransform GetScaleTransform(string tag)
    {
        ScaleTransform[] tlist = GetComponents<ScaleTransform>();
        int len = tlist.Length;
        for (int i = 0; i < len; i++)
        {
            ScaleTransform curr = tlist[i];
            if (curr.tag == tag) return curr;
        }

        return null;
    }


    /// <summary>
    /// 注册位置变换器
    /// </summary> 
    internal void _RegTransform(PositionTransform t)
    {
        m_PositionTransforms.Add(t);
        m_PositionTransformChanged = true;
    }

    /// <summary>
    /// 反注册一个位置变换器
    /// </summary>
    internal void _UnregTransform(PositionTransform t)
    {
        m_PositionTransforms.Remove(t);
        m_PositionTransformChanged = true;
    }

    internal void _RegTransform(RotationTransform t)
    {
        m_RotationTransforms.Add(t);
        m_RotationTransformChanged = true;
    }

    internal void _UnregTransform(RotationTransform t)
    {
        m_RotationTransforms.Remove(t);
        m_RotationTransformChanged = true;
    }

    internal void _RegTransform(ScaleTransform t)
    {
        m_ScaleTransforms.Add(t);
        m_ScaleTransformChanged = true;
    }

    internal void _UnregTransform(ScaleTransform t)
    {
        m_ScaleTransforms.Remove(t);
        m_ScaleTransformChanged = true;
    }
    /// <summary>
    /// 位置发生变化
    /// </summary>
    internal void _SetPositionChanged()    {  
        m_PositionTransformChanged = true;   
#if UNITY_EDITOR
        ManualUpdate();
#endif
    }

    internal void _SetRotationChanged()
    {
        m_RotationTransformChanged = true;
#if UNITY_EDITOR
        ManualUpdate();
#endif
    }

    internal void _SetScaleChanged()
    {
        m_ScaleTransformChanged = true;
#if UNITY_EDITOR
        ManualUpdate();
#endif
    }
    public PositionTransform MainPositionTransform
    {
        get
        {
#if UNITY_EDITOR
            //如果主位置变换被用户删除则自动创建
            AutoCreateMainPositionTransform();
            AutoCreateMainRotationTransform();
            AutoCreateMainScaleTransform();
#endif
            return m_MainPositionTransform;

        }
    }

    public RotationTransform MainRotationTransform
    {
        get
        {
#if UNITY_EDITOR
            //如果主变换被用户删除则自动创建
            AutoCreateMainRotationTransform();
#endif
            return m_MainRotationTransform;

        }
    }

    public ScaleTransform MainScaleTransform
    {
        get
        {
#if UNITY_EDITOR
            //如果主变换被用户删除则自动创建
            AutoCreateMainScaleTransform();
#endif
            return m_MainScaleTransform;

        }
    } 


    void AutoCreateMainPositionTransform()
    { 
        if (m_MainPositionTransform == null)
        {
            m_MainPositionTransform = GetPositionTransform("main");
            if (m_MainPositionTransform == null)
            {
                m_MainPositionTransform = gameObject.AddComponent<PositionTransform>();
                m_MainPositionTransform.tag = "main";
                _RegTransform(m_MainPositionTransform);//立即注册
            }
        } else
        {
            //手欠的用户更改了主变换器的tag
            if (m_MainPositionTransform.tag != "main") m_MainPositionTransform.tag = "main";
        }
    }

    void AutoCreateMainRotationTransform()
    {
        if (m_MainRotationTransform == null)
        {
            m_MainRotationTransform = GetRotationTransform("main");
            if (m_MainRotationTransform == null)
            {
                m_MainRotationTransform = gameObject.AddComponent<RotationTransform>();
                m_MainRotationTransform.tag = "main";
                _RegTransform(m_MainRotationTransform);//立即注册
            }
        }
        else
        {
            //手欠的用户更改了主变换器的tag
            if (m_MainRotationTransform.tag != "main") m_MainRotationTransform.tag = "main";
        }
    }

    void AutoCreateMainScaleTransform()
    {
        if (m_MainScaleTransform == null)
        {
            m_MainScaleTransform = GetScaleTransform("main");
            if (m_MainScaleTransform == null)
            {
                m_MainScaleTransform = gameObject.AddComponent<ScaleTransform>();
                m_MainScaleTransform.tag = "main";
                _RegTransform(m_MainScaleTransform);//立即注册
            }
        }
        else
        {
            //手欠的用户更改了主变换器的tag
            if (m_MainScaleTransform.tag != "main") m_MainScaleTransform.tag = "main";
        }
    }

    HashSet<PositionTransform> m_PositionTransforms = new HashSet<PositionTransform>();
    HashSet<RotationTransform> m_RotationTransforms = new HashSet<RotationTransform>();
    HashSet<ScaleTransform> m_ScaleTransforms = new HashSet<ScaleTransform>();

    Vector3 m_TotalPositionTransform;
    Quaternion m_TotalRotationTransform;
    Vector3 m_TotalScaleTransform;

    /// <summary>
    /// 位置变换是否产生过变化
    /// </summary>
    bool m_PositionTransformChanged = true;
    bool m_RotationTransformChanged = true;
    bool m_ScaleTransformChanged = true;

    PositionTransform m_MainPositionTransform = null;
    RotationTransform m_MainRotationTransform = null;
    ScaleTransform m_MainScaleTransform = null;
}