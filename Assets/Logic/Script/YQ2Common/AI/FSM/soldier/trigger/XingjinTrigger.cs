using System;
using UnityEngine;
using System.Collections;
/// <summary>
/// 行进状态，很多状态可以切换为行进状态 比如 入场、待机、攻击
/// </summary>
public class XingjinTrigger : SoldierFSMTrigger
{
    //public override bool CheckTrigger(SoldierFSMSystem fsm)
    //{
    //    //Debug.Log("当前血量--------------------------------------" + fsm.Display.ClusterData.MemberData.CurrentHP);
    //    // 所有的状态标识
    //    if (fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0)
    //    {
    //        return false;
    //    }
    //    switch (fsm.CurrentStateID)
    //    {
    //        case SoldierStateID.RuChang:
    //            return fsm.IsCanRun;
    //        case SoldierStateID.PutongGongji:
    //        case SoldierStateID.JinengGongji:
    //            return fsm.TargetIsLoseEfficacy;
    //        case SoldierStateID.ZhuiJi:
    //            return !fsm.IsZhuiJi;
    //    }
    //    return false;
    //    //return (fsm.IsCanRun || fsm.TargetIsLoseEfficacy) && (fsm.Display.ClusterData.AllData.MemberData.CurrentHP > 0) && !fsm.IsZhuiJi;
    //}

    public override void Init()
    {
        triggerId = SoldierTriggerID.Xingjin;
    }
}