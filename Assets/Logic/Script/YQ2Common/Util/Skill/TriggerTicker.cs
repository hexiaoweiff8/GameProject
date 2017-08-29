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
    /// Tick变更列表
    /// </summary>
    private IDictionary<long, long> changeDic = new Dictionary<long, long>();

    /// <summary>
    /// Detach的Buff列表
    /// </summary>
    private IList<BuffInfo> delList = new List<BuffInfo>();

    // ---------------------------私有属性-------------------------------


    // -------------------------公共方法-------------------------------

    /// <summary>
    /// 添加技能id到ticker中
    /// </summary>
    /// <param name="skill"></param>
    public void Add(SkillBase skill)
    {
        if (skill == null)
        {
            throw new Exception("被Ticker技能为空");
        }
        beTriggerTimeDic.Add(skill.AddtionId, (long)(skill.TickTime * 1000) + DateTime.Now.Ticks);
    }

    /// <summary>
    /// 是否包含指定id
    /// </summary>
    /// <param name="addtionId"></param>
    /// <returns></returns>
    public bool Contains(long addtionId)
    {
        return beTriggerTimeDic.ContainsKey(addtionId);
    }

    /// <summary>
    /// 删除指定id
    /// </summary>
    /// <param name="addtionId"></param>
    public void Remove(long addtionId)
    {
        if (Contains(addtionId))
        {
            beTriggerTimeDic.Remove(addtionId);
        }
    }

    public void Do()
    {
        lock (beTriggerTimeDic)
        {
            var nowTickTime = DateTime.Now.Ticks;
            // tick所有走时间的Trigger 
            foreach (var item in beTriggerTimeDic)
            {
                var id = item.Key;
                var lastTick = item.Value;
                var tickDiff = nowTickTime - lastTick;
                if (BuffManager.Single.ContainsInstanceBuffId(id))
                {
                    // 检测
                    var tmpBuffInfo = BuffManager.Single.GetBuffInstance(id);
                    if (tmpBuffInfo != null)
                    {
                        // 检测上次tick与上次tick的时差, 超过或相等的执行action一次, 并更新tick
                        if (tmpBuffInfo.TickTime > 0 && tickDiff >= tmpBuffInfo.TickTime * Utils.TicksTimeToSecond)
                        {
                            // 执行buff的Action
                            BuffManager.Single.DoBuff(tmpBuffInfo, BuffDoType.Action, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(tmpBuffInfo.ReleaseMember, tmpBuffInfo.ReceiveMember, tmpBuffInfo, 1, tmpBuffInfo.IsNotLethal));
                            // 并更新tick时间
                            changeDic.Add(id, nowTickTime);
                            //beTriggerTimeDic[id] = nowTickTime;
                        }

                        // 检测buff是否到时见
                        // 到达极限时间buff直接Detach
                        var buffStartTimeDiff = nowTickTime - tmpBuffInfo.BuffStartTime;
                        if (buffStartTimeDiff > tmpBuffInfo.BuffTime * Utils.TicksTimeToSecond)
                        {
                            // buff Detach
                            delList.Add(tmpBuffInfo);
                        }

                    }
                    //else
                    //{
                    //    // buff已销毁 删除本地buff时间记录
                    //    delList.Add(id);
                    //}
                }
                else if (SkillManager.Single.ContainsInstanceSkillId(id))
                {
                    // TODO tick类技能必须以选择目标的标记其实(因为没有初始目标)
                    // TODO 检测技能Ticker
                    var tmpSkillInfo = SkillManager.Single.GetSkillInstance(id);
                    if (tmpSkillInfo != null)
                    {
                        if (tickDiff >= tmpSkillInfo.TickTime * Utils.TicksTimeToSecond)
                        {
                            // 执行skill
                            //SkillManager.Single.DoShillInfo(tmpSkillInfo,
                            //    FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(
                            //    tmpSkillInfo.ReleaseMember,
                            //        null,
                            //        tmpSkillInfo,
                            //        - 1));

                            // 抛出事件
                            SkillManager.Single.SetTriggerData(new TriggerData()
                            {
                                ReceiveMember = tmpSkillInfo.ReleaseMember,
                                ReleaseMember = tmpSkillInfo.ReleaseMember,
                                TypeLevel1 = TriggerLevel1.Time,
                                TypeLevel2 = TriggerLevel2.TickTime
                            });

                            // 并更新tick时间
                            changeDic.Add(id, nowTickTime);
                        }
                    }
                }
            }

            // 删除列表内的key
            foreach (var buff in delList)
            {
                //beTriggerTimeDic.Remove(itemKey);
                BuffManager.Single.DoBuff(buff, BuffDoType.Detach, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buff.ReleaseMember, buff.ReceiveMember, buff, 1, buff.IsNotLethal));
            }
            delList.Clear();

            // 变更tick
            foreach (var item in changeDic)
            {
                beTriggerTimeDic[item.Key] = item.Value;
            }
            changeDic.Clear();
        }
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
