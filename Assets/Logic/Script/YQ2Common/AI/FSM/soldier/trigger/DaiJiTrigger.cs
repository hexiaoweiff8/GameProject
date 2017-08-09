using UnityEngine;
using System.Collections;
using System;

public class DaiJiTrigger : SoldierFSMTrigger {

    //public override bool CheckTrigger(SoldierFSMSystem fsm)
    //{
    //    return false;
    //}

    public override void Init()
    {
        triggerId = SoldierTriggerID.DaiJi;
    }
}