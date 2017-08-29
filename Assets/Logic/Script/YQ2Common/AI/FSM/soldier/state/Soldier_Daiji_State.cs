using UnityEngine;
using System.Collections;
using System;
/// <summary>
/// 待机状态 待机状态可以由入场状态切换而来
/// </summary>
public class Soldier_Daiji_State : SoldierFSMState {

    public override void Init()
    {
        StateID = SoldierStateID.DaiJi;
    }

    /// <summary>
    /// 初始化血条和寻路 士兵开始行走
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        //Debug.Log("行进:" + fsm.Display.GameObj.name);
        base.DoBeforeEntering(fsm);
        fsm.Display.ClusterData.StopMove();
        fsm.IsCanRun = true;
        // 切换动作
        SwitchAnim(fsm, SoldierAnimConst.DAIJI, WrapMode.Loop);

    }
    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        base.DoBeforeLeaving(fsm);
        fsm.IsCanRun = false;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        // 根据数据判断切换目标状态
    }

}
