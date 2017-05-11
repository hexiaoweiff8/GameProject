using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class DiamondGrid //: I_PathNode
{
    public DiamondGrid(
        byte gredX, byte gredZ,
        float worldX,float worldZ
        )
    { 
        GredX = gredX;
        GredZ = gredZ;
        WorldX = worldX;
        WorldZ = worldZ;
        //GredXPos = gredX;
        //if (gredZ % 2 != 0) GredXPos += 0.5f;//单行
    }

   // public void SetAdjacent(I_PathNode[] adjacent) {   m_Adjacent = adjacent; }

    public float Distance(DiamondGrid other)
    {
        float cx = WorldX - other.WorldX;
        float cz = WorldZ - other.WorldZ;
        return (float)Math.Sqrt(cx * cx + cz * cz);
    }

    public static bool IsEmptyGrid(DiamondGrid grid)
    {
        return grid != null && !grid.IsObstacle;
    }

   
    /*
    //寻找附近的空位
    public DiamondGrid NearbyVoidSpace
    {
        get {
            if (!IsObstacle) return this;//当前格不是障碍，立即返回

            //在附近查找空位
            {
                HashSet<I_PathNode> closeList = new HashSet<I_PathNode>();//关闭队列
                HashSet<I_PathNode> openList = new HashSet<I_PathNode>();//开放队列
                openList.Add(this);//将本格加入到开放队列

                while (openList.Count > 0)
                {
                    HashSet<I_PathNode>.Enumerator it = openList.GetEnumerator();
                    it.MoveNext();

                    I_PathNode currNode = it.Current;
                    closeList.Add(currNode);//立即加入到关闭队列
                    openList.Remove(currNode);//从开放队列移除

                    if (!currNode.IsObstacle) return currNode as DiamondGrid;//当前格不是障碍，则返回

                    //将相邻格子加入到开放队列
                    I_PathNode[] ad = currNode.Adjacent;
                    int len = ad.Length;
                    for (int i = 0; i < len; i++)
                    {
                        I_PathNode grid = ad[i];
                        if (closeList.Contains(grid)) continue;//已经在关闭队列中
                        if (!openList.Contains(grid)) openList.Add(grid);//添加到开放队列
                    }
                }
            }

            return null;//找遍了地图，也没有空位了
        }
    }
    */
    //世界XZ
    public readonly float WorldX;
    public readonly float WorldZ;

    //格子索引XZ
    public readonly byte GredX;
    public readonly byte GredZ;

    //格子位置XZ
    //public readonly float GredXPos;
    public float GredZPos { get { return GredZ; } } 

    //I_PathNode[] m_Adjacent = null;
     
    //public I_PathNode[]  Adjacent  { get {  return m_Adjacent;  } }
 

    /// <summary>
    /// 是否是一个障碍物
    /// </summary>
    public bool IsObstacle {  get { return Obj != null; } }

    public AI_FightUnit Obj = null;
}