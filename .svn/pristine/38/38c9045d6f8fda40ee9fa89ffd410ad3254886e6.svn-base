using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
/// <summary>
/// AI线程
/// </summary>
class AI_Thread
{
    public  static AI_Thread Single = null;

    public AI_Thread()
    {
        Single = this;

        Thread t = new Thread(new ThreadStart(T_Main));
        t.Start();
    }

    public  void T_Main()
    {
        T_Reset();

        while (true)
        {
            lock (MutexLock)
            {
                T_Do();
            }

            Thread.Sleep(2);
        }
    }

    public void T_Do()
    {
        //using (new CoderTime("###########AI_Thread",0.05f))
        while (AI_Single.Single.Battlefield.TotalLostTime < m_EndTime)
            AI_Single.Single.Battlefield.IterationNext();//迭代AI  
    }

    public void T_Reset()
    {
        m_EndTime = 0.0f; 
    }

    /// <summary>
    /// 设定当前可执行AI的结束时间点
    /// </summary>
    /// <param name="time"></param>
    public void T_SetEndTime(float time)
    {
        if (time > m_EndTime) m_EndTime = time;
        //Interlocked.Exchange(ref m_EndTime, time);
    }

    public Object MutexLock  = new Object();

    float m_EndTime ; 
} 
