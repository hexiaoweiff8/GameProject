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
        FightUnitFactory.DeleteUnit(fsm.Display.ClusterData.MemberData);
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        //throw new NotImplementedException();
    }
}
