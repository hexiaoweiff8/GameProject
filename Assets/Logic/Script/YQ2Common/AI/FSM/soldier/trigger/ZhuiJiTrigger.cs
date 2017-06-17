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
        // 如果正在技能攻击或普通攻击则不进入追击状态
        if (fsm.IsCanInJinenggongji || fsm.IsCanInPutonggongji)
        {
            return false;
        }
        var clusterData = fsm.Display.ClusterData;
        //var objId = clusterData.MemberData.ObjID;
        // 视野范围内是否有敌人
        var pos = new Vector2(clusterData.X, clusterData.Y);
        var list = ClusterManager.Single.CheckRange( pos, clusterData.MemberData.SightRange, clusterData.MemberData.Camp, true);
        Utils.DrawGraphics(new CircleGraphics(pos, clusterData.MemberData.SightRange), Color.yellow);
        //fsm.Display.ClusterData.MemberData.SightRange
        if (list.Count > 0)
        {
            // 追击目标
            // 设置状态 切追击状态
            fsm.IsZhuiJi = true;
            return SetTarget(fsm, list);
        }

        return fsm.IsZhuiJi;
    }


    /// <summary>
    /// 设置目标单位
    /// </summary>
    /// <param name="fsm"></param>
    /// <param name="res"></param>
    /// <returns></returns>
    private bool SetTarget(SoldierFSMSystem fsm, IList<PositionObject> res)
    {
        var ran = new System.Random();
        // TODO 取最近的
        var target = res[ran.Next(0, res.Count)];
        fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
        return res.Count > 0;
    }
}