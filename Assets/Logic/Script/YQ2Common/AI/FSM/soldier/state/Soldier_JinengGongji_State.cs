using UnityEngine;
using System.Collections;

public class Soldier_JinengGongji_State : SoldierFSMState
{

    public override void Init()
    {
        StateID = SoldierStateID.JinengGongji;
    }

    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        Debug.Log("技能攻击");
    }
    public override void Action(SoldierFSMSystem fsm)
    {
        // fsm 中带技能
        if (fsm.IsCanInJinenggongji && fsm.EnemyTarget.ClusterData != null && fsm.EnemyTarget.GameObj != null)
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
            fsm.IsCanInJinenggongji = false;
            fsm.Skill = null;
            // 切换状态到行进状态
            fsm.TargetIsLoseEfficacy = true;
            fsm.EnemyTarget = null;
        }
    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        Debug.Log("技能攻击结束");
    }
}