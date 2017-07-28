using UnityEngine;
using System.Collections;
using Util;
using System;

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
        Debug.Log("普通攻击:" + fsm.Display.GameObj.name);
        _fireTick = fsm.Display.ClusterData.AllData.MemberData.AttackRate1;
        _fireTimer = new Timer(_fireTick,true);
        _fireTimer.OnCompleteCallback(() => { fire(fsm); }).Start();

        _bulletCount = fsm.Display.ClusterData.AllData.MemberData.Clipsize1;
        _bulletMax = fsm.Display.ClusterData.AllData.MemberData.Clipsize1;
        _reloadTime = fsm.Display.ClusterData.AllData.MemberData.ReloadTime1;
        // 单位转向目标
        var clusterData = fsm.Display.ClusterData as ClusterData;
        if (clusterData != null)
        {
            clusterData.RotateToWithoutYAxis(fsm.EnemyTarget.ClusterData.transform.position);
        }
    }


    /// <summary>
    /// 攻击方法
    /// </summary>
    /// <param name="fsm"></param>
    private void fire(SoldierFSMSystem fsm)
    {
        if (null == fsm.EnemyTarget || null == fsm.EnemyTarget.ClusterData)
        {
            return;
        }
        var enemyDisplayOwner = fsm.EnemyTarget;
        var myDisplayOwner = fsm.Display;
        var enemyClusterData = enemyDisplayOwner.ClusterData;
        var myClusterData = myDisplayOwner.ClusterData;
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
        SkillManager.Single.SetTriggerData(new TriggerData()
        {
            ReceiveMember = enemyDisplayOwner,
            ReleaseMember = myDisplayOwner,
            TypeLevel1 = TriggerLevel1.Fight,
            TypeLevel2 = TriggerLevel2.Attack
        });


        // 如果攻击方的攻击方式不为普通攻击的读取攻击表, 获取对应攻击方式
        IGeneralAttack normalGeneralAttack = null;
        if (fsm.Display.ClusterData.AllData.MemberData.AttackType == Utils.BulletTypeNormal)
        {
            normalGeneralAttack = GeneralAttackManager.Instance()
                .GetNormalGeneralAttack(myClusterData, enemyClusterData, "test/TrailPrj",
                    myClusterData.transform.position + new Vector3(0, 10, 0),
                    enemyClusterData.gameObject,
                    200,
                    TrajectoryAlgorithmType.Line,
                    () =>
                    {
                        //Debug.Log("普通攻击");
                        
                    });
        }
        else if (myClusterData.AllData.MemberData.AttackType == Utils.BulletTypeScope)
        {
            // 获取
            //Debug.Log("AOE");
            var armyAOE = myClusterData.AllData.AOEData;
            // 根据不同攻击类型获取不同数据
            switch (armyAOE.AOEAim)
            {
                case Utils.AOEObjScope:
                    normalGeneralAttack = GeneralAttackManager.Instance().GetPointToObjScopeGeneralAttack(myClusterData,
                        new[] { armyAOE.BulletModel, armyAOE.DamageEffect },
                        myClusterData.transform.position,
                        enemyClusterData.gameObject,
                        armyAOE.AOERadius,
                        200,
                        armyAOE.EffectTime,
                        (TrajectoryAlgorithmType)armyAOE.BulletPath,
                        () =>
                        {
                            //Debug.Log("AOE Attack1");
                        });
                    break;
                case Utils.AOEPointScope:
                    normalGeneralAttack =
                        GeneralAttackManager.Instance().GetPointToPositionScopeGeneralAttack(myClusterData,
                            new[] { armyAOE.BulletModel, armyAOE.DamageEffect },
                            myClusterData.transform.position,
                            enemyClusterData.transform.position,
                            armyAOE.AOERadius,
                            200,
                            armyAOE.EffectTime,
                            (TrajectoryAlgorithmType) armyAOE.BulletPath,
                            () =>
                            {
                            //Debug.Log("AOE Attack2");
                            });
                    break;
                case Utils.AOEScope:
                    normalGeneralAttack = GeneralAttackManager.Instance().GetPositionScopeGeneralAttack(myClusterData,
                        armyAOE.DamageEffect,
                        myClusterData.transform.position,
                        new CircleGraphics(new Vector2(myClusterData.X, myClusterData.Y), armyAOE.AOERadius), 
                        armyAOE.EffectTime,
                        () =>
                        {
                            //Debug.Log("AOE Attack3");
                        });
                    break;
                case Utils.AOEForwardScope:
                    normalGeneralAttack =
                        GeneralAttackManager.Instance().GetPositionRectScopeGeneralAttack(myClusterData,
                            armyAOE.DamageEffect,
                            myClusterData.transform.position,
                            armyAOE.AOEWidth,
                            armyAOE.AOEHeight,
                            Vector2.Angle(Vector2.up, new Vector2(myClusterData.transform.forward.x, myClusterData.transform.forward.z)),
                            armyAOE.EffectTime,
                            () =>
                            {
                                //Debug.Log("AOE Attack4");
                            });
                    break;
            }
            SwitchAnim(fsm, SoldierAnimConst.GONGJI,WrapMode.Loop);
        }

        if (normalGeneralAttack != null)
        {
            normalGeneralAttack.Begin();
        }

        // 攻击动作
        //var myself = fsm.Display.RanderControl;
        // TODO 部分单位没有attack动画会报错
        //myself.ModelRander.SetClip("attack".GetHashCode());

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
        //Debug.Log("普通攻击结束:" + fsm.Display.GameObj.name);
        _fireTimer.Kill();
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        if (!_stateIsLose)
        {
            // 范围内没有敌人
            if (AdjustTargetIsInRange(fsm))
            {
                fsm.IsCanInPutonggongji = false;
                fsm.TargetIsLoseEfficacy = true;
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
        return (distance > fsm.Display.ClusterData.AllData.MemberData.AttackRange) ||
               (fsm.EnemyTarget.ClusterData.AllData.MemberData.CurrentHP <= 0);
    }
}
