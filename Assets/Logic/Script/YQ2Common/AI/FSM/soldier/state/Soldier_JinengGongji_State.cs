using System;
using UnityEngine;
using System.Collections;
using Util;

public class Soldier_JinengGongji_State : SoldierFSMState
{

    /// <summary>
    /// 开火计时器
    /// </summary>
    private Timer skillTimer;

    /// <summary>
    /// 技能执行计数器
    /// </summary>
    private int counter = 0;


    private FormulaParamsPacker param;

    public override void Init()
    {
        StateID = SoldierStateID.JinengGongji;
    }

    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        //Debug.Log("技能攻击:" + fsm.Display.GameObj.name);
        // 单位转向目标
        var clusterData = fsm.Display.ClusterData as ClusterData;
        if (clusterData != null)
        {
            clusterData.RotateToWithoutYAxis(fsm.EnemyTarget.ClusterData.transform.position);
        }

        // 被释放技能
        var skill = fsm.Skill;
        if (skill == null)
        {
            throw new Exception("被释放技能为空.");
        }

        param = FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(
            fsm.Skill,
            fsm.Display,
            fsm.EnemyTarget
            );

        // 开始释放技能
        if (skill.ReleaseTime > 0)
        {
            // 执行技能起始效果(Attach)
            SkillManager.Single.DoFormula(skill.GetAttachFormula(param));
            skillTimer = new Timer(skill.IntervalTime, true);
            skillTimer.OnCompleteCallback(() => { ReleaseSkill(fsm); })
                .OnKill(() =>
                {
                    // 执行技能结束效果(Detach)
                    SkillManager.Single.DoFormula(skill.GetDetachFormula(param));
                }).Start();
        }
        else
        {
            ReleaseSkill(fsm);
        }
    }

    public override void Action(SoldierFSMSystem fsm)
    {

    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        // 中断技能
        skillTimer.Kill();
    }


    /// <summary>
    /// 释放技能
    /// </summary>
    /// <param name="fsm"></param>
    private void ReleaseSkill(SoldierFSMSystem fsm)
    {

        // TODO 持续技能
        // 技能状态
        // 开始执行技能
        // 
        // 技能动作

        // fsm 中带技能
        if (fsm.IsCanInJinenggongji && fsm.EnemyTarget.ClusterData != null && fsm.EnemyTarget.GameObj != null)
        {
            SkillManager.Single.DoSkillInfo(fsm.Skill, param, fsm.Skill.ReleaseTime > 1);

            // 检测是否释放完毕
            if (fsm.Skill.IsDone)
            {
                fsm.IsCanInJinenggongji = false;
                fsm.Skill = null;
                // 切换状态到行进状态
                fsm.TargetIsLoseEfficacy = true;
                fsm.EnemyTarget = null;
            }
        }
        else
        {
            // 技能不可被释放, 跳出释放技能状态
            fsm.IsCanInJinenggongji = false;
            fsm.Skill = null;
            // 切换状态到行进状态
            fsm.TargetIsLoseEfficacy = true;
            fsm.EnemyTarget = null;
            
        }

        // 技能结束标记
        // TODO 结束条件
        // 时间, 距离, 死亡, 被位移, 切状态

        counter++;
        if (counter >= fsm.Skill.ReleaseTime)
        {
            // 退出
            fsm.Skill.IsDone = true;
        }
    }
}