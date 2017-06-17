using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// 单点普通攻击
/// </summary>
public class NormalGeneralAttack : IGeneralAttack
{
    /// <summary>
    /// 攻击特效
    /// </summary>
    private EffectBehaviorAbstract effect;

    /// <summary>
    /// 
    /// </summary>
    /// <param name="attacker">攻击者数据</param>
    /// <param name="beAttackMember">被攻击者数据</param>
    /// <param name="effectKey">子弹预设key(或path)</param>
    /// <param name="releasePos">子弹飞行起点</param>
    /// <param name="targetObj">子弹目标单位</param>
    /// <param name="speed">子弹飞行速度</param>
    /// <param name="taType">子弹飞行轨迹</param>
    /// <param name="callback">攻击结束回调</param>
    public NormalGeneralAttack(PositionObject attacker, 
        PositionObject beAttackMember, 
        string effectKey, 
        Vector3 releasePos, 
        GameObject targetObj, 
        float speed, 
        TrajectoryAlgorithmType taType, 
        Action callback)
    {
        if (attacker == null || beAttackMember == null)
        {
            throw new Exception("被攻击者或攻击者数据为空");
        }
        Action demage = () =>
        {

            var attackerDisplayOwner = DisplayerManager.Single.GetElementByPositionObject(attacker);
            var beAttackerDisplayOwner = DisplayerManager.Single.GetElementByPositionObject(beAttackMember);
            // 判断是否命中
            var isMiss = HurtResult.AdjustIsMiss(attackerDisplayOwner, beAttackerDisplayOwner);
            if (!isMiss)
            {
                // 计算伤害
                var hurt = HurtResult.GetHurt(attackerDisplayOwner, beAttackerDisplayOwner);
                if (null != beAttackerDisplayOwner &&
                    null != beAttackerDisplayOwner.ClusterData &&
                    null != beAttackerDisplayOwner.RanderControl)
                {
                    // 记录被击触发 记录扣血 伤害结算时结算
                    SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                    {
                        HealthChangeValue = hurt,
                        ReceiveMember = attackerDisplayOwner,
                        ReleaseMember = beAttackerDisplayOwner,
                        TypeLevel1 = SkillTriggerLevel1.Fight,
                        TypeLevel2 = SkillTriggerLevel2.BeAttack
                    });
                }
                // 命中时检测技能
                SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                {
                    ReceiveMember = beAttackerDisplayOwner,
                    ReleaseMember = attackerDisplayOwner,
                    TypeLevel1 = SkillTriggerLevel1.Fight,
                    TypeLevel2 = SkillTriggerLevel2.Hit
                });
            }
            else
            {
                // TODO 播放miss特效
                // 闪避时事件
                SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                {
                    ReceiveMember = attackerDisplayOwner,
                    ReleaseMember = beAttackerDisplayOwner,
                    TypeLevel1 = SkillTriggerLevel1.Fight,
                    TypeLevel2 = SkillTriggerLevel2.Dodge
                });
            }
        };

        if (callback == null)
        {
            callback = () => { };
        }
        effect = EffectsFactory.Single.CreatePointToObjEffect(effectKey, 
            ParentManager.Instance().GetParent(ParentManager.BallisticParent).transform,
            releasePos, 
            targetObj, 
            new Vector3(1, 1, 1), 
            speed, 
            taType, 
            demage + callback, 
            Utils.EffectLayer);

    }

    public void Begin()
    {
        effect.Begin();
    }
}