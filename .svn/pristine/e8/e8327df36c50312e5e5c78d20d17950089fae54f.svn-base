using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class UTimer : MonoBehaviour
{
    public MonoEX.Timer Reset(float live)
    {
        if (m_Timer != null) m_Timer.Kill();
        m_Timer = new MonoEX.Timer(live)
                .OnComplete(() => { if (OnComplete != null) OnComplete(); })
                .OnKill(() => { if (OnKill!=null) OnKill(); });

        //当前处于启用状态，立即运行
        if (enabled) m_Timer.Play();

        return m_Timer;
    }

    public MonoEX.Timer TimerHandel { get { return m_Timer; } }

    void OnEnable()
    {
        if (m_Timer == null) return;
        m_Timer.Play();
    }
    void OnDisable() {
        if (m_Timer == null) return;
        m_Timer.Pause();
    }

    public event Action OnComplete;
    public event Action OnKill;


    void OnDestroy()
    {
        if (m_Timer != null)  m_Timer.Kill();

       // OnComplete = null;
       // OnKill = null;
    }

    /*
    public LuaEvent OnComplete { 
        get { return _OnComplete; }
        set { 
            if (_OnComplete == value) return;
            if (_OnComplete != null) _OnComplete.Dispose();
            _OnComplete = value;
        } 
    }
    public LuaEvent OnKill {
        get { return _OnKill; }
        set
        {
            if (_OnKill == value) return;
            if (_OnKill != null) _OnKill.Dispose();
            _OnKill = value;
        } 
    }


    LuaEvent _OnComplete = null;
    LuaEvent _OnKill = null;
    */

    MonoEX.Timer m_Timer = null;
}