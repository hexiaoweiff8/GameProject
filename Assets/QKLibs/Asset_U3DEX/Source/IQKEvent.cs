using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public interface IEventCallback : IDisposable
{
    void Call(object param);
}
 

public interface IQKEvent : IDisposable
{
    void AddCallback(IEventCallback callBack);
    void RemoveCallback(IEventCallback callBack);

    void Call(object param);
}

public interface IQKDelegate  : IDisposable
{
    object Call(object param);
}


public class DelegateProperty: IDisposable
{
    public IQKDelegate Get() { return m_v; }

    public void Set(IQKDelegate luaDelegate)
    {
        if (m_v == luaDelegate) return;
        if (m_v != null) m_v.Dispose();
        m_v = luaDelegate;
    }

    public void Dispose() {    Set(null); }

    IQKDelegate m_v = null;
}




public class QKEvent : IQKEvent
{
    public void AddCallback(IEventCallback callBack)
    {
        m_Callbacks.Add(callBack);
    }

    public void RemoveCallback(IEventCallback callBack)
    {
        callBack.Dispose();

        if (m_Callbacks.Contains(callBack))
            m_Callbacks.Remove(callBack);
    }

    public void Call(object param)
    {
        HashSet<IEventCallback> clondCallbacks = new HashSet<IEventCallback>();
        foreach (IEventCallback curr in m_Callbacks) clondCallbacks.Add(curr);

        foreach (IEventCallback curr in clondCallbacks)
        {
            curr.Call(param);
        }
    }

    public void Dispose()
    {
        foreach (IEventCallback curr in m_Callbacks)
        {
            curr.Dispose();
        }
        m_Callbacks.Clear();
    }

    public bool HasCallback { get { return m_Callbacks.Count > 0; } }

    HashSet<IEventCallback> m_Callbacks = new HashSet<IEventCallback>();
}
