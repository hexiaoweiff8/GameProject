using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public enum TriggerTypeEnum
{
    None = 0,
   None1 = -1,
   TX_SD_Box =1,//1=特性技能+手动技能+Box生效触发 （读I16$TriggerStart字段）   
   JieshuTiaojian = 2,//Box和Effect结束条件          （读I16$TriggerEnd字段）
   BishaJi = 3//必杀技触发条件 
}

/// <summary>
/// 条件触发
/// </summary>
public enum ConditionTriggerEnum
{
    None = 0,//不触发
    CD = 1,//CD类
    CD_StartFull = 2,//时间积累初始为满  
    SelfHPGreater = 4,//自身百分比气血高于X%时
    SelfHPLess = 5,//自身百分比气血低于X%时
    Poweer = 7,//收集能量型 
    Moment = 8,//瞬时死亡
    BattleStart = 9,//战役开始
    SelfHeroDie = 10,//我方符合子条件的武将死亡时
    EnemyHeroDie = 11,//敌方符合子条件的武将死亡时  
    SelfHeroJoin = 12,//我方符合子条件的武将奇袭出场时
    EnemyHeroJoin = 13,//敌方符合子条件的武将奇袭出场时
    SelfShoudong = 14,//我方符合子条件的英雄释放手动成功 
    EnemyShoudong = 15,//敌方符合子条件的英雄释放手动成功  
    SelfArmyZero = 16,//我方符合子条件的英雄士兵为0时 
    EnemyArmyZero = 17,//敌方符合子条件的英雄士兵为0时
    SelfKill = 18,//我方符合子条件的武将杀敌时    
    EnemyKill = 19,//敌方符合子条件的武将杀敌时
    SelfLianZhan = 20,//我方符合子条件的武将达到X连斩数时  
    EnemyLianZhan = 21,//敌方符合子条件的武将达到X连斩数时
    SelfHPGreaterFirst = 22,//我方符合子条件的武将气血首次高于X%时  
    EnemyHPLessFirst = 23,//敌方符合子条件的武将气血首次低于X%时
    SelfConnecting = 24,//我方符合子条件的武将发生碰撞时      
    EnemyConnecting = 25,//敌方符合子条件的武将发生碰撞时
    SelfLostHPFirst = 26,//我方符合子条件的武将第一次受到伤害
    EnemyLostHPFirst = 27,//敌方符合子条件的武将第一次受到伤害
    SelfKillArmy = 28,//我方符合子条件的武将杀死敌方士兵时（少用）
    EnemyKillArmy = 29,//敌方符合子条件的武将杀死敌方士兵时（少用）
    SelfBadlyWounded = 30,//我方符合子条件的武将受到致命伤害时   
    EnemyBadlyWounded = 31,//敌方符合子条件的武将受到致命伤害时  

    SelfHitFirst = 32,//我方符合子条件的武将第一次造成伤害时
    EnemyHitFirst = 33,//敌方符合子条件的武将第一次造成伤害时

    SelfSoldiersLess = 34,//我方符合子条件的武将士兵数低于N时  
    EnemySoldiersLess = 35,//敌方符合子条件的武将士兵数低于N时


    SelfYinchangDaduan = 36,//我方符合子条件的武将手动吟唱被打断    
    EnemyYinchangDaduan = 37,//敌方符合子条件的武将手动吟唱被打断

    SelfBishaShoudongTexing = 38,//我方符合子条件的武将释放任意必杀/手动/特性技能
    EnemyBishaShoudongTexing = 39,//敌方符合子条件的武将释放任意必杀/手动/特性技能

    SelfBishaTexing = 40,//我方符合子条件的武将释放任意必杀/特性技能  
    EnemyBishaTexing = 41,//敌方符合子条件的武将释放任意必杀/特性技能        
    
    SelfSquareKill = 42,//我方符合子条件的阵杀敌时
    EnemySquareKill = 43,//敌方符合子条件的阵杀敌时

    SelfNegativeState = 50,//我方符合子条件的武将受到负面状态时   
    EnemyNegativeState = 51,//敌方符合子条件的武将受到负面状态时
    SelfFengJi = 52,//我方符合子条件的武将被封技时   
    EnemyFengJi = 53,//敌方符合子条件的武将被封技时
    SelfDingshen = 54,//我方符合子条件的武将定身时    
    EnemyDingshen = 55,//敌方符合子条件的武将定身时
    SelfYun = 56,//我方符合子条件的武将被击晕时
    EnemyYun = 57,//敌方符合子条件的武将被击晕时
    SelfZhongdu = 58,//我方符合子条件的武将被中毒时  
    EnemyZhongdu = 59,//敌方符合子条件的武将被中毒时
    SelfBianxing = 60,//我方符合子条件的武将被变形时 
    EnemyBianxing = 61,//敌方符合子条件的武将被变形时
    SelfLostEquip = 62,//我方符合子条件的武将被缴械时   
    EnemyLostEquip = 63,//敌方符合子条件的武将被缴械时 
    SelfReleaseSkill = 80,//我方符合子条件武将释放某技能ID时    
    EnemyReleaseSkill = 81,//敌方符合子条件武将释放某技能ID时
}

/// <summary>
/// 范围类触发
/// </summary>
public enum RangeTriggerEnum
{
    None = 0,//无限制条件  
    CurrEnemy = 1,//当前敌人
    Random = 2,//一方一个随机目标 【特殊筛选流程】
    MingziID = 3,//一方指定名字ID的武将
    MinDistance = 4,//一方距离最近的武将【特殊筛选流程】
    Onlyme = 5,//仅包含自己

    Mou = 14,//一方所有谋士 
    FashuBing = 15,//一方所有带法术兵的 
    MengOrMou = 16,//猛将或谋士 
    YongOrMou = 17,//勇将或谋士
    GongOrMou = 18,//弓将或谋士

    All = 20,//一方所有武将   
    Man = 21,//一方所有男性  
    Woman = 22,//一方所有女性
    Wei = 23,//一方所有魏国  
    Shu = 24,//一方所有蜀国 
    Wu = 25,//一方所有吴国 
    Qunxiong = 26,//一方所有群雄
    Meng = 29,//一方所有猛将   
    Yong = 30,//一方所有勇将 
    Gong = 31,//一方所有弓将

    DaiDao = 32,//目标是带刀兵的将
    DaiQiang = 33,//目标是带枪兵的将
    DaiQi = 34,//目标是带骑兵的将
    DaiGong = 35,//目标是带弓兵的将

    MengOrYong = 36,//一方猛将或勇将 
    MengOrGong = 37,//一方猛将或弓将  
    YongOrGong = 38,//一方勇将或弓将

    MostCurrHPV = 40,//一方当前HP最多的 【特殊筛选流程】  
    LeastCurrHPV = 41,//一方当前HP最少的 【特殊筛选流程】
    MostMaxHP = 42,//一方HP上限最多的   【特殊筛选流程】
    LeastMaxHP = 43,//一方HP上限最少的 【特殊筛选流程】
    MostWuli = 44,//一方武力最高的  【特殊筛选流程】  
    LeastWuli = 45,//一方武力最低的 【特殊筛选流程】
    MostTili = 46,//一方体力最高的  【特殊筛选流程】  
    LeastTili = 47,//一方体力最低的 【特殊筛选流程】
    MostNu = 48,//一方怒气最高的  【特殊筛选流程】  
    LeastNu = 49,//一方怒气最低的 【特殊筛选流程】
    MostSpeed = 50,//一方移动速度最高的  【特殊筛选流程】 
    LeastSpeed = 51,//一方移动速度最低的 【特殊筛选流程】
    MostSoldiers = 52,//一方当前士兵数量最高的  【特殊筛选流程】
    LeastSoldiers = 53,//一方当前士兵数量最低的 【特殊筛选流程】
    HPGreater = 54,//一方当前HP比例高于X%的
    HPLess = 55,//一方当前HP低于X%的

    MostCurrHPBFB = 56,//一方当前HP百分比最多的 【特殊筛选流程】
    LeastCurrHPBFB = 57,//一方当前HP百分比最少的 【特殊筛选流程】

    SoldiersNUMComplete = 58,//士兵数为最大值
    SoldiersNUMZero = 59,//无士兵

    Qixi = 60,//一方拥有奇袭属性的武将
    NegativeState = 61,//一方受到负面状态的武将   
    FengJi = 62,//一方被封技的武将   
    DingShen = 63,//一方定身的武将   
    Yun = 64,//一方被击晕的武将 
    Zhongdu = 65,//一方被中毒的武将    
    Bianxing = 66,//一方被变形的武将    
    LostEquip = 67,//一方被缴械的武将
}
 

public enum ObjectTriggerEnum
{
    None = 0,//无限制条件
    Cehou = 1,//侧后方攻击时
    Gailv = 2,//概率调用
    MingziID = 3,//如果目标是指定名字ID的武将
    Mou = 14,//目标是谋士 
    FashuBing = 15,//目标是带法术兵的
    Man = 21,//目标是男性
    Woman = 22,//目标是女性
    Wei = 23,//目标是魏国
    Shu = 24,//目标是蜀国 
    Wu = 25,//目标是吴国 
    Qunxiong = 26,//目标是群雄
    Meng = 29,//目标是猛将   
    Yong = 30,//目标是勇将  
    Gong = 31,//目标是弓将

    DaiDao = 32,//目标是带刀兵的将
    DaiQiang = 33,//目标是带枪兵的将
    DaiQi = 34,//目标是带骑兵的将
    DaiGong = 35,//目标是带弓兵的将

    Hero = 36,//目标是英雄
    Soldiers=37,//目标是士兵



    MostCurrHPV = 40,//是敌方当前HP值最多的  
    LeastCurrHPV = 41,//是敌方当前HP值最少的
    MostMaxHP = 42,//是敌方HP上限最多的  
    LeastMaxHP = 43,//是敌方HP上限最少的
    MostWuli = 44,//是敌方武力最高的   
    LeastWuli = 45,//是敌方武力最低的
    MostTili = 46,//是敌方体力最高的   
    LeastTili = 47,//是敌方体力最低的
    MostNu = 48,//是敌方怒气最高的   
    LeastNu = 49,//是敌方怒气最低的
    MostSpeed = 50,//是敌方移动速度最高的 
    LeastSpeed = 51,//是敌方移动速度最低的
    MostSoldiers = 52,//是敌方当前士兵数量最高的  
    LeastSoldiers = 53,//是敌方当前士兵数量最低的
    HPGreater = 54,//敌方当前HP比例高于X%的   
    HPLess = 55,//敌方当前HP低于X%的

    MostCurrHPBFB = 56, //一方当前HP百分比最多的(百分比)
    LeastCurrHPBFB = 57,//一方当前HP百分比最少的（百分比）
    SoldiersNUMComplete = 58,//士兵数为最大值
    SoldiersNUMZero = 59,//无士兵

    Qixi = 60,//拥有奇袭属性的武将
    NegativeState = 61,//受到负面状态的武将   
    FengJi = 62,//被封技的武将   
    DingShen = 63,//被定身的武将   
    Yun = 64,//被击晕的武将 
    Zhongdu = 65,//被中毒的武将    
    Bianxing = 66,//被变形的武将    
    LostEquip = 67,//被缴械的武将  
}
public class SkillTriggerInfo
{


    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        ITriggerType = reader.ColumnName2Index("TriggerType");
        IIsLvUp = reader.ColumnName2Index("IsLvUp");
        ITriggerStart = reader.ColumnName2Index("TriggerStart");
        I2ndTriggerStart = reader.ColumnName2Index("2ndTriggerStart");
        IIsSelfStart = reader.ColumnName2Index("IsSelfStart");
        IIsSelfStart2 = reader.ColumnName2Index("IsSelfStart2");
        
        ITriggerStartLv = reader.ColumnName2Index("TriggerStartLv");
        ITriggerEnd = reader.ColumnName2Index("TriggerEnd");
        I2ndTriggerEnd = reader.ColumnName2Index("2ndTriggerEnd");
        IIsSelfEnd = reader.ColumnName2Index("IsSelfEnd");
        ITriggerEndLv = reader.ColumnName2Index("TriggerEndLv");
        IBishaTrigger = reader.ColumnName2Index("BishaTrigger");
        ISubBishaTrigger = reader.ColumnName2Index("SubBishaTrigger");
        I3rdTriggerEnd = reader.ColumnName2Index("3rdTriggerEnd");
        I3rdTriggerStart = reader.ColumnName2Index("3rdTriggerStart");
        I4rdTriggerStart = reader.ColumnName2Index("4rdTriggerStart");
        I4rdTriggerEnd = reader.ColumnName2Index("4rdTriggerEnd");
        ITriggerStart2 = reader.ColumnName2Index("TriggerStart2");
        I3rdTriggerStart2 = reader.ColumnName2Index("3rdTriggerStart2");
        I2ndTriggerStart2 = reader.ColumnName2Index("2ndTriggerStart2");
    }
    public SkillTriggerInfo(ITabReader reader, int row)
    {
        TriggerType = (TriggerTypeEnum)reader.GetI16(ITriggerType, row);
        IsLvUp = reader.GetI16(IIsLvUp, row) == 1;
        TriggerStart = (ConditionTriggerEnum)reader.GetI16(ITriggerStart, row);
        _2ndTriggerStart = (RangeTriggerEnum)reader.GetI16(I2ndTriggerStart, row);
        IsSelfStart = reader.GetI16(IIsSelfStart, row) == 1;
        IsSelfStart2 = reader.GetI16(IIsSelfStart2, row) == 1;

        
        TriggerStartLv = reader.GetI16(ITriggerStartLv, row);
        TriggerEnd = (ConditionTriggerEnum)reader.GetI16(ITriggerEnd, row);
        _2ndTriggerEnd = (RangeTriggerEnum)reader.GetI16(I2ndTriggerEnd, row);
        IsSelfEnd = reader.GetI16(IIsSelfEnd, row) == 1;
        TriggerEndLv = reader.GetI16(ITriggerEndLv, row);
        BishaTrigger = (ObjectTriggerEnum)reader.GetI16(IBishaTrigger, row);
        ID = reader.GetI32(IID, row);

        string str_3rdTriggerStart = reader.GetS(I3rdTriggerStart, row);
        try
        {
            _3rdTrigger_FullAttr(TriggerStart, str_3rdTriggerStart, ref Float_3rdTriggerStart, ref Int_3rdTriggerStart, ref IntArray_3rdTriggerStart);
        }
        catch (Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("3rdTriggerStart error! ID:{0}", ID));
            throw ex;
        }


         TriggerStart2 = (ConditionTriggerEnum)reader.GetI16(ITriggerStart2, row); 
          _2ndTriggerStart2 = (RangeTriggerEnum)reader.GetI16(I2ndTriggerStart2, row);
        string str_3rdTriggerStart2 = reader.GetS(I3rdTriggerStart2, row);
        try
        {
            _3rdTrigger_FullAttr(TriggerStart2, str_3rdTriggerStart2, ref Float_3rdTriggerStart2, ref Int_3rdTriggerStart2, ref IntArray_3rdTriggerStart2);
        }
        catch (Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("3rdTriggerStart2 error! ID:{0}", ID));
            throw ex;
        }


        string str_4rdTriggerStart = reader.GetS(I4rdTriggerStart, row);
        SkillRangeInfo.ParseSubRange(ID, _2ndTriggerStart, str_4rdTriggerStart, out IntArray_4rdTriggerStart, out Float_4rdTriggerStart);

        var str_SubBishaTrigger = reader.GetS(ISubBishaTrigger, row);
        switch (BishaTrigger)
        {
            case ObjectTriggerEnum.MingziID:
                {
                    IntArray_SubBishaTrigger = MingziIDSplit(str_SubBishaTrigger);
                }
                break;
            case ObjectTriggerEnum.Gailv:
                Int_SubBishaTrigger = int.Parse(str_SubBishaTrigger);
                break;
            case ObjectTriggerEnum.HPGreater:
            case ObjectTriggerEnum.HPLess:
                {
                    Float_SubBishaTrigger = (float)int.Parse(str_SubBishaTrigger) / 100f;
                }
                break;
        }

        var str_3rdTriggerEnd = reader.GetS(I3rdTriggerEnd, row);

        try
        {
            _3rdTrigger_FullAttr(TriggerEnd, str_3rdTriggerEnd, ref Float_3rdTriggerEnd, ref Int_3rdTriggerEnd, ref IntArray_3rdTriggerEnd);

        }
        catch (Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("3rdTriggerEnd error! ID:{0}", ID));
            throw ex;
        }

        string str_4rdTriggerEnd = reader.GetS(I4rdTriggerEnd, row);
        SkillRangeInfo.ParseSubRange(ID, _2ndTriggerEnd, str_4rdTriggerEnd, out IntArray_4rdTriggerEnd, out Float_4rdTriggerEnd);



        BishaTrigger2BishaRange(BishaTrigger, out BishaRangeTrigger);
    }

    /// <summary>
    /// 毫秒类型的触发
    /// </summary>
    static bool IsHaomiaoTrigger(ConditionTriggerEnum trigger)
    {
        switch (trigger)
        {
            //毫秒
            case ConditionTriggerEnum.CD:
            case ConditionTriggerEnum.CD_StartFull:
                return true;
            default:
                return false;
        }
    }

    /// <summary>
    /// 百分比类型的触发
    /// </summary> 
    static bool IsBfbTrigger(ConditionTriggerEnum trigger)
    {
        switch (trigger)
        {
            //百分比
            case ConditionTriggerEnum.SelfHPGreater:
            case ConditionTriggerEnum.SelfHPLess:
            case ConditionTriggerEnum.SelfHPGreaterFirst:
            case ConditionTriggerEnum.EnemyHPLessFirst:
                return true;
            default:
                return false;
        }
    }

    /// <summary>
    /// 整数类型触发
    /// </summary> 
    static bool IsIntTrigger(ConditionTriggerEnum trigger)
    {
        switch (trigger)
        {
            case ConditionTriggerEnum.SelfLianZhan:
            case ConditionTriggerEnum.EnemyLianZhan:
            case ConditionTriggerEnum.SelfLostHPFirst:
            case ConditionTriggerEnum.EnemyLostHPFirst:
                return true;
            default:
                return false;
        }
    }

    static bool IsIntArray(ConditionTriggerEnum trigger)
    {
        switch (trigger)
        {
            case ConditionTriggerEnum.SelfReleaseSkill:
            case ConditionTriggerEnum.EnemyReleaseSkill: 
                return true;
            default:
                return false;
        } 
    }

    /// <summary>
    /// 整数数组类型触发
    /// </summary> 
    static bool IsIntArrayTrigger(RangeTriggerEnum range)
    {
        switch (range)
        {
            case RangeTriggerEnum.MingziID:
                return true;
            default:
                return false;
        }
    }

    static void _3rdTrigger_FullAttr(ConditionTriggerEnum trigger, string in_strv, ref float floatV, ref int intV,ref int[] intArray)
    {
        if (IsHaomiaoTrigger(trigger))
        {
            floatV = (float)int.Parse(in_strv) / 1000f;
        }
        else if (IsBfbTrigger(trigger))
            floatV = (float)int.Parse(in_strv) / 100f;
        else if (IsIntTrigger(trigger))
            intV = int.Parse(in_strv);
        else if(IsIntArray( trigger) )
            intArray = MingziIDSplit(in_strv);
    }

    static int[] MingziIDSplit(string str_mzid)
    {
        string[] strarray = str_mzid.Split('|');
        var intArrayV = new int[strarray.Length];
        int i = 0; Array.ForEach(strarray, (v) => intArrayV[i++] = int.Parse(v));
        return intArrayV;
    }

    void BishaTrigger2BishaRange(ObjectTriggerEnum in_bisha, out RangeTriggerEnum out_range)
    {
        switch (in_bisha)
        {
            case ObjectTriggerEnum.MingziID://如果目标是指定名字ID的武将 
                out_range = RangeTriggerEnum.MingziID;
                break;
            case ObjectTriggerEnum.Man://目标是男性
                out_range = RangeTriggerEnum.Man;
                break;
            case ObjectTriggerEnum.Woman://目标是女性
                out_range = RangeTriggerEnum.Woman;
                break;
            case ObjectTriggerEnum.Wei://目标是魏国
                out_range = RangeTriggerEnum.Wei;
                break;
            case ObjectTriggerEnum.Shu://目标是蜀国 
                out_range = RangeTriggerEnum.Shu;
                break;
            case ObjectTriggerEnum.Wu://目标是吴国 
                out_range = RangeTriggerEnum.Wu;
                break;
            case ObjectTriggerEnum.Qunxiong://目标是群雄
                out_range = RangeTriggerEnum.Qunxiong;
                break;
            case ObjectTriggerEnum.Mou://目标是谋士
                out_range = RangeTriggerEnum.Mou;
                break;
            case ObjectTriggerEnum.FashuBing://目标是带法术兵的
                out_range = RangeTriggerEnum.FashuBing;
                break;
            case ObjectTriggerEnum.Meng://目标是猛将   
                out_range = RangeTriggerEnum.Meng;
                break;
            case ObjectTriggerEnum.Yong://目标是勇将  
                out_range = RangeTriggerEnum.Yong;
                break;
            case ObjectTriggerEnum.Gong://目标是弓将
                out_range = RangeTriggerEnum.Gong;
                break;
            case ObjectTriggerEnum.MostCurrHPV://是敌方当前HP最多的  
                out_range = RangeTriggerEnum.MostCurrHPV;
                break;
            case ObjectTriggerEnum.LeastCurrHPV://是敌方当前HP最少的
                out_range = RangeTriggerEnum.LeastCurrHPV;
                break;

            case ObjectTriggerEnum.MostCurrHPBFB://是敌方当前HP最多的  
                out_range = RangeTriggerEnum.MostCurrHPBFB;
                break;
            case ObjectTriggerEnum.LeastCurrHPBFB://是敌方当前HP最少的
                out_range = RangeTriggerEnum.LeastCurrHPBFB;
                break;

            case ObjectTriggerEnum.MostMaxHP://是敌方HP上限最多的  
                out_range = RangeTriggerEnum.MostMaxHP;
                break;
            case ObjectTriggerEnum.LeastMaxHP://是敌方HP上限最少的
                out_range = RangeTriggerEnum.LeastMaxHP;
                break;
            case ObjectTriggerEnum.MostWuli://是敌方武力最高的   
                out_range = RangeTriggerEnum.MostWuli;
                break;
            case ObjectTriggerEnum.LeastWuli://是敌方武力最低的
                out_range = RangeTriggerEnum.LeastWuli;
                break;
            case ObjectTriggerEnum.MostTili://是敌方体力最高的   
                out_range = RangeTriggerEnum.MostTili;
                break;
            case ObjectTriggerEnum.LeastTili://是敌方体力最低的
                out_range = RangeTriggerEnum.LeastTili;
                break;
            case ObjectTriggerEnum.MostNu://是敌方怒气最高的   
                out_range = RangeTriggerEnum.MostNu;
                break;
            case ObjectTriggerEnum.LeastNu://是敌方怒气最低的
                out_range = RangeTriggerEnum.LeastNu;
                break;
            case ObjectTriggerEnum.MostSpeed://是敌方移动速度最高的 
                out_range = RangeTriggerEnum.MostSpeed;
                break;
            case ObjectTriggerEnum.LeastSpeed://是敌方移动速度最低的
                out_range = RangeTriggerEnum.LeastSpeed;
                break;
            case ObjectTriggerEnum.MostSoldiers://是敌方当前士兵数量最高的  
                out_range = RangeTriggerEnum.MostSoldiers;
                break;
            case ObjectTriggerEnum.LeastSoldiers://是敌方当前士兵数量最低的
                out_range = RangeTriggerEnum.LeastSoldiers;
                break;
            case ObjectTriggerEnum.HPGreater://敌方当前HP比例高于X%的   
                out_range = RangeTriggerEnum.HPGreater;
                break;
            case ObjectTriggerEnum.HPLess://敌方当前HP低于X%的
                out_range = RangeTriggerEnum.HPLess;
                break;
            case ObjectTriggerEnum.Qixi://拥有奇袭属性的武将
                out_range = RangeTriggerEnum.Qixi;
                break;
            case ObjectTriggerEnum.NegativeState://受到负面状态的武将   
                out_range = RangeTriggerEnum.NegativeState;
                break;
            case ObjectTriggerEnum.FengJi://被封技的武将   
                out_range = RangeTriggerEnum.FengJi;
                break;
            case ObjectTriggerEnum.DingShen://被定身的武将   
                out_range = RangeTriggerEnum.DingShen;
                break;
            case ObjectTriggerEnum.Yun://被击晕的武将 
                out_range = RangeTriggerEnum.Yun;
                break;
            case ObjectTriggerEnum.Zhongdu://被中毒的武将    
                out_range = RangeTriggerEnum.Zhongdu;
                break;
            case ObjectTriggerEnum.Bianxing://被变形的武将  
                out_range = RangeTriggerEnum.Bianxing;
                break;
            case ObjectTriggerEnum.LostEquip://被缴械的武将  
                out_range = RangeTriggerEnum.LostEquip;
                break;
            case ObjectTriggerEnum.DaiDao:
                out_range = RangeTriggerEnum.DaiDao;
                break;
            case ObjectTriggerEnum.DaiQiang:
                out_range = RangeTriggerEnum.DaiQiang;
                break;
            case ObjectTriggerEnum.DaiQi:
                out_range = RangeTriggerEnum.DaiQi;
                break;
            case ObjectTriggerEnum.DaiGong:
                out_range = RangeTriggerEnum.DaiGong;
                break;
            case ObjectTriggerEnum.SoldiersNUMComplete:
                out_range = RangeTriggerEnum.SoldiersNUMComplete;
                break;
            case ObjectTriggerEnum.SoldiersNUMZero:
                out_range = RangeTriggerEnum.SoldiersNUMZero;
                break;
            default:
                out_range = RangeTriggerEnum.None;
                break;
        }
    }

    public readonly int ID;
    public readonly TriggerTypeEnum TriggerType;
    public readonly bool IsLvUp;
    public readonly ConditionTriggerEnum TriggerStart;
    public readonly RangeTriggerEnum _2ndTriggerStart;


    ConditionTriggerEnum TriggerStart2;
    public readonly RangeTriggerEnum _2ndTriggerStart2;

    public readonly bool IsSelfStart2;
    public readonly bool IsSelfStart;
    public readonly short TriggerStartLv;
    public readonly ConditionTriggerEnum TriggerEnd;
    public readonly RangeTriggerEnum _2ndTriggerEnd;
    public readonly bool IsSelfEnd;
    public readonly short TriggerEndLv;
    public readonly ObjectTriggerEnum BishaTrigger;
    public readonly RangeTriggerEnum BishaRangeTrigger;

    public readonly int Int_3rdTriggerStart = 0;
    public readonly float Float_3rdTriggerStart = 0;
    public readonly int[] IntArray_3rdTriggerStart;

    public readonly int Int_3rdTriggerStart2 = 0;
    public readonly float Float_3rdTriggerStart2 = 0;
    public readonly int[] IntArray_3rdTriggerStart2;


    public readonly float Float_4rdTriggerStart = 0;
    public readonly int[] IntArray_4rdTriggerStart;

    public readonly float Float_4rdTriggerEnd = 0;
    public readonly int[] IntArray_4rdTriggerEnd;



    public float Float3rdTriggerEnd_Lv(int sklv)
    {
        return Float_3rdTriggerEnd + TriggerEndLv * (sklv - 1);
    }

    public readonly int Int_3rdTriggerEnd = 0;
    public readonly float Float_3rdTriggerEnd = 0;
    public readonly int[] IntArray_3rdTriggerEnd;

    public readonly int[] IntArray_SubBishaTrigger;
    public readonly float Float_SubBishaTrigger;
    public readonly int Int_SubBishaTrigger;
    static short IID;
    static short ITriggerType;
    static short IIsLvUp;
    static short ITriggerStart;
    static short I2ndTriggerStart;
    static short IIsSelfStart;
    static short IIsSelfStart2;
    static short ITriggerStartLv;
    static short ITriggerEnd;
    static short I2ndTriggerEnd;
    static short IIsSelfEnd;
    static short ITriggerEndLv;
    static short IBishaTrigger;
    static short ISubBishaTrigger;
    static short I3rdTriggerEnd;
    static short I3rdTriggerStart;
    static short I4rdTriggerStart;
    static short I4rdTriggerEnd;

    static short ITriggerStart2;
    static short I3rdTriggerStart2;
    static short I2ndTriggerStart2;
}


public class SData_SkillTrigger : MonoEX.Singleton<SData_SkillTrigger>
{
    public SData_SkillTrigger()
    {

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillTrigger");
            reader.Load("bsv", "SkillTrigger");
            SkillTriggerInfo.FillFieldIndex(reader);
            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new SkillTriggerInfo(reader, row);
                try
                {
                    Data.Add(sa.ID, sa);
                }catch(Exception )
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "SkillTrigger 表存在重复ID "+sa.ID);
                }
            }
        }
    }

    public SkillTriggerInfo Get(int id)
    {
        try
        {
            return Data[id];
        }
        catch (Exception)
        {
            throw new Exception(String.Format("SData_SkillTrigger Get ID:{0}", id));
        }
    }


    Dictionary<int, SkillTriggerInfo> Data = new Dictionary<int, SkillTriggerInfo>();
}
