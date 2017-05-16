using UnityEngine;
using System.Collections;
using System;
/// <summary>
/// 士兵的行军状态 在行军中主要执行的是寻路和寻敌等操作
/// </summary>
public class Soldier_Xingjin_State : SoldierFSMState
{
    public override void Init()
    {
        StateID = SoldierStateID.Xingjin;
    }
    /// <summary>
    /// 初始化血条和寻路 士兵开始行走
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        base.DoBeforeEntering(fsm);
        fsm.Display.ClusterData.ContinueMove();
    }
    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        base.DoBeforeLeaving(fsm);
        fsm.IsCanRun = false;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        
    }

}
