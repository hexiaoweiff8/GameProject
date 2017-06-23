using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 技能/buff时间触发器
/// 战斗中启用
/// 战斗结束关闭
/// </summary>
public class TriggerTicker : ILoopItem
{
    /// <summary>
    /// 单例
    /// </summary>
    public static TriggerTicker Single
    {
        get
        {
            if (single == null)
            {
                single = new TriggerTicker();
            }
            // 启动
            single.Start();

            return single;
        }
    }

    // ---------------------------私有属性-------------------------------

    /// <summary>
    /// 单例对象
    /// </summary>
    private static TriggerTicker single = null;

    /// <summary>
    /// 结束标志, 如果为True则会销毁自己
    /// </summary>
    private bool isEnd = false;

    /// <summary>
    /// 循环器中的Key
    /// 如果为0则没有启动
    /// </summary>
    private long looperKey = 0;

    /// <summary>
    /// 记录上次trigger时间
    /// </summary>
    private IDictionary<long, long> beTriggerTimeDic = new Dictionary<long, long>();

    /// <summary>
    /// 被删除的Key列表
    /// </summary>
    private IList<long> delList = new List<long>();

    // ---------------------------私有属性-------------------------------


    // -------------------------公共方法-------------------------------


    public void Do()
    {
        BuffInfo tmpBuffInfo = null;
        var nowTickTime = DateTime.Now.Ticks;
        // tick所有走时间的Trigger 
        foreach (var item in beTriggerTimeDic)
        {
            var buffId = item.Key;
            var lastTick = item.Value;
            if (BuffManager.Instance().ContainsBuffId(buffId))
            {
                // 检测
                tmpBuffInfo = BuffManager.Instance().GetBuffInstance(buffId);
                if (tmpBuffInfo != null)
                {
                    // 检测上次tick与上次tick的时差, 超过或相等的执行action一次, 并更新tick
                    var tickDiff = nowTickTime - lastTick;
                    if (tickDiff >= tmpBuffInfo.TickTime*1000)
                    {
                        // 执行buff的Action
                        BuffManager.Instance().DoBuff(tmpBuffInfo, BuffDoType.Action);
                        // 并更新tick时间
                        beTriggerTimeDic[buffId] = nowTickTime;
                    }

                    // 检测buff是否到时见
                    // 到达极限时间buff直接Detach
                    var buffStartTimeDiff = nowTickTime - tmpBuffInfo.BuffStartTime;
                    if (buffStartTimeDiff > tmpBuffInfo.BuffTime*1000)
                    {
                        // buff Detach
                        BuffManager.Instance().DoBuff(tmpBuffInfo, BuffDoType.Detach);
                    }
                     
                }
                else
                {
                    // buff已销毁 删除本地buff时间记录
                    delList.Add(buffId);
                }
            }
        }

        // 删除列表内的key
        foreach (var itemKey in delList)
        {
            beTriggerTimeDic.Remove(itemKey);
        }
        delList.Clear();
    }

    public bool IsEnd()
    {
        // 结束标志
        return isEnd;
    }

    public void OnDestroy()
    {
        // 清空列表
        beTriggerTimeDic.Clear();
    }

    /// <summary>
    /// 启动
    /// </summary>
    public void Start()
    {
        isEnd = false;
        // 如果未启动则启动
        if (looperKey == 0 || !LooperManager.Single.Contains(looperKey))
        {
            looperKey = LooperManager.Single.Add(this);
        }
    }

    /// <summary>
    /// 结束并且清理数据
    /// </summary>
    public void StopAndClear()
    {
        isEnd = true;
        // 清理数据
        LooperManager.Single.Remove(looperKey);
        looperKey = 0;
        beTriggerTimeDic.Clear();
    }
    // -------------------------公共方法-------------------------------
}
