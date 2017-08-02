using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

 
/// <summary>
/// 菱形地图
/// </summary>
public class DiamondGridMap : I_Map
{
    public const float wxs = 1.732f;//边长转换为宽度的系数
    public const float harf_wxs = 1.732f / 2.0f;//边长转换为宽度一半的系数

    public const short SideSize = 20;//边尺寸，用于特殊部队出场，例如奇袭，只能使用双数。 由于单双行问题，单数会破外战斗区的形状。


    public static float VerticalSpacingFactor
    {
        get
        {
            return 1.5f * SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang;
            //return 0.866050808f * SData_MapData.Single.TerrainCellBianchang*2; //垂直间隔系数 垂直间隔/格子宽
        }
    }

  
    public static float WidthSpacingFactor
    {
        get { return mWidthSpacingFactor; }
    }

    static float mWidthSpacingFactor = 0;

    //1.732101616628176
    public float AdjacentDistance(I_PathNode a, I_PathNode b)
    {
        DiamondGrid gridA = a as DiamondGrid;
        DiamondGrid gridB = b as DiamondGrid;
        return gridA.Distance(gridB);
    }

    public float DstimateDistance(I_PathNode a, I_PathNode b)
    {
        DiamondGrid gridA = a as DiamondGrid;
        DiamondGrid gridB = b as DiamondGrid;
        return Math.Abs(gridA.WorldX - gridB.WorldX) + Math.Abs(gridA.WorldZ - gridB.WorldZ);
    }

    public bool InMap(int GredX, int GredZ)
    {
        return GredX >= 1 && GredX <= m_width && GredZ >= 1 && GredZ <= m_height;
    }

    public DiamondGrid GetGrid(int GredX, int GredZ)
    {
        if (!InMap(GredX, GredZ)) return null;
        return m_Grids[GredZ - 1, GredX - 1];
    }



    public static void Grid2World(int gHeight, int x, int z, out float out_x, out float out_z)
    {
        x -= SideSize;
        z += SideSize;

        out_z = (float)(gHeight - z) * VerticalSpacingFactor;
        out_x = x * wxs;

        if (z % 2 != 1) out_x += harf_wxs;//z为偶数的时候，错半个格子

        out_x *= SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang;
    }

    internal DiamondGrid[,] m_Grids = null;
    //float m_scale;//格子空间和场景空间缩放比例尺
    internal int m_width;
    internal int m_height;
}



 