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


    /// <summary>
    /// 目标单位
    /// </summary>
    private DisplayOwner targetDisplay = null;

    /// <summary>
    /// 上一帧是否可移动
    /// </summary>
    private bool couldMoveLastTime = false;

    public override void Init()
    {
        StateID = SoldierStateID.Xingjin;
    }


    /// <summary>
    /// 初始化寻路 士兵开始行走
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        base.DoBeforeEntering(fsm);
        clusterData = fsm.Display.ClusterData as ClusterData;
    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        base.DoBeforeLeaving(fsm);
        fsm.IsCanRun = false;
        couldMoveLastTime = false;
    }


    public override void Action(SoldierFSMSystem fsm)
    {
        // TODO 判断当前目标是否有效, 如果无效则重新寻路
        // 目标是否已死亡
        if (targetDisplay == null || targetDisplay.ClusterData == null)
        {
            ReFindPath();
        }

        // TODO 检测是否可移动
        var memberData = fsm.Display.ClusterData.AllData.MemberData;
        if (memberData.CouldMove)
        {
            // 如果能移动, 上一帧是否不可移动, 是则切换移动
            if (!couldMoveLastTime)
            {
                StartMove(fsm);
                couldMoveLastTime = true;
            }
        }
        // 不能移动则停止移动但不切状态
        else
        {
            // 
            if (couldMoveLastTime)
            {
                StopMove(fsm);
                couldMoveLastTime = false;
            }
        }

    }


    /// <summary>
    /// 初始化血条和寻路 士兵开始行走
    /// </summary>
    /// <param name="fsm"></param>
    private void StartMove(SoldierFSMSystem fsm)
    {

        fsm.Display.ClusterData.ContinueMove();

        // 切换动作
        SwitchAnim(fsm, SoldierAnimConst.XINGJIN, WrapMode.Loop);

        // TODO 重巡路条件
        // 重新寻路
        ReFindPath();
    }

    /// <summary>
    /// 停止移动
    /// </summary>
    /// <param name="fsm"></param>
    private void StopMove(SoldierFSMSystem fsm)
    {
        fsm.Display.ClusterData.StopMove();
        // 切换动作
        SwitchAnim(fsm, SoldierAnimConst.DAIJI, WrapMode.Loop);
    }



    /// <summary>
    /// 重巡路径
    /// </summary>
    private void ReFindPath()
    {
        //Debug.Log("重新寻路");
        // 重新寻路设置目标点
        // 清空当前目标点
        clusterData.ClearTarget();
        // 取最近的对方建筑
        var buildingList = DisplayerManager.Single.GetBuildingByType(GetTypeArray(clusterData.AllData.MemberData.ObjID.ObjType));

        // TODO 区分地面与空中

        int[][] mapData = null;
        // 当前地图数据
        switch (clusterData.AllData.MemberData.GeneralType)
        {
            case Utils.GeneralTypeAir:
                mapData = LoadMap.Single.GetAirMapData();
                break;
            case Utils.GeneralTypeSurface:
                mapData = LoadMap.Single.GetSurfaceMapData();
                break;

        }
        // 当前单位位置映射
        var startPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, clusterData.transform.position, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 当前目标位置映射
        var endPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, GetClosestBuildingPos(buildingList), ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 生成路径
        var path = AStarPathFinding.SearchRoad(mapData, startPos[0], startPos[1], endPos[0], endPos[1], (int)clusterData.Diameter, (int)clusterData.Diameter + 1);
        if (path != null && path.Count > 0)
        {
            // 清空当前目标点
            clusterData.ClearTarget();
            clusterData.PushTargetList(Utils.NumToPostionByList(LoadMap.Single.MapPlane.transform.position, path,
                ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight));
        }
        else
        {
            Debug.Log("xingjin 目标点不可达:start:" + startPos[0] + "," + startPos[1] + " end:" + endPos[0] + "," + endPos[1]);
        }
        //clusterData.PushTargetList(Utils.NumToPostionByList(LoadMap.Single.MapPlane.transform.position, path, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight));
    }

    /// <summary>
    /// 获取目标类型
    /// </summary>
    /// <param name="myType"></param>
    /// <returns></returns>
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

    /// <summary>
    /// 获取最近对方建筑位置
    /// </summary>
    /// <param name="displayList"></param>
    /// <returns></returns>
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
                    targetDisplay = display;
                    result = display.GameObj.transform.position;
                }
            }
        }
        return result;
    }

}