using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 地图管理器
/// </summary>
public class MapManager : Singleton<MapManager>
{
    /// <summary>
    /// 地图文件数据字典
    /// (地图文件名, 地图数据)
    /// </summary>
    private Dictionary<string, string> mapDataDic = null;

    /// <summary>
    /// 地图文件是否已加载
    /// </summary>
    private bool isLoaded = false;
    // -----------------文件加载管理--------------------

    /// <summary>
    /// 按照ID加载文件, 并且将加载文件缓存
    /// </summary>
    /// <param name="mapId">被加载地图DI</param>
    /// <param name="level">被加载层级</param>
    /// <returns>被加载地图内容, 如果不存在返回null</returns>
    public int[][] GetMapInfoById(int mapId, int level)
    {
        int[][] result = null;

        if (!isLoaded)
        {
            // 加载文件
            mapDataDic = Utils.DepartFileData(Utils.LoadFileRotate(@"MapData\mapdata"));

            if (mapDataDic == null)
            {
                Debug.LogError("加载失败");
            }
            else
            {
                isLoaded = true;
            }
        }
        if (mapId > 0)
        {
            // 从缓存中查找, 如果缓存中不存在, 则从文件中加载
            var key = Utils.GetMapFileNameById(mapId, level);
            if (mapDataDic != null && mapDataDic.ContainsKey(key))
            {
                result = DeCodeInfo(mapDataDic[key]);
            }
            else
            {
                Debug.LogError("地图不存在 ID:" + mapId);
            }
        }

        return result;
    }


    /// <summary>
    /// 解码地图数据
    /// </summary>
    /// <param name="mapInfoJson">地图数据json</param>
    /// <returns>地图数据数组</returns>
    private int[][] DeCodeInfo(string mapInfoJson)
    {
        if (string.IsNullOrEmpty(mapInfoJson))
        {
            return null;
        }
        //var mapData = new List<List<int>>();
        // 读出数据
        var mapLines = mapInfoJson.Split('\n');

        int[][] mapInfo = new int[mapLines.Length][];
        for (var row = 0; row < mapLines.Length; row++)
        {
            var line = mapLines[row];
            if (string.IsNullOrEmpty(line))
            {
                continue;
            }

            var cells = line.Split(',');
            mapInfo[row] = new int[cells.Length];
            for (int col = 0; col < cells.Length; col++)
            {
                if (string.IsNullOrEmpty(cells[col].Trim()))
                {
                    continue;
                }
                //Debug.Log(cells[col]);
                mapInfo[row][col] = int.Parse(cells[col]);
            }
        }

        return mapInfo;
    }
}