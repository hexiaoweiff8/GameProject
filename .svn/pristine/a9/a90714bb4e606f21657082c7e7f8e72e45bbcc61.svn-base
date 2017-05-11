using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;




//显示时间轴,u3d无关
public class DP_TimeLine //: MonoEX.Singleton<DP_TimeLine>
{
  
    public void AddNotbornActor(DPActor_Base actor)
    {
        m_NotbornActors.PushBack(actor);

        LinkList<DPActor_Base>.Node curr = m_NotbornActors.Back;
        while (curr.before != null)
        {
            if (curr.v.BirthTime < curr.before.v.BirthTime)
            {
                //交换
                DPActor_Base z = curr.v;
                curr.v = curr.before.v;
                curr.before.v = z;

                curr = curr.before;
            }
            else
                break;
        }
    }

    /// <summary>
    /// 剪掉指定时间之后的演员，不包括指定的这个时间点
    /// </summary>
    /// <param name="time"></param>
    public void Cut(float time)
    {
        while(m_NotbornActors.Back!=null && m_NotbornActors.Back.v.BirthTime>=time)
        {
            m_NotbornActors.RemoveNode(m_NotbornActors.Back);
        }
    }

    public void Reset()
    {
        m_NotbornActors.Clear();
    }

    public LinkList<DPActor_Base> m_NotbornActors = new LinkList<DPActor_Base>();//还未出生的显示层演员，按出生先后顺序排列       
   
}