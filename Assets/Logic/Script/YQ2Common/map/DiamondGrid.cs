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

    //世界XZ
    public readonly float WorldX;
    public readonly float WorldZ;

    //格子索引XZ
    public readonly byte GredX;
    public readonly byte GredZ;


    /// <summary>
    /// 是否是一个障碍物
    /// </summary>
    public bool IsObstacle {  get { return false; } }

}