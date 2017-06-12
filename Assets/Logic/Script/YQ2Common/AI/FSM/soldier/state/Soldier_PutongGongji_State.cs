using UnityEngine;
using System.Collections;
using Util;
using System;
using System.Collections.Generic;

public class Soldier_PutongGongji_State : SoldierFSMState
{
    /// <summary>
    /// 开火间隔
    /// </summary>
    private float _fireTick;
    /// <summary>
    /// 当前发射的子弹数量 当达到子弹上限后 需要填充子弹 并清零
    /// </summary>
    private int _bulletCount;
    /// <summary>
    /// 一弹夹子弹上限
    /// </summary>
    private int _bulletMax;
    /// <summary>
    /// 开火计时器
    /// </summary>
    private Timer _fireTimer;
    /// <summary>
    /// 装填时间 两弹夹子弹之间的间隔
    /// </summary>
    private float _reloadTime;

    public override void Init()
    {
        StateID = SoldierStateID.PutongGongji;
    }


    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        _fireTick = fsm.Display.ClusterData.MemberData.AttackRate1;
        _fireTimer = new Timer(_fireTick,true);
        _fireTimer.OnCompleteCallback(() => { fire(fsm); }).Start();

        _bulletCount = fsm.Display.ClusterData.MemberData.Clipsize1;
        _bulletMax = fsm.Display.ClusterData.MemberData.Clipsize1;
        _reloadTime = fsm.Display.ClusterData.MemberData.ReloadTime1;
    }

    private void fire(SoldierFSMSystem fsm)
    {
        if (null == fsm.EnemyTarget || null == fsm.EnemyTarget.ClusterData)
        {
            return;
        }
        // 无子弹reload不攻击
        if (_bulletCount <= 0)
        {
            Globals.Instance.StartCoroutine(_waitFor(() =>
            {
                _bulletCount = _bulletMax;
                _fireTimer.GoOn();
            }));
            _fireTimer.Pause();
            return;
        }

        //var fightVO = fsm.Display.ClusterData.MemberData as FightVO;
        // 攻击时检测技能
        SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
        {
            ReceiveMember = fsm.EnemyTarget,
            ReleaseMember = fsm.Display,
            TypeLevel1 = SkillTriggerLevel1.Fight,
            TypeLevel2 = SkillTriggerLevel2.Attack
        });

        var ballistic = EffectsFactory.Single.CreatePointToPointEffect("test/TrailPrj", null,
            fsm.Display.ClusterData.Position, fsm.EnemyTarget.ClusterData.Position, new Vector3(1, 1, 1), 200, TrajectoryAlgorithmType.Line,
            () =>
            {
                // 判断是否命中
                var isMiss = HurtResult.AdjustIsMiss(fsm.Display, fsm.EnemyTarget);
                if (!isMiss)
                {
                    // 计算伤害
                    var hurt = HurtResult.GetHurt(fsm.Display, fsm.EnemyTarget);
                    if (null != fsm.EnemyTarget &&
                        null != fsm.EnemyTarget.ClusterData &&
                        null != fsm.EnemyTarget.RanderControl)
                    {
                        // 记录被击触发 记录扣血 伤害结算时结算
                        SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                        {
                            HealthChangeValue = hurt,
                            ReceiveMember = fsm.Display,
                            ReleaseMember = fsm.EnemyTarget,
                            TypeLevel1 = SkillTriggerLevel1.Fight,
                            TypeLevel2 = SkillTriggerLevel2.BeAttack
                        });
                    }
                    // 命中时检测技能
                    SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                    {
                        ReceiveMember = fsm.EnemyTarget,
                        ReleaseMember = fsm.Display,
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
                        ReceiveMember = fsm.Display,
                        ReleaseMember = fsm.EnemyTarget,
                        TypeLevel1 = SkillTriggerLevel1.Fight,
                        TypeLevel2 = SkillTriggerLevel2.Dodge
                    });
                }
            }, 12);
        ballistic.Begin();

        // 开火后子弹数量-1
        _bulletCount--;
    }

    private IEnumerator _waitFor(Action waitEnd)
    {
        yield return new WaitForSeconds(_reloadTime);
        
        waitEnd();
    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        _fireTimer.Kill();
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        if (!_stateIsLose)
        {
            // 范围内没有敌人
            if (AdjustTargetIsInRange(fsm))
            {
                fsm.TargetIsLoseEfficacy = true;
                // TODO 如果在视野范围内开始追击
            }
            // 有技能可放

        }
    }

    /// <summary>
    /// 判断目标是否还在范围内 两种情况会脱离范围 跑出视野 或者血为0
    /// </summary>
    /// <returns></returns>
    private bool AdjustTargetIsInRange(SoldierFSMSystem fsm)
    {
        // 验证单位是否有效
        if (null == fsm.EnemyTarget || null == fsm.EnemyTarget.GameObj || null == fsm.EnemyTarget.ClusterData)
        {
            return true;
        }
        var targetPos = fsm.EnemyTarget.ClusterData.Position;
        var myPos = fsm.Display.ClusterData.Position;
        var distance = AI_Math.V2Distance(targetPos.x, targetPos.z, myPos.x, myPos.z) - fsm.EnemyTarget.ClusterData.Diameter * 0.5f - fsm.Display.ClusterData.Diameter * 0.5f;
        return (distance > fsm.Display.ClusterData.MemberData.SightRange) ||
               (fsm.EnemyTarget.ClusterData.MemberData.CurrentHP <= 0);
    }
}
