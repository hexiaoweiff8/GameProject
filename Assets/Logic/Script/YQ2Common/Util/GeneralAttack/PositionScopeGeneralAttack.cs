using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// 范围攻击
/// </summary>
public class PositionScopeGeneralAttack : IGeneralAttack
{
    /// <summary>
    /// 攻击者数据
    /// </summary>
    private PositionObject attacker = null;

    /// <summary>
    /// 显示特效
    /// </summary>
    private string effectKey;

    /// <summary>
    /// 目标位置
    /// </summary>
    private Vector3 targetPos;

    /// <summary>
    /// 范围检测图形
    /// </summary>
    private ICollisionGraphics graphics;

    /// <summary>
    /// 持续时间
    /// </summary>
    private float durTime;

    /// <summary>
    /// 结束时回调
    /// </summary>
    public Action callback;


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="attacker">攻击者数据</param>
    /// <param name="effectKey">范围特效</param>
    /// <param name="targetPos">目标位置</param>
    /// <param name="scopeRaduis">范围半径</param>
    /// <param name="durTime">持续时间</param>
    /// <param name="callback">结束回调</param>
    public PositionScopeGeneralAttack(PositionObject attacker, 
        string effectKey, 
        Vector3 targetPos, 
        float scopeRaduis, 
        float durTime, 
        Action callback)
    {
        if (attacker == null)
        {
            throw new Exception("攻击者数据为null");
        }
        this.attacker = attacker;
        this.effectKey = effectKey;
        this.targetPos = targetPos;
        graphics = new CircleGraphics(new Vector2(targetPos.x, targetPos.z), scopeRaduis);
        this.durTime = durTime;
        this.callback = callback;
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="attacker">攻击者数据</param>
    /// <param name="effectKey">范围特效</param>
    /// <param name="targetPos">目标点位置</param>
    /// <param name="graphics">范围检测图形</param>
    /// <param name="durTime">持续时间</param>
    /// <param name="callback">结束回调</param>
    public PositionScopeGeneralAttack(PositionObject attacker, 
        string effectKey, 
        Vector3 targetPos, 
        ICollisionGraphics graphics, 
        float durTime, 
        Action callback)
    {
        if (attacker == null)
        {
            throw new Exception("攻击者数据为null");
        }
        this.attacker = attacker;
        this.effectKey = effectKey;
        this.targetPos = targetPos;
        this.graphics = graphics;
        this.durTime = durTime;
        this.callback = callback;
    }

    public void Begin()
    {
        // 范围内选择单位
        var memberList = ClusterManager.Single.CheckRange(graphics, attacker.AllData.MemberData.Camp, true);
        // 攻击者数据
        var attackerDisplayOwner = DisplayerManager.Single.GetElementByPositionObject(attacker);
        // 所有单位扣除生命
        foreach (var member in memberList)
        {
            // 被攻击者数据
            var beAttackDisplayOwner = DisplayerManager.Single.GetElementByPositionObject(member);
            // 独计算是否命中, 是否伤害
            var isMiss = HurtResult.AdjustIsMiss(attackerDisplayOwner, beAttackDisplayOwner);
            if (!isMiss)
            {
                // 计算伤害值
                var hurt = HurtResult.GetHurt(attackerDisplayOwner, beAttackDisplayOwner);
                // 记录被击触发 记录扣血 伤害结算时结算
                SkillManager.Single.SetTriggerData(new TriggerData()
                {
                    HealthChangeValue = hurt,
                    ReceiveMember = attackerDisplayOwner,
                    ReleaseMember = beAttackDisplayOwner,
                    TypeLevel1 = TriggerLevel1.Fight,
                    TypeLevel2 = TriggerLevel2.BeAttack
                });
            }
        }

        // 播放特效
        EffectsFactory.Single.CreatePointEffect(effectKey,
            ParentManager.Instance().GetParent(ParentManager.BallisticParent).transform, 
            targetPos, 
            new Vector3(1, 1, 1), 
            durTime, 
            0, 
            callback, 
            Utils.EffectLayer).Begin();
    }
}