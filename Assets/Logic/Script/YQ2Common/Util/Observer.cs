using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 观察者管理器
/// </summary>
public class ObserverManager
{

    /// <summary>
    /// 通知者列表
    /// </summary>
    private IList<ISubject> subjectList = new List<ISubject>();


    /// <summary>
    /// 添加通知者
    /// </summary>
    /// <param name="subject"></param>
    public void AddSubject(ISubject subject)
    {
        subjectList.Add(subject);
    }

    /// <summary>
    /// 
    /// </summary>
    public void Update()
    {
        foreach (var subject in subjectList)
        {
            subject.Notify();
        }
    }

}



/// <summary>
/// 通知者虚类
/// </summary>
public abstract class Subject : ISubject
{
    /// <summary>
    /// 观察者列表
    /// </summary>
    private IList<IObserver> observerList = new List<IObserver>();


    /// <summary>
    /// 添加观察者
    /// </summary>
    /// <param name="observer">被添加观察者对象, 不能为null</param>
    public void AddObserver(IObserver observer)
    {
        if (observer != null)
        {
            observerList.Add(observer);
        }
    }

    /// <summary>
    /// 删除观察者
    /// </summary>
    /// <param name="observer">被删除观察者对象, 不能为null</param>
    public void RemoveObserver(IObserver observer)
    {
        if (observer != null)
        {
            observerList.Remove(observer);
        }
    }


    /// <summary>
    /// 通知方法
    /// </summary>
    public void Notify()
    {
        foreach (var observer in observerList)
        {
            observer.Update();
        }
    }
}


public abstract class Observer : IObserver
{
    /// <summary>
    /// 被通知方法
    /// </summary>
    public abstract void Update();
}

/// <summary>
/// 通知者接口
/// </summary>
public interface ISubject
{
    /// <summary>
    /// 通知方法
    /// </summary>
    void Notify();
}

/// <summary>
/// 观察者接口
/// </summary>
public interface IObserver
{
    /// <summary>
    /// 被通知方法
    /// </summary>
    void Update();
}