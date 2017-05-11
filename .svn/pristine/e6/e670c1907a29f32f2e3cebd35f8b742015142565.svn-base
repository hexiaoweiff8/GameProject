using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


public  class UROMSystem
{
    public const string object_name = "UROMSystem";

    static UROMSystem _Single = null;
 
    public static UROMSystem Single
    {
        get
        {
            if (_Single == null)  _Single = new UROMSystem();
            return _Single;
        }
    }

	public GameObject GameObject
	{
		get{ return m_GameObject;}
	}

    UROMSystem()
    {
        m_GameObject = GameObject.Find(object_name);

        if (m_GameObject == null)
        {
            m_GameObject = new GameObject(object_name); // 创建一个新的GameObject
            UnityEngine.Object.DontDestroyOnLoad(m_GameObject);// 防止被销毁
        }
    }

    public T AddComponent<T>() where T : Component
    {   
        return m_GameObject.AddComponent<T>();
    }

    public void RemoveComponent<T>()  where T : Component
    {
        T t = m_GameObject.GetComponent<T>();
        if (t != null) GameObject.Destroy(t);
    }

    GameObject m_GameObject = null;
}

