using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 追击状态
/// </summary>
public class Soldier_Zhuiji_State : SoldierFSMState
{
    /// <summary>
    /// 当前单位的行动类
    /// </summary>
    private ClusterData clusterData = null;

    /// <summary>
    /// 目标位置
    /// </summary>
    private ClusterData targetClusterData = null;

    /// <summary>
    /// 当前目标点
    /// </summary>
    private Vector3 targetPos;

    /// <summary>
    /// 初始化
    /// </summary>
    public override void Init()
    {
        // 状态切换
        StateID = SoldierStateID.ZhuiJi;
    }

    /// <summary>
    /// 进入改状态时执行
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        // 加载当前数据
        Debug.Log("追击状态:" + fsm.Display.GameObj.name);
        clusterData = fsm.Display.ClusterData;
        targetClusterData = fsm.EnemyTarget.ClusterData;
    }

    /// <summary>
    /// 每帧检测
    /// </summary>
    /// <param name="fsm"></param>
    public override void Action(SoldierFSMSystem fsm)
    {
        // 检测目标是否在追击范围内
        if (TargetIsInScope())
        {
            // 检测目标是否与当前目标点差距太大, 如果没有需用寻路, 如果有则重新寻路
            if (IsNeedReFindPath())
            {
                // 重巡路径
                ReFindPath();
            }

        }
        else
        {
            // 切换行进状态
            fsm.IsZhuiJi = false;
        }
    }

    /// <summary>
    /// 改状态消失时执行
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        // 清空当前数据
        Debug.Log("技能攻击结束:" + fsm.Display.GameObj.name);
    }


    /// <summary>
    /// 是否需要重新寻路
    /// </summary>
    /// <param name="fsm"></param>
    /// <returns></returns>
    private bool IsNeedReFindPath()
    {
        // 判断目标点与当前目标的距离
        var distance = (Utils.WithOutY(targetPos) - Utils.WithOutY(targetClusterData.transform.position)).magnitude;
        var minDistance = clusterData.Diameter*ClusterManager.Single.UnitWidth*0.5f +
                          targetClusterData.Diameter*ClusterManager.Single.UnitWidth*0.5f;

        return distance > minDistance;
    }

    /// <summary>
    /// 重巡路径
    /// </summary>
    /// <param name="fsm"></param>
    private void ReFindPath()
    {
        // 重新寻路设置目标点
        // 清空当前目标点
        clusterData.ClearTarget();
        // 当前地图数据
        var mapData = LoadMap.Single.GetMapData();
        // 当前单位位置映射
        var startPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, clusterData.transform.position, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 当前目标位置映射
        var endPos = Utils.PositionToNum(LoadMap.Single.MapPlane.transform.position, targetClusterData.transform.position, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight);
        // 生成路径
        var path = AStarPathFinding.SearchRoad(mapData, startPos[0], startPos[1], endPos[0], endPos[1], (int)clusterData.Diameter, (int)clusterData.Diameter + 1);
        targetPos = targetClusterData.transform.position;
        clusterData.PushTargetList(Utils.NumToPostionByList(LoadMap.Single.MapPlane.transform.position, path, ClusterManager.Single.UnitWidth, ClusterManager.Single.MapWidth, ClusterManager.Single.MapHeight));
    }

    /// <summary>
    /// 是否超出追击范围
    /// </summary>
    /// <returns></returns>
    private bool TargetIsInScope()
    {
        var distance = (Utils.WithOutY(targetClusterData.transform.position) -
                        Utils.WithOutY(clusterData.transform.position));
        var result = distance.magnitude < 200;

        return result;
    }

}
