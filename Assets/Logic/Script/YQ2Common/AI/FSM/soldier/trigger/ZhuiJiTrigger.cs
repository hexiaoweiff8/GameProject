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
        var objId = clusterData.MemberData.ObjID;
        // 视野范围内是否有敌人
        var pos = new Vector2(clusterData.X, clusterData.Y);
        var list = CheckRange(objId, pos, clusterData.MemberData.SightRange, clusterData.MemberData.Camp, true);
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

    /// <summary>
    /// 检测范围内单位
    /// </summary>
    /// <param name="objId">筛选者Id</param>
    /// <param name="pos">检测位置</param>
    /// <param name="range">检测半径</param>
    /// <param name="myCamp">当前单位阵营</param>
    /// <param name="isExceptMyCamp">是否排除己方阵营</param>
    /// <returns>范围内单位</returns>
    private IList<PositionObject> CheckRange(ObjectID objId, Vector2 pos, float range, int myCamp = -1, bool isExceptMyCamp = false)
    {
        var memberInSightScope =
                ClusterManager.Single.GetPositionObjectListByGraphics(
                    new CircleGraphics(pos, range));

        IList<PositionObject> list = new List<PositionObject>();
        foreach (var member in memberInSightScope)
        {
            // 区分自己
            if (objId.ID == member.MemberData.ObjID.ID)
            {
                continue;
            }
            // || objId.ObjType != ObjectID.ObjectType.NPCObstacle
            // 区分阵营
            if (member.MemberData.CurrentHP > 0
                && (myCamp == -1
                || (isExceptMyCamp && member.MemberData.Camp != myCamp)
                || (!isExceptMyCamp && member.MemberData.Camp == myCamp)))
            {
                list.Add(member);
            }
        }

        return list;
    }
}