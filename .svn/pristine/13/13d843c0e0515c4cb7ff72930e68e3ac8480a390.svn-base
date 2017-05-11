using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
 

//游戏配置组件
[AddComponentMenu("QK/GameConfig")]
public class GameConfig : MonoBehaviourSingleton<GameConfig>
{
    void Awake()
    {
        KeyValue[] kvs = GetComponents<KeyValue>();
        foreach(KeyValue curr in kvs)  m_keyvalues.Add(curr.key, curr.value);
    }

     

    public string GetValue(string key)
    {
        if (!m_keyvalues.ContainsKey(key)) return null;
        return m_keyvalues[key];
    }

    public bool IsDev {
        get {
            string v = GetValue("IsDev");
            if (v == null) return false;

            return v == "true";
        }
    }

    

    Dictionary<string, string> m_keyvalues = new Dictionary<string,string>();
}
 