using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 事件处理器
/// </summary>
public class TriggerRunner : MonoBehaviour
{
    /// <summary>
    /// 单位数据
    /// </summary>
    public DisplayOwner Display;

    /// <summary>
    /// 临时事件列表
    /// </summary>
    public List<TriggerData> tmpList = new List<TriggerData>();

    /// <summary>
    /// 结算伤害/治疗
    /// </summary>
    private Action<TriggerLevel1, TriggerLevel2, TriggerData, AllData> settlementDamageOrCure;

    ///// <summary>
    ///// 技能释放包装类字典
    ///// ObjectId.ID, SkillReleasePacker
    ///// </summary>
    //private static Dictionary<int, SkillReleasePacker> skillReleasePackerDic = new Dictionary<int, SkillReleasePacker>();

    ///// <summary>
    ///// 被释放技能列表
    ///// </summary>
    //private List<SkillReleasePacker> skillReleasePackerList = new List<SkillReleasePacker>();


    ///// <summary>
    ///// 添加技能被释放
    ///// </summary>
    ///// <param name="objId">释放者Id</param>
    ///// <param name="packer">释放技能详情</param>
    //public static void AddSkillReleasePacker(ObjectID objId, SkillReleasePacker packer)
    //{
    //    if (objId == null || packer == null)
    //    {
    //        return;
    //    }
    //    skillReleasePackerDic.Add(objId.ID, packer);
    //}

    ///// <summary>
    ///// 清空被释放技能
    ///// </summary>
    //public static void ClearSkillReleasePacker()
    //{
    //    skillReleasePackerDic.Clear();
    //}


    private void Awake()
    {
        // 初始化事件
        settlementDamageOrCure = (type1, type2, trigger, alldata) =>
        {
            // 治疗结算
            if (type1 == TriggerLevel1.Fight && type2 == TriggerLevel2.BeCure)
            {
                alldata.MemberData.CurrentHP += trigger.HealthChangeValue;
            }
            // 伤害结算
            if (type1 == TriggerLevel1.Fight && type2 == TriggerLevel2.BeAttack)
            {
                alldata.MemberData.CurrentHP -= trigger.HealthChangeValue;
                if (alldata.MemberData.CurrentHP < Utils.ApproachZero)
                {
                    alldata.MemberData.CurrentHP = 0;
                    // 并判断该伤害是否致死, 如果不致死则生命值设置为1
                    if (trigger.IsNotLethal)
                    {
                        alldata.MemberData.CurrentHP = 1;
                    }
                    else
                    {
                        // 抛出致死攻击事件
                        tmpList.Add(new TriggerData()
                        {
                            HealthChangeValue = trigger.HealthChangeValue,
                            ReceiveMember = trigger.ReleaseMember,
                            ReleaseMember = trigger.ReceiveMember,
                            TypeLevel1 = TriggerLevel1.Fight,
                            TypeLevel2 = TriggerLevel2.LethalHit
                        });
                    }
                }


                // 是否有吸收伤害
                if (trigger.IsAbsorption)
                {
                    // 检测是否有伤害吸收的buff/skill
                    // 触发吸收伤害事件
                    tmpList.Add(new TriggerData()
                    {
                        HealthChangeValue = trigger.HealthChangeValue,
                        ReceiveMember = trigger.ReleaseMember,
                        ReleaseMember = trigger.ReceiveMember,
                        TypeLevel1 = TriggerLevel1.Fight,
                        TypeLevel2 = TriggerLevel2.Absorption
                    });
                }
            }
        };
    }


    private void Update()
    {
        //// 检测并执行技能释放
        //CheckReleaseSkills();
        // 检查光环
        CheckHalo(Display);
        // 处理事件
        CheckTrigger(Display);
    }


    /// <summary>
    /// 检测当前单位的触发事件
    /// </summary>
    private void CheckTrigger(DisplayOwner display)
    {
        var allData = display.ClusterData.AllData;
        if (allData.MemberData != null)
        {
            // 抛出None事件用于持续技能执行
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                ReceiveMember = display,
                ReleaseMember = display,
                TypeLevel1 = TriggerLevel1.None,
                TypeLevel2 = TriggerLevel2.None
            });
            // 触发当前单位的所有事件
            SkillManager.Single.SetEachAction(allData.MemberData.ObjID, (type1, type2, trigger) =>
            {
                if (allData.SkillInfoList != null)
                {
                    // 触发skill类
                    SkillManager.Single.CheckAndDoSkillInfo(allData.SkillInfoList, trigger);
                }
                if (allData.BuffInfoList != null)
                {
                    // 技能触发完毕开始触发buff类
                    BuffManager.Single.CheckAndDoBuffInfo(allData.BuffInfoList, trigger);
                }
                // 计算伤害
                settlementDamageOrCure(type1, type2, trigger, allData);
            }, true);
            PushTriggerData();
        }
    }

    /// <summary>
    /// 检查光环
    /// </summary>
    /// <param name="display">被检查单位</param>
    private void CheckHalo(DisplayOwner display)
    {
        // 执行光环
        var allData = display.ClusterData.AllData;
        if (allData.MemberData == null) return;
        // 检查光环
        foreach (var halo in allData.HaloInfoList)
        {
            
        }
    }

    /// <summary>
    /// 将缓存的事件压入事件列表中
    /// </summary>
    private void PushTriggerData()
    {
        // 将事件压入
        foreach (var item in tmpList)
        {
            SkillManager.Single.SetTriggerData(item);
        }
        tmpList.Clear();
    }

    ///// <summary>
    ///// 检查释放技能
    ///// </summary>
    //private void CheckReleaseSkills()
    //{
    //    lock (skillReleasePackerList)
    //    {
    //        foreach (var skillReleasePacker in skillReleasePackerList)
    //        {
    //            // 技能释放者
    //            // 技能接收者
    //            // 技能
    //            // fsm 中带技能
    //            if (skillReleasePacker.SkillReceiveMember.ClusterData != null
    //                && skillReleasePacker.SkillReceiveMember.GameObj != null)
    //            {
    //                SkillManager.Single.DoShillInfo(skillReleasePacker.Skill,
    //                    FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(skillReleasePacker.Skill,
    //                        skillReleasePacker.SkillReleaseMember,
    //                        skillReleasePacker.SkillReceiveMember));
    //            }
    //        }
    //        // 将释放完毕的技能删除, 如果未释放完毕则等待
    //        for (var i = 0; i < skillReleasePackerList.Count; i++)
    //        {
    //            var skillReleasePacker = skillReleasePackerList[i];
    //            if (skillReleasePacker.Skill.IsDone)
    //            {
    //                skillReleasePackerList.RemoveAt(i);
    //                i--;
    //            }
    //        }
    //    }
    //}


    private void OnDestroy()
    {
        // TODO 释放
        // TODO 死亡时将未释放技能进行释放
        // 清空事件
        //ClearSkillReleasePacker();
    }
}

/// <summary>
/// 技能释放包装类
/// </summary>
public class SkillReleasePacker
{

    /// <summary>
    /// 技能释放者
    /// </summary>
    public DisplayOwner SkillReleaseMember { get; set; }

    /// <summary>
    /// 技能接受者
    /// </summary>
    public DisplayOwner SkillReceiveMember { get; set; }

    /// <summary>
    /// 被释放技能
    /// </summary>
    public SkillBase Skill { get; set; }

}