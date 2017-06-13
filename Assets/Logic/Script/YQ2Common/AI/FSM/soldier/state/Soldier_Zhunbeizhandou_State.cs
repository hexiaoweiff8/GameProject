using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

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
        if (fsm.IsCanInPutonggongji || fsm.IsCanInJinenggongji)
        {
            //var myself = fsm.Display.RanderControl;
            //myself.ModelRander.SetClip("attack".GetHashCode());
            fsm.Display.ClusterData.Stop();
        }


        // 状态切换路由
        //if (fsm.EnemyTarget != null && fsm.Skill == null)
        //{
        //    fsm.IsCanInPutonggongji = true;
        //}
        //else if(fsm.Skill != null)
        //{
        //    fsm.IsCanInJinenggongji = true;
        //}
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        
    }


}
