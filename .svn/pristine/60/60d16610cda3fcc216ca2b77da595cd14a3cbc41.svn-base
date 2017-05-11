using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public class AI_Timer
{
    public  event Action OnComplete;

    public void Start(float time)
    {
        m_Time = time;
        isRuning = true;
    }

    public void Stop()
    {
        m_Time = 0;
        isRuning = false;
    }

    public void AddTime(float time)
    {
        if (isRuning) m_Time -= time;
    }

    public void Update()
    {
        if (!isRuning) return;
        if (m_Time <= 0) { isRuning = false; OnComplete(); }
    }

    public bool IsRuning { get { return m_Time > 0; } }


    bool isRuning = false;
    float m_Time = 0;
} 
