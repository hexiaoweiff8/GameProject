using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


/// <summary>
/// 追击状态检测
/// </summary>
public class ZhuiJiTrigger : SoldierFSMTrigger
{
    public override void Init()
    {
        triggerId = SoldierTriggerID.ZhuiJi;
    }

    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        return fsm.IsZhuiJi;
    }
}