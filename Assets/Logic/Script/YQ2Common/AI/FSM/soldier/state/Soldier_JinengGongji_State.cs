using UnityEngine;
using System.Collections;

public class Soldier_JinengGongji_State : SoldierFSMState
{
    /// <summary>
    /// 技能是否释放完毕
    /// </summary>
    private bool skillIsEnd = false;

    public override void Init()
    {
        StateID = SoldierStateID.JinengGongji;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        // fsm 中带技能ID
        if (!skillIsEnd)
        {
            SkillManager.Single.DoShillInfo(fsm.Skill, new FormulaParamsPacker()
            {
                DataList = fsm.Skill.DataList,
                // TODO 技能等级, 最大目标数量
                SkillLevel = 1,
                SkillNum = fsm.Skill.SkillNum,
                ReceiverMenber = fsm.EnemyTarget,
                ReleaseMember = fsm.Display,
                StartPos = fsm.Display.ClusterData.gameObject.transform.position,
                TargetPos = fsm.EnemyTarget.ClusterData.gameObject.transform.position
            });
            skillIsEnd = true;
            fsm.Skill = null;
        }
        else
        {
            // 切换状态到行进状态
            fsm.IsCanInJinenggongji = false;
            fsm.TargetIsLoseEfficacy = true;
            fsm.EnemyTarget = null;
        }
    }
}