using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public enum RangeTypeEnum
{
    Obj = 1,//指向目标型          
    ObjFlyHit = 2,//指向目标且过飞行过程中也会造成效果
    Grid = 3,//指向目标所在格子    
    GridFlyHit = 4,//指向目标所在格子且飞行过程中会造成效果
    Shape = 11,//形状类型   （挂在逻辑格子上用这种做）
}

public enum SelfOrEnemyEnum
{
    Self = 1,
    Enemy = 2
}

public enum HeroOrArmyEnum
{
    Hero = 1,//武将
    Soldiers = 2,//所属士兵
    HeroAndSoldiers = 3,//武将+士兵
}

public enum XingzhuangEnum
{
    Point = 1,// 点 / 忽略
    Rect = 2,//矩形/直线  
    Sector = 3,//扇形
    Circular = 4,//圆形 
    CircularRandom  = 5,//圆形区域内的随机点
}

public enum SkillRangeDirection
{
    None = 0,//无方向  
    Front = 1,//前 
    FrontLeft = 2,//前左
    FrontRight = 3,//前右
    Back = 4,//后
    BackLeft = 5,//后左
    BackRight =6,//后右 
}

 

public class SkillRangeInfo
 {
    internal static void FillFieldIndex(ITabReader reader)
     {
         IID = reader.ColumnName2Index("ID");
        ISubObjectType = reader.ColumnName2Index("SubObjectType");
        IRangeType = reader.ColumnName2Index("RangeType");
        ISelfOrEnemy = reader.ColumnName2Index("SelfOrEnemy");
        IHeroOrArmy = reader.ColumnName2Index("HeroOrArmy");
        IIsSelf = reader.ColumnName2Index("IsSelf");
        IObjectType = reader.ColumnName2Index("ObjectType");
        IXingzhuang = reader.ColumnName2Index("Xingzhuang");
        IDirection = reader.ColumnName2Index("Direction");
        IXingzhuangCanshu1 = reader.ColumnName2Index("XingzhuangCanshu1");
        IXingzhuangCanshu2 = reader.ColumnName2Index("XingzhuangCanshu2");
        IYuandianDirection = reader.ColumnName2Index("YuandianDirection");
        IYuandianDis = reader.ColumnName2Index("YuandianDis");
        I3rdObjectType = reader.ColumnName2Index("3rdObjectType");
        I2rdSubRange = reader.ColumnName2Index("2rdSubRange");
        ISubRange = reader.ColumnName2Index("SubRange");
     }

    public SkillRangeInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        RangeType = (RangeTypeEnum)reader.GetI16(IRangeType, row);
        SubRange = (RangeTriggerEnum)reader.GetI16(ISubRange, row);
        
        SelfOrEnemy = (SelfOrEnemyEnum)reader.GetI16(ISelfOrEnemy, row);
        HeroOrArmy = (HeroOrArmyEnum)reader.GetI16(IHeroOrArmy, row);
        IsSelf = reader.GetI16(IIsSelf, row) == 1;
        ObjectType = (RangeTriggerEnum)reader.GetI16(IObjectType, row);
        SubObjectType = (RangeTriggerEnum)reader.GetI16(ISubObjectType, row);

        
        Xingzhuang = (XingzhuangEnum)reader.GetI16(IXingzhuang, row);
        Direction = (SkillRangeDirection)reader.GetI16(IDirection, row);
        XingzhuangCanshu1 = reader.GetI16(IXingzhuangCanshu1, row);
        XingzhuangCanshu2 = reader.GetI16(IXingzhuangCanshu2, row);
        YuandianDirection = (SkillRangeDirection)reader.GetI16(IYuandianDirection, row);
        YuandianDis = reader.GetI16(IYuandianDis, row);
        
        var _3rdObjectType  = reader.GetS(I3rdObjectType, row);
        ParseSubRange(ID, SubObjectType, _3rdObjectType, out _3rdObjectTypeIntArray, out _3rdObjectTypeFloat);

        //形状类范围
        var _2rdSubRange = reader.GetS(I2rdSubRange, row);
        ParseSubRange(ID,SubRange, _2rdSubRange, out _2rdSubRangeIntArray, out _2rdSubRangeFloat);
    }
    
    public static void ParseSubRange(int ID,RangeTriggerEnum range,string strV,out int[] intArray,out float floatV)
    {
        intArray = null;
        floatV = 0;
        switch (range)
        {
            case RangeTriggerEnum.MingziID:
                {
                    try
                    {
                        var idArray = strV.Split('|');
                        int len = idArray.Length;
                        intArray = new int[len];
                        for(int i=0;i<len;i++) 
                           intArray[i] = int.Parse(idArray[i]); 
                    }
                    catch (Exception)
                    {
                        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("名字ID填写有误！ ID:{0}", ID));
                    }
                }
                break;
            case RangeTriggerEnum.HPLess:
            case RangeTriggerEnum.HPGreater:
                {
                    floatV = float.Parse(strV) / 100.0f;
                }
                break;
        }
    }

    public bool CheckHeroOrArmy(AI_FightUnit unit)
    {
        if (HeroOrArmy == HeroOrArmyEnum.HeroAndSoldiers) return true;

        if (HeroOrArmy == HeroOrArmyEnum.Hero && unit.UnitType != UnitType.Hero) return false;

        if (HeroOrArmy == HeroOrArmyEnum.Soldiers && unit.UnitType != UnitType.Soldiers) return false;

        return true;
    }

    public readonly int ID;
    public readonly RangeTriggerEnum SubRange;
    public readonly RangeTypeEnum RangeType;
    public readonly SelfOrEnemyEnum SelfOrEnemy;
    public readonly HeroOrArmyEnum HeroOrArmy;
    public readonly bool IsSelf;
    public readonly RangeTriggerEnum ObjectType;
    public readonly RangeTriggerEnum SubObjectType;
    public readonly XingzhuangEnum Xingzhuang;
    public readonly SkillRangeDirection Direction;
    public readonly short XingzhuangCanshu1;
    public readonly short XingzhuangCanshu2;
    public readonly SkillRangeDirection YuandianDirection;
    public readonly short YuandianDis;
    public readonly int[] _3rdObjectTypeIntArray;
    public readonly float _3rdObjectTypeFloat;

    public readonly int[] _2rdSubRangeIntArray;
    public readonly float _2rdSubRangeFloat;

    internal static short IID;
    internal static short ISubObjectType;
    internal static short  IRangeType ;
    internal static short  ISelfOrEnemy;
    internal static short  IHeroOrArmy;
    internal static short  IIsSelf;
    internal static short  IObjectType;
    internal static short  IXingzhuang;
    internal static short  IDirection ;
    internal static short  IXingzhuangCanshu1;
    internal static short   IXingzhuangCanshu2 ;
    internal static short    IYuandianDirection ;
    internal static short IYuandianDis ;
    internal static short I3rdObjectType;
    internal static short I2rdSubRange;
    internal static short ISubRange;
         
 }


public class SData_SkillRange: MonoEX.Singleton<SData_SkillRange>
{
    public SData_SkillRange()
    {

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillRange");

            reader.Load("bsv", "SkillRange");
            SkillRangeInfo.FillFieldIndex(reader);
            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new SkillRangeInfo(reader, row);
                try
                {
                    Data.Add(sa.ID, sa);
                }catch(Exception )
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("SkillRange表存在重复ID {0}", sa.ID));
                }
            }
        }
    }

    public SkillRangeInfo Get(int id)
    {
        try
        {
            return Data[id];
        }
        catch (Exception)
        {
            throw new Exception(String.Format("SData_SkillRange Get ID:{0}", id));
        }
    }


    Dictionary<int, SkillRangeInfo> Data = new Dictionary<int, SkillRangeInfo>();
} 
