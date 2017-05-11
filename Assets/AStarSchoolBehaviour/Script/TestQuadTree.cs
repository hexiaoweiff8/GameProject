using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Random = System.Random;

public class TestQuadTree : MonoBehaviour
{

    /// <summary>
    /// 创建单位数量
    /// </summary>
    public int ItemCount = 10;

    /// <summary>
    /// 地图高度
    /// </summary>
    public int Width = 100;

    /// <summary>
    /// 地图宽度
    /// </summary>
    public int Heght = 100;


    /// <summary>
    /// 图形列表
    /// </summary>
    private TargetList<Holder> quadtree;

    /// <summary>
    /// 碰撞检测
    /// </summary>
    private Dictionary<Holder, bool> collisionList = new Dictionary<Holder, bool>(); 
	

	void Update ()
	{
	    Control();
	    Move();
	    CheckCollision();
	    DrawItem();
	}

    /// <summary>
    /// 控制
    /// </summary>
    private void Control()
    {
        if (Input.GetMouseButtonUp(0))
        {
            // 创建单位移动
            CreateItems();
        }
    }

    /// <summary>
    /// 创建单位
    /// </summary>
    private void CreateItems()
    {
        quadtree = new TargetList<Holder>(Width * 0.5f, Heght * 0.5f, Width, Heght, 1);
        var random = new Random(DateTime.Now.Millisecond);
        for (var i = 0; i < ItemCount; i++)
        {
            var circle = new CircleGraphics(new Vector2(random.Next(0, Width), random.Next(0, Heght)), random.Next(1, 10));
            var holder = new Holder();
            holder.Direction = new Vector2(random.Next(-10, 10), random.Next(-10, 10));
            holder.MyCollisionGraphics = circle;
            quadtree.Add(holder);
        }
    }

    /// <summary>
    /// 单位移动
    /// </summary>
    private void Move()
    {
        if (quadtree == null)
        {
            return;
        }
        // 沿着当前方向移动, 碰边反弹
        foreach (var item in quadtree.List)
        {
            item.MyCollisionGraphics.Postion += item.Direction * Time.deltaTime;
            // 验证四边
            if (item.MyCollisionGraphics.Postion.x > Width)
            {
                item.Direction = new Vector2(-Math.Abs(item.Direction.x), item.Direction.y);
            }
            if (item.MyCollisionGraphics.Postion.x < 0)
            {
                item.Direction = new Vector2(Math.Abs(item.Direction.x), item.Direction.y);
            }
            if (item.MyCollisionGraphics.Postion.y > Heght)
            {
                item.Direction = new Vector2(item.Direction.x, -Math.Abs(item.Direction.y));
            }
            if(item.MyCollisionGraphics.Postion.y < 0)
            {
                item.Direction = new Vector2(item.Direction.x, Math.Abs(item.Direction.y));
            }
        }
        quadtree.RebuildQuadTree();
    }


    private void CheckCollision()
    {
        if (quadtree == null)
        {
            return;
        }
        collisionList.Clear();
        foreach (var item in quadtree.List)
        {
            var probablyCollisionList = quadtree.QuadTree.Retrieve(item.MyCollisionGraphics);
            foreach (var probablyCollisionItem in probablyCollisionList)
            {
                if (!probablyCollisionItem.Equals(item) && probablyCollisionItem.MyCollisionGraphics.CheckCollision(item.MyCollisionGraphics))
                {
                    if (!collisionList.ContainsKey(item))
                    {
                        collisionList.Add(item, true);
                    } if (!collisionList.ContainsKey(probablyCollisionItem))
                    {
                        collisionList.Add(probablyCollisionItem, true);
                    }
                }
            }
        }
    }

    /// <summary>
    /// 绘制单位
    /// </summary>
    private void DrawItem()
    {
        if (quadtree == null)
        {
            return;
        }
        foreach (var graphics in quadtree.List)
        {
            var color = Color.white;
            if (collisionList.ContainsKey(graphics))
            {
                color = Color.red;
            }
            Utils.DrawGraphics(graphics.MyCollisionGraphics, color);
        }
        DrawQuadTreeLine(quadtree.QuadTree);
    }


    /// <summary>
    /// 绘制单元位置与四叉树分区情况
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="argQuadTree"></param>
    private void DrawQuadTreeLine<T>(QuadTree<T> argQuadTree) where T : IGraphicsHolder
    {
        var colorForItem = Color.green;
        // 绘制四叉树边框
        Utils.DrawGraphics(argQuadTree.GetRectangle(), Color.white);
        //// 遍历四叉树内容
        //foreach (var item in argQuadTree.GetItemList())
        //{
        //    // 绘制当前对象
        //    Utils.DrawGraphics(item.MyCollisionGraphics, colorForItem);
        //}

        if (argQuadTree.GetSubNodes()[0] != null)
        {
            foreach (var node in argQuadTree.GetSubNodes())
            {
                DrawQuadTreeLine(node);
            }
        }
    }

    /// <summary>
    /// 图形持有对象
    /// </summary>
    private class Holder : IGraphicsHolder
    {
        /// <summary>
        /// 当前对象的图形
        /// </summary>
        public ICollisionGraphics MyCollisionGraphics { get; set; }

        /// <summary>
        /// 方向
        /// </summary>
        public Vector2 Direction;
    }
}


