using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/// <summary>
/// 战斗管理器
/// </summary>
public class FightManager
{
    /// <summary>
    /// 单例
    /// </summary>
    public static FightManager Single
    {
        get
        {
            if (single == null)
            {
                single = new FightManager();
            }

            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static FightManager single = null;



    /// <summary>
    /// 开始战斗
    /// 场景必须切换完毕
    /// </summary>
    /// <param name="mapId">地图Id</param>
    /// <param name="mapDataPacker">战斗数据包装类</param>
    /// <param name="isOnline">是否在线游戏</param>
    public void StartFight(int mapId, MapManager.MapDataParamsPacker mapDataPacker, bool isOnline)
    {
        // 加载战斗数据
        // 加载障碍曾
        var mapInfoData = MapManager.Instance().GetMapInfoById(mapDataPacker.MapId, 1);
        // 加载建筑层
        var mapInfoBuildingData = MapManager.Instance().GetMapInfoById(mapDataPacker.MapId, 2);

        Debug.Log("加载完毕");

        if (AstarFight.Instance != null)
        {
            // 是否在线战斗
            if (isOnline)
            {
                // 设置线上战斗标识
                GlobalData.FightData.IsOnline = true;
                // 启动战斗数据同步
                FightDataSyncer.Single.Start();

                // 设置消息回调
                FightDataSyncer.Single.AddMsgDispatch(
                    MsgId.MsgAskBattleResponse,
                    (headData) =>
                    {
                        // 如果收到战斗请求回复
                        // 加载地图加载建筑
                        AstarFight.Instance.InitMap(mapInfoData, mapInfoBuildingData);
                        // 请求战斗开始
                        FightDataSyncer.Single.SendBattleStartMsg(null);
                    }, true);
                // 请求战斗
                FightDataSyncer.Single.SendAskBattleMsg(null);
                // 如果收到请求开始回复
                FightDataSyncer.Single.AddMsgDispatch(
                   MsgId.MsgBattleStartResponse,
                   (headData) =>
                   {
                       // 如果收到战斗请求回复

                       // TODO 开始战斗可以操作

                       Debug.Log("战斗开始");
                   }, true);
            }
            else
            {

                GlobalData.FightData.IsOnline = false;
                FightDataSyncer.Single.Clear();
                // 如果不是在线战斗
                // 直接加载战斗
                AstarFight.Instance.InitMap(mapInfoData, mapInfoBuildingData);
            }
        }
        else
        {
            Debug.LogError("AstarFight脚本未加载");
        }
    }

    /// <summary>
    /// 结束战斗
    /// </summary>
    public void EndFight()
    {
        // 结束流程
        // 清理数据
    }

    // 战斗关卡

    // 战斗地图加载

    /// <summary>
    /// 加载地图数据
    /// </summary>
    public void InitMap()
    {
        // 加载数据
        if (!GlobalData.FightData.IsSetData)
        {
            Debug.LogError("战斗数据未设置.");
            return;
        }
        // 加载障碍层
        var mapInfoData = MapManager.Instance().GetMapInfoById(GlobalData.FightData.MapId, 1);
        // 加载建筑层
        var mapInfoBuildingData = MapManager.Instance().GetMapInfoById(GlobalData.FightData.MapId, 2);
    }

    // 地图数据请求
    // 数据回来之后调用AstarFight内的初始化并开始战斗
    // 如果是PVE则直接开始战斗

}