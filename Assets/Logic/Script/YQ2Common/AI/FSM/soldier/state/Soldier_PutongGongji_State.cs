using UnityEngine;
using System.Collections;
using Util;
using System;

public class Soldier_PutongGongji_State : SoldierFSMState
{
    ///// <summary>
    ///// 开火间隔
    ///// </summary>
    //private float _fireTick;

    /// <summary>
    /// 当前发射的子弹数量 当达到子弹上限后 需要填充子弹 并清零
    /// </summary>
    private int _bulletCount;

    ///// <summary>
    ///// 一弹夹子弹上限
    ///// </summary>
    //private int _bulletMax;

    /// <summary>
    /// 开火计时器
    /// </summary>
    private Timer _fireTimer;

    /// <summary>
    /// 再装填计时器
    /// </summary>
    private Timer _reloadTimer;

    ///// <summary>
    ///// 装填时间 两弹夹子弹之间的间隔
    ///// </summary>
    //private float _reloadTime;

    /// <summary>
    /// 是否正在待机
    /// </summary>
    private bool _isDaiJi = false;

    public override void Init()
    {
        StateID = SoldierStateID.PutongGongji;
    }


    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        _fireTimer = new Timer(fsm.Display.ClusterData.AllData.MemberData.AttackRate1, true);
        _fireTimer.OnCompleteCallback(() => { fire(fsm); }).Start();

        _bulletCount = fsm.Display.ClusterData.AllData.MemberData.Clipsize1;
        //_bulletMax = fsm.Display.ClusterData.AllData.MemberData.Clipsize1;
        //_reloadTime = fsm.Display.ClusterData.AllData.MemberData.ReloadTime1;
        // 单位转向目标
        var clusterData = fsm.Display.ClusterData;
        if (clusterData != null && fsm.EnemyTarget != null && fsm.EnemyTarget.ClusterData != null)
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
        var myClusterData = myDisplayOwner.ClusterData;
        var myMemberData = myClusterData.AllData.MemberData;

        // 单位转向目标
        myClusterData.RotateToWithoutYAxis(myClusterData.transform.position);


        // 重置攻击时间间隔
        _fireTimer.LoopTime = myMemberData.AttackRate1;

        // 如果能攻击
        if (myMemberData.CouldNormalAttack)
        {
            // 无子弹reload不攻击
            if (_bulletCount <= 0)
            {
                _reloadTimer = new Timer(myMemberData.ReloadTime1);
                // 等待装填
                _reloadTimer.OnCompleteCallback(() =>
                {
                    _bulletCount = myMemberData.Clipsize1;
                    _fireTimer.GoOn();
                }).Start();

                _fireTimer.Pause();

                // 是否有装填动作使用装填时间来判定
                if (myMemberData.ReloadTime1 > Utils.ApproachZero)
                {
                    SwitchAnim(fsm, SoldierAnimConst.ZHUANGTIAN, WrapMode.Once);
                }
                return;
            }

            // 抛出攻击事件
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                ReceiveMember = enemyDisplayOwner,
                ReleaseMember = myDisplayOwner,
                TypeLevel1 = TriggerLevel1.Fight,
                TypeLevel2 = TriggerLevel2.Attack
            });

            // 发射子弹
            ShootBullet(fsm);

            // 攻击动作
            SwitchAnim(fsm, SoldierAnimConst.GONGJI, WrapMode.Once);
            // 开火后子弹数量-1
            _bulletCount--;
        }
        else
        {
            // 不能攻击
            // 播放待机动作
            if (!_isDaiJi)
            {
                SwitchAnim(fsm, SoldierAnimConst.DAIJI, WrapMode.Once);
                _isDaiJi = true;
            }
        }
        
    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        fsm.IsCanInPutonggongji = false;
        fsm.TargetIsLoseEfficacy = true;
        if (_fireTimer != null)
        {
            _fireTimer.Kill();
        }
        if (_reloadTimer != null)
        {
            _reloadTimer.Kill();
        }
        _isDaiJi = false;
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
        var distance = AI_Math.V2Distance(targetPos.x, targetPos.z, myPos.x, myPos.z)
            - fsm.EnemyTarget.ClusterData.Diameter * ClusterManager.Single.UnitWidth * 0.5f
            - fsm.Display.ClusterData.Diameter * ClusterManager.Single.UnitWidth * 0.5f;
        return (distance > fsm.Display.ClusterData.AllData.MemberData.AttackRange) ||
               (fsm.EnemyTarget.ClusterData.AllData.MemberData.CurrentHP <= 0);
    }

    /// <summary>
    /// 发射子弹
    /// </summary>
    /// <param name="fsm"></param>
    private void ShootBullet(SoldierFSMSystem fsm)
    {

        var enemyDisplayOwner = fsm.EnemyTarget;
        var myDisplayOwner = fsm.Display;
        var enemyClusterData = enemyDisplayOwner.ClusterData;
        var myClusterData = myDisplayOwner.ClusterData;
        var myMemberData = myClusterData.AllData.MemberData;
        var effect = myClusterData.AllData.EffectData;

        // 如果攻击方的攻击方式不为普通攻击的读取攻击表, 获取对应攻击方式
        IGeneralAttack normalGeneralAttack = null;
        switch (myMemberData.AttackType)
        {
            case Utils.BulletTypeNormal:
                normalGeneralAttack = GeneralAttackManager.Instance()
                    .GetNormalGeneralAttack(myClusterData, enemyClusterData, effect.Bullet,
                        myClusterData.transform.position + new Vector3(0, 10, 0),
                        enemyClusterData.gameObject,
                        myMemberData.BulletSpeed,
                        TrajectoryAlgorithmType.Line,
                        (obj) =>
                        {
                            //Debug.Log("普通攻击");
                            // 播受击特效

                        });
                break;
            case Utils.BulletTypeScope:
                // 获取
                //Debug.Log("AOE");
                var armyAOE = myClusterData.AllData.AOEData;
                // 根据不同攻击类型获取不同数据
                switch (armyAOE.AOEAim)
                {
                    case Utils.AOEObjScope:
                        normalGeneralAttack = GeneralAttackManager.Instance().GetPointToObjScopeGeneralAttack(myClusterData,
                            new[] { effect.Bullet, effect.RangeEffect },
                            myClusterData.transform.position,
                            enemyClusterData.gameObject,
                            armyAOE.AOERadius,
                            myMemberData.BulletSpeed,
                            1, //effect.EffectTime,
                            (TrajectoryAlgorithmType)Enum.Parse(typeof(TrajectoryAlgorithmType), effect.TrajectoryEffect),
                            () =>
                            {
                                //Debug.Log("AOE Attack1");
                            });
                        break;
                    case Utils.AOEPointScope:
                        normalGeneralAttack =
                            GeneralAttackManager.Instance().GetPointToPositionScopeGeneralAttack(myClusterData,
                                myClusterData.transform.position,
                                enemyClusterData.transform.position,
                                armyAOE.AOERadius,
                                myMemberData.BulletSpeed,
                                (TrajectoryAlgorithmType)Enum.Parse(typeof(TrajectoryAlgorithmType), effect.TrajectoryEffect),
                                () =>
                                {
                                    //Debug.Log("AOE Attack2");
                                });
                        break;
                    case Utils.AOEScope:
                        normalGeneralAttack = GeneralAttackManager.Instance().GetPositionScopeGeneralAttack(myClusterData,
                            effect.RangeEffect,
                            myClusterData.transform.position,
                            new CircleGraphics(new Vector2(myClusterData.X, myClusterData.Y), armyAOE.AOERadius),
                            1, //effect.EffectTime,
                            () =>
                            {
                                //Debug.Log("AOE Attack3");
                            });
                        break;
                    case Utils.AOEForwardScope:
                        normalGeneralAttack =
                            GeneralAttackManager.Instance().GetPositionRectScopeGeneralAttack(myClusterData,
                                effect.RangeEffect,
                                myClusterData.transform.position,
                                armyAOE.AOEWidth,
                                armyAOE.AOEHeight,
                                Vector2.Angle(Vector2.up, new Vector2(myClusterData.transform.forward.x, myClusterData.transform.forward.z)),
                                1, //effect.EffectTime,
                                () =>
                                {
                                    //Debug.Log("AOE Attack4");
                                    // 播放目标的受击特效
                                });
                        break;
                }
                break;
        }

        if (normalGeneralAttack != null)
        {
            normalGeneralAttack.Begin();
        }
    }
}
