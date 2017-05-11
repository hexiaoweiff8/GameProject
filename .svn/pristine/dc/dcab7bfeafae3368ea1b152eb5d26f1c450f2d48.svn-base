using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SafeObjects : IDisposable
{
    public void Add(IDisposable obj)
    {
        if (obj == null) return;
        m_Objects.Add(obj);
    }

    public void Dispose()
    {
        foreach (IDisposable curr in m_Objects) curr.Dispose();
        m_Objects.Clear();
    }

    HashSet<IDisposable> m_Objects = new HashSet<IDisposable>();
}