using UnityEngine;
using System.Collections;
using System;
using Object = UnityEngine.Object;

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
        var allData = fsm.Display.ClusterData.AllData;

        // 死亡时检测技能
        if (allData.SkillInfoList != null)
        {
            // 抛出死亡事件
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                ReleaseMember = fsm.Display,
                ReceiveMember = fsm.Display,
                TypeLevel1 = TriggerLevel1.Fight,
                TypeLevel2 = TriggerLevel2.Death
            });
        }
        Object.Destroy(fsm.Display.ClusterData);
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        //throw new NotImplementedException();
    }
}
