using System;
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Util;

/// <summary>
/// 战斗逻辑
/// </summary>
public class AstarFight : MonoBehaviour
{


    public static AstarFight Instance { get; private set; }

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
    public static int UnitWidth = 1;

    ///// <summary>
    ///// 其实x
    ///// </summary>
    //public int StartX = 0;

    ///// <summary>
    ///// 起始Y
    ///// </summary>
    //public int StartY = 0;

    ///// <summary>
    ///// 目标X
    ///// </summary>
    //public int TargetX = 0;

    ///// <summary>
    ///// 目标Y
    ///// </summary>
    //public int TargetY = 0;

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
    /// 记录同半径下所有可下兵的点，为了计算哪个点离触摸点最近
    /// </summary>
    private readonly List<int> tempList2 = new List<int>();

    /// <summary>
    /// 创建集群个数
    /// </summary>
    public int ItemCount = 1;

    /// <summary>
    /// 地图障碍层
    /// </summary>
    private int[][] mapInfoData;

    /// <summary>
    /// 地图建筑层
    /// </summary>
    private int[][] mapInfoBuildingData;


    /// <summary>
    /// 4个触摸+敌方 5个物体父物体
    /// </summary>
    private readonly Transform[] parentArray = new Transform[5];

    /// <summary>
    /// 4个触摸+敌方 5个物体宽高
    /// </summary>
    private readonly int[][] widthHeightArray = new int[5][];


    /// <summary>
    /// 4个触摸+敌方 5个阵型列表
    /// </summary>
    private readonly int[][] zhenxingArray = new int[5][];

    /// <summary>
    /// 4个触摸+敌方 5个兵种类型列表
    /// </summary>
    private readonly int[] generalTypeArray = new int[5];

    /// <summary>
    /// 当前关卡所有换算了宽高的阵型字典
    /// </summary>
    private static readonly Dictionary<int, int[]> allZhenxingList = new Dictionary<int, int[]>();

    /// <summary>
    /// 向中点偏移距离;
    /// </summary>
    private static readonly Dictionary<int, Vector3> allCenternOffset = new Dictionary<int, Vector3>();

    /// <summary>
    /// 向中点偏移距离
    /// </summary>
    private readonly Vector3[] zhenxingCenternOffsetArray = new Vector3[5];

    /// <summary>
    /// 按半径扩大的4边上的点阵数组，保存10组，不够再动态计算
    /// </summary>
    private readonly int[][] serchPathArray = new int[10][];


    //////////前锋模型数据//////////////////////
    /// <summary>
    /// 4个触摸+敌方 5个物体父物体
    /// </summary>
    private readonly Transform[] QianFengParentArray = new Transform[6];

    /// <summary>
    /// 4个触摸+敌方 5个物体宽高
    /// </summary>
    private readonly int[][] QianFengWidthHeightArray = new int[6][];

    /// <summary>
    /// 前锋模型阵型列表
    /// </summary>
    private readonly int[][] QianFengZXList = new int[6][];

    /// <summary>
    /// 前锋模型向中点偏移距离
    /// </summary>
    private readonly Vector3[] QianFengZhenXingOffsetArray = new Vector3[6];



    void Start()
    {
        // 保存实例化对象
        Instance = this;
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
        // 初始化点阵数组
        // 以触摸点为中心循环扩大搜索半径来搜索可下兵的点，tempList记录搜索正方形范围边上的所有点
        serchPathArray[0] = new[] { 0, 0 };
        var spani = 1;
        while (spani < 10)
        {
            serchPathArray[spani] = new int[2 * spani * 8];
            var a1 = -spani;
            var b1 = -spani;
            var a2 = spani;
            var b2 = spani;
            //获取搜索区域边上的点
            var tempCount = 0;
            for (int i2 = 1; i2 < 2 * spani + 1; i2++)
            {
                serchPathArray[spani][tempCount++] = a1;
                serchPathArray[spani][tempCount++] = b1 + i2;
                serchPathArray[spani][tempCount++] = a1 + i2;
                serchPathArray[spani][tempCount++] = b1;
                serchPathArray[spani][tempCount++] = a2;
                serchPathArray[spani][tempCount++] = b2 - i2;
                serchPathArray[spani][tempCount++] = a2 - i2;
                serchPathArray[spani][tempCount++] = b2;
            }
            int templ = serchPathArray[spani].Length;
            serchPathArray[spani][templ - 4] = a1;
            serchPathArray[spani][templ - 3] = b1;
            serchPathArray[spani][templ - 2] = a2;
            serchPathArray[spani][templ - 1] = b2;
            spani++;
        }

        // 加载TriggerTicker
        TriggerTicker.Single.StopAndClear();
        TriggerTicker.Single.Start();
        // 初始化TimerManager
        TimerManager.Single.Do();

        // 初始化单位
        // InitMap();
    }

    /// <summary>
    /// 初始化地图
    /// </summary>
    public void InitMap(int[][] obMapInfo, int[][] buildingMapInfo)
    {
        //// 判断是否已经设置数据
        //if (!GlobalData.FightData.IsSetData)
        //{
        //    Debug.LogError("战斗数据未设置.");
        //    return;
        //}
        Clear();
        // 清理数据
        // 加载障碍曾
        mapInfoData = obMapInfo;
        // 加载建筑层
        mapInfoBuildingData = buildingMapInfo;

        MapWidth = mapInfoData[0].Length;
        MapHeight = mapInfoData.Length;

        //// 目标点向对方基地/炮塔前进
        //if (TargetX >= MapWidth || TargetX < 0)
        //{
        //    TargetX = MapWidth - 1;
        //}
        //if (TargetY >= MapHeight || TargetY < 0)
        //{
        //    TargetY = MapHeight - 1;
        //}
        // 初始化地图宽度
        UnitWidth = (int)SData_Constant.Single.GetDataOfID(Utils.UnitWidthId).Value;
        LoadMap.Init(mapInfoData, UnitWidth);
        // 初始化集群管理
        var loadMapPos = LoadMap.GetLeftBottom();
        ClusterManager.Single.Init(loadMapPos.x, loadMapPos.z, MapWidth, MapHeight, UnitWidth, mapInfoData);

    }

    /// <summary>
    /// 分析地图
    /// </summary>
    public void AnalysisMap()
    {
        // 解析地图障碍层
        MapManager.Instance().AnalysisMap(mapInfoData);
        // 创建建筑层, 并传入基地等级
        MapManager.Instance().AnalysisMap(mapInfoBuildingData, new MapManager.MapDataParamsPacker()
        {
            MapId = GlobalData.FightData.MapId,
            BaseLevel = GlobalData.FightData.BaseLevel,
            TurretLevel = GlobalData.FightData.TurretLevel,
            Race = GlobalData.FightData.Race,
            EnemyBaseLevel = GlobalData.FightData.EnemyBaseLevel,
            EnemyRace = GlobalData.FightData.EnemyRace,
            EnemyTurretLevel = GlobalData.FightData.EnemyTurretLevel
        });
    }

    /// <summary>
    /// 清理数据
    /// </summary>
    public void Clear()
    {
        // 清理单位
        ClusterManager.Single.ClearAll();
        // 清理本地缓存
        mapInfoData = null;

        mapInfoBuildingData = null;
        //TargetX = 0;
        //TargetY = 0;
    }



    //TODODO  超过红色max的坐标提前转换到max内
    /// <summary>
    /// 设置阵型中每个物体的位置确保不压障碍
    /// </summary>
    /// <param name="mapPosition">物体起始点，我方为世界坐标，敌人方为格子坐标</param>
    /// <param name="index">多点触摸模式下的触摸Index，为4是为敌方</param>
    /// <returns>最优的可下兵的点</returns>
    public void isZhangAi(Vector3 mapPosition, int index)
    {
        //模型的真实坐标
        Vector3 realPosition = new Vector3(0, 0, 0);
        //触摸点所对应格子坐标
        int[] gridPosition = new int[2];
        if (index == 4)//如果为敌人
        {
            gridPosition[0] = (int)mapPosition.x;
            gridPosition[1] = (int)mapPosition.z;
        }
        else
        {

            switch (generalTypeArray[index])
            {
                // 空中单位高度
                case Utils.GeneralTypeAir:
                    realPosition.y = mapPosition.y + SData_Constant.Single.GetDataOfID(Utils.AirTypeConstantId).Value;
                    break;
                // 地面单位高度
                case Utils.GeneralTypeBuilding:
                case Utils.GeneralTypeSurface:
                    realPosition.y = mapPosition.y + SData_Constant.Single.GetDataOfID(Utils.SurfaceTypeConstantId).Value;
                    break;
            }

            mapPosition += zhenxingCenternOffsetArray[index];
            realPosition.x = mapPosition.x;
            realPosition.z = mapPosition.z;
            gridPosition = Utils.PositionToNum(LoadMap.MapPlane.transform.position, realPosition, UnitWidth, MapWidth, MapHeight);
        }
        int tempCount = 0, tempCount2 = 0;
        int an = zhenxingArray[index].Length;
        int _width = widthHeightArray[index][0];//物体宽
        int _height = widthHeightArray[index][1];//物体高
        int[] bianjie = { (-1 + _width), (-1 + _height), (MapWidth - _width), (MapHeight - _height), (maxX - _width) };
        if (index == 4)//如果为敌方
        {
            bianjie[4] = maxX + _width;
            if (gridPosition[0] < bianjie[4] - 13)//如果超过最远下兵范围
            {
                gridPosition[0] = bianjie[4] - 13;
            }
        }
        else
        {
            if (gridPosition[0] > bianjie[4] + 13) //如果超过最远下兵范围
            {
                gridPosition[0] = bianjie[4] + 13;
            }
        }

        //把自己所占格子加入列表,用来给阵型中其他的物体做重叠判断
        int[] tempA3 = new int[zhenxingArray[index].Length * _width * _height];
        for (int i = 0; i < an; i += 2)
        {
            //计算阵型中的点在当前触摸点偏移后的格子坐标
            var tempA1 = new[] { zhenxingArray[index][i] + gridPosition[0], zhenxingArray[index][i + 1] + gridPosition[1] };
            tempList2.Clear();
            var spani = 0;//搜索半径
            while (true)
            {
                int[] tempArray;
                if (spani < 10)
                {
                    tempArray = serchPathArray[spani];//取出缓存的点阵
                }
                else
                {
                    // 以触摸点为中心循环扩大搜索半径来搜索可下兵的点，tempList记录搜索正方形范围边上的所有点
                    tempArray = new int[2 * spani * 8];
                    var a1 = -spani;
                    var b1 = -spani;
                    var a2 = spani;
                    var b2 = spani;
                    //获取搜索区域边上的点
                    var tempCount333 = 0;
                    for (int i2 = 1; i2 < 2 * spani + 1; i2++)
                    {
                        tempArray[tempCount333++] = a1;
                        tempArray[tempCount333++] = b1 + i2;
                        tempArray[tempCount333++] = a1 + i2;
                        tempArray[tempCount333++] = b1;
                        tempArray[tempCount333++] = a2;
                        tempArray[tempCount333++] = b2 - i2;
                        tempArray[tempCount333++] = a2 - i2;
                        tempArray[tempCount333++] = b2;
                    }
                    int templ = tempArray.Length;
                    tempArray[templ - 4] = a1;
                    tempArray[templ - 3] = b1;
                    tempArray[templ - 2] = a2;
                    tempArray[templ - 1] = b2;
                }

                //遍历点阵
                for (int i3 = 0; i3 < tempArray.Length; i3 += 2)
                {
                    var state = false;
                    var tempA2 = new[] { tempA1[0] + tempArray[i3], tempA1[1] + tempArray[i3 + 1] };
                    if (
                        !(((tempA2[0] < bianjie[4] && index != 4) || (tempA2[0] > bianjie[4] && index == 4)) &&
                          tempA2[0] > bianjie[0] && tempA2[1] > bianjie[1] && tempA2[0] < bianjie[2] &&
                          tempA2[1] < bianjie[3]))//如果超过上下左右边界或者超过最远下兵距离
                    {
                        continue;
                    }
                    //测试自己所占格子是否有障碍
                    for (int j = 0; j < _width; j++)
                    {
                        for (int k = 0; k < _height; k++)
                        {
                            var x = tempA2[0] + j;
                            var y = tempA2[1] + k;
                            if (mapInfoData[y][x] == 1)
                            {
                                state = true;
                                break;
                            }
                            else
                            {
                                //测试是否和阵型中其他的物体重叠
                                for (int l = 0; l < tempCount2; l += 2)
                                {
                                    if (tempA3[l] == x && tempA3[l + 1] == y)
                                    {
                                        state = true;
                                        break;
                                    }
                                }
                            }
                        }
                        if (state)//如果有重叠的点或障碍
                        {
                            break;
                        }
                    }
                    if (!state)//如果该点可下兵
                    {
                        //把所有可下兵格子加入列表，用来计算最近格子
                        tempList2.Add(tempA2[0]);
                        tempList2.Add(tempA2[1]);
                    }
                }
                if (tempList2.Count > 0)//如果有可下兵的格子
                {
                    float min = 9999;
                    int tempInt2 = 0;
                    //计算哪个点离触摸点最近
                    for (int i33 = 0; i33 < tempList2.Count; i33 += 2)
                    {
                        var tempFloat = (float)(Math.Pow(tempA1[0] - tempList2[i33], 2) + Math.Pow(tempA1[1] - tempList2[i33 + 1], 2));

                        if (tempFloat < min)
                        {
                            min = tempFloat;
                            tempInt2 = i33;
                        }
                    }

                    //根据计算出来的各个格子位置设置lua传来的物体所有子物体位置
                    Vector3 posXZ = Utils.NumToPosition(LoadMap.transform.position,
                        new Vector2(tempList2[tempInt2], tempList2[tempInt2 + 1]), UnitWidth , MapWidth, MapHeight);
                    //设置子模型的高度
                    Vector3 posY = new Vector3(0, realPosition.y, 0);
                    parentArray[index].GetChild(tempCount++).localPosition = posXZ + posY;
                    if (tempCount < an)//如果不是阵型中最后一个物体
                    {
                        //把自己所占格子加入列表,用来给阵型中其他的物体做重叠判断
                        for (int j = 0; j < _width; j++)
                        {
                            for (int k = 0; k < _height; k++)
                            {
                                tempA3[tempCount2++] = tempList2[tempInt2] + j;
                                tempA3[tempCount2++] = tempList2[tempInt2 + 1] + k;
                            }
                        }
                    }
                    break;
                }
                else//如果没有可下兵的格子则扩大半径循环查找
                {
                    spani++;
                }
            }
        }
    }
    //TODODO  超过红色max的坐标提前转换到max内
    /// <summary>
    /// 设置阵型中每个物体的位置确保不压障碍
    /// </summary>
    /// <param name="mapPosition">物体起始点，我方为世界坐标，敌人方为格子坐标</param>
    /// <param name="index">多点触摸模式下的触摸Index，为4是为敌方</param>
    /// <returns>最优的可下兵的点</returns>
    public void isQianFengZhangAi(Vector3 mapPosition, int index)
    {
        //触摸点所对应格子坐标
        int[] gridPosition = new int[2];
        mapPosition += QianFengZhenXingOffsetArray[index];
        gridPosition = Utils.PositionToNum(LoadMap.MapPlane.transform.position, mapPosition, UnitWidth, MapWidth, MapHeight);
        
        int tempCount = 0, tempCount2 = 0;
        int an = QianFengZXList[index].Length;
        int _width = QianFengWidthHeightArray[index][0];//物体宽
        int _height = QianFengWidthHeightArray[index][1];//物体高
        int[] bianjie = { (-1 + _width), (-1 + _height), (MapWidth - _width), (MapHeight - _height), (maxX - _width) };
        if (gridPosition[0] > bianjie[4] + 13) //如果超过最远下兵范围
        {
            gridPosition[0] = bianjie[4] + 13;
        }

        //把自己所占格子加入列表,用来给阵型中其他的物体做重叠判断
        int[] tempA3 = new int[QianFengZXList[index].Length * _width * _height];
        for (int i = 0; i < an; i += 2)
        {
            //计算阵型中的点在当前触摸点偏移后的格子坐标
            var tempA1 = new[] { QianFengZXList[index][i] + gridPosition[0], QianFengZXList[index][i + 1] + gridPosition[1] };
            tempList2.Clear();
            var spani = 0;//搜索半径
            while (true)
            {
                int[] tempArray;
                if (spani < 10)
                {
                    tempArray = serchPathArray[spani];//取出缓存的点阵
                }
                else
                {
                    // 以触摸点为中心循环扩大搜索半径来搜索可下兵的点，tempList记录搜索正方形范围边上的所有点
                    tempArray = new int[2 * spani * 8];
                    var a1 = -spani;
                    var b1 = -spani;
                    var a2 = spani;
                    var b2 = spani;
                    //获取搜索区域边上的点
                    var tempCount333 = 0;
                    for (int i2 = 1; i2 < 2 * spani + 1; i2++)
                    {
                        tempArray[tempCount333++] = a1;
                        tempArray[tempCount333++] = b1 + i2;
                        tempArray[tempCount333++] = a1 + i2;
                        tempArray[tempCount333++] = b1;
                        tempArray[tempCount333++] = a2;
                        tempArray[tempCount333++] = b2 - i2;
                        tempArray[tempCount333++] = a2 - i2;
                        tempArray[tempCount333++] = b2;
                    }
                    int templ = tempArray.Length;
                    tempArray[templ - 4] = a1;
                    tempArray[templ - 3] = b1;
                    tempArray[templ - 2] = a2;
                    tempArray[templ - 1] = b2;
                }

                //遍历点阵
                for (int i3 = 0; i3 < tempArray.Length; i3 += 2)
                {
                    var state = false;
                    var tempA2 = new[] { tempA1[0] + tempArray[i3], tempA1[1] + tempArray[i3 + 1] };
                    if (!(tempA2[0] > bianjie[0] && tempA2[1] > bianjie[1] && tempA2[0] < bianjie[2] &&
                          tempA2[1] < bianjie[3]))//如果超过上下左右边界或者超过最远下兵距离
                    {
                        continue;
                    }
                    //测试自己所占格子是否有障碍
                    for (int j = 0; j < _width; j++)
                    {
                        for (int k = 0; k < _height; k++)
                        {
                            var x = tempA2[0] + j;
                            var y = tempA2[1] + k;
                            if (mapInfoData[y][x] == 1)
                            {
                                state = true;
                                break;
                            }
                            else
                            {
                                //测试是否和阵型中其他的物体重叠
                                for (int l = 0; l < tempCount2; l += 2)
                                {
                                    if (tempA3[l] == x && tempA3[l + 1] == y)
                                    {
                                        state = true;
                                        break;
                                    }
                                }
                            }
                        }
                        if (state)//如果有重叠的点或障碍
                        {
                            break;
                        }
                    }
                    if (!state)//如果该点可下兵
                    {
                        //把所有可下兵格子加入列表，用来计算最近格子
                        tempList2.Add(tempA2[0]);
                        tempList2.Add(tempA2[1]);
                    }
                }
                if (tempList2.Count > 0)//如果有可下兵的格子
                {
                    float min = 9999;
                    int tempInt2 = 0;
                    //计算哪个点离触摸点最近
                    for (int i33 = 0; i33 < tempList2.Count; i33 += 2)
                    {
                        var tempFloat = (float)(Math.Pow(tempA1[0] - tempList2[i33], 2) + Math.Pow(tempA1[1] - tempList2[i33 + 1], 2));

                        if (tempFloat < min)
                        {
                            min = tempFloat;
                            tempInt2 = i33;
                        }
                    }

                    //根据计算出来的各个格子位置设置lua传来的物体所有子物体位置
                    QianFengParentArray[index].GetChild(tempCount++).position = Utils.NumToPosition(LoadMap.transform.position,
                        new Vector2(tempList2[tempInt2], tempList2[tempInt2 + 1]), UnitWidth, MapWidth, MapHeight);
                    if (tempCount < an)//如果不是阵型中最后一个物体
                    {
                        //把自己所占格子加入列表,用来给阵型中其他的物体做重叠判断
                        for (int j = 0; j < _width; j++)
                        {
                            for (int k = 0; k < _height; k++)
                            {
                                tempA3[tempCount2++] = tempList2[tempInt2] + j;
                                tempA3[tempCount2++] = tempList2[tempInt2 + 1] + k;
                            }
                        }
                    }
                    break;
                }
                else//如果没有可下兵的格子则扩大半径循环查找
                {
                    spani++;
                }
            }
        }
    }
    /// <summary>
    /// 通过物体宽高计算阵型所对应物体占的格子,存入到字典中
    /// </summary>
    /// <param name="cardID">该局所有卡牌ID</param>
    /// <param name="level">该局所有卡牌等级</param>
    /// <returns></returns>
    public static Dictionary<int, int[]> setAllZhenxingList(int[] cardID, int[] level)
    {
        for (int starti = 0; starti < cardID.Length; starti++)
        {
            int _cardID = cardID[starti];
            if (allZhenxingList.ContainsKey(_cardID))
            {
                continue;
            }
            var cardData = SData_armycardbase_c.Single.GetDataOfID(_cardID);
            int armyID = int.Parse(string.Format("{0}{1:D3}", cardData.ArmyID, level[starti]));

            var armyData = SData_armybase_c.Single.GetDataOfID(armyID);
            int _width = (int)Math.Ceiling(armyData.SpaceSet);//物体宽
            int _height = (int)armyData.SpaceSet;//物体高

            //解析阵型数据到数组中
            string s = SData_array_c.Single.GetDataOfID(cardData.ArrayID).Position;
            List<int> tempA = new List<int>();
            var tempS1 = s.Split(';');
            for (int i = 0; i < tempS1.Length; i++)
            {
                var tempS2 = tempS1[i].Split('&');
                tempA.Add(int.Parse(tempS2[0]));
                tempA.Add(int.Parse(tempS2[1]));
            }
            int[] a = tempA.ToArray();



            if (_width == 1 && _height == 1)//如果半径为1
            {
                //把加入宽高转换后的阵型数据放入一维数组中传回lua
                int[] t = new int[a.Length];//显示数组
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
                allZhenxingList[_cardID] = t;
                allCenternOffset[_cardID] = new Vector3((tempMaxX + tempMinX - _width) * UnitWidth / 2f, 0, (tempMaxY + tempMinY - _width) * UnitWidth / 2f);
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
                while (true)
                {
                    var b = true;//记录是否阵型中所有点都不重叠
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
                            var tempIntMaxX = a[i] * tempCount;
                            var tempIntMaxY = a[i + 1] * tempCount;
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
                            //t[i] = a2[a2.Length - 2] + tempIntMaxX;
                            //t[i + 1] = a2[a2.Length - 1] + tempIntMaxY;
                            //取物体宽高最中点（可以尝试取中点或最左下的点）
                            t[i] = a2[a2.Length/2 - 3] + tempIntMaxX;
                            t[i + 1] = a2[a2.Length / 2 - 2] + tempIntMaxY;
                        }
                        allZhenxingList[_cardID] = t;
                        allCenternOffset[_cardID] = new Vector3((tempMaxX + tempMinX - _width) * UnitWidth / 2f, 0, (tempMaxY + tempMinY - _width) * UnitWidth / 2f);

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
        return allZhenxingList;
    }


    /// <summary>
    /// 设置游戏中手牌和地方出牌阵型数据
    /// </summary>
    /// <param name="go">模型引用</param>
    /// <param name="cardID">卡牌ID</param>
    /// <param name="index">模型Index</param>
    public void setZhenxingInfo(Transform go, int cardID, int index)
    {
        zhenxingArray[index] = allZhenxingList[cardID];
        zhenxingCenternOffsetArray[index] = allCenternOffset[cardID];
        int armyID = int.Parse(string.Format("{0}{1:D3}", SData_armycardbase_c.Single.GetDataOfID(cardID).ArmyID, 1));
        generalTypeArray[index] = (int)SData_armybase_c.Single.GetDataOfID(armyID).GeneralType;
        widthHeightArray[index] = new[] { (int)Math.Ceiling(SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet), (int)SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet };
        parentArray[index] = go;
        if (index == 4)
        {
            //如果是敌方则阵型水平翻转
            for (int i = 0; i < zhenxingArray[index].Length; i += 2)
            {
                zhenxingArray[index][i] = -zhenxingArray[index][i];
            }
        }
    }

    /// <summary>
    /// 设置前锋阵型数据
    /// </summary>
    /// <param name="go"></param>
    /// <param name="cardID"></param>
    /// <param name="index"></param>
    public void setQianFengInfo(Transform go, int cardID, int index)
    {
        QianFengZXList[index] = allZhenxingList[cardID];
        QianFengZhenXingOffsetArray[index] = allCenternOffset[cardID];
        int armyID = int.Parse(string.Format("{0}{1:D3}", SData_armycardbase_c.Single.GetDataOfID(cardID).ArmyID, 1));
        QianFengWidthHeightArray[index] = new[] { (int)Math.Ceiling(SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet), (int)SData_armybase_c.Single.GetDataOfID(armyID).SpaceSet };
        QianFengParentArray[index] = go;
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
    /// 设置可下兵的最远的X坐标
    /// </summary>
    /// <param name="X">可下兵的最远的X坐标(格子坐标)</param>
    public void setMaxX(float X)
    {
        maxX = (int)((X - LoadMap.MapPlane.transform.position.x) / UnitWidth + MapWidth / 2f);
    }


    public void OnDestroy()
    {
        // 销毁时清空引用
        Instance = null;
    }

}