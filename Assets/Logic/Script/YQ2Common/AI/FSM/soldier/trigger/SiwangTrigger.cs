using UnityEngine;
using System.Collections;
using System;

public class SiwangTrigger : SoldierFSMTrigger
{
    public override void Init()
    {
        triggerId = SoldierTriggerID.SiWang;
    }
    //public override bool CheckTrigger(SoldierFSMSystem fsm)
    //{
    //    return fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0;
    //}
}
