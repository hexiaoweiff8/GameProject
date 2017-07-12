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

    void Awake()
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


    void Update()
    {
        // 处理事件
        CheckTrigger(Display.ClusterData.AllData);
    }


    /// <summary>
    /// 检测当前单位的触发事件
    /// </summary>
    private void CheckTrigger(AllData alldata)
    {
        if (alldata.MemberData != null && alldata.SkillInfoList != null)
        {
            // 触发当前单位的所有事件
            SkillManager.Single.SetEachAction(alldata.MemberData.ObjID, (type1, type2, trigger) =>
            {
                // 触发skill类
                SkillManager.Single.CheckAndDoSkillInfo(alldata.SkillInfoList, trigger);
                // 技能触发完毕开始触发buff类
                BuffManager.Single.CheckAndDoBuffInfo(alldata.BuffInfoList, trigger);
                // 计算伤害
                settlementDamageOrCure(type1, type2, trigger, alldata);
            },
            true);
            PushTriggerData();
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
    ///// 结算当前单位的血量
    ///// </summary>
    //private void SettlementDamageOrCure(AllData alldata)
    //{
    //    var isOneHealth = false;
    //    if (alldata.MemberData != null && alldata.SkillInfoList != null)
    //    {
    //        var demage = 0f;
    //        var cure = 0f;

    //        // 先计算治疗量
    //        var cureList = SkillManager.Single.GetSkillTriggerDataList(alldata.MemberData.ObjID, TriggerLevel1.Fight, TriggerLevel2.BeCure);
    //        if (cureList != null && cureList.Count > 0)
    //        {
    //            // 计算治疗量总和
    //            cure += cureList.Sum(attackMember => attackMember.HealthChangeValue);
    //        }

    //        // 再计算伤害量
    //        // 获取被击列表
    //        var attackList = SkillManager.Single.GetSkillTriggerDataList(alldata.MemberData.ObjID, TriggerLevel1.Fight, TriggerLevel2.BeAttack);
    //        // 检测是否被击
    //        if (attackList != null && attackList.Count > 0)
    //        {
    //            // 计算血量变动总和
    //            // 这里返回的都是负值所以使用+=
    //            demage += attackList.Sum(attackMember => attackMember.HealthChangeValue);
    //            Debug.Log("伤害值:" + demage);
    //            // 如果单位死亡在抛出一个死亡事件
    //            // 检测致死攻击
    //            if (alldata.MemberData.CurrentHP - demage < Utils.ApproachZero)
    //            {
    //                // 检测最后一个
    //                var lastHitMember = attackList[attackList.Count - 1];
    //                // 并判断该伤害是否致死, 如果不致死则生命值设置为1
    //                if (lastHitMember.IsNotLethal)
    //                {
    //                    isOneHealth = true;
    //                }
    //                else
    //                {
    //                    // 抛出致死攻击事件
    //                    SkillManager.Single.SetTriggerData(new TriggerData()
    //                    {
    //                        HealthChangeValue = lastHitMember.HealthChangeValue,
    //                        ReceiveMember = lastHitMember.ReceiveMember,
    //                        ReleaseMember = lastHitMember.ReleaseMember,
    //                        TypeLevel1 = TriggerLevel1.Fight,
    //                        TypeLevel2 = TriggerLevel2.LethalHit
    //                    });
    //                }
    //            }


    //            // 如果有伤害吸收则将伤害计算到技能的伤害吸收中
    //            if (demage < Utils.ApproachZero)
    //            {
    //                // 检测是否有伤害吸收的buff/skill
    //                // 触发吸收伤害事件
    //            }

    //            // 结算血量变动
    //            if (isOneHealth)
    //            {
    //                // 收到非致死超过血量的伤害, 生命值设置为1
    //                alldata.MemberData.CurrentHP = 1;
    //            }
    //            else
    //            {
    //                // 正常扣血
    //                alldata.MemberData.CurrentHP += cure - demage;
    //            }
    //            // 刷新血条
    //            //fsm.Display.RanderControl.SetBloodBarValue();
    //        }
    //    }
    //}

}