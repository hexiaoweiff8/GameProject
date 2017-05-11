using System;
using System.Collections.Generic;
using UnityEngine;
 
class CoderTime:IDisposable
{
    public CoderTime(string name, float leastTime=0f)
    {
        m_Name = name;
        m_StartTime = DateTime.Now;
        m_LeastTime = leastTime;
    }

    public void Dispose()
    {
        var t = (DateTime.Now - m_StartTime).TotalSeconds;
        if (t >= m_LeastTime)
        Debug.Log(
            string.Format("coderTime name:\"{0}\" span:{1} seconds", m_Name, t)
        );
    }

    DateTime m_StartTime;
    string m_Name;
    float m_LeastTime;
} 