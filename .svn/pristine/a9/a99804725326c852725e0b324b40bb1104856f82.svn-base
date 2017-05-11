using UnityEngine;
using System.Collections;
using System;

public class Soldier_Zhunbeizhandou_State : SoldierFSMState
{
    public override void Init()
    {
        this.StateID = SoldierStateID.Zhunbeizhandou;
    }
    /// <summary>
    /// 准备战斗 作战单位停止运动 并且判断接下来是普通攻击或者技能攻击
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        var myself = fsm.Display.RanderControl;
        myself.ModelRander.SetClip("wait2".GetHashCode());
        fsm.Display.ClusterData.Stop();
        
        fsm.IsCanInPutonggongji = true;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        
    }


}
