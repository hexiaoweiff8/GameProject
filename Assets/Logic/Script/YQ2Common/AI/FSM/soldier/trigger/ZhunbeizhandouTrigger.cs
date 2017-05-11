using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
/// <summary>
/// 准备战斗触发器
/// </summary>
public class ZhunbeizhandouTrigger : SoldierFSMTrigger{
    public override void Init()
    {
        triggerId = SoldierTriggerID.Zhunbeizhandou;
    }

    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {

        var myObjid = fsm.Display.MFAModelRender.ObjId;
        var enemy = DisplayerManager.Single.GetOpposingCamps(myObjid);

        IList<DisplayOwner> list = new List<DisplayOwner>();
        foreach (var display in enemy)
        {
            list.Add(display.Value);
        }
        var res = TargetSelecter.GetCollisionItemList(list,fsm.Display.ClusterData.X,fsm.Display.ClusterData.Y,fsm.Display.ClusterData.MemberData.SightRange);

        if (res.Count > 0)
        {
            System.Random ran = new System.Random();
            var target = res[ran.Next(0, res.Count)];
            fsm.EnemyTarget = target;
        }
        return res.Count > 0;
    }
}
