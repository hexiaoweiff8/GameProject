using UnityEngine;
using System.Collections;
using System;

public class JinengGongjiTrigger : SoldierFSMTrigger
{
    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        // 当前单位技能释放判断

        return fsm.IsCanInJinenggongji;
    }

    public override void Init()
    {
        triggerId = SoldierTriggerID.JinengGongji;
    }
}
