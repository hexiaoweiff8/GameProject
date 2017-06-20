using UnityEngine;
using System.Collections;
using System;

public class Soldier_Siwang_State : SoldierFSMState
{
    public override void Init()
    {
        this.StateID = SoldierStateID.SiWang;
    }
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        base.DoBeforeEntering(fsm);
        fsm.Display.ClusterData.Stop();
        ClusterManager.Single.Remove(fsm.Display.ClusterData);
        FightUnitFactory.DeleteUnit(fsm.Display.ClusterData.AllData.MemberData);
        // 释放死亡时技能
        var fightVo = fsm.Display.ClusterData.AllData.MemberData as FightVO;

        // 死亡时检测技能
        if (fightVo != null && fightVo.SkillInfoList != null)
        {
            SkillManager.Single.CheckAndDoSkillInfo(fightVo.SkillInfoList, fsm.Display, fsm.EnemyTarget, SkillTriggerLevel1.Fight, SkillTriggerLevel2.Death);
        }
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        //throw new NotImplementedException();
    }
}
