﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
 
/// <summary>
/// 特性类技能
/// </summary>
public class AI_TriggerChecker
{

    /// <summary>
    /// 从迭代器中选择一个
    /// </summary>
    /// <param name="ArmySquareEnumerable">阵迭代器</param>
    static AI_FightUnit SelectRangeUnit(
        List<AI_ArmySquare>.Enumerator ArmySquareEnumerable,
        AI_FightUnit self,
        bool IsSelf,//是否为我方
        RangeTriggerEnum range,
        bool containsMe,//是否包含自己
        int[] IntArray_3rdTrigger,
        float Float_3rdTrigger,
        HeroOrArmyEnum tgType
        )
    {
        var selfSquare = self.OwnerArmySquare;
        var flag = IsSelf ? self.Flag : AI_Math.ReverseFlag(self.Flag);
        switch (range)
        {
            case RangeTriggerEnum.Random://一方一个随机目标  
                {
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    m_TmpFightUnit.Clear();
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare)||
                            !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;

                        m_TmpFightUnit.Add(square.hero);
                    }
                    if (m_TmpFightUnit.Count <= 0) return null;
                    return m_TmpFightUnit[self.OwnerBattlefield.RandomInt(0, m_TmpFightUnit.Count - 1)];
                }
            case RangeTriggerEnum.MinDistance://一方距离最近的武将 
                {
                    var g1 = self.ownerGrid;

                    float distance = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (
                            square.flag != flag || square.hero.IsDie ||
                            square == selfSquare||//距离最近的肯定不能包含自己，否则没啥意义
                            !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        var g2 = square.hero.ownerGrid;

                        float cdis = AI_Math.V2Distance(g1.WorldX, g1.WorldZ, g2.WorldX, g2.WorldZ);
                        if (cdis < distance) { distance = cdis; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostCurrHPV://一方当前HP最多的  
                {
                    int hp = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (
                            square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare)||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.CurrHP > hp) { hp = square.hero.CurrHP; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastCurrHPV://一方当前HP最少的
                {
                    int hp = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.CurrHP < hp) { hp = square.hero.CurrHP; seldHero = square.hero; }
                    }

                    return seldHero;
                }

            case RangeTriggerEnum.MostCurrHPBFB://一方当前HP最多的  
                {
                    float hp = 0;
                    AI_Hero seldHero = null; 
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (
                            square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;

                        var currBFB = (float)square.hero.CurrHP/(float)square.hero.FinalMaxHP;
                        if (currBFB > hp) { hp = currBFB; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastCurrHPBFB://一方当前HP最少的
                {
                    float hp = 99;
                    AI_Hero seldHero = null; 
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;

                        var currBFB = (float)square.hero.CurrHP / (float)square.hero.FinalMaxHP;
                        if (currBFB < hp) { hp = currBFB; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostMaxHP://一方HP上限最多的 
                {
                    int hp = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.FinalMaxHP > hp) { hp = square.hero.FinalMaxHP; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastMaxHP://一方HP上限最少的
                {
                    int hp = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.FinalMaxHP < hp) { hp = square.hero.FinalMaxHP; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostWuli://一方武力最高的    
                {
                    float v = 0;
                    AI_Hero seldHero = null;
                   // var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.WuLi.ToFloat() > v) { v = square.hero.WuLi.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastWuli://一方武力最低的
                {
                    float v = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.WuLi.ToFloat() < v) { v = square.hero.WuLi.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostTili://一方体力最高的    
                {
                    float v = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.TiLi.ToFloat() > v) { v = square.hero.TiLi.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastTili://一方体力最低的
                {
                    float v = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.TiLi.ToFloat() < v) { v = square.hero.TiLi.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostNu://一方怒气最高的    
                {
                    float v = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.Nu.ToFloat() > v) { v = square.hero.Nu.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastNu://一方怒气最低的
                {
                    float v = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.Nu.ToFloat() < v) { v = square.hero.Nu.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostSpeed://一方移动速度最高的   
                {
                    float v = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.Speed.ToFloat() > v) { v = square.hero.Speed.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastSpeed://一方移动速度最低的
                {
                    float v = 99999999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.hero.Speed.ToFloat() < v) { v = square.hero.Speed.ToFloat(); seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.MostSoldiers://一方当前士兵数量最高的  
                {
                    int v = 0;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.SoldiersCount > v) { v = square.SoldiersCount; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            case RangeTriggerEnum.LeastSoldiers://一方当前士兵数量最低的
                {
                    int v = 99999;
                    AI_Hero seldHero = null;
                    //var it = self.OwnerBattlefield.ArmySquareListEnumerator;
                    while (ArmySquareEnumerable.MoveNext())
                    {
                        var square = ArmySquareEnumerable.Current;
                        if (square.flag != flag || square.hero.IsDie ||
                            (!containsMe && square == selfSquare) ||
                             !TargetHasLive(tgType, square.hero)//不是存活的有效目标
                            ) continue;
                        if (square.SoldiersCount < v) { v = square.SoldiersCount; seldHero = square.hero; }
                    }

                    return seldHero;
                }
            default:
                return null;
        }
    }


    static bool TargetHasLive(HeroOrArmyEnum tgType,AI_FightUnit tg)
    {
          if(tgType== HeroOrArmyEnum.Hero)
            return !tg.OwnerArmySquare.hero.IsDie;
         else if (tgType == HeroOrArmyEnum.Soldiers) 
            return tg.OwnerArmySquare.SoldiersCount>0;
         else 
            return (!tg.OwnerArmySquare.hero.IsDie) || (tg.OwnerArmySquare.SoldiersCount > 0); 
    }

    static bool RangeTriggerCheck(
            AI_FightUnit self,
            AI_FightUnit other,
            bool IsSelf,//是否为我方
            RangeTriggerEnum range,
            bool containsMe,//是否包含自己
            int[] IntArray_3rdTrigger,
            float Float_3rdTrigger,
            HeroOrArmyEnum tgType
            )
    {
        var flag = IsSelf ? self.Flag : AI_Math.ReverseFlag(self.Flag);
        if (
            other.Flag != flag ||//旗帜不符合要求
            (!containsMe && self.OwnerArmySquare == other.OwnerArmySquare)||//条件指明不能包含自己，实际other是自己
            !TargetHasLive(tgType, other)//不是存活的有效目标
            ) return false;

      


        var otherHero = other.OwnerArmySquare.hero;

        switch (range) 
        {
            case RangeTriggerEnum.None://无限制条件  
                return true;//;//trigger.IsSelfStart && 
            case RangeTriggerEnum.CurrEnemy://当前敌人
                if (!self.IsEnemyValid) return false;
                return self.Enemy == other;
                //throw new Exception("因为当前敌人可能是士兵，需要特殊实现！");
            case RangeTriggerEnum.MingziID://一方指定名字ID的武将
                {
                    if (IntArray_3rdTrigger == null) return false;
                    var len = IntArray_3rdTrigger.Length; //trigger.IntArray_3rdTriggerStart.Length;
                    for (int i = 0; i < len; i++)
                    {
                        if (IntArray_3rdTrigger[i] == otherHero.Data.MingziID)
                            return true;
                    }
                }
                return false;
            case RangeTriggerEnum.Onlyme://仅包含自己
                {
                    var box = self as AI_SkillBox;
                    if(box==null)
                        return other == self;
                    else
                       return other == box.ownerUnit;
                }
            case RangeTriggerEnum.All://一方所有武将   
                return true;
            case RangeTriggerEnum.DaiDao://带刀兵的
                return otherHero.Data.Army.Type == SoldierType.Dao;
            case RangeTriggerEnum.DaiQiang://带枪兵的
                return otherHero.Data.Army.Type == SoldierType.Qiang;
            case RangeTriggerEnum.DaiQi://带骑兵的
                return otherHero.Data.Army.Type == SoldierType.Qi;
            case RangeTriggerEnum.DaiGong://带弓兵的
                return otherHero.Data.Army.Type == SoldierType.Gong;
            case RangeTriggerEnum.SoldiersNUMComplete://士兵数量等于上限的
                return otherHero.OwnerArmySquare.SoldiersCount == otherHero.OwnerArmySquare.BaseAttr.soldiersCount;
            case RangeTriggerEnum.SoldiersNUMZero://士兵全挂掉的
                return otherHero.OwnerArmySquare.SoldiersCount == 0;
            case RangeTriggerEnum.Mou://一方所有谋士 
                return otherHero.Data.Type == HeroType.Moushi;
            case RangeTriggerEnum.FashuBing://一方所有带法术兵的 
                return otherHero.OwnerArmySquare.ArmyData.Type ==  SoldierType.Fa;
            case RangeTriggerEnum.MengOrMou://猛将或谋士 
                return otherHero.Data.Type == HeroType.Moushi || otherHero.Data.Type == HeroType.Meng;
            case RangeTriggerEnum.YongOrMou://勇将或谋士
                return otherHero.Data.Type == HeroType.Moushi || otherHero.Data.Type == HeroType.Yong;
            case RangeTriggerEnum.GongOrMou://弓将或谋士
                return otherHero.Data.Type == HeroType.Moushi || otherHero.Data.Type == HeroType.Gong;
            case RangeTriggerEnum.Meng://一方所有猛将   
                return otherHero.Data.Type == HeroType.Meng;
            case RangeTriggerEnum.Yong://一方所有勇将 
                return otherHero.Data.Type == HeroType.Yong;
            case RangeTriggerEnum.Gong://一方所有弓将
                return otherHero.Data.Type == HeroType.Gong;
            case RangeTriggerEnum.MengOrYong://一方猛将或勇将 
                return otherHero.Data.Type == HeroType.Meng || otherHero.Data.Type == HeroType.Yong;
            case RangeTriggerEnum.MengOrGong://一方猛将或弓将  
                return otherHero.Data.Type == HeroType.Meng || otherHero.Data.Type == HeroType.Gong;
            case RangeTriggerEnum.YongOrGong://一方勇将或弓将
                return otherHero.Data.Type == HeroType.Yong || otherHero.Data.Type == HeroType.Gong;
            case RangeTriggerEnum.HPLess://一方当前HP低于X%的 
                {
                    var bfb = (float)otherHero.CurrHP / (float)otherHero.FinalMaxHP;
                    return bfb < Float_3rdTrigger; 
                }
            case RangeTriggerEnum.HPGreater://一方当前HP比例高于X%的  
                {
                    var bfb = (float)otherHero.CurrHP / (float)otherHero.FinalMaxHP;
                    return bfb > Float_3rdTrigger; 
                }
            case RangeTriggerEnum.Qixi://一方拥有奇袭属性的武将
            case RangeTriggerEnum.NegativeState://一方受到负面状态的武将    
            case RangeTriggerEnum.FengJi://一方被封技的武将   
            case RangeTriggerEnum.DingShen://一方定身的武将   
            case RangeTriggerEnum.Yun://一方被击晕的武将  
            case RangeTriggerEnum.Zhongdu://一方被中毒的武将      
            case RangeTriggerEnum.Bianxing://一方被变形的武将 
            case RangeTriggerEnum.LostEquip://一方被缴械的武将 
                return false;
            default:
                return false;
        }

    }


    /// <summary>
    /// 检查某一个角色是否满足范围触发器条件
    /// </summary>
    public static bool RangeTriggerCheckOne(
        AI_FightUnit self,
        AI_FightUnit other,
        bool IsSelf,//是否为我方
        RangeTriggerEnum range,
        bool containsMe,//是否包含自己
        int[] IntArray_3rdTrigger,
        float Float_3rdTrigger,
        HeroOrArmyEnum tgType
        )
    {
        var unit = SelectRangeUnit(self.OwnerBattlefield.ArmySquareListEnumerator, self, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType);//遍历选择逻辑
        if (unit != null)//被遍历选择命中
            return unit == other;
        else//单个角色检查逻辑
            return RangeTriggerCheck(self, other, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType);
    }

    /// <summary>
    /// 使用范围触发器来选择目标
    /// </summary>
    public static void RangeTriggerSelectTarget(
        AI_FightUnit self,
        bool IsSelf,//是否为我方
        RangeTriggerEnum range,
        bool containsMe,//是否包含自己
        int[] IntArray_3rdTrigger,
        float Float_3rdTrigger,
        HeroOrArmyEnum tgType,
        List<AI_FightUnit> OutUnits
        )
    {
        RangeTriggerSelectTarget(
          self.OwnerBattlefield.ArmySquareListEnumerator,
           self,
           IsSelf,//是否为我方
           range,
           containsMe,//是否包含自己
          IntArray_3rdTrigger,
          Float_3rdTrigger,
          tgType,
          OutUnits
         );
    }

    public static void RangeTriggerSelectTarget(
        List<AI_ArmySquare>.Enumerator ArmySquareEnumerable,
        AI_FightUnit self,
        bool IsSelf,//是否为我方
        RangeTriggerEnum range,
        bool containsMe,//是否包含自己
        int[] IntArray_3rdTrigger,
        float Float_3rdTrigger,
         HeroOrArmyEnum tgType,
        List<AI_FightUnit> OutUnits
        )
    {
        var unit = SelectRangeUnit(ArmySquareEnumerable, self, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType);//遍历选择逻辑
        if (unit != null)//被遍历选择命中
            OutUnits.Add(unit);
        else
        {
            
            if (range == RangeTriggerEnum.CurrEnemy&&self.IsEnemyValid)
                OutUnits.Add(self.Enemy);  
            else
            {

                var it = ArmySquareEnumerable;
                while (it.MoveNext())
                {
                    var square = it.Current;

                    if (square.IsDie) continue;

                    if (RangeTriggerCheckOne(self, square.hero, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType))
                        OutUnits.Add(square.hero);
                }
            }
             
        }
    }


    /// <summary>
    /// 使用范围触发器来选择目标
    /// </summary>
    public static void RangeTriggerSelectTarget(
        AI_FightUnit self,
        bool IsSelf,//是否为我方
        RangeTriggerEnum range,
        RangeTriggerEnum range2,
        bool containsMe,//是否包含自己
        int[] IntArray_3rdTrigger,
        float Float_3rdTrigger,
         HeroOrArmyEnum tgType,
        List<AI_FightUnit> OutUnits
        )
    {
        
        if (range2== RangeTriggerEnum.None)//不存在条件2
        {
            RangeTriggerSelectTarget(self, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType, OutUnits);
            return;
        }

        m_TmpFightUnit.Clear();

        //根据范围1选择目标
        RangeTriggerSelectTarget(self, IsSelf, range, containsMe, IntArray_3rdTrigger, Float_3rdTrigger, tgType, m_TmpFightUnit);


        m_TmpSquare.Clear();
        m_TmpFightUnit.ForEach((u) => m_TmpSquare.Add(u.OwnerArmySquare));

        //在结果中继续筛选
        RangeTriggerSelectTarget(
            m_TmpSquare.GetEnumerator(),
            self,
            IsSelf,//是否为我方
            range2,
            containsMe,//是否包含自己
            IntArray_3rdTrigger, 
            Float_3rdTrigger,
            tgType,
            OutUnits
        );
    }

    static List<AI_FightUnit> m_TmpFightUnit = new List<AI_FightUnit>();
    static List<AI_ArmySquare> m_TmpSquare = new List<AI_ArmySquare>();
}
