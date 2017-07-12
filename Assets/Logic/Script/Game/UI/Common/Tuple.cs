using System;
/*
    .NET Framework 4.7
    File: system\tuple.cs
    Project: ndp\clr\src\bcl\mscorlib.csproj (mscorlib)
*/
public static class Tuple
{
    public static Tuple<T1, T2> Create<T1, T2>(T1 item1, T2 item2)
    {
        return new Tuple<T1, T2>(item1, item2);
    }
    public static Tuple<T1, T2, T3> Create<T1, T2, T3>(T1 item1, T2 item2, T3 item3)
    {
        return new Tuple<T1, T2, T3>(item1, item2, item3);
    }
}

[Serializable]
public class Tuple<T1, T2>
{

    private readonly T1 m_Item1;
    private readonly T2 m_Item2;

    public T1 Item1 { get { return m_Item1; } }
    public T2 Item2 { get { return m_Item2; } }

    public Tuple(T1 item1, T2 item2)
    {
        m_Item1 = item1;
        m_Item2 = item2;
    }

}

[Serializable]
public class Tuple<T1, T2, T3>
{

    private readonly T1 m_Item1;
    private readonly T2 m_Item2;
    private readonly T3 m_Item3;

    public T1 Item1 { get { return m_Item1; } }
    public T2 Item2 { get { return m_Item2; } }
    public T3 Item3 { get { return m_Item3; } }

    public Tuple(T1 item1, T2 item2, T3 item3)
    {
        m_Item1 = item1;
        m_Item2 = item2;
        m_Item3 = item3;
    }

}