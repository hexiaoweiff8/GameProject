using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SharpEventCallback : IEventCallback
{
    public delegate void CB_CallBack(object param);

    public SharpEventCallback(CB_CallBack callBack)
    {
        m_CallBack = callBack;
    }

    public void Call(object param)
    {
        m_CallBack(param);
    }

    public void Dispose()
    {

    }
    CB_CallBack m_CallBack;
}
