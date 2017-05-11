using System;
using UnityEngine;
using System.Collections;
/// <summary>
/// 行进状态，很多状态可以切换为行进状态 比如 入场、待机、攻击
/// </summary>
public class XingjinTrigger : SoldierFSMTrigger
{
    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        return fsm.IsCanRun;
    }

    public override void Init()
    {
        triggerId = SoldierTriggerID.Xingjin;
    }
}
