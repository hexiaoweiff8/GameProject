using UnityEngine;
using System.Collections;
using System;

public class PutongGongjiTrigger : SoldierFSMTrigger
{

    ///// <summary>
    ///// 检查状态切换
    ///// </summary>
    ///// <param name="fsm"></param>
    ///// <returns></returns>
    //public override bool CheckTrigger(SoldierFSMSystem fsm)
    //{
    //    switch (fsm.CurrentStateID)
    //    {
    //        case SoldierStateID.Zhunbeizhandou:
    //            return fsm.IsCanInPutonggongji;
    //    }
    //    return false;
    //}


    /// <summary>
    /// 初始化
    /// </summary>
    public override void Init()
    {
        triggerId = SoldierTriggerID.PutongGongji;
    }
}
