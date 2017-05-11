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

    short mSideRight;//右侧边
    short mSideBottom;//下侧边

    public static float VerticalSpacingFactor
    {
        get
        {
            return 1.5f * SData_MapData.Single.TerrainCellBianchang;
            //return 0.866050808f * SData_MapData.Single.TerrainCellBianchang*2; //垂直间隔系数 垂直间隔/格子宽
        }
    }

    public DiamondGridMap()
    {
        mWidthSpacingFactor = SData_MapData.Single.TerrainCellBianchang * wxs;
        mSideRight = (short) (SideSize + SData_MapData.Single.MapMaxColumn - 1);
        mSideBottom = (short)(SideSize + SData_MapData.Single.MapMaxRow - 1);
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

    //寻找附近的空位
    public DiamondGrid NearbyVoidSpace(int GredX, int GredZ)
    {
        //判断圆心位置是否为障碍
        {
            DiamondGrid grid = GetGrid(GredX, GredZ);
            if (grid != null && !grid.IsObstacle) return grid;//不是障碍则立即返回
        }

        Func<int, int, int> CalculateLineStartX;

        //圆心在偶数行和奇数行分别用不同的求行起始X函数
        {
            if (GredZ % 2 == 1)
                CalculateLineStartX = CalculateLineStartX_Odd;//奇数行
            else
                CalculateLineStartX = CalculateLineStartX_Even;//偶数行
        }

        int radius = 1;//从半径1开始找
        do
        {

            //中心行
            {
                DiamondGrid g = GetGrid(GredX - radius, GredZ);
                if (g != null && !g.IsObstacle) return g;

                g = GetGrid(GredX + radius, GredZ);
                if (g != null && !g.IsObstacle) return g;
            }

            //处理非首行末行中心行
            for (int r = 1; r < radius; r++)//从中心开始，遍历每一列
            {
                int sx = CalculateLineStartX(GredX, r);
                int ex = sx + r;
                int cz = radius - r;
                sx -= cz;
                ex += cz;

                int z1 = GredZ - r;
                int z2 = GredZ + r;

                DiamondGrid g = GetGrid(sx, z1);
                if (g != null && !g.IsObstacle) return g;

                g = GetGrid(ex, z1);
                if (g != null && !g.IsObstacle) return g;

                g = GetGrid(sx, z2);
                if (g != null && !g.IsObstacle) return g;

                g = GetGrid(ex, z2);
                if (g != null && !g.IsObstacle) return g;
            }

            //遍历首行和末行
            {
                int sx = CalculateLineStartX(GredX, radius);
                int ex = sx + radius;
                int z1 = GredZ - radius;
                int z2 = GredZ + radius;
                for (int x = sx; x <= ex; x++)
                {
                    DiamondGrid g = GetGrid(x, z1);
                    if (g != null && !g.IsObstacle) return g;

                    g = GetGrid(x, z2);
                    if (g != null && !g.IsObstacle) return g;
                }
            }

            radius++;//半径增加
        } while (true);
    }

    public DiamondGrid GetGrid(int GredX, int GredZ)
    {
        if (!InMap(GredX, GredZ)) return null;
        return m_Grids[GredZ - 1, GredX - 1];
    }

    //圆心在奇数行的行起始X计算
    static int CalculateLineStartX_Odd(int centerX, int radius)
    {
        return centerX - (radius + 1) / 2;
    }

    //圆心在偶数行的行起始X计算
    static int CalculateLineStartX_Even(int centerX, int radius)
    {
        return centerX - radius / 2;
    }

    /// <summary>
    /// 格子坐标转世界坐标，按照scale = 1 进行转换
    /// </summary>
    public void Grid2World(int x, int z, out float out_x, out float out_z)
    {
        Grid2World(m_height, x, z, out out_x, out out_z);
    }


    public static void Grid2World(int gHeight, int x, int z, out float out_x, out float out_z)
    {
        x -= SideSize;
        z += SideSize;

        out_z = (float)(gHeight - z) * VerticalSpacingFactor;
        out_x = x * wxs;

        if (z % 2 != 1) out_x += harf_wxs;//z为偶数的时候，错半个格子

        out_x *= SData_MapData.Single.TerrainCellBianchang;
    }

    /*
    public static float GridX2World(int x)
    {
        float out_x = x * wxs;
        out_x *= SData_MapData.Single.TerrainCellBianchang;
        return out_x;
    }

    public static float GridZ2World(int gHeight, int z)
    {
        return (float)(gHeight - z) * VerticalSpacingFactor;
    }*/

    /// <summary>
    /// 不是很精确
    /// </summary>
    public void World2Grid(float x, float z, out int out_x, out int out_z)
    {
        out_z = m_height - (int)(z / VerticalSpacingFactor);
        x /= SData_MapData.Single.TerrainCellBianchang;
        if (z % 2 != 1) x -= harf_wxs;
        out_x = (int)(x / wxs);

        out_x += SideSize;
        out_z -= SideSize;
    }

    public void ClearItems()
    {
        for (int z = 0; z < m_height; z++)
        {
            for (int x = 0; x < m_width; x++)
            {
                var grid = m_Grids[z, x];
                if (grid != null) grid.Obj = null;
            }
        }
    }

    //地图尺寸改变
    public void Resize(byte w, byte h)
    {
        m_width = w;
        m_height = h;

        m_Grids = new DiamondGrid[h, w];
        for (byte z = 0; z < h; z++)
        {
            byte gridz = (byte)(z + 1);
            for (byte x = 0; x < w; x++)
            {
                byte gridx = (byte)(x + 1);

                float worldX, worldZ;
                Grid2World(gridx, gridz, out worldX, out  worldZ);
                m_Grids[z, x] = new DiamondGrid(gridx, gridz, worldX, worldZ);
            }
        }

        //构建相邻关系
        /*
        for (int z = 0; z < h; z++)
        {
            int gridz = z + 1;
            bool isIndentLine = (gridz % 2 != 1);//当前是否为缩进行
            for (int x = 0; x < w; x++)
            {
                int gridx = x + 1;

                DiamondGrid[] adjacent;//相邻的格子

                if (gridz == 1)
                {
                    if (gridx == 1)//左上缺
                    {
                        adjacent = new DiamondGrid[2]{
                            m_Grids[1,2],
                            m_Grids[2, 1]
                        };

                    }
                    else if (gridx == m_width)//右上缺
                    {
                        adjacent = new DiamondGrid[3]{
                            m_Grids[z, x-1],
                            m_Grids[z+1, x -1],
                            m_Grids[z + 1, x]
                        };
                    }
                    else //上缺
                    {
                        adjacent = new DiamondGrid[4]{
                            m_Grids[z, x -1],
                            m_Grids[z, x + 1],
                            m_Grids[z+1, x - 1],
                            m_Grids[z + 1, x ]
                        };
                    }
                }
                else if (gridz == m_height)
                {
                    if (gridx == 1)//左下缺
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[3]{
                                m_Grids[z,x+1],
                                m_Grids[z-1, x+1],
                                 m_Grids[z-1, x]
                            };
                        }
                        else//不是缩进行
                        {
                            adjacent = new DiamondGrid[2]{
                                m_Grids[z-1,x],
                                m_Grids[z, x+1]
                            };
                        }
                    }
                    else if (gridx == m_width)//右下缺
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z-1, x]
                            };
                        }
                        else//不是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z-1, x-1],
                                m_Grids[z-1, x]
                            };
                        }
                    }
                    else //下缺
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z,x+1],
                                m_Grids[z-1,x],
                                m_Grids[z-1,x+1]
                             };
                        }
                        else
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z,x+1],
                                m_Grids[z-1,x-1],
                                m_Grids[z-1,x]
                             };
                        }

                    }
                }
                else
                {
                    if (gridx == 1)//左缺
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x+1],
                                m_Grids[z-1,x],
                                m_Grids[z-1,x+1],
                                m_Grids[z+1,x],
                                m_Grids[z+1,x+1]
                             };
                        }
                        else//不是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x+1],
                                m_Grids[z-1,x],
                                m_Grids[z+1,x]
                             };
                        }
                    }
                    else if (gridx == m_width)//右缺
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z-1,x],
                                m_Grids[z+1,x]
                             };
                        }
                        else//不是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z-1,x-1],
                                m_Grids[z-1,x],
                                m_Grids[z+1,x-1],
                                m_Grids[z+1,x]
                             };
                        }
                    }
                    else //完整
                    {
                        if (isIndentLine) //当前是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z,x+1],
                                m_Grids[z-1,x],
                                m_Grids[z-1,x+1],
                                m_Grids[z+1,x],
                                m_Grids[z+1,x+1]
                             };
                        }
                        else//不是缩进行
                        {
                            adjacent = new DiamondGrid[]{
                                m_Grids[z,x-1],
                                m_Grids[z,x+1],
                                m_Grids[z-1,x-1],
                                m_Grids[z-1,x],
                                m_Grids[z+1,x-1],
                                m_Grids[z+1,x]
                             };
                        }
                    }
                }

                m_Grids[z, x].SetAdjacent(adjacent);
            }
        }*/
    }


    /// <summary>
    /// 根据格子id获取方向导航格,如果格子超界返回null
    /// </summary>
    /// <param name="gridID"></param>
    /// <returns></returns>
    public DiamondGrid GetDirectionGuideGrid(int GredX, int GredZ, int gridID)
    {
        if (gridID < 1 || gridID > 12) return null;//错误的方向引导格ID
        gridID--;//转为数组id

        if (GredZ % 2 == 1) //奇数行
            return GetGrid(GredX + xoffset_odd[gridID], GredZ + zoffset_odd[gridID]);
        else
            return GetGrid(GredX + xoffset_even[gridID], GredZ + zoffset_even[gridID]);
    }

    /// <summary>
    /// 根据朝向获取相邻的一个格子
    /// </summary> 
    public DiamondGrid GetDirectionGuideGrid(int GredX, int GredZ, float dirX, float dirZ)
    {
        return GetDirectionGuideGrid(
            GredX, GredZ, 
            GetDirectionGuideGridID(  dirX,   dirZ)
            );
    }



    /// <summary>
    /// 根据朝向获取相邻的一个格子
    /// </summary> 
    public int GetDirectionGuideGridID(float dirX, float dirZ)
    {
        //计算出角度
        float radian;
        {
            //从正右向量转到 朝向目标的方向向量 逆时针旋转角度
            radian = AI_Math.Dir2Radian(dirX, dirZ);

            if (radian >= 5.759586532)//330度
                radian = (float)(-(2 * Math.PI - radian));//转换为负数表示的弧度
        }

        //根据弧度计算出相邻格格子ID
        int girdID;
        if (radian < 2.617993878)//150
        {
            if (radian < 0.523598776) //0-30
                girdID = 5;//正右
            else if (radian < 1.570796327)//30-90
                girdID = 4;
            else
                girdID = 3; //90-150

        }
        else
        {
            if (radian < 3.665191429)//150-210
                girdID = 8;
            else if (radian < 4.71238898)//210-270
                girdID = 7;
            else if (radian < 5.759586532)//270-330
                girdID = 6;
            else
                girdID = 5;//正右 
        }

        return girdID;
    }


    public DiamondGrid GetDirectionGuideGrid(int GredX, int GredZ, AIDirection dir)
    {
        if (dir == AIDirection.Left) return GetGrid(GredX - 1, GredZ);

        if (dir == AIDirection.Right) return GetGrid(GredX + 1, GredZ);

        bool isDH = GredZ % 2 == 1;//当前格是否在单行上

        switch (dir)
        {
            case AIDirection.LeftUp:
                return GetGrid(isDH ? GredX - 1 : GredX, GredZ - 1);

            case AIDirection.UpRight:
                return GetGrid(isDH ? GredX : GredX + 1, GredZ - 1);
            case AIDirection.DownLeft:
                return GetGrid(isDH ? GredX - 1 : GredX, GredZ + 1);
            case AIDirection.RightDown:
                return GetGrid(isDH ? GredX : GredX + 1, GredZ + 1);
            default:
                return null;
        }
    }

    public DiamondGrid MoveOneStep(
        short ModelRange,
        DirectionGuideSchemeType DirectionGuideType,
        DiamondGrid selfGrid, DiamondGrid lastGrid, DiamondGrid targetGrid,
        out bool isRound,//是否进行了绕行，当选择的格子不是优先级最高的一格时，认为绕行了
        out AI_FightUnit blockEnemy,
        out AI_FightUnit blockFriend //挡路的友军士兵，英雄不算
        )
    {
        ArmyFlag flag = selfGrid.Obj.Flag;
        ArmyFlag eFlag = AI_Math.ReverseFlag(selfGrid.Obj == null ? ArmyFlag.None : flag);//敌人标志
        blockEnemy = null;
        blockFriend = null;
        isRound = false;
        //计算出角度
        float radian;
        {
            //从正右向量转到 朝向目标的方向向量 逆时针旋转角度
            radian = AI_Math.Dir2Radian(targetGrid.WorldX - selfGrid.WorldX, targetGrid.WorldZ - selfGrid.WorldZ);

            if (radian >= 6.021385919)//345度
                radian = (float)(-(2 * Math.PI - radian));//转换为负数表示的弧度
        }

        //根据角度确定导航方案 
        var scheme = DirectionGuideSchemeManage.Single.GetScheme(DirectionGuideType); //IsMelee ? DirectionGuideSchemeManage.Single.JinZhanScheme : DirectionGuideSchemeManage.Single.YuanZhanScheme;
        var guide = scheme.GetGuide(radian);//取得一个绕障方案

        //确定导航格优先级
        byte[] GuideGrids = null;
        {
            if (Math.Abs(guide.radian - radian) < 0.0001)//使用等于的优先级
                GuideGrids = guide.GuideGrids_eq;
            else if (radian > guide.radian) //使用大于的优先级
                GuideGrids = guide.GuideGrids_gt;
            else//只能使用小于的优先级了
                GuideGrids = guide.GuideGrids_ls;
        }

        //按优先级逐个尝试移动
        {
            int GredX = selfGrid.GredX;
            int GredZ = selfGrid.GredZ;

            int len = GuideGrids.Length;
            for (int i = 0; i < len; i++)
            {
                int gridID = GuideGrids[i];

                DiamondGrid regrid = null;
                if (ModelRange > 0)
                {
                    if (gridID < 3 || gridID > 8) continue;
                    DamoxingYindaoInfo.Offset[] offsets = SData_DamoxingYindao.Single.GetMoveGuideOffset(ModelRange, 1 - (GredZ % 2), gridID);
                    int len1 = offsets.Length;
                    bool canEnter = true;
                    for(var u=0;u<len1;u++)
                    {
                        DiamondGrid grid = GetGrid(GredX + offsets[u].offsetX, GredZ + offsets[u].offsetZ);
                        var g = CheckGrid(
                            selfGrid,
                            grid, lastGrid, ref   isRound,
                            gridID,
                            flag,
                            eFlag,
                            ref   blockEnemy,
                            ref   blockFriend //挡路的友军士兵，英雄不算
                         );
                        if (g == null) { canEnter = false; break; }
                    }
                    if(canEnter) 
                        regrid = GetDirectionGuideGrid(GredX, GredZ, gridID);//使用方向上的格子做为移动目标格 
                }
                else
                {
                    DiamondGrid grid = GetDirectionGuideGrid(GredX, GredZ, gridID);

                     regrid = CheckGrid(
                        selfGrid,
                        grid, lastGrid, ref   isRound,
                        gridID,
                        flag,
                        eFlag,
                        ref   blockEnemy,
                        ref   blockFriend //挡路的友军士兵，英雄不算
                    );
                }


                if (regrid != null)
                {
                    isRound = (i != 0);
                    return regrid;
                }
            }//end for (int i = 0;...
        }

        isRound = true;
        return null;//尝试了各种办法不能通过，只能卡死了
    }

    DiamondGrid CheckGrid( 
         DiamondGrid selfGrid,
            DiamondGrid grid, DiamondGrid lastGrid, ref bool isRound, 
             int gridID,
            ArmyFlag flag ,
            ArmyFlag eFlag ,
            ref AI_FightUnit blockEnemy,
            ref AI_FightUnit blockFriend //挡路的友军士兵，英雄不算
        )

    {
        int GredX = selfGrid.GredX;
        int GredZ = selfGrid.GredZ;

        if (
                        grid == null ||//可能这个格子id超出了地图边界 
                        grid == lastGrid//目标格和上一次通过的格子一样，不允许退回去
                        )
            return null;

        if (grid.IsObstacle)//目标格是一个障碍
        {
            isRound = true;

            if (!grid.Obj.IsDie)
            {
                if (
                    grid.Obj.Flag == flag && grid.Obj.UnitType == UnitType.Soldiers &&
                    (blockFriend == null || (gridID < 9 && gridID > 2))
                    )
                    blockFriend = grid.Obj;

                if (
                     grid.Obj.Flag == eFlag &&
                    (blockEnemy == null || (gridID < 9 && gridID > 2))
                    )
                    blockEnemy = grid.Obj;//记录下挡路的敌方角色 

            }
            return null;
        }

        
        //取得通路信息
        DirectionGuideSchemeManage.pathwaysInfo wInfo = DirectionGuideSchemeManage.Single.GetPathwaysInfo(gridID);
        if (wInfo != null)//存在通路信息
        {
            bool canpass = false;//是否能通过

            //检查是否有不是障碍的通路
            int wlen = wInfo.ways.Length;
            for (int ii = 0; ii < wlen; ii++)
            {
                DiamondGrid wgrid = GetDirectionGuideGrid(GredX, GredZ, wInfo.ways[ii]);
                if (wgrid == null) continue;
                if (
                    !wgrid.IsObstacle &&
                    wgrid != lastGrid//通路格不是上次经过的格子
                    )
                {
                    canpass = true;
                    break;
                }

                if (wgrid.IsObstacle) //通路格有障碍物
                {
                    isRound = true;

                    if (!wgrid.Obj.IsDie)
                    {
                        if (
                            wgrid.Obj.Flag == flag && wgrid.Obj.UnitType == UnitType.Soldiers &&
                            (blockFriend == null || (gridID < 9 && gridID > 2))
                            )
                            blockFriend = wgrid.Obj;

                        if (wgrid.Obj.Flag == eFlag &&
                             (blockEnemy == null || (gridID < 9 && gridID > 2))
                            )
                        {
                            blockEnemy = wgrid.Obj;//记录下挡路的敌方角色 
                            break;//如果通路上遇到了敌人，则不能移动到此格
                        }
                    }
                }
            }

            if (!canpass) return null;//由于通路被堵死不能通过
        }

        //检查目标格是否在边区域
        if (
            IsInSide(grid) &&//目标格在边区域内
            !IsInSide(selfGrid)//起始格不在边区域内
            )
            return null;//边区域是只允许进，但不允许出的

        return grid;//进入目标格
    }

    public   bool IsInSide(DiamondGrid grid)
    {
        return grid.GredX > mSideRight || grid.GredX <= SideSize ||
               grid.GredZ > mSideBottom || grid.GredZ <= SideSize;
    }
    /*
     重合的向量 0
->4.71
<-1.57

2P
     */

    //方向引导导航格偏移量
    short[] xoffset_odd = new short[] { 0, 0, -1, 0, 1, 0, -1, -1, 1, 1, -2, -2 };
    short[] zoffset_odd = new short[] { -2, 2, -1, -1, 0, 1, 1, 0, -1, 1, -1, 1 };

    short[] xoffset_even = new short[] { 0, 0, 0, 1, 1, 1, 0, -1, 2, 2, -1, -1 };
    short[] zoffset_even = new short[] { -2, 2, -1, -1, 0, 1, 1, 0, -1, 1, -1, 1 };

    internal DiamondGrid[,] m_Grids = null;
    //float m_scale;//格子空间和场景空间缩放比例尺
    internal int m_width;
    internal int m_height;
}



 