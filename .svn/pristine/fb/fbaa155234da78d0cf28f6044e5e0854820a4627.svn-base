using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 目标列表
/// </summary>
/// <typeparam name="T"></typeparam>
public class TargetList<T> where T : IGraphicsHolder//IGraphical<Rectangle>
{
    /// <summary>
    /// 返回全引用列表
    /// </summary>
    public IList<T> List { get { return list; } } 

    /// <summary>
    /// 返回四叉树列表
    /// </summary>
    public QuadTree<T> QuadTree { get { return quadTree; } }

    /// <summary>
    /// 地图信息
    /// </summary>
    public MapInfo<T> MapInfo
    {
        get { return mapinfo; }
        set { mapinfo = value; }
    }


    /// <summary>
    /// 目标总列表
    /// </summary>
    private IList<T> list = null;

    /// <summary>
    /// 四叉树
    /// </summary>
    private QuadTree<T> quadTree = null;

    /// <summary>
    /// 地图信息
    /// </summary>
    private MapInfo<T> mapinfo = null;

    /// <summary>
    /// 单位格子宽度
    /// </summary>
    private int unitWidht;


    /// <summary>
    /// 创建目标列表
    /// </summary>
    /// <param name="x">地图位置x</param>
    /// <param name="y">地图位置y</param>
    /// <param name="width">地图宽度</param>
    /// <param name="height">地图高度</param>
    /// <param name="unitWidht"></param>
    public TargetList(float x, float y, int width, int height, int unitWidht)
    {
        var mapRect = new RectGraphics(new Vector2(x, y), width * unitWidht, height * unitWidht, 0);
        this.unitWidht = unitWidht;
        quadTree = new QuadTree<T>(0, mapRect);
        list = new List<T>();
    }

    /// <summary>
    /// 添加单元
    /// </summary>
    /// <param name="t">单元对象, 类型T</param>
    public void Add(T t)
    {
        // 空对象不加入队列
        if (t == null)
        {
            return;
        }
        // 加入全局列表
        list.Add(t);
        // 加入四叉树
        quadTree.Insert(t);
    }
    /// <summary>
    /// 根据范围获取对象
    /// </summary>
    /// <param name="rect">矩形对象, 用于判断碰撞</param>
    /// <returns></returns>
    public IList<T> GetListWithRectangle(RectGraphics rect)
    {
        // 返回范围内的对象列表
        return quadTree.Retrieve(rect);
    }

    /// <summary>
    /// 重新构建四叉树
    /// 使用情况: 列表中对向位置已变更时
    /// </summary>
    public void RebuildQuadTree()
    {
        quadTree.Clear();
        quadTree.Insert(list);
    }


    public void RebulidMapInfo()
    {
        if (mapinfo != null)
        {
            mapinfo.RebuildMapInfo(list);
        }
    }

    /// <summary>
    /// 清理数据
    /// </summary>
    public void Clear()
    {
        list.Clear();
        quadTree.Clear();
        if (mapinfo != null)
        {
            mapinfo = null;
        }
    }

}