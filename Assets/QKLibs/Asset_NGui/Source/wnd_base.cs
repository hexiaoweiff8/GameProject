public abstract class wnd_base
{
    public wnd_base(string name)
    {
        m_name = name;
        WndManage.Single.OnWndDestroy += OnWndDestroy;
    }

    void OnWndDestroy(Wnd wnd)
    {
        if (wnd == m_instance)
        {
            OnLostInstance();
            m_instance = null;
        }
    }

    public void Hide(float duration)
    {
        m_isVisible = false;
    }

    public void Show(float duration)
    {
        m_isVisible = true;
    }

    protected abstract void OnLostInstance();
    protected abstract void OnNewInstance();

    protected virtual void OnShowfinish() { }

    public bool IsVisible { get { return m_isVisible; } }
    public Wnd Instance { get { return m_instance; } }

    //IQKEvent evt_showfinish = new IQKEvent();
    //float m_lastHideDuration = 0;
    protected string m_name;
    protected bool m_isVisible = false;
    protected Wnd m_instance = null;
}

