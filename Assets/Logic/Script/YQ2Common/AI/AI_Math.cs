using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public class AI_Math
{

    public const float MapScale = 1.0f;//地图比例尺


    public static byte CalculateMassifX(int x, int z, ArmyFlag flag, bool indent)
    {
        var re = flag == ArmyFlag.Attacker ? x : (SData_mapdata.Single.GetDataOfID(1).MapMaxColumn - x + (z % 2 == 0 ? 1 : 2));
        if(indent) re += flag == ArmyFlag.Attacker ? 1 : -1;
        return (byte)re;
    } 

    //计算缩进偏移
    public static float IndentOffset(ArmyFlag flag)
    {
        return (flag == ArmyFlag.Attacker ? -DiamondGridMap.WidthSpacingFactor / 2.0f : DiamondGridMap.WidthSpacingFactor / 2.0f);
    }

    /// <summary>
    /// 归一化Vector2
    /// </summary>
    /// <returns></returns>
    public static float NormaliseV2(ref float x, ref float y)
    {
        float fLength = (float)Math.Sqrt(x * x + y * y);

        if (fLength > 1e-08)
        {
            float fInvLength = 1.0f / fLength;
            x *= fInvLength;
            y *= fInvLength;
        }

        return fLength;
    }

    public static void V2Dir(
        float from_x, float from_z, float target_x, float target_z,
        out float out_dirx,out float out_dirz
        )
    {
        out_dirx = target_x - from_x;
        out_dirz = target_z - from_z;

        //if (out_dirx == out_dirz && out_dirz == 0)
          //  out_dirz = 0;//QKDEBUG
    }

    public static float V2Distance(float x1,float z1,float x2,float z2)
    {
        float tx = x1 - x2;
        float tz = z1 - z2;

        return (float)Math.Sqrt(tx * tx + tz * tz);
    }

    /// <summary>
    /// 计算正右方逆时针转向x,z向量的夹角弧度值
    /// </summary>
    public static float Dir2Radian(float worldDirX, float worldDirZ)
    {
        // normalize
        {
            float dist = (float)Math.Sqrt(worldDirX * worldDirX + worldDirZ * worldDirZ);
            worldDirX /= dist;
            worldDirZ /= dist;
        }
        return (float)getRotateRadian(1, 0, worldDirX, worldDirZ);
    }


    public static bool WithinShot(float objWorldDistance,int gridDistance,int a)
    { 
        if (GridDistance (objWorldDistance) > gridDistance) return false;//超出射程
        return true;
    }

    public static int GridDistance(float objWorldDistance)
    {
        float fGDis = objWorldDistance / SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang / DiamondGridMap.wxs;//浮点格子距离
        return (int)Math.Round(fGDis, MidpointRounding.AwayFromZero);
    }

    public static int GridDistance(AI_FightUnit a, AI_FightUnit b)
    {
        var g1 = a.ownerGrid;
        var g2 = b.ownerGrid;

        var dis = V2Distance(g1.WorldX, g1.WorldZ, g2.WorldX, g2.WorldZ);
        return GridDistance(dis);
    }

    /// <summary>
    /// 计算是否已经进入射程
    /// </summary>
    /// <returns></returns>
    public static bool WithinShot(AI_FightUnit a,AI_FightUnit b,int gridDistance)
    { 

        var ag = a.ownerGrid;
        var bg = b.ownerGrid;

        var worldDistance = V2Distance( ag.WorldX,ag.WorldZ, bg.WorldX,bg.WorldZ);//世界距离
        float fGDis = worldDistance / SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang / DiamondGridMap.wxs;//浮点格子距离
        if ((int)Math.Round(fGDis, MidpointRounding.AwayFromZero) > gridDistance + a.ModelRange + b.ModelRange) return false;//超出射程

        return true;
        /*
        float dirx,dirz; V2Dir(ag.WorldX,ag.WorldZ, bg.WorldX,bg.WorldZ,out dirx,out dirz);

        //判断夹角
        float ar = Dir2Radian(dirx,dirz);//计算出夹角弧度
         
        //判断朝向必须与六边形的六条边垂直
        return Math.Abs(ar-0)<0.001f ||
            Math.Abs(ar-1.047197551)<0.001f|| //60
            Math.Abs(ar-2.094395102)<0.001f|| //120
            Math.Abs(ar-3.141592654)<0.001f|| //180
            Math.Abs(ar-4.188790205)<0.001f|| //240
            Math.Abs(ar-5.235987756)<0.001f|| //300
            Math.Abs(ar - 6.283185307) < 0.001f; //360
         */
    }


    /// <summary>
    /// 弧度转换为可发动进攻的标准朝向
    /// </summary>
    static public AIDirection Radian2HitDir(float radian)
    {
        if (radian < 0.523598776f)//30
        {
            return AIDirection.Right; //右
        }
        else if (radian < 1.570796327f)//90
            return AIDirection.UpRight; //右上
        else if (radian < 2.617993878f)//150
            return AIDirection.LeftUp;//左上
        else if (radian < 3.665191429f)//210
            return AIDirection.Left;//左
        else if (radian < 4.71238898f)//270
            return AIDirection.DownLeft; //左下
        else if (radian < 5.759586532f)//330
            return AIDirection.RightDown;//右下
        else
            return AIDirection.Right;//右
    }

    //根据旋转角度计算朝向向量,仅支持标准的6方向
    static public void AIDirection2Vector(AIDirection dirType, out float dirx, out float dirz)
    {
        float radian = 0;
         switch(dirType)
         {
             case AIDirection.UpRight:
                 radian = 1.047197551f;//60;
                 break;
             case AIDirection.LeftUp:
                 radian = 2.094395102f;//120;
                 break;
             case AIDirection.Left:
                 radian = 3.141592654f;//180;
                 break;
             case AIDirection.DownLeft:
                 radian = 4.188790205f;//240;
                 break;
             case AIDirection.RightDown:
                 radian = 5.235987756f;//300;
                 break;
             
         }
         Radian2Vector(radian, out dirx, out dirz);
    }

    /// <summary>
    /// 弧度转朝向向量
    /// </summary>
    /// <param name="radian">弧度</param>
    static public void Radian2Vector(float radian, out float dirx, out float dirz)
    {
        dirx = (float)(1.0f * Math.Cos(radian));
        dirz = (float)(1.0f * Math.Sin(radian));
    }

    /// <summary>
    /// 获取2维向量逆时针旋转弧度，向量需要归一化后传入
    /// </summary> 
     static double getRotateRadian(double x1, double y1, double x2, double y2)
    { 
        // normalize
        /*
        {
            double dist = Math.Sqrt(x1 * x1 + y1 * y1);
            x1 /= dist;
            y1 /= dist;
            dist = Math.Sqrt(x2 * x2 + y2 * y2);
            x2 /= dist;
            y2 /= dist;
        }*/

        double angle;
        // dot product
        double dot = x1 * x2 + y1 * y2;
        if (Math.Abs(dot - 1.0) <= double.Epsilon)
            angle = 0.0;
        else if (Math.Abs(dot + 1.0) <= double.Epsilon)
            angle = Math.PI;
        else
        {
            double cross;

            angle = Math.Acos(dot);
            //cross product
            cross = x1 * y2 - x2 * y1;
            // vector p2 is clockwise from vector p1 
            // with respect to the origin (0.0)
            if (cross < 0) angle = 2 * Math.PI - angle;
        }
        //degree = angle * 180.0 / nyPI;
        //return degree;
        return angle;
    }
     
    public static AIDirection ReverseDir(AIDirection dir)
    {
        switch(dir)
        {
            case AIDirection.Left:
                return AIDirection.Right;
            case AIDirection.Right:
                return AIDirection.Left;
            default:
                return dir;
        } 
    }

    public static ArmyFlag ReverseFlag(ArmyFlag flag)
    {
        switch(flag)
        {
            case ArmyFlag.Attacker:
                return ArmyFlag.Defender;
            case ArmyFlag.Defender:
                return ArmyFlag.Attacker;
            case ArmyFlag.All:
                return ArmyFlag.None;
            default:
                return ArmyFlag.All;
        } 
    }
     
    /// <summary>
    /// 判定两个格子是否相邻
    /// </summary>
    /// <returns></returns>
    public static bool IsAdjacentGird(int x1,int z1,int x2,int z2)
    {
        if (z1 == z2)//同行
        {
            return Math.Abs(x1 - x2) == 1;
        }
        else if (Math.Abs(z1 - z2) == 1)
        {
            if(z1%2==1) 
                return (x1==x2||x1-1==x2); 
            else
                return (x1==x2||x1+1==x2); 
        } 
        else
            return false;
    }
} 
