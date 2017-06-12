using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

/// <summary>
/// 士兵的行军状态 在行军中主要执行的是寻路和寻敌等操作
/// </summary>
public class Soldier_Xingjin_State : SoldierFSMState
{
    /// <summary>
    /// 当前单位的行动类
    /// </summary>
    private ClusterData clusterData = null;

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
        clusterData = fsm.Display.ClusterData;

        // 重新寻路
        ReFindPath();
    }
    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        base.DoBeforeLeaving(fsm);
        fsm.IsCanRun = false;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        
    }



    /// <summary>
    /// 重巡路径
    /// </summary>
    /// <param name="fsm"></param>
    private void ReFindPath()
    {
        Debug.Log("重新寻路");
        // 重新寻路设置目标点
        // 清空当前目标点
        clusterData.ClearTarget();
        // 取最近的对方建筑
        var buildingList = DisplayerManager.Single.GetBuildingByType(GetTypeArray(clusterData.MemberData.ObjID.ObjType));

        // 当前地图数据
        var mapData = LoadMap.Single.GetMapData();
        // 当前单位位置映射
        var startPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, clusterData.transform.position, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 当前目标位置映射
        var endPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, GetClosestBuildingPos(buildingList), ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 生成路径
        var path = AStarPathFinding.SearchRoad(mapData, startPos[0], startPos[1], endPos[0], endPos[1], (int)clusterData.Diameter, (int)clusterData.Diameter + 1);

        clusterData.PushTargetList(Utils.NumToPostionByList(LoadMap.Single.MapPlane.transform.position, path, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight));
    }


    private ObjectID.ObjectType[] GetTypeArray(ObjectID.ObjectType myType)
    {
        ObjectID.ObjectType[] result = null;
        switch (myType)
        {
            case ObjectID.ObjectType.MyTank:
            case ObjectID.ObjectType.MySoldier:
                result = new[] {ObjectID.ObjectType.EnemyJiDi, ObjectID.ObjectType.EnemyTower};
                break;
            case ObjectID.ObjectType.EnemyTank:
            case ObjectID.ObjectType.EnemySoldier:
                result = new[] { ObjectID.ObjectType.MyJiDi, ObjectID.ObjectType.MyTower };
                break;
        }

        return result;
    }


    private Vector3 GetClosestBuildingPos(IList<DisplayOwner> displayList)
    {
        var result = Vector3.zero;

        if (displayList != null && displayList.Count > 0)
        {
            result = displayList[0].GameObj.transform.position;
            var minDistance = (result - clusterData.transform.position).magnitude;
            foreach (var display in displayList)
            {
                var distance = (display.GameObj.transform.position - clusterData.transform.position).magnitude;
                if (distance < minDistance)
                {
                    minDistance = distance;
                    result = display.GameObj.transform.position;
                }
            }
        }

        return result;
    }

}