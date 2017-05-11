﻿using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public class AstarFight : MonoBehaviour
{

    private GameObject main;

    /// <summary>
    /// 寻路X轴宽度
    /// </summary>
    public int DiameterX = 1;

    /// <summary>
    /// 寻路Y轴宽度
    /// </summary>
    public int DiameterY = 1;

    /// <summary>
    /// 随机
    /// </summary>
    //public int RandomRate = 40;

    /// <summary>
    /// 地图宽度
    /// </summary>
    public int MapWidth = 50;

    /// <summary>
    /// 地图高度
    /// </summary>
    public int MapHeight = 50;

    /// <summary>
    /// 单位宽度
    /// </summary>
    public int UnitWidth = 1;

    /// <summary>
    /// 其实x
    /// </summary>
    public int StartX = 0;

    /// <summary>
    /// 起始Y
    /// </summary>
    public int StartY = 0;

    /// <summary>
    /// 目标X
    /// </summary>
    public int TargetX = 0;

    /// <summary>
    /// 目标Y
    /// </summary>
    public int TargetY = 0;

    /// <summary>
    /// 是否提供跳点路径
    /// </summary>
    public bool IsJumpPoint = false;

    /// <summary>
    /// 地图加载
    /// </summary>
    public LoadMap LoadMap;

    /// <summary>
    /// 路径点对象
    /// </summary>
    public GameObject PathPoint;

    /// <summary>
    /// 路径点父级
    /// </summary>
    public GameObject PathPointFather;

    ///// <summary>
    ///// 集群引用
    ///// </summary>
    //public ClusterManager ClusterManager;

    /// <summary>
    /// 可下兵的最远的X坐标
    /// </summary>
    private int maxX;

    /// <summary>
    /// 以触摸点为中心循环扩大搜索半径来搜索可下兵的点，tempList记录搜索正方形范围边上的所有点
    /// </summary>
    private List<int> tempList = new List<int>();
    /// <summary>
    /// 记录同半径下所有可下兵的点，为了计算哪个点离触摸点最近
    /// </summary>
    private List<int> tempList2 = new List<int>();

    /// <summary>
    /// 创建集群个数
    /// </summary>
    public int ItemCount = 1;


    private int[][] mapInfoData;

    /// <summary>
    /// 4个触摸+敌方 5个阵型列表
    /// </summary>
    private int[][] zhenxingArray = new int[5][];
    /// <summary>
    /// 当前关卡所有换算了宽高的阵型字典
    /// </summary>
    private Dictionary<int, int[]> allZhenxingList = new Dictionary<int, int[]>();

    /// <summary>
    /// 当前阵型最远的X值(单位：格子)，避免下兵时右半侧的部队可以下到最远区域外
    /// </summary>
    private int[] zhenxingMaxXArray = new int[5];
    /// <summary>
    /// 当前关卡所有换算了宽高的阵型最远的X值字典
    /// </summary>
    private Dictionary<int, int> allZhenxingMaxX = new Dictionary<int, int>();
    /// <summary>
    /// 向中点偏移距离;
    /// </summary>
    private Dictionary<int, Vector3> allCenternOffset = new Dictionary<int, Vector3>();

    /// <summary>
    /// 向中点偏移距离
    /// </summary>
    private Vector3[] zhenxingCenternOffsetArray = new Vector3[5];

    void Start()
    {
        // 初始化
        Init();
    }



    //private void setAllZhenxingList()
    //{
    //}


    /// <summary>
    /// 初始化战斗场景
    /// </summary>
    private void Init()
    {
        // TODO 文件应该从配置文件中读取
        var mapInfoPath = Application.dataPath + Path.AltDirectorySeparatorChar + "mapinfo";
        var mapInfoStr = Utils.LoadFileInfo(mapInfoPath);
        mapInfoData = DeCodeInfo(mapInfoStr);

        MapWidth = mapInfoData[0].Length;
        MapHeight = mapInfoData.Length;
        if (TargetX >= MapWidth || TargetX < 0)
        {
            TargetX = MapWidth - 1;
        }
        if (TargetY >= MapHeight || TargetY < 0)
        {
            TargetY = MapHeight - 1;
        }

        LoadMap.Init(mapInfoData, UnitWidth);
        // 初始化集群管理
        var loadMapPos = LoadMap.GetLeftBottom();
        ClusterManager.Single.Init(loadMapPos.x + MapWidth * UnitWidth * 0.5f, loadMapPos.z + MapHeight * UnitWidth * 0.5f, MapWidth, MapHeight, UnitWidth, mapInfoData);

        // 创建障碍物
        var fixtureList = FixtureData.GetFixtureDataList(mapInfoData, LoadMap.transform.position, MapWidth, MapHeight, UnitWidth);
        // 将障碍物加入列表
        foreach (var fixture in fixtureList)
        {
            ClusterManager.Single.Add(fixture);
        }
    }


    /// <summary>
    /// 向lua返回最优的可下兵的点
    /// </summary>
    /// <param name="mp">物体起始点，我方为世界坐标，地方为格子坐标</param>
    /// <param name="index">多点触摸模式下的触摸Index，为4是为敌方</param>
    /// <returns>最优的可下兵的点</returns>
    public Vector3 isZhangAi(Vector3 mp, int index)
    {
        mp += zhenxingCenternOffsetArray[index];
        int[] a = new int[2];
        int spani = 1;//搜索半径
        int tempMax = maxX - zhenxingMaxXArray[index];
        if (index == 4)//如果为敌人
        {
            a[0] = (int)mp.x;
            a[1] = (int)mp.z;
        }
        else
        {
            a = Utils.PositionToNum(LoadMap.MapPlane.transform.position, mp, UnitWidth, MapWidth, MapHeight);
        }
        Vector3 tempP = Utils.NumToPosition(LoadMap.transform.position, new Vector2(a[0], a[1]), UnitWidth,
        MapWidth, MapHeight);
        ////触摸点世界坐标转换为格子坐标
        //float[] aC = { (tempP.x - mp.x) / UnitWidth, (tempP.z - mp.z) / UnitWidth };

        tempList2.Clear();
        while (true)
        {
            tempList.Clear();
            if (spani == 1)//半径为1时添加触摸点本身
            {
                tempList.Add(0);
                tempList.Add(0);
            }
            int a1 = -spani;
            int b1 = -spani;
            int a2 = spani;
            int b2 = spani;
            //获取搜索区域边上的点
            for (int i = 1; i < 2 * spani + 1; i++)
            {
                tempList.Add(a1);
                tempList.Add(b1 + i);
                tempList.Add(a1 + i);
                tempList.Add(b1);
                tempList.Add(a2);
                tempList.Add(b2 - i);
                tempList.Add(a2 - i);
                tempList.Add(b2);
            }
            int templ = tempList.Count;
            tempList[templ - 4] = a1;
            tempList[templ - 3] = b1;
            tempList[templ - 2] = a2;
            tempList[templ - 1] = b2;
            spani++;

            for (int i = 0; i < tempList.Count; i += 2)
            {
                //测试是否是可下兵的点
                if (testPoint(a[0] + tempList[i], a[1] + tempList[i + 1], index) && (((a[0] + tempList[i]) < tempMax && index != 4) || ((a[0] + tempList[i]) > tempMax && index == 4)))
                {
                    tempList2.Add(tempList[i]);
                    tempList2.Add(tempList[i + 1]);
                }
            }

            if (tempList2.Count > 0)
            {
                float min = 9999;
                float tempFloat;
                int tempInt2 = 0;
                //计算哪个点离触摸点最近
                for (int i = 0; i < tempList2.Count; i += 2)
                {
                    //tempFloat = (float)(Math.Pow(aC[0] - tempList2[i], 2) + Math.Pow(aC[1] - tempList2[i + 1], 2));
                    tempFloat = (float)(Math.Pow(tempList2[i], 2) + Math.Pow(tempList2[i + 1], 2));
                    if (tempFloat < min)
                    {
                        min = tempFloat;
                        tempInt2 = i;
                    }
                }

                //向lua返回最优的可下兵的点
                                return Utils.NumToPosition(LoadMap.transform.position, new Vector2(a[0] + tempList2[tempInt2], a[1] + tempList2[tempInt2 + 1]), UnitWidth, MapWidth, MapHeight);
            }
        }
    }

    /// <summary>
    /// 设置可下兵的最远的X坐标
    /// </summary>
    /// <param name="X">可下兵的最远的X坐标</param>
    public void setMaxX(float X)
    {
        maxX = (int)((X - LoadMap.MapPlane.transform.position.x + MapWidth * UnitWidth / 2) / UnitWidth);
    }


    /// <summary>
    /// 通过物体宽高计算阵型所对应物体占的格子,存入到字典中
    /// </summary>
    /// <param name="cardID">该局所有卡牌ID</param>
    /// <param name="level">该局所有卡牌等级</param>
    /// <returns></returns>
    public Dictionary<int, int[]> setAllZhenxingList(int[] cardID, int[] level)
    {
        Dictionary<int, int[]> allrenderZhenxingList = new Dictionary<int, int[]>(); // 当前关卡所有换算了宽高的阵型字典

        for (int starti = 0; starti < cardID.Length; starti++)
        {
            int _cardID = cardID[starti];
            if (allZhenxingMaxX.ContainsKey(_cardID))
            {
                continue;
            }
            int armyID = int.Parse(string.Format("{0}{1:D3}", SData_armycardbase_c.Single.GetDataOfID(_cardID).ArmyID, level[starti]));
            int _width = (int)Math.Ceiling(SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet);//物体宽
            int _height = (int)SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet;//物体高

            //解析阵型数据到数组中
            string s = SData_zhenxing_data.Single.GetDataOfID(SData_armycardbase_c.Single.GetDataOfID(_cardID).ArrayID).Position;
            int idx = 0;
            int tempidx = 0;
            List<int> tempA = new List<int>();
            string tempS;
            string[] tempS1;
            string[] tempS2;
            tempS1 = s.Split(';');
            for (int i = 0; i < tempS1.Length; i++)
            {
                tempS2 = tempS1[i].Split(',');
                tempA.Add(int.Parse(tempS2[0]));
                tempA.Add(int.Parse(tempS2[1]));
            }
            int[] a = tempA.ToArray();



            if (_width == 1 && _height == 1)//如果半径为1
            {
                //把加入宽高转换后的阵型数据放入一维数组中传回lua
                int[] t = new int[a.Length];//显示数组
                int[] t2 = new int[2];//做碰撞判断的数组
                int tempCount2 = 0;
                int tempMax = 0;//最远的x值
                int tempMaxX = 0;//最大的x值
                int tempMinX = 0; //最小的x值
                int tempMaxY = 0; //最大的y值
                int tempMinY = 0;//最小的y值
                for (int i = 0; i < a.Length; i += 2)
                {
                    if (a[i] > tempMax)
                    {
                        tempMax = a[i];
                    }
                    if (a[i] > tempMaxX)
                    {
                        tempMaxX = a[i];
                    }
                    if (a[i] < tempMinX)
                    {
                        tempMinX = a[i];
                    }
                    if (a[i + 1] > tempMaxY)
                    {
                        tempMaxY = a[i + 1];
                    }
                    if (a[i + 1] < tempMinY)
                    {
                        tempMinY = a[i + 1];
                    }
                    t[i] = a[i];
                    t[i + 1] = a[i + 1];
                }
                allZhenxingMaxX[_cardID] = tempMax + _width;
                allZhenxingList[_cardID] = t;
                allrenderZhenxingList[_cardID] = t;
                allCenternOffset[_cardID] = new Vector3((tempMaxX + tempMinX - _width) * UnitWidth / 2, 0, (tempMaxY + tempMinY - _width) * UnitWidth / 2);//TODODO 半径为1时中心点还没有设置
            }
            else
            {
                //把物体宽高转换为格子数据，0,0点为左下角
                int[] a2 = new int[_width * _height * 2];
                for (int i = 0; i < _width; i++)
                {
                    for (int j = 0; j < _height; j++)
                    {
                        var t = (i * _height + j) * 2;
                        a2[t] = i;
                        a2[t + 1] = j;
                    }
                }

                //根据阵型中物体的个数拷贝出相应的物体格子数据放到数组中
                int[][] a3 = new int[a.Length / 2][];
                for (int i = 0; i < a.Length; i += 2)
                {
                    a3[i / 2] = new int[a2.Length];
                    for (int j = 0; j < a2.Length; j += 2)
                    {
                        a3[i / 2][j] = a2[j] + a[i];
                        a3[i / 2][j + 1] = a2[j + 1] + a[i + 1];
                    }
                }

                int tempCount = 1;//记录偏移次数
                bool b;//记录是否阵型中所有点都不重叠
                while (true)
                {
                    b = true;
                    //冒泡法遍历阵型中所有点验证是否有重复的点
                    for (int i = 0; i < a3.Length; i++)
                    {
                        for (int k = 0; k < a3[i].Length; k += 2)
                        {
                            if (a3[i][k] == 999)//如果该点已经不重叠了则跳过改点
                            {
                                continue;
                            }
                            for (int j = i + 1; j < a3.Length; j++)
                            {
                                for (int l = 0; l < a3[j].Length; l += 2)
                                {
                                    if (a3[i][k] == a3[j][l] && a3[i][k + 1] == a3[j][l + 1])
                                    {
                                        b = false;
                                        break;
                                    }
                                }
                                if (!b)
                                {
                                    break;
                                }
                            }
                            if (b)
                            {
                                a3[i][k] = 999;//该点不重叠则设置为跳过
                            }
                        }
                    }
                    if (b)//如果所有点都不重复
                    {

                        //把加入宽高转换后的阵型数据放入一维数组中传回lua
                        int[] t = new int[a.Length];//显示数组
                        int[] t2 = new int[a3.Length * a2.Length];//做碰撞判断的数组
                        int tempCount2 = 0;
                        int tempIntMaxX = 0;
                        int tempIntMinX = 0;
                        int tempIntMaxY = 0;
                        int tempIntMinY = 0;
                        int tempMaxX = 0;//最大的x值
                        int tempMinX = 0; //最小的x值
                        int tempMaxY = 0; //最大的y值
                        int tempMinY = 0;//最小的y值
                        for (int i = 0; i < a.Length; i += 2)
                        {
                            for (int j = 0; j < a2.Length; j += 2)
                            {
                                t2[tempCount2++] = a2[j] + a[i] * tempCount;//阵型*偏移次数
                                t2[tempCount2++] = a2[j + 1] + a[i + 1] * tempCount; //阵型*偏移次数
                            }
                            tempIntMaxX = a[i] * tempCount;
                            tempIntMaxY = a[i + 1] * tempCount;
                            if (tempIntMaxX > tempMaxX)
                            {
                                tempMaxX = tempIntMaxX;
                            }
                            if (tempIntMaxX < tempMinX)
                            {
                                tempMinX = tempIntMaxX;
                            }
                            if (tempIntMaxY > tempMaxY)
                            {
                                tempMaxY = tempIntMaxY;
                            }
                            if (tempIntMaxY < tempMinY)
                            {
                                tempMinY = tempIntMaxY;
                            }
                            //取物体宽高最右上的点（可以尝试取中点或最左下的点）
                            t[i] = a2[a2.Length - 2] + tempIntMaxX;
                            t[i + 1] = a2[a2.Length - 1] + tempIntMaxY;
                        }
                        allZhenxingMaxX[_cardID] = tempMaxX + _width;
                        allZhenxingList[_cardID] = t2;
                        allrenderZhenxingList[_cardID] = t;
                        allCenternOffset[_cardID] = new Vector3((tempMaxX + tempMinX - _width) * UnitWidth / 2, 0, (tempMaxY + tempMinY - _width) * UnitWidth / 2);//TODODO 半径为1时中心点还没有设置

                        break;
                    }
                    else
                    {
                        tempCount++;
                        //每次向阵型中所在点的方向偏移
                        for (int i = 0; i < a.Length; i += 2)
                        {
                            for (int j = 0; j < a3[i / 2].Length; j += 2)
                            {
                                if (a3[i / 2][j] == 999)//如果该点已经不重叠了则跳过改点
                                {
                                    continue;
                                }
                                a3[i / 2][j] += a[i];
                                a3[i / 2][j + 1] += a[i + 1];
                            }
                        }
                    }
                }
            }
        }
        return allrenderZhenxingList;
    }

    public void setZhenxingInfo(int cardID, int index)
    {
        zhenxingMaxXArray[index] = allZhenxingMaxX[cardID];
        zhenxingArray[index] = allZhenxingList[cardID];
        zhenxingCenternOffsetArray[index] = allCenternOffset[cardID];
        if (index == 4)
        {
            zhenxingMaxXArray[index] = -zhenxingMaxXArray[index];
            //如果是敌方则阵型水平翻转
            for (int i = 0; i < zhenxingArray[index].Length; i += 2)
            {
                zhenxingArray[index][i] = -zhenxingArray[index][i];
            }
        }
    }

    /// <summary>
    /// 向lua传回世界坐标转换为格子坐标
    /// </summary>
    /// <param name="p"></param>
    /// <returns></returns>
    public Vector3 getNum(Vector3 p)
    {
        int[] a = Utils.PositionToNum(LoadMap.MapPlane.transform.position, p, UnitWidth, MapWidth, MapHeight);
        return new Vector3(a[0], 0, a[1]);

    }


    /// <summary>
    /// 物体寻路
    /// </summary>
    /// <param name="isEnemy">是否为地方阵营</param>
    /// <param name="groupIndex">队伍index</param>
    /// <param name="go">物体GameObject</param>
    internal void toXunLu(ClusterData data, bool isEnemy, int groupIndex, DisplayOwner displayOwner)
    {
        var go = displayOwner.GameObj;
        if (go == null)
        {
            throw new Exception("显示对象的GameObj引用为空. 请检查创建过程.");
        }
        //把物体当前世界坐标转换为格子坐标
        int[] a = Utils.PositionToNum(LoadMap.MapPlane.transform.position, go.transform.position, UnitWidth, MapWidth, MapHeight);
        IList<Node> path;
        if (!isEnemy)//敌我阵营的起始位置相反
        {
            path = AStarPathFinding.SearchRoad(mapInfoData, a[0], a[1], TargetX, a[1], DiameterX, DiameterY,
                IsJumpPoint);
        }
        else
        {
            path = AStarPathFinding.SearchRoad(mapInfoData, a[0], a[1], 1, a[1], DiameterX, DiameterY,
                IsJumpPoint);
        }


        ClusterData clusterData = data;
        //TODODO
        clusterData.GroupId = groupIndex;
        clusterData.PhysicsInfo.MaxSpeed = 30;
        clusterData.RotateSpeed = 1;
        clusterData.RotateWeight = 1;
        clusterData.Diameter = 1 * UnitWidth;

        //clusterData.transform.localPosition = new Vector3((tempInt % 3) * 2, 1, tempInt / 3 * 2) + Utils.NumToPosition(LoadMap.transform.position, new Vector2(a[0], a[1]), UnitWidth, MapWidth, MapHeight);

        clusterData.Group.Target = Utils.NumToPosition(LoadMap.MapPlane.transform.position, new Vector2(path[path.Count - 1].X, path[path.Count - 1].Y), UnitWidth, MapWidth, MapHeight);
        ClusterManager.Single.Add(clusterData);
        // 外层对象持有ClusterData引用
        displayOwner.ClusterData = clusterData;

        Action<ClusterGroup> lambdaComplete = (thisGroup) =>
        {
            //Debug.Log("GroupComplete:" + thisGroup.Target);
            // 数据本地化
            // 数据结束
            if (path.Count == 0)
            {
                return;
            }
            path.RemoveAt(path.Count - 1);
            if (path.Count == 0)
            {
                return;
            }
            var node = path[path.Count - 1];
            thisGroup.Target = Utils.NumToPosition(LoadMap.MapPlane.transform.position, new Vector2(node.X, node.Y), UnitWidth, MapWidth, MapHeight);
        };
        clusterData.Group.ProportionOfComplete = 1;
        clusterData.Group.Complete = lambdaComplete;
    }

    /// <summary>
    /// //测试是否是可下兵的点
    /// </summary>
    /// <param name="a0"></param>
    /// <param name="a1"></param>
    /// <param name="index">多点触摸模式下的触摸Index，为4是为敌方</param>
    /// <returns></returns>
    private bool testPoint(int a0, int a1, int index)
    {
        int an = zhenxingArray[index].Length;
        int x, y;
        for (int i = 0; i < an; i += 2)
        {
            x = a0 + zhenxingArray[index][i];
            y = a1 + zhenxingArray[index][i + 1];
            if (x > -1 && y > -1 && x < MapWidth && y < MapHeight && mapInfoData[y][x] == 1)
            {
                return false;
            }
        }
        return true;
    }

    /// <summary>
    /// TODO 解码地图数据
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

        int[][] mapInfo = new int[mapLines.Length - 1][];
        for (var row = 0; row < mapLines.Length; row++)
        {
            var line = mapLines[row];
            if (string.IsNullOrEmpty(line))
            {
                continue;
            }
            var cells = line.Split(',');
            // Debug.Log(line);
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