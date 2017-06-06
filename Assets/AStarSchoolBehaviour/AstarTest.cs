using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Random = System.Random;

public class AstarTest : MonoBehaviour {
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
    /// 主相机
    /// </summary>
    private Camera mainCamera;

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
        Move(1, 3, 0)
}";
        var skillInfo = FormulaConstructor.Constructor(formulaStr);
        var skillInfo2 = FormulaConstructor.Constructor(formulaStr2);
        var skillInfo3 = FormulaConstructor.Constructor(formulaStr3);
        var skillInfo4 = FormulaConstructor.Constructor(formulaStr4);
        SkillManager.Single.AddSkillInfo(skillInfo);
        SkillManager.Single.AddSkillInfo(skillInfo2);
        SkillManager.Single.AddSkillInfo(skillInfo3);
        SkillManager.Single.AddSkillInfo(skillInfo4);

        // 设定帧数
        Application.targetFrameRate = 60;
        mainCamera = GameObject.Find("Main Camera").GetComponent<Camera>();
        var loadMapPos = LoadMap.GetLeftBottom();
        ClusterManager.Single.Init(loadMapPos.x + LoadMap.MapWidth * LoadMap.UnitWidth, loadMapPos.z + LoadMap.MapHeight * LoadMap.UnitWidth, MapWidth, MapHeight, UnitWidth, null);
        InitMapInfo();
        DisplayerManager.AutoInstance();
    }
    
    void Update()
    {
        // 控制
        Control();
        Scan();
    }


    private void Scan()
    {
        if (scaner != null)
        {
            var resultList = TargetSelecter.GetCollisionItemList(itemList, scaner.X, scaner.Y, scaner.MemberData.AttackRange*0.5f);
            Utils.DrawCircle(new Vector3(scaner.X, 0, scaner.Y), scaner.MemberData.AttackRange * 0.5f, Color.white);
            for (var i = 0; i < resultList.Count; i++)
            {
                var item = resultList[i];
                Utils.DrawCircle(new Vector3(item.X, 0, item.Y), item.MemberData.SpaceSet * 0.5f, Color.white);
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
            var ray = mainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            if (hit.collider != null && hit.collider.name.Equals(LoadMap.MapPlane.name))
            {
               
                SkillManager.Single.DoSkillNum(1003, new FormulaParamsPacker()
                {
                    StartPos = new Vector3(hit.point.x, 0, hit.point.z),
                    TargetPos = new Vector3(hit.point.x - 40, 0, hit.point.z + 40),
                    ReleaseMember = new DisplayOwner(scaner.gameObject, scaner, null, null),
                });
            }
        }
        if (Input.GetMouseButtonDown(0))
        {
            // 获取地图上的点击点
            var ray = mainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            // 点击到底板
            if (hit.collider != null && hit.collider.name.Equals(LoadMap.MapPlane.name))
            {
                var posOnMap = Utils.PositionToNum(LoadMap.MapPlane.transform.position, hit.point, UnitWidth, MapWidth, MapHeight);
                // 加载文件内容
                var mapInfoData = InitMapInfo();

                var path = AStarPathFinding.SearchRoad(mapInfoData, lastTimeTargetX, lastTimeTargetY, posOnMap[0], posOnMap[1], DiameterX, DiameterY, IsJumpPoint);
                // 根据path放地标, 使用组队寻路跟随过去
                StartCoroutine(Step(path));
                
                var loadMapPos = LoadMap.GetLeftBottom();
                ClusterManager.Single.Init(loadMapPos.x + LoadMap.MapWidth * LoadMap.UnitWidth * 0.5f, loadMapPos.z + LoadMap.MapHeight * LoadMap.UnitWidth * 0.5f, MapWidth, MapHeight, UnitWidth, mapInfoData);
                //LoadMap.RefreshMap();
                StartMoving(path, mapInfoData, lastTimeTargetX, lastTimeTargetY);

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
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x, mainCamera.transform.localPosition.y, mainCamera.transform.localPosition.z + 1);
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x, mainCamera.transform.localPosition.y, mainCamera.transform.localPosition.z - 1);
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x - 1, mainCamera.transform.localPosition.y, mainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x + 1, mainCamera.transform.localPosition.y, mainCamera.transform.localPosition.z);
        }
        // 升高下降
        if (Input.GetKey(KeyCode.PageUp))
        {
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x, mainCamera.transform.localPosition.y + 1, mainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.PageDown))
        {
            mainCamera.transform.localPosition = new Vector3(mainCamera.transform.localPosition.x, mainCamera.transform.localPosition.y - 1, mainCamera.transform.localPosition.z);
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
    }

    /// <summary>
    /// 初始化
    /// </summary>
    public int[][] InitMapInfo()
    {
        var mapInfoPath = Application.dataPath + Path.AltDirectorySeparatorChar + "mapinfo";
        var mapInfoStr = Utils.LoadFileInfo(mapInfoPath);
        var mapInfoData = DeCodeInfo(mapInfoStr);
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
            school.MemberData = new VOBase()
            {
                AttackRange = 20,
                SpaceSet = 3,
                ObjID = objId,
                MoveSpeed = 60
            };
            //school.GroupId = 1;
            // TODO 物理信息中一部分来自于数据
            school.PhysicsInfo.MaxSpeed = 10;
            school.RotateSpeed = 10;
            school.transform.localPosition = new Vector3((i % 3) * 2 + start.x, start.y, i / 3 * 2 + start.z);
            school.name = "item" + i;
            school.TargetPos = target;
            school.Diameter = (i) % 5 + 1;
            school.PushTargetList(Utils.NumToPostionByList(LoadMap.transform.position, cloneList, UnitWidth, MapWidth, MapHeight));
            //school.Moveing = (a) => { Debug.Log(a.name + "Moving"); };

            //school.Wait = (a) => { Debug.Log(a.name + "Wait"); };
            //school.Complete = (a) => { Debug.Log(a.name + "Complete"); };
            itemList.Add(school);
            ClusterManager.Single.Add(school);
            DisplayerManager.Single.AddElement(objId, new DisplayOwner(schoolItem, school, null, null));


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
                        fix.MemberData = new VOBase()
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