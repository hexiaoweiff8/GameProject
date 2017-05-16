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
            //排除掉已经死了的目标
            if (display.Value.ClusterData.MemberData.CurrentHP > 0)
            {
                list.Add(display.Value);
            }
        }
        var res = TargetSelecter.GetCollisionItemList(list,fsm.Display.ClusterData.X,fsm.Display.ClusterData.Y,fsm.Display.ClusterData.MemberData.SightRange);

        if (res.Count > 0)
        {
            System.Random ran = new System.Random();
            var target = res[ran.Next(0, res.Count)];
            fsm.EnemyTarget = target;
            fsm.TargetIsLoseEfficacy = false;
        }
        return res.Count > 0;
    }
}
