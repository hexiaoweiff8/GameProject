using System;
using UnityEngine;
using System.Collections.Generic;
using System.Text;
using UnityEditor;

/// <summary>
/// 地图编辑器
/// </summary>
public class MapEditor : MonoBehaviour
{

    // -----------------------外置属性-----------------------
    /// <summary>
    /// 地面
    /// </summary>
    public BoxCollider Plane;

    /// <summary>
    /// 障碍物对象, 如果该对象为空则创建cube
    /// </summary>
    public GameObject Obstacler;

    /// <summary>
    /// 障碍物父级
    /// </summary>
    public GameObject ObstaclerList;

    /// <summary>
    /// 主相机
    /// </summary>
    public Camera MainCamera;

    /// <summary>
    /// 地图宽度
    /// </summary>
    public int MapWidth = 100;

    /// <summary>
    /// 地图高度
    /// </summary>
    public int MapHeight = 100;

    /// <summary>
    /// 单位宽度
    /// </summary>
    public int UnitWidth = 1;

    /// <summary>
    /// 鼠标敏感度
    /// </summary>
    public int MouseSensitivity = 10;

    /// <summary>
    /// 网格线颜色
    /// </summary>
    public Color LineColor = Color.red;

    //--------------------常量---------------------------

    /// <summary>
    /// 当前位置可设置
    /// </summary>
    public const int CouldSet = 0;

    /// <summary>
    /// 当前位置已设置
    /// </summary>
    public const int SetYet = 1;


    //--------------------私有属性-----------------------

    /// <summary>
    /// 地图数据
    /// </summary>
    private int[][] map = null;

    /// <summary>
    /// 鼠标点击状态
    /// 0: 当前位置无障碍
    /// 1: 当前位置有障碍
    /// </summary>
    private int mapControlState = CouldSet;

    /// <summary>
    /// 是否正在操作地图
    /// </summary>
    private bool isInControl = false;

    /// <summary>
    /// 地图状态
    /// </summary>
    private Dictionary<long, GameObject> mapStateDic = new Dictionary<long, GameObject>();


    //-------------------计算优化属性---------------------
    /// <summary>
    /// 半地图宽度
    /// </summary>
    private float halfMapWidth;

    /// <summary>
    /// 半地图长度
    /// </summary>
    private float halfMapHight;

    /// <summary>
    /// 地图四角位置
    /// 初始化时计算
    /// </summary>
    private Vector3 leftup = Vector3.zero;
    private Vector3 leftdown = Vector3.zero;
    private Vector3 rightup = Vector3.zero;
    private Vector3 rightdown = Vector3.zero;


    //---------------------定义结束-----------------------
    void Start()
    {
        Init();
    }

    void Update()
    {
        // 控制
        Control();
        // Plane上画网格
        DrawLine();
        // 创建障碍物
        CreateObstacle();
        // 刷新地图状态
        RefreshMap();
    }

    /// <summary>
    /// 初始化
    /// </summary>
    private void Init()
    {
        if (Plane != null)
        {
            // 设置地图大小
            // 设置地缩放
            Plane.transform.localScale = new Vector3(MapWidth, 1, MapHeight);


            // 创建对应大小的map数据
            map = new int[MapHeight][];
            for (var row = 0; row < MapHeight; row++)
            {
                map[row] = new int[MapWidth];
            }

            // 初始化优化数据
            halfMapWidth = MapWidth / 2.0f;
            halfMapHight = MapHeight / 2.0f;

            // 获得起始点
            Vector3 startPosition = Plane.transform.position;
            // 初始化四角点
            leftup = new Vector3(-halfMapWidth + startPosition.x, (Plane.size.y * Plane.transform.localScale.y) / 2 + startPosition.y, halfMapHight + startPosition.z);
            leftdown = new Vector3(-halfMapWidth + startPosition.x, (Plane.size.y * Plane.transform.localScale.y) / 2 + startPosition.y, -halfMapHight + startPosition.z);
            rightup = new Vector3(halfMapWidth + startPosition.x, (Plane.size.y * Plane.transform.localScale.y) / 2 + startPosition.y, halfMapHight + startPosition.z);
            rightdown = new Vector3(halfMapWidth + startPosition.x, (Plane.size.y * Plane.transform.localScale.y) / 2 + startPosition.y, -halfMapHight + startPosition.z);

            // 清空障碍列表
            mapStateDic.Clear();
        }
    }


    /// <summary>
    /// 控制
    /// 上下左右控制相机x,z轴移动
    /// pageup pagedown 控制相机y轴移动
    /// 鼠标控制相机方向
    /// 回车保存地图
    /// </summary>
    private void Control()
    {
        if (MainCamera == null)
        {
            Debug.Log("主相机为空.");
            return;
        }
        // 位置移动
        // 移动x,z轴
        if (Input.GetKey(KeyCode.UpArrow))
        {
            MainCamera.transform.localPosition += MainCamera.transform.forward;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            MainCamera.transform.localPosition -= MainCamera.transform.forward;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            MainCamera.transform.localPosition += Quaternion.Euler(0, -90, 0) * new Vector3(MainCamera.transform.forward.x, 0, MainCamera.transform.forward.z);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            MainCamera.transform.localPosition += Quaternion.Euler(0, 90, 0) * new Vector3(MainCamera.transform.forward.x, 0, MainCamera.transform.forward.z);
        }
        // 移动y轴
        if (Input.GetKey(KeyCode.PageUp))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y + 1, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.PageDown))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y - 1, MainCamera.transform.localPosition.z);
        }

        // 方向移动
        if (Input.GetMouseButton(1))
        {
            float rotateX = MainCamera.transform.localEulerAngles.x - Input.GetAxis("Mouse Y");
            float rotateY = MainCamera.transform.localEulerAngles.y + Input.GetAxis("Mouse X");
            MainCamera.transform.localEulerAngles = new Vector3(rotateX, rotateY, 0);
        }

        // 输出地图数据
        if (Input.GetKey(KeyCode.KeypadEnter))
        {
            ConsoleMap();
        }

        // 清空地图
        if (Input.GetKey(KeyCode.Escape))
        {
            Init();
        }
    }

    /// <summary>
    /// 在地图上画出网格
    /// </summary>
    private void DrawLine()
    {
        // 在底板上画出格子
        // 画四边
        Debug.DrawLine(leftup, rightup, LineColor);
        Debug.DrawLine(leftup, leftdown, LineColor);
        Debug.DrawLine(rightdown, rightup, LineColor);
        Debug.DrawLine(rightdown, leftdown, LineColor);

        // 获得格数
        var xCount = MapWidth / UnitWidth;
        var yCount = MapHeight / UnitWidth;

        for (var i = 1; i <= xCount; i++)
        {
            Debug.DrawLine(leftup + new Vector3(i * UnitWidth, 0, 0), leftdown + new Vector3(i * UnitWidth, 0, 0), LineColor);
        }
        for (var i = 1; i <= yCount; i++)
        {
            Debug.DrawLine(leftdown + new Vector3(0, 0, i * UnitWidth), rightdown + new Vector3(0, 0, i * UnitWidth), LineColor);
        }
    }

    /// <summary>
    /// 创建障碍物
    /// 鼠标点击创建障碍物
    /// </summary>
    private void CreateObstacle()
    {
        if (MainCamera == null)
        {
            Debug.Log("主相机为空.");
            return;
        }

        if (Input.GetMouseButton(0))
        {
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                if (hit.collider.name.Equals(Plane.name))
                {
                    // 识别位置
                    var posOnMap = Utils.PositionToNum(Plane.transform.position, hit.point, UnitWidth, MapWidth, MapHeight);
                    // Debug.Log(posOnMap[0] + ":" + posOnMap[1]);
                    // 若该位置没有障碍则记录并创建障碍, 若该位置有障碍则消除该位置的障碍
                    if (!isInControl)
                    {
                        mapControlState = map[posOnMap[1]][posOnMap[0]] == Utils.Obstacle ? SetYet : CouldSet;
                        isInControl = true;
                    }
                    else
                    {
                        switch (mapControlState)
                        {
                            case SetYet:
                                // 如果该位置已有障碍, 则将障碍清除, 反之不处理
                                map[posOnMap[1]][posOnMap[0]] = Utils.Accessibility;
                                break;
                            case CouldSet:
                                // 如果该位置未有障碍, 则将障碍设置, 反之不处理
                                map[posOnMap[1]][posOnMap[0]] = Utils.Obstacle;
                                break;
                        }
                    }

                }
            }
        }

        // 释放状态
        if (Input.GetMouseButtonUp(0))
        {
            isInControl = false;
        }
    }

    /// <summary>
    /// 将map状态刷到plane上
    /// </summary>
    private void RefreshMap()
    {
        for (long row = 0; row < map.Length; row++)
        {
            var oneRow = map[row];
            for (long col = 0; col < oneRow.Length; col++)
            {
                var key = (row << 32) + col;
                switch (oneRow[col])
                {
                    case Utils.Obstacle:
                        // 有障碍则在该位置创建障碍物
                        var isExist = mapStateDic.ContainsKey(key);
                        if (isExist && mapStateDic[key] == null || !isExist)
                        {
                            var newObstacler = CreateObstacler();
                            newObstacler.transform.parent = ObstaclerList == null ? null : ObstaclerList.transform;
                            newObstacler.transform.localScale = new Vector3(UnitWidth, UnitWidth, UnitWidth);
                            newObstacler.transform.position = Utils.NumToPosition(Plane.transform.position, new Vector2(col, row), UnitWidth, MapWidth, MapHeight);
                            mapStateDic[key] = newObstacler;
                        }
                        break;
                    case Utils.Accessibility:
                        // 无障碍 如果有则清除障碍
                        if (mapStateDic.ContainsKey(key))
                        {
                            if (mapStateDic[key] != null)
                            {
                                Destroy(mapStateDic[key]);
                                mapStateDic[key] = null;
                            }
                        }
                        break;
                }
            }
        }
    }

    /// <summary>
    /// 创建障碍物对象
    /// 如果障碍物引用为空则创建cube
    /// </summary>
    /// <returns>障碍物引用</returns>
    private GameObject CreateObstacler()
    {
        if (Obstacler == null)
        {
            Obstacler = GameObject.CreatePrimitive(PrimitiveType.Cube);
            Destroy(Obstacler.GetComponent<BoxCollider>());
            Obstacler.name = "Obstacler";
            Obstacler.transform.localPosition = leftup;
        }
        var result = Instantiate(Obstacler);

        return result;
    }

    ///// <summary>
    ///// 位置转行列
    ///// </summary>
    ///// <param name="position">当前在plane上的位置(区间, 比如0-1 为同一个位置)</param>
    ///// <returns>map中的行列位置 0位x 1位y</returns>
    //private int[] PositionToNum(Vector3 position)
    //{
    //    var x = (int)(position.x - Plane.transform.position.x + halfMapWidth) / UnitWidth;
    //    var y = (int)(position.z - Plane.transform.position.z + halfMapHight) / UnitWidth;
    //    //Debug.Log(position + ":" + x + ":" + y);
    //    return new []{x, y};
    //}

    ///// <summary>
    ///// 行列转位置
    ///// </summary>
    ///// <param name="Num">map中的行列位置</param>
    ///// <returns>当前plane对应位置, 固定位置的中心点</returns>
    //private Vector3 NumToPosition(Vector2 Num)
    //{
    //    var result = new Vector3(
    //        Plane.transform.position.x - halfMapWidth + UnitWidth / 2f + Num.x * UnitWidth,
    //        Plane.transform.position.y  + UnitWidth,
    //        Plane.transform.position.z - halfMapHight + UnitWidth / 2f + Num.y * UnitWidth);

    //    return result;
    //}


    /// <summary>
    /// 将map数据输出
    /// </summary>
    private void ConsoleMap()
    {

        var strResult = new StringBuilder();
        for (var row = 0; row < map.Length; row++)
        {
            var oneRow = map[row];
            for (var col = 0; col < oneRow.Length; col++)
            {
                var cell = oneRow[col];
                strResult.Append(cell + ((col == oneRow.Length - 1) ? "" : ","));
            }
            strResult.Append((row == map.Length - 1) ? "" : "\n");
        }
        Debug.Log(strResult);
        // TODO 弹出框强制输入文件名称
        // EditorWindow.GetWindow(typeof (EditMapNameWindow));
        // TODO 生成文件 不是该类的功能
        Utils.CreateOrOpenFile(Application.dataPath, "mapInfo", strResult.ToString());
    }


}
