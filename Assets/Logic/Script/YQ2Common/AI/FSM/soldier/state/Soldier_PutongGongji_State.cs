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
        _fireTimer = new Timer(_fireTick,true);
        _fireTimer.OnCompleteCallback(() => { fire(fsm); }).Start();

        _bulletCount = fsm.Display.ClusterData.MemberData.Clipsize1;
        _bulletMax = fsm.Display.ClusterData.MemberData.Clipsize1;
        _reloadTime = fsm.Display.ClusterData.MemberData.ReloadTime1;
    }

    private void fire(SoldierFSMSystem fsm)
    {
        _bulletCount --;
        if (null == fsm.EnemyTarget || null == fsm.EnemyTarget.ClusterData)
        {
            return;
        }
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
        Vector3 dir = fsm.EnemyTarget.ClusterData.Position - fsm.Display.ClusterData.Position;
        dir = dir.normalized;

        var bullet = GameObject.CreatePrimitive(PrimitiveType.Cube);
        bullet.transform.localScale = new Vector3(1, 1, 1);
        // Effect层
        bullet.layer = 12;

        var ballistic = BallisticFactory.Single.CreateBallistic(bullet, fsm.Display.ClusterData.Position, dir,
                        fsm.EnemyTarget.ClusterData.Position,
                        200f, 3, trajectoryType: TrajectoryAlgorithmType.Line);


        ballistic.Complete = (a, b) =>
        {
            GameObject.Destroy(a.gameObject);
            var isMiss = HurtResult.AdjustIsMiss(fsm.Display, fsm.EnemyTarget);
            if (!isMiss)
            {
                var hurt = HurtResult.GetHurt(fsm.Display, fsm.EnemyTarget);
                if (null != fsm.EnemyTarget &&
                    null != fsm.EnemyTarget.ClusterData &&
                    null != fsm.EnemyTarget.RanderControl)
                {
                    fsm.EnemyTarget.ClusterData.MemberData.CurrentHP -= hurt;
                    fsm.EnemyTarget.RanderControl.SetBloodBarValue();
                }
            }
            else
            {
                //播放miss特效

            }

        };
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
            if (AdjustTargetIsInRange(fsm))
            {
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
        if (null == fsm.EnemyTarget || null == fsm.EnemyTarget.ClusterData)
        {
            return true;
        }
        var targetPos = fsm.EnemyTarget.ClusterData.Position;
        var myPos = fsm.Display.ClusterData.Position;
        var distance = AI_Math.V2Distance(targetPos.x, targetPos.z, myPos.x, myPos.z);
        return (distance > fsm.Display.ClusterData.MemberData.SightRange) ||
               (fsm.EnemyTarget.ClusterData.MemberData.CurrentHP <= 0);

    }
}
