using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Random = System.Random;

public class AstarTest : MonoBehaviour
{

    /// <summary>
    /// 主相机
    /// </summary>
    public Camera MainCamera;

    /// <summary>
    /// 寻路X轴宽度
    /// </summary>
    public int DiameterX = 4; 

    /// <summary>
    /// 寻路Y轴宽度
    /// </summary>
    public int DiameterY = 2;

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
    /// 是否启动状态机
    /// </summary>
    public bool IsFSM = false;

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

    /// <summary>
    /// 创建集群个数
    /// </summary>
    public int ItemCount = 10;

    /// <summary>
    /// 集群引用
    /// </summary>
    //public ClusterManager clusterManager;
    


    /// <summary>
    /// 路径点列表
    /// </summary>
    private IList<GameObject> pathPoint = new List<GameObject>();

    /// <summary>
    /// 上次目标点X
    /// </summary>
    private int lastTimeTargetX = 0;

    /// <summary>
    /// 上次目标点Y
    /// </summary>
    private int lastTimeTargetY = 0;

    /// <summary>
    /// 搜寻单位
    /// </summary>
    private ClusterData scaner = null;

    /// <summary>
    /// 集群单位列表
    /// </summary>
    private IList<PositionObject> itemList = new List<PositionObject>();


    

    void Start ()
    {
        // 加载技能
        string formulaStr = @"SkillNum(1001)
{
        Point(1,test/ExplordScope,0,0,3,10,1,10),
        CollisionDetection(0, 10, 1, 0, -1, 10, 0, 0)
        {
            Skill(1, 1002, 1)
            //PointToObj(1,test/TrailPrj,10,0,10,1,10),
            //Point(1,test/ExplordScope,1,0,3,10,1,10),
        }
}";
        string formulaStr2 = @"SkillNum(1002)
{
        PointToObj(1,test/TrailPrj,10,0,10,1,10),
        Point(1,test/ExplordScope,1,0,3,10,1,10),
}";
        string formulaStr3 = @"SkillNum(1003)
{
        SlideCollisionDetection(1, 1, %0, 40, -1)
        {
            //PointToObj(1,test/TrailPrj,10,0,10,1,10),
            Point(1,test/ExplordScope,1,%1,10,1,10),
        }
}
        // 数据
        [
            TriggerLevel1(1)
            TriggerLevel2(1)
            100, 5
        ]
";
        string formulaStr4 = @"SkillNum(1004)
{
        Move(1, 3, false)
}";
        string formulaStr5 = @"SkillNum(1005)
    {
        SlideCollisionDetection(1, 1, %0, 40, -1)
        {
            //If(1, 0, Health, 0_100)
            //{
                HealthChange(1,0,0,0,1)
                //PointToObj(1,test/TrailPrj,10,0,10,1,10),
                Point(1,test/ExplordScope,1,%1,10,1,10),   
            //}
        }
         
    }

        [
            TriggerLevel1(1)
            TriggerLevel2(1)
            Description(哟哦哦{%0},哦哟哦哟{%1})
            100, 5
        ]
";
        string formulaStr6 = @"SkillNum(1006)
        {
            HealthChange(1,0,0,0,1)
        }

";

        string formulaStr7 = @"SkillNum(1007)
        {
            SlideCollisionDetection(1, 1, %0, 40, -1)
            {
                //If(1, 0, Health, 0_100)
                //{
                    Buff(1,1007, 1)
                    Buff(1,1008, 1)
                    //PointToObj(1,test/TrailPrj,10,0,10,1,10),
                    //Point(1,test/ExplordScope,1,%1,10,1,10),   
                //}
            }
        }

        [
            CDTime(1)
            CDGroup(2)
            Icon(test/Icon1)
            ReleaseTime(10)
            TriggerLevel1(1)
            TriggerLevel2(1)
            Description(Test{%0},测试{%1})
            100, 5
        ]
"; 
        string buffStr1 = @"BuffNum(1007)
        Action
        {
            HealthChange(1,0,0,0,1)
        }

        [
            TickTime(1)
            BuffTime(10)
            TriggerLevel1(4)
            TriggerLevel2(18)
            BuffLevel(1)
            BuffGroup(1)
            ChangeData(CurrentHP,100,0)
        ]
";

        string buffStr2 = @"BuffNum(1008)
        Action
        {
            ResistDemage(1,3,1,true)
            {
                Point(1,test/ExplordScope,0,3,10,1,10),  
            }
        }
        [
            BuffTime(10)
            TriggerLevel1(3)
            TriggerLevel2(10)
            DetachTriggerLevel1(3)
            DetachTriggerLevel2(10)
            DetachQualified(ResistDemage,<=,0.0f)
        ]
";


        var skillInfo = FormulaConstructor.SkillConstructor(formulaStr);
        var skillInfo2 = FormulaConstructor.SkillConstructor(formulaStr2);
        var skillInfo3 = FormulaConstructor.SkillConstructor(formulaStr3);
        var skillInfo4 = FormulaConstructor.SkillConstructor(formulaStr4);
        var skillInfo5 = FormulaConstructor.SkillConstructor(formulaStr5);
        var skillInfo7 = FormulaConstructor.SkillConstructor(formulaStr7);
        var buffInfo1 = FormulaConstructor.BuffConstructor(buffStr1);
        var buffInfo2 = FormulaConstructor.BuffConstructor(buffStr2);

        SkillManager.Single.AddSkillInfo(skillInfo);
        SkillManager.Single.AddSkillInfo(skillInfo2);
        SkillManager.Single.AddSkillInfo(skillInfo3);
        SkillManager.Single.AddSkillInfo(skillInfo4);
        SkillManager.Single.AddSkillInfo(skillInfo5);
        SkillManager.Single.AddSkillInfo(skillInfo7);
        BuffManager.Single.AddBuffInfo(buffInfo1);
        BuffManager.Single.AddBuffInfo(buffInfo2);

        // 启动TriggerTicker
        TriggerTicker.Single.Start();

        Debug.Log(skillInfo5.GetReplacedDescription(1));
        //Debug.Log(buffInfo1.GetReplacedDescription(1));
        // 设定帧数
        Application.targetFrameRate = 60;
        var loadMapPos = LoadMap.GetLeftBottom();
        ClusterManager.Single.Init(loadMapPos.x + LoadMap.MapWidth * LoadMap.UnitWidth, loadMapPos.z + LoadMap.MapHeight * LoadMap.UnitWidth, MapWidth, MapHeight, UnitWidth, null);
        InitMapInfo();

        // 启动显示管理器
        DisplayerManager.AutoInstance();
        // 启动携程器
        CoroutineManage.AutoInstance();
        // 启动数据管理器
        DataManager.AutoInstance();
        // 加载资源包
        var packLoader = new PacketLoader();
        packLoader.Start(PackType.Res, new List<string>()
            {
                "ui_fightU"
            }, (isDone) =>
            {
                if (isDone)
                {
                    Debug.Log("加载完毕");
                }
            });

        Debug.LogError(RandomPacker.Single.GetRangeI(0, 100));
        RandomPacker.Single.SetSeed(100);
        Debug.LogError(RandomPacker.Single.GetRangeI(0, 100));
        Debug.LogError(RandomPacker.Single.GetRangeI(0, 100));
        RandomPacker.Single.SetSeed(100);
        Debug.LogError(RandomPacker.Single.GetRangeI(0, 100));
        Debug.LogError(RandomPacker.Single.GetRangeI(0, 100));
    }
    
    void Update()
    {
        // 控制
        Control();
        Scan();
        // 显示数据
        Log();
        //CheckTrigger();
    }


    private void Scan()
    {
        if (scaner != null)
        {
            var resultList = TargetSelecter.GetCollisionItemList(itemList, scaner.X, scaner.Y, scaner.AllData.MemberData.AttackRange*0.5f);
            Utils.DrawCircle(new Vector3(scaner.X, 0, scaner.Y), scaner.AllData.MemberData.AttackRange * 0.5f, Color.white);
            for (var i = 0; i < resultList.Count; i++)
            {
                var item = resultList[i];
                Utils.DrawCircle(new Vector3(item.X, 0, item.Y), item.AllData.MemberData.SpaceSet * 0.5f, Color.white);
            }
        }
    }
    
    /// <summary>
    /// 控制
    /// </summary>
    private void Control()
    {
        if (Input.GetMouseButtonDown(1))
        {
            // 释放技能
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            if (hit.collider != null && hit.collider.name.Equals(LoadMap.MapPlane.name))
            {
               
                SkillManager.Single.DoSkillNum(1007, new FormulaParamsPacker()
                {
                    StartPos = new Vector3(hit.point.x, 0, hit.point.z),
                    TargetPos = new Vector3(hit.point.x - 40, 0, hit.point.z + 40),
                    ReleaseMember = new DisplayOwner(scaner.gameObject, scaner),
                });
            }
        }
        if (Input.GetMouseButtonDown(0))
        {
            // 获取地图上的点击点
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            // 点击到底板
            if (hit.collider != null && hit.collider.name.Equals(LoadMap.MapPlane.name))
            {
                var posOnMap = Utils.PositionToNum(LoadMap.MapPlane.transform.position, hit.point, UnitWidth, MapWidth, MapHeight);
                Debug.Log("start:" + lastTimeTargetX + "," + lastTimeTargetY + " end:" + posOnMap[0] + "," + posOnMap[1]);
                // 加载文件内容
                var mapInfoData = InitMapInfo();

                var path = AStarPathFinding.SearchRoad(mapInfoData, lastTimeTargetX, lastTimeTargetY, posOnMap[0], posOnMap[1], DiameterX, DiameterY, IsJumpPoint);
                // 根据path放地标, 使用组队寻路跟随过去
                //StartCoroutine(Step(path));
                
                var loadMapPos = LoadMap.GetLeftBottom();
                ClusterManager.Single.Init(loadMapPos.x + LoadMap.MapWidth * LoadMap.UnitWidth * 0.5f, loadMapPos.z + LoadMap.MapHeight * LoadMap.UnitWidth * 0.5f, MapWidth, MapHeight, UnitWidth, mapInfoData);
                //LoadMap.RefreshMap();
                StartMoving(path, mapInfoData, lastTimeTargetX, lastTimeTargetY);

                // 缓存上次目标点
                lastTimeTargetX = posOnMap[0];
                lastTimeTargetY = posOnMap[1];

            }
        }

        if (Input.GetMouseButtonDown(2))
        {
            // 获取地图上的点击点
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            // 点击到底板
            if (hit.collider != null && hit.collider.name.Equals(LoadMap.MapPlane.name))
            {
                var posOnMap = Utils.PositionToNum(LoadMap.MapPlane.transform.position, hit.point, UnitWidth, MapWidth, MapHeight);
                // 加载文件内容
                var mapInfoData = InitMapInfo();

                
                // 根据path放地标, 使用组队寻路跟随过去
                StartCoroutine(AStarPathFinding.ISearchRoad(mapInfoData, lastTimeTargetX, lastTimeTargetY, posOnMap[0], posOnMap[1], DiameterX, DiameterY));

                // 缓存上次目标点
                lastTimeTargetX = posOnMap[0];
                lastTimeTargetY = posOnMap[1];

            }
        }

        if (Input.GetMouseButton(0))
        {
            Utils.DrawGraphics(new RectGraphics(new Vector2(0,0), 10, 10, 90), Color.white);
        }

        // 上下左右移动
        if (Input.GetKey(KeyCode.UpArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z + 1);
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z - 1);
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x - 1, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x + 1, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z);
        }
        // 升高下降
        if (Input.GetKey(KeyCode.PageUp))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y + 1, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.PageDown))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y - 1, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.P))
        {
            // 暂停
            ClusterManager.Single.Pause();
        }
        if (Input.GetKey(KeyCode.G))
        {
            // 继续
            ClusterManager.Single.GoOn();
        }
        // 绘制关闭列表
        DrawCloseMap(AStarPathFinding.closePathMap);
    }


    public void Log()
    {
        foreach (var item in itemList)
        {
            if (item is ClusterData)
            {
                Debug.Log(item.AllData.MemberData.CurrentHP);
            }
        }
    }


    ///// <summary>
    ///// 检测当前单位的触发事件
    ///// </summary>
    //private void CheckTrigger()
    //{
    //    if (scaner == null)
    //    {
    //        return;
    //    }
    //    var alldata = scaner.AllData;
    //    if (alldata.MemberData != null && alldata.SkillInfoList != null)
    //    {
    //        // 结算技能伤害/治疗
    //        SettlementDamageOrCure();
    //        // 触发当前单位的所有事件
    //        SkillManager.Single.SetEachAction(alldata.MemberData.ObjID, (type1, type2, trigger) =>
    //        {
    //            // 触发skill类
    //            SkillManager.Single.CheckAndDoSkillInfo(alldata.SkillInfoList, trigger);
    //            // 触发buff类
    //            BuffManager.Single.CheckAndDoBuffInfo(alldata.BuffInfoList, trigger);
    //        },
    //        true);
    //    }
    //}

    ///// <summary>
    ///// 结算当前单位的血量
    ///// </summary>
    //private void SettlementDamageOrCure()
    //{
    //    var alldata = scaner.AllData;
    //    var isOneHealth = false;
    //    if (alldata.MemberData != null && alldata.SkillInfoList != null)
    //    {
    //        var demage = 0f;
    //        var cure = 0f;

    //        // 先计算治疗量
    //        var cureList = SkillManager.Single.GetSkillTriggerDataList(alldata.MemberData.ObjID, TriggerLevel1.Fight, TriggerLevel2.BeCure);
    //        if (cureList != null && cureList.Count > 0)
    //        {
    //            // 计算治疗量总和
    //            cure += cureList.Sum(attackMember => attackMember.HealthChangeValue);
    //        }

    //        // 再计算伤害量
    //        // 获取被击列表
    //        var attackList = SkillManager.Single.GetSkillTriggerDataList(alldata.MemberData.ObjID, TriggerLevel1.Fight, TriggerLevel2.BeAttack);
    //        // 检测是否被击
    //        if (attackList != null && attackList.Count > 0)
    //        {
    //            // 计算血量变动总和
    //            // 这里返回的都是负值所以使用+=
    //            demage += attackList.Sum(attackMember => attackMember.HealthChangeValue);

    //            // 如果单位死亡在抛出一个死亡事件
    //            // 检测致死攻击
    //            if (alldata.MemberData.CurrentHP - demage < Utils.ApproachZero)
    //            {
    //                // 检测最后一个
    //                var lastHitMember = attackList[attackList.Count - 1];
    //                // 并判断该伤害是否致死, 如果不致死则生命值设置为1
    //                if (lastHitMember.IsNotLethal)
    //                {
    //                    isOneHealth = true;
    //                }
    //                else
    //                {
    //                    // 抛出致死攻击事件
    //                    SkillManager.Single.SetTriggerData(new TriggerData()
    //                    {
    //                        HealthChangeValue = lastHitMember.HealthChangeValue,
    //                        ReceiveMember = lastHitMember.ReceiveMember,
    //                        ReleaseMember = lastHitMember.ReleaseMember,
    //                        TypeLevel1 = TriggerLevel1.Fight,
    //                        TypeLevel2 = TriggerLevel2.LethalHit
    //                    });
    //                }
    //            }


    //            // 如果有伤害吸收则将伤害计算到技能的伤害吸收中
    //            if (demage < Utils.ApproachZero)
    //            {
    //                // 检测是否有伤害吸收的buff/skill
    //                // 触发吸收伤害事件
    //            }

    //            // 结算血量变动
    //            if (isOneHealth)
    //            {
    //                // 收到非致死超过血量的伤害, 生命值设置为1
    //                scaner.AllData.MemberData.CurrentHP = 1;
    //            }
    //            else
    //            {
    //                // 正常扣血
    //                scaner.AllData.MemberData.CurrentHP += cure - demage;
    //            }
    //        }
    //    }
    //}

    /// <summary>
    /// 初始化
    /// </summary>
    public int[][] InitMapInfo()
    {
        //var mapInfoPath = Application.dataPath + Path.AltDirectorySeparatorChar + "mapinfo";
        //var mapInfoStr = Utils.LoadFileInfo(mapInfoPath);
        //var mapInfoData = DeCodeInfo(mapInfoStr);
        var mapInfoData = MapManager.Instance().GetMapInfoById(1, 1);
        LoadMap.Init(mapInfoData, UnitWidth);
        ClusterManager.Single.Init(-MapWidth * 0.5f, -MapHeight * 0.5f, MapWidth, MapHeight, 10, mapInfoData);
        MapWidth = mapInfoData[0].Length;
        MapHeight = mapInfoData.Length;
        return mapInfoData;
    }
    
    /// <summary>
    /// 携程移动
    /// </summary>
    /// <param name="path">移动路径</param>
    IEnumerator Step(IList<Node> path)
    {
        // 删除所有
        pathPoint.All((item) => {
            Destroy(item);
            return item;
        });
        pathPoint.Clear();
        var pathArray = path.ToArray();
        Array.Reverse(pathArray);
        foreach (var node in pathArray)
        {
            for (var x = 0; x < DiameterX; x++)
            {
                for (var y = 0; y < DiameterY; y++)
                {
                    var newSphere = Instantiate(PathPoint);
                    newSphere.transform.parent = PathPointFather == null ? null : PathPointFather.transform;
                    newSphere.transform.position = Utils.NumToPosition(LoadMap.transform.position, new Vector2(node.X, node.Y), UnitWidth, MapWidth, MapHeight)
                        + new Vector3(UnitWidth * x, 0, UnitWidth * y);
                    pathPoint.Add(newSphere);
                }
            }
            yield return new WaitForEndOfFrame();
        }
        yield return null;
    }


    private void DrawCloseMap(int[][] closeTable)
    {
        if (closeTable != null)
        {
            for (int i = 0; i < closeTable.Length; i++)
            {
                var row = closeTable[i];
                for (var j = 0; j < row.Length; j++)
                {
                    var cell = row[j];
                    if (cell == Utils.Closed)
                    {
                        // 绘制关闭路径
                        Utils.DrawRect(Utils.NumToPosition(LoadMap.transform.position, new Vector2(j, i), UnitWidth, MapWidth, MapHeight), UnitWidth, UnitWidth, 0, Color.green);
                    }
                }
            }
        }
    }

    /// <summary>
    /// 随机生成地图
    /// </summary>
    /// <param name="x">地图宽度</param>
    /// <param name="y">地图高度</param>
    /// <returns>地图数据</returns>
    //int[][] RandomMap(int x, int y)
    //{
    //    var random = new Random();
    //    var map = new int[y][];
    //    for (var i = 0; i < y; i++)
    //    {
    //        if (map[i] == null)
    //        {
    //            map[i] = new int[x];
    //        }
    //        for (var j = 0; j < x; j++)
    //        {

    //            map[i][j] = random.Next(RandomRate) > 1 ? Accessibility : Obstacle;
    //        }
    //    }
    //    return map;
    //}

    /// <summary>
    /// 集群功能
    /// 组建集群开始根据路径点移动
    /// </summary>
    /// <param name="pathList">列表</param>
    /// <param name="map">地图信息</param>
    private void StartMoving(IList<Node> pathList, int[][] map, int startX, int startY)
    {
        if (pathList == null || pathList.Count == 0)
        {
            return;
        }
        foreach (var item in itemList)
        {
            Destroy(item);
            Destroy(item.gameObject);
        }
        itemList.Clear();
        // 清除所有组
        ClusterManager.Single.ClearAll();
        GameObject schoolItem = null;
        ClusterData school = null;
        var cloneList = new List<Node>(pathList);
        var target = Utils.NumToPosition(LoadMap.transform.position, new Vector2(cloneList[cloneList.Count - 1].X, cloneList[cloneList.Count - 1].Y), UnitWidth, MapWidth, MapHeight);
        var start = Utils.NumToPosition(LoadMap.transform.position, new Vector2(startX, startY), UnitWidth, MapWidth, MapHeight);
        for (int i = 0; i < ItemCount; i++)
        {
            var objId = new ObjectID(ObjectID.ObjectType.MySoldier);
            schoolItem = GameObject.CreatePrimitive(PrimitiveType.Cube);
            school = schoolItem.AddComponent<ClusterData>();
            school.AllData.MemberData = new VOBase()
            {
                AttackRange = 20,
                SpaceSet = 3,
                ObjID = objId,
                MoveSpeed = 60
            };
            //school.GroupId = 1;
            // TODO 物理信息中一部分来自于数据
            school.MaxSpeed = 10;
            school.RotateSpeed = 10;
            school.transform.localPosition = new Vector3((i % 3) * 2 + start.x, start.y, i / 3 * 2 + start.z);
            school.name = "item" + i;
            school.TargetPos = target;
            school.Diameter = i == 0 ? 10 : 3;
            school.PushTargetList(Utils.NumToPostionByList(LoadMap.transform.position, cloneList, UnitWidth, MapWidth, MapHeight));
            //school.Moveing = (a) => { Debug.Log(a.name + "Moving"); };

            //school.Wait = (a) => { Debug.Log(a.name + "Wait"); };
            //school.Complete = (a) => { Debug.Log(a.name + "Complete"); };
            // 目标选择权重
            var fightData = new SelectWeightData();
            // 选择目标数据
            fightData.AirWeight = 100;
            fightData.BuildWeight = 100;
            fightData.SurfaceWeight = 100;

            fightData.HumanWeight = 10;
            fightData.OrcWeight = 10;
            fightData.OmnicWeight = 10;
            //member.TankWeight = 10;
            //member.LVWeight = 10;
            //member.CannonWeight = 10;
            //member.AirCraftWeight = 10;
            //member.SoldierWeight = 10;

            fightData.HideWeight = -1;
            fightData.TauntWeight = 1000;

            fightData.HealthMaxWeight = 0;
            fightData.HealthMinWeight = 10;
            //member.AngleWeight = 10;
            fightData.DistanceMaxWeight = 0;
            fightData.DistanceMinWeight = 10;
            school.AllData.SelectWeightData = fightData;
            school.AllData.MemberData.CurrentHP = 99;
            school.AllData.MemberData.TotalHp = 100;

            // 创建测试技能
            school.AllData.SkillInfoList=new List<SkillInfo>()
            {
                
            };


            itemList.Add(school);
            ClusterManager.Single.Add(school);
            var displayOwner = new DisplayOwner(schoolItem, school);
            DisplayerManager.Single.AddElement(objId, displayOwner);

            if (IsFSM)
            {
                // 加载RanderControl
                var randerControl = schoolItem.AddComponent<RanderControl>();
                displayOwner.RanderControl = randerControl;
                // 挂载事件处理器
                var triggerRunner = schoolItem.AddComponent<TriggerRunner>();
                triggerRunner.Display = displayOwner;

                // TODO 为了适应状态机中的效果
                var head = GameObject.CreatePrimitive(PrimitiveType.Cube);
                head.name = "head";
                schoolItem.AddChild(head);
            }

            //Action<ClusterGroup> lam = (thisGroup) =>
            //{
            //    // Debug.Log("GroupComplete:" + thisGroup.Target);
            //    // 数据本地化
            //    // 数据结束
            //    if (cloneList.Count == 0)
            //    {
            //        return;
            //    }
            //    cloneList.RemoveAt(cloneList.Count - 1);
            //    if (cloneList.Count == 0)
            //    {
            //        return;
            //    }
            //    //var node = cloneList[cloneList.Count - 1];
            //    //thisGroup.Target = Utils.NumToPosition(LoadMap.transform.position, new Vector2(node.X, node.Y), UnitWidth, MapWidth, MapHeight);
            //};
            //school.Group.ProportionOfComplete = 1;
            //school.Group.Complete = lam;
        }
        // 设置搜寻单位
        scaner = school;

        GameObject fixItem = null;
        FixtureData fix = null;

        // 遍历地图将障碍物加入列表
        for (var i = 0; i < map.Length; i++)
        {
            var row = map[i];
            for (int j = 0; j < row.Length; j++)
            {
                switch (row[j])
                {
                    case Utils.Obstacle:
                        fixItem = GameObject.CreatePrimitive(PrimitiveType.Cube);
                        fixItem.name += i;
                        fix = fixItem.AddComponent<FixtureData>();
                        fix.AllData.MemberData = new VOBase()
                        {
                            SpaceSet = 1 * UnitWidth
                        };
                        fix.transform.localScale = new Vector3(UnitWidth, UnitWidth, UnitWidth);
                        fix.transform.position = Utils.NumToPosition(transform.position, new Vector2(j, i), UnitWidth, MapWidth, MapHeight);
                        fix.X = j * UnitWidth - MapWidth * UnitWidth * 0.5f;
                        fix.Y = i * UnitWidth - MapHeight * UnitWidth * 0.5f;
                        fix.Diameter = 1*UnitWidth;
                        itemList.Add(fix);
                        ClusterManager.Single.Add(fix);
                        break;
                }
            }
        }

        //school.Group.Target = Utils.NumToPosition(LoadMap.transform.position, new Vector2(cloneList[cloneList.Count - 1].X, cloneList[cloneList.Count - 1].Y), UnitWidth, MapWidth, MapHeight); 
        

        //Action<ClusterGroup> lambdaComplete = (thisGroup) =>
        //{
        //    // Debug.Log("GroupComplete:" + thisGroup.Target);
        //    // 数据本地化
        //    // 数据结束
        //    if (cloneList.Count == 0)
        //    {
        //        return;
        //    }
        //    cloneList.RemoveAt(cloneList.Count - 1);
        //    if (cloneList.Count == 0)
        //    {
        //        return;
        //    }
        //    var node = cloneList[cloneList.Count - 1];
        //    thisGroup.Target = Utils.NumToPosition(LoadMap.transform.position, new Vector2(node.X, node.Y), UnitWidth, MapWidth, MapHeight);
        //};
        //school.Group.ProportionOfComplete = 1;
        //school.Group.Complete = lambdaComplete;
    }



}