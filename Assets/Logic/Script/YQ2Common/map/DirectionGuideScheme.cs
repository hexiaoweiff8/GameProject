using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

/// <summary>
/// 方向导航方案
/// </summary>
public class DirectionGuide
{
    public float radian;//弧度
    public byte[] GuideGrids_eq = null;//导航格,角度刚好
    public byte[] GuideGrids_gt = null;//导航格,角度大于
    public byte[] GuideGrids_ls = null;//导航格,角度小于

   
} 

public class DirectionGuideScheme
{
    public DirectionGuide[] Guides = new DirectionGuide[12];//方向指引


    /// <summary>
    /// 根据 正右方逆时针转向朝向的夹角弧度值，取行进引导信息
    /// </summary>
    /// <param name="radian"></param>
    /// <returns></returns>
    public DirectionGuide GetGuide(float radian)
    {
        int schemeID;
        if (radian < 2.879793216666667)//165
        {
            if (radian < 1.308996916666667)//75
            {
                if (radian < 0.2617993833333334) // 6.021385816666667 0.2617993833333334   // 345-15 0
                    schemeID = 0;
                else if (radian < 0.7853981500000001)//0.2617993833333334 0.7853981500000001 //15-45 1
                    schemeID = 1;
                else
                    schemeID = 2;//0.7853981500000001   1.308996916666667//45-75 2
            }
            else
            {
                if (radian < 1.832595683333334) //1.308996916666667 1.832595683333334//75-105 3
                    schemeID = 3;
                else if (radian < 2.35619445)//1.832595683333334  2.35619445//105-135 4
                    schemeID = 4;
                else //2.35619445  2.879793216666667 //135-165 5
                    schemeID = 5;
            }
        }
        else
        {
            if (radian < 4.450589516666667)//255
            {
                if (radian < 3.403391983333334)//2.879793216666667  3.403391983333334//165-195 6
                    schemeID = 6;
                else if (radian < 3.92699075)//3.403391983333334 3.92699075//195-225 7
                    schemeID = 7;
                else//3.92699075 4.450589516666667//225-255 8
                    schemeID = 8;
            }
            else
            {
                if (radian < 4.974188283333334)//    4.450589516666667 4.974188283333334 //255-285 9
                    schemeID = 9;
                else if (radian < 5.49778705)//       4.974188283333334 5.49778705//285-315 10
                    schemeID = 10;
                else if (radian < 6.021385816666667)//5.49778705 6.021385816666667  //315-345 11
                    schemeID = 11;
                else
                    schemeID = 0;
            }
        }

        return Guides[schemeID];
    }
}


/// <summary>
/// 方向导航方案管理
/// </summary>
public class DirectionGuideSchemeManage : MonoEX.Singleton<DirectionGuideSchemeManage>
{
    public DirectionGuideSchemeManage()
    {
        //通路信息初始化
        {
            pathways[0] = new pathwaysInfo(new int[] { 3, 4 });
            pathways[1] = new pathwaysInfo(new int[] { 6, 7 });
            pathways[2] = pathways[3] = pathways[4] = pathways[5] = pathways[6] = pathways[7] = null;

            pathways[8] = new pathwaysInfo(new int[] { 4, 5 });
            pathways[9] = new pathwaysInfo(new int[] { 5, 6 });
            pathways[10] = new pathwaysInfo(new int[] { 3, 8 });
            pathways[11] = new pathwaysInfo(new int[] { 8, 7 });
        }
         
        InitSchemes();

    }

    void  InitSchemes()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "DirectionGuideScheme");
            short IAngle = reader.ColumnName2Index("Angle");
            short IEqual = reader.ColumnName2Index("Equal");
            short IGreater = reader.ColumnName2Index("Greater");
            short ILess = reader.ColumnName2Index("Less");
            short IType = reader.ColumnName2Index("Type");

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                short angle = reader.GetI16(IAngle, row);
                short type = reader.GetI16(IType, row);
                var equal = reader.GetS(IEqual, row).Split(';');
                var greater = reader.GetS(IGreater, row).Split(';');
                var less=reader.GetS(ILess, row).Split(';');

                DirectionGuideSchemeType dType;
                switch (type)
                {
                    case 11://刀兵
                        dType = DirectionGuideSchemeType.Daobing;
                        break;
                    case 12://枪兵
                        dType = DirectionGuideSchemeType.Qiangbing;
                        break;
                    case 13://骑兵
                        dType = DirectionGuideSchemeType.Qibing;
                        break;
                    case 14://弓兵
                        dType = DirectionGuideSchemeType.Gongbing;
                        break;
                    case 22://猛将
                        dType = DirectionGuideSchemeType.MengJiang;
                        break;
                    case 23://勇将
                        dType = DirectionGuideSchemeType.YongJiang;
                        break;
                    default://弓将
                        dType = DirectionGuideSchemeType.GongJiang;
                        break;
                }

                if (Schemes[(int)dType] == null) Schemes[(int)dType] = new DirectionGuideScheme();
                DirectionGuideScheme newScheme = Schemes[(int)dType];

                DirectionGuide n = new DirectionGuide();
                n.radian = angle * Utils.AngleToPi;
                n.GuideGrids_eq = To(equal);
                n.GuideGrids_gt = To(greater);
                n.GuideGrids_ls = To(less); 
                newScheme.Guides[angle/30] = n; 
            }
        } 

        //检查导航方案的完整性
        for(int i=0;i<Schemes.Length;i++)
        {
            var scheme = Schemes[i];
            if(scheme==null)
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format( "缺少导航方案 {0}",i ));
            }

            for(int i2=0;i2< scheme.Guides.Length;i2++)
            {
                if(scheme.Guides[i2]==null)
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("缺少导航方向 {0}.{1}", i,i2*30));
            }
        } 
    }

    byte[] To(String[] a)
    { 
        var len = a.Length;
        byte[] re = new byte[len];
        for (int i = 0; i < len; i++)
            re[i] = byte.Parse(a[i]);

        return re;
    }

 


    public pathwaysInfo GetPathwaysInfo(int gridID)
    {
        return pathways[gridID - 1];

    }

    public DirectionGuideScheme GetScheme(DirectionGuideSchemeType type) { return Schemes[(int)type]; }

    DirectionGuideScheme[] Schemes = new DirectionGuideScheme[(int)DirectionGuideSchemeType.Max];

    public class pathwaysInfo
    {
        public pathwaysInfo(
            int[] ways
            //, bool canEnter
            )
        {
            this.ways = ways;
            //this.canEnter = canEnter;
        }

        public readonly int[] ways;
        //public readonly bool canEnter;//是否允许直接踩进格子
    }
    
    pathwaysInfo[] pathways = new pathwaysInfo[12];//通路id
}

public enum DirectionGuideSchemeType
{
    Daobing = 0,// 刀兵
    Qiangbing = 1,//枪兵
    Qibing = 2,//骑兵
    Gongbing = 3,//弓兵

    MengJiang = 4,//猛将
    YongJiang = 5,//勇将
    GongJiang = 6,//弓将
    Max = 7,
}

