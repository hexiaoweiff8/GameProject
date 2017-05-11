using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public class AI_SkillHit
{

    /// <summary>
    /// 武将攻击武将公式
    /// </summary> 
    public static void HeroHitHero(AI_Hero self, SkillEffect skillEffect, int skillLv, AI_Hero enemy, out int heroHit, out int armyHit)
    {
        var soldiersCount = enemy.OwnerArmySquare.SoldiersCount;//士兵总数
        float DefProportion = soldiersCount <= 0 ? 0 : enemy.OwnerArmySquare.ArmyData.DefProportion;
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float wuli = self.WuLi.ToFloat();

        var FloatHeroHit = (skillHit + hitPercent * wuli) * (1.0f - enemy.FangyuLv) * (1.0f - DefProportion);
        heroHit = (int)Math.Ceiling(FloatHeroHit);

        if (soldiersCount > 0)
            armyHit = (int)Math.Ceiling(FloatHeroHit * DefProportion / (1.0f - DefProportion) / (float)soldiersCount);
        else
            armyHit = 0;
    }

    /*
     HeroHit=（SelfHero.SkillHit+SelfHero.HitPercent* SelfHero. Zhili）*
     * （1-EmenyHero .FashuFangyulv）*（1-EnemyArmy. DefProportion）
     */

    /// <summary>
    /// 武将攻击武将公式_智力
    /// </summary> 
    public static void HeroHitHero_Zhili(AI_Hero self, SkillEffect skillEffect, int skillLv, AI_Hero enemy, out int heroHit, out int armyHit)
    {
        var soldiersCount = enemy.OwnerArmySquare.SoldiersCount;//士兵总数
        float DefProportion = soldiersCount <= 0 ? 0 : enemy.OwnerArmySquare.ArmyData.DefProportion;
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float zhili = self.Zhili.ToFloat();

        var FloatHeroHit = (skillHit + hitPercent * zhili) * (1.0f - enemy.FashuFangyulv) * (1.0f - DefProportion);
        heroHit = (int)Math.Ceiling(FloatHeroHit);

        if (soldiersCount > 0)
            armyHit = (int)Math.Ceiling(FloatHeroHit * DefProportion / (1.0f - DefProportion) / (float)soldiersCount);
        else
            armyHit = 0;
    }


    /// <summary>
    ///武将攻击士兵公式
    /// </summary> 
    public static int HeroHitSoldiers(AI_Hero self, SkillEffect skillEffect, int skillLv, AI_ArmySquare enemy)
    {
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float wuli = self.WuLi.ToFloat();
        return (int)Math.Ceiling((skillHit + hitPercent * wuli) * (1.0f - enemy.FangyuLv));
    }

    /// <summary>
    ///武将攻击士兵公式_智力
    /// </summary> 
    public static int HeroHitSoldiers_Zhili(AI_Hero self, SkillEffect skillEffect, int skillLv, AI_ArmySquare enemy)
    { 
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float zhili = self.Zhili.ToFloat();
        return (int)Math.Ceiling((skillHit + hitPercent * zhili) * (1.0f - enemy.FashuFangyulv));
    }



    /// <summary>
    /// 士兵攻击武将
    /// </summary> 
    public static void SoldiersHitHero(AI_ArmySquare self, SkillEffect skillEffect, int skillLv, AI_Hero enemy, out int heroHit, out int armyHit)
    {
        var soldiersCount = enemy.OwnerArmySquare.SoldiersCount;//士兵总数
        float DefProportion = soldiersCount <= 0 ? 0 : enemy.OwnerArmySquare.ArmyData.DefProportion;
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float wuli = self.FnWuLi;
        var FloatHeroHit  = (skillHit + hitPercent * wuli) * (1.0f - enemy.FangyuLv) * (1.0f - DefProportion) * self.ArmyData.AtkHeroXueruo;

        heroHit = (int)Math.Ceiling(FloatHeroHit);

        if (soldiersCount > 0)
            armyHit = (int)Math.Ceiling(FloatHeroHit * DefProportion / (1.0f - DefProportion) / (float)soldiersCount);
        else
            armyHit = 0;
    }

    
    /// <summary>
    /// 士兵攻击武将
    /// </summary> 
    public static void SoldiersHitHero_Zhili(AI_ArmySquare self, SkillEffect skillEffect, int skillLv, AI_Hero enemy, out int heroHit, out int armyHit)
    {
        var soldiersCount = enemy.OwnerArmySquare.SoldiersCount;//士兵总数
        float DefProportion = soldiersCount <= 0 ? 0 : enemy.OwnerArmySquare.ArmyData.DefProportion;
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float zhili = self.FnZhli;
        var FloatHeroHit = (skillHit + hitPercent * zhili) * (1.0f - enemy.FashuFangyulv) * (1.0f - DefProportion) * self.ArmyData.AtkHeroXueruo;

        heroHit = (int)Math.Ceiling(FloatHeroHit);

        if (soldiersCount > 0)
            armyHit = (int)Math.Ceiling(FloatHeroHit * DefProportion / (1.0f - DefProportion) / (float)soldiersCount);
        else
            armyHit = 0;
    }



    /// <summary>
    /// 士兵攻击 士兵
    /// </summary> 
    public static int SoldiersHitSoldiers(AI_ArmySquare self, SkillEffect skillEffect, int skillLv, AI_ArmySquare enemy)
    {
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float wuli = self.FnWuLi;
        var armyRestraint = self.ArmyData.GetRestraintAttr(enemy.ArmyData.Type);
        float Modulus = armyRestraint == null ? 1.0f : armyRestraint.Modulus; 
        return (int)Math.Ceiling((skillHit + hitPercent * wuli) * (1.0f - enemy.FangyuLv) * Modulus);
    }


    /// <summary>
    /// 士兵攻击 士兵
    /// </summary> 
    public static int SoldiersHitSoldiers_Zhili(AI_ArmySquare self, SkillEffect skillEffect, int skillLv, AI_ArmySquare enemy)
    {
        float skillHit = skillEffect.GetSkillHit(skillLv);
        float hitPercent = skillEffect.GetHitPercent(skillLv);
        float zhili = self.FnZhli;
        var armyRestraint = self.ArmyData.GetRestraintAttr(enemy.ArmyData.Type);
        float Modulus = armyRestraint == null ? 1.0f : armyRestraint.Modulus;
        return (int)Math.Ceiling((skillHit + hitPercent * zhili) * (1.0f - enemy.FashuFangyulv) * Modulus);
    }



    public static void DoSkill(
        Skill skill, AI_FightUnit attacker,   
        List<EffectHit> out_targetList,
        List<BoxHit> out_boxList,
        out bool hasXingZhuangHit
        )
    {
        hasXingZhuangHit = false;
        foreach (var effect in skill.TakeEffects) BuildHitEffectList(attacker, effect, out_targetList,ref hasXingZhuangHit);

        foreach (var box in skill.TakeBoxObjs) BuildBoxList(attacker, box, out_boxList,ref hasXingZhuangHit); 
    }

    public static void BuildBoxList(
        AI_FightUnit attacker,
        SkillBoxInfo box,
        List<BoxHit> out_boxList,
        ref bool hasXingZhuangHit
        )
    { 
        //筛选被击目标
        var units = BuildHitTargetList(attacker, box.SkillRange, ref hasXingZhuangHit);

        foreach(var kv in units)
        {
            var curr = kv.Key;
            var angleOrder = kv.Value;
            if (curr.IsDie||
                (box.BoxDanwei == BoxDanweiEnum.Hero && curr.UnitType!= UnitType.Hero)
                ) continue;


            out_boxList.Add(new BoxHit() { angleOrder = angleOrder, boxInfo = box, unit = curr });
        } 
    }

   

    /// <summary>
    /// 向效果队列加入一个效果
    /// </summary>
    static void AddEffect2TargetList(List<EffectHit> targetList, AI_FightUnit defenders, SkillEffect effect, byte angleOrder)
    {
        /*
        if (!targetList.ContainsKey(defenders))
            targetList.Add(defenders, new List<SkillEffect>());

        targetList[defenders].Add(effect);*/
        targetList.Add(new EffectHit() { angleOrder = angleOrder, effectInfo = effect, unit = defenders });
    }

    static List<KeyValuePair<AI_FightUnit, byte>> m_TmpUnits = new List<KeyValuePair<AI_FightUnit, byte>>();
    static List<AI_FightUnit> m_TmpUnits1 = new List<AI_FightUnit>();

    public static List<KeyValuePair<AI_FightUnit, byte>> BuildHitTargetList(
        AI_FightUnit attacker, SkillRangeInfo range ,ref bool hasXingZhuangHit
        )
    { 

        m_TmpUnits.Clear();

        if (range.RangeType == RangeTypeEnum.Shape)//形状类型技能
        {
            hasXingZhuangHit = true;

            //立即面向当前敌人
            if (attacker.Enemy != null)
            {
                AI_Math.V2Dir(attacker.ownerGrid.WorldX, attacker.ownerGrid.WorldZ, attacker.Enemy.ownerGrid.WorldX, attacker.Enemy.ownerGrid.WorldZ, out attacker.dirx, out attacker.dirz);
                AI_Math.NormaliseV2(ref attacker.dirx, ref attacker.dirz);
            }
            //根据方向和形状取得格子筛选器
            XingzhuangEnum shapeTp = XingzhuangEnum.Point;
            switch (range.Xingzhuang)
            {
                case XingzhuangEnum.Circular:
                case XingzhuangEnum.CircularRandom:
                    shapeTp = XingzhuangEnum.Circular;
                    break;
                case XingzhuangEnum.Rect:
                    shapeTp = XingzhuangEnum.Rect;
                    break;
                case XingzhuangEnum.Sector:
                    shapeTp = XingzhuangEnum.Sector;
                    break;
            }

            Action<DiamondGrid, byte> CheckGrid = (gzObj, angleOrder) =>
            {
                if (gzObj == null || gzObj.Obj == null)
                    return;

                //子筛选条件
                if (AI_TriggerChecker.RangeTriggerCheckOne(
                    attacker,
                    gzObj.Obj,
                    false,//是否为我方
                    range.SubRange,
                    range.IsSelf,//是否包含自己
                    range._2rdSubRangeIntArray,
                    range._2rdSubRangeFloat,
                    range.HeroOrArmy
                ))
                    m_TmpUnits.Add(new KeyValuePair<AI_FightUnit, byte>(gzObj.Obj, angleOrder));//选择这个目标
            };

            if (shapeTp != XingzhuangEnum.Point) //可以读取策划填写的形状
            {
                //根据攻击者朝向确定发射方向 
                AIDirection dir = AI_Math.Radian2HitDir(AI_Math.Dir2Radian(attacker.dirx, attacker.dirz));
                if (dir < AIDirection.Right || dir > AIDirection.RightDown)
                {
                    return m_TmpUnits; //错误的朝向
                }


                var ownerGX = attacker.ownerGrid.GredX;
                var ownerGZ = attacker.ownerGrid.GredZ;

                var map = attacker.OwnerBattlefield.GridMap;

                bool isDH = (ownerGZ % 2 != 0);//当前是否处于单行
                var sp = SData_RangeXingzhuang.Single.Get(shapeTp, isDH, dir);//取得形状数据

                short w = (shapeTp != XingzhuangEnum.Rect) ? (short)0 : range.XingzhuangCanshu2;//形状宽度
                int chang = range.XingzhuangCanshu1;//形状长度

                //应用模型对范围的影响
                chang += attacker.ModelRange;

                if (chang > 9)//用特殊规则计算
                {
                    if (shapeTp == XingzhuangEnum.Rect)
                    {
                        for (int x = 0; x <= w; x++)
                        {
                            var gzs = sp.Grids[x][1];
                            if (gzs != null) //长为0的格子作为起始遍历格
                            {
                                foreach (var gz in gzs.Grids)
                                {
                                    var gzObj = map.GetGrid(ownerGX + gz.OffsetX, ownerGZ + gz.OffsetZ);
                                    CheckGrid(gzObj, gz.AngleOrder);

                                    for (int c = 1; c <= chang; c++)
                                    {
                                        gzObj = map.GetDirectionGuideGrid(gzObj.GredX, gzObj.GredZ, dir);
                                        if (gzObj == null) break;

                                        CheckGrid(gzObj, 0);
                                    }
                                }
                            } 
                        }
                        CheckGrid(attacker.ownerGrid, 0);//当前格
                    }
                }
                else//从配置图形中找
                {
                    for (int x = 0; x <= w; x++)
                    {
                        for (int z = 0; z <= chang; z++)
                        {
                            var gzs = sp.Grids[x][z];
                            if (gzs != null)
                            {
                                foreach (var gz in gzs.Grids)
                                {
                                    var gzObj = map.GetGrid(ownerGX + gz.OffsetX, ownerGZ + gz.OffsetZ);
                                    CheckGrid(gzObj, gz.AngleOrder);
                                }
                            }
                        }
                    }
                }


                if (
                    range.Xingzhuang == XingzhuangEnum.CircularRandom &&//仅随机一个
                    m_TmpUnits.Count > 0//队列中有合法的目标
                    )
                {
                    var sel = m_TmpUnits[attacker.OwnerBattlefield.RandomInt(0, m_TmpUnits.Count - 1)];
                    m_TmpUnits.Clear();
                    m_TmpUnits.Add(sel);
                }
            }
            else //判断当前格
            {
                CheckGrid(attacker.ownerGrid,0);
            }


        }
        else
        {
            m_TmpUnits1.Clear();
            AI_TriggerChecker.RangeTriggerSelectTarget(
                attacker,
                range.SelfOrEnemy == SelfOrEnemyEnum.Self,//是否为我方
                range.ObjectType,
                range.SubObjectType,
                range.IsSelf,//是否包含自己
                range._3rdObjectTypeIntArray,
                range._3rdObjectTypeFloat,
                range.HeroOrArmy,
                m_TmpUnits1
            );

            if(m_TmpUnits1.Count>0)
            {
                foreach (var curr in m_TmpUnits1)
                    m_TmpUnits.Add(new KeyValuePair<AI_FightUnit, byte>(curr,0));
            } 
        }

        return m_TmpUnits; 
    }

    /// <summary>
    /// 构建伤害效果队列
    /// </summary>
    public static void BuildHitEffectList(
        AI_FightUnit attacker, SkillEffect effect ,
        List<EffectHit> targetList,
        ref bool hasXingZhuangHit
        )
    {
        var units = BuildHitTargetList(attacker, effect.SkillRange,ref hasXingZhuangHit);
        foreach (var kv in units) AddEffect2TargetList(targetList, kv.Key, effect,kv.Value); 
    }

    public static void DoSkillEffect(
        AI_FightUnit attacker, 
        AI_FightUnit defenders, 
        Skill skill,
        SkillEffect effect,
        short skillLv,
        DieEffect dieEffect,
        bool isGrazes//是否为擦伤 被图形类技能选中目标 或 飞行过程中被命中 属于擦伤 
        )
    {
         


        var heroOrArmy = effect.SkillRange.HeroOrArmy;


        if (!defenders.IsDie &&//没有死
               effect.SkillRange.CheckHeroOrArmy(defenders)//满足HeroOrArmy筛选
               )
        { 
            
            _DoSkillEffect(
                  attacker,
                  defenders, 
                  skill,
                  effect,
                  skillLv,
                  dieEffect,
                  isGrazes?EffectLiveType.Shunjian:EffectLiveType.All//擦伤只应用瞬间类，非擦伤应用全部类型的效果 
                );
        }

        if (defenders.UnitType == UnitType.Hero&&//目标是英雄
            heroOrArmy!= HeroOrArmyEnum.Hero&&//同时对士兵有效
            !isGrazes//不是擦伤
            )
        { 
            if (defenders.OwnerArmySquare.SoldiersCount > 0)//有活着的士兵
            {
                {
                    var sbit = defenders.OwnerArmySquare.soldiers.GetEnumerator();
                    while (sbit.MoveNext())
                    {
                        var sb = sbit.Current;
                        if (sb.IsDie) continue;//随便找一个活着的士兵。这里不能对每个士兵作用，因为buff类效果会叠加！！！

                        _DoSkillEffect(
                            attacker,
                            sb, 
                            skill,
                            effect,
                            skillLv,
                            dieEffect,
                            EffectLiveType.Chixu//仅应用持续效果 
                            );

                        break;
                    }
                }

                //对每个兵应用瞬间效果
                /*
                {
                    var sbit = defenders.OwnerArmySquare.soldiers.GetEnumerator();
                    while (sbit.MoveNext())
                    {
                        var sb = sbit.Current;
                        if (sb.IsDie) continue; 

                        _DoSkillEffect(
                            attacker,
                            sb,
                            effect,
                            skillLv,
                            dieEffect,
                            EffectLiveType.Shunjian//仅应用瞬间效果
                            );
                    }
                }*/

            }
            
        }
    }

    enum EffectLiveType
    {
        Shunjian,//瞬间类
        Chixu,//持续类
        All,//全部
    }

    static void _DoSkillEffect(
        AI_FightUnit attacker, 
        AI_FightUnit defenders, 
        Skill skill,
        SkillEffect effect,
        short skillLv,
        DieEffect dieEffect,
        EffectLiveType lt
        )
    {
        if (
            effect.SkillRange.SelfOrEnemy == SelfOrEnemyEnum.Enemy&&//这是一个攻击敌人的技能
            !defenders.ActionsLimit.CanInjured(attacker)//不能受到伤害
            )
            return;//无视此效果

        if (effect.EffectType == SkillEffectType.Hit || effect.EffectType == SkillEffectType.Zhili)//瞬间
        {
            if (lt== EffectLiveType.Shunjian||lt== EffectLiveType.All)
                ApplySkillEffect(attacker, defenders, skill,effect, skillLv, true, dieEffect);

        } else //持续
        {
            var currTime = attacker.OwnerBattlefield.TotalLostTime;

            if(effect.EffectType == SkillEffectType.State)
            {
                if(DoShunjianStateEffect(attacker, defenders, effect, skillLv))//处理瞬间类状态
                    return;
            } 

            if (lt == EffectLiveType.Chixu || lt == EffectLiveType.All)
            {
                if (effect.SkillRange.HeroOrArmy == HeroOrArmyEnum.Hero || effect.SkillRange.HeroOrArmy == HeroOrArmyEnum.HeroAndSoldiers)
                {
                    if (!defenders.OwnerArmySquare.hero.IsDie)
                        defenders.OwnerArmySquare.hero.EffectBuffManage.Add(currTime, attacker, skill, effect, skillLv);
                }

                if (effect.SkillRange.HeroOrArmy == HeroOrArmyEnum.Soldiers || effect.SkillRange.HeroOrArmy == HeroOrArmyEnum.HeroAndSoldiers)
                    defenders.OwnerArmySquare.EffectBuffManage.Add(currTime,attacker, skill,effect,   skillLv);
            }
         }
    }

    public static void ApplySkillEffect(
        AI_FightUnit attacker, 
        AI_FightUnit defenders,
        Skill skill,
        SkillEffect effect,
        short skillLv,
        bool IsApply,//是否是使效果生效
        DieEffect dieEffect 
        )
    {
        switch(effect.EffectType)
        {
            case SkillEffectType.EditAttr://修改属性
            case SkillEffectType.ZhiliEditAttr://智力治疗
                DoEditAttr(attacker, defenders,skill, effect, skillLv, IsApply, dieEffect); 
                break;
            case SkillEffectType.Hit://攻击类 
            case SkillEffectType.Zhili://智力攻击类
                DoSkillHit(attacker, defenders, skill, effect, skillLv, dieEffect);
                break;
            case SkillEffectType.State://持续状态类
                DoChixuStateAttr(attacker,   defenders,   effect,   skillLv, IsApply,  dieEffect); 
                break;
        } 
    }

    static void DoChixuStateAttr(AI_FightUnit attacker, AI_FightUnit defenders, SkillEffect effect, int skillLv,bool IsApply, DieEffect dieEffect)
    {
        switch (effect.Zhuangtai)
        {
            case SkillEffectBOOLST.CDEditor://编辑CD
                {
                    DoCDEditor(attacker, defenders, effect, skillLv, IsApply, dieEffect);
                }
                break;
        }
    }

    static void DoCDEditor(AI_FightUnit attacker, AI_FightUnit defenders, SkillEffect effect, int skillLv, bool IsApply, DieEffect dieEffect)
    {
        if (defenders.UnitType != UnitType.Hero) return;

        AI_Hero heroDefenders = defenders as AI_Hero;

        if (heroDefenders.ShoudongSkill == null) return;

        var skillTrigger = heroDefenders.ShoudongSkill.SkillTrigger;
        if (
            skillTrigger == null ||
            (skillTrigger.TriggerStart != ConditionTriggerEnum.CD && skillTrigger.TriggerStart != ConditionTriggerEnum.CD_StartFull)
            )
            return;

        if (!heroDefenders.ShoudongIsActived)//手动技能没有处于激活状态
        {
            //重新计算满cd时间
            heroDefenders.ShoudongCDFullTime = heroDefenders.ShoudongCDStartTime + heroDefenders.ShoudongCDTime;

            var time = heroDefenders.OwnerBattlefield.TotalLostTime;

            //CD进度关键帧
            heroDefenders.OwnerArmySquare.OverheadPanel.AddKey_CD(
                time, 
                0,
                heroDefenders.ShoudongCDFullTime - (time - heroDefenders.ShoudongCDStartTime)
                );
        }
    }
    /// <summary>
    /// 瞬间类状态效果
    /// </summary>
    /// <param name="attacker"></param>
    /// <param name="defenders"></param>
    /// <param name="effect"></param>
    /// <param name="skillLv"></param>
    static bool DoShunjianStateEffect(AI_FightUnit attacker, AI_FightUnit defenders, SkillEffect effect, int skillLv)
    {
        switch (effect.Zhuangtai)
        {
            case SkillEffectBOOLST.Taopao://逃跑
                {
                    if(
                        defenders.UnitType== UnitType.Soldiers&&//只有士兵可以应用这个效果
                        !defenders.EffectBuffManage.HasStateM(SkillEffectBOOLST.Mianyi_Taopao, SkillEffectBOOLST.Mianyi_All)//没有免疫逃跑
                        )
                    {
                        //丢失全部生命，秒杀
                        defenders.LostHP(defenders.CurrHP, attacker, DieEffect.Taopao,true);
                    }
                }
                return true;
            case SkillEffectBOOLST.Shuaxin://刷新手动
                {
                    defenders.OwnerArmySquare.hero.ActiveShoudong(true);
                }
                return true;
            case SkillEffectBOOLST.Meihuo://魅惑
                {
                    if (
                        defenders.UnitType == UnitType.Soldiers&&//只有士兵可以应用这个效果
                        !defenders.EffectBuffManage.HasStateM(SkillEffectBOOLST.Mianyi_Meihuo, SkillEffectBOOLST.Mianyi_All)//没有免疫魅惑
                        )
                    {
                        //处理被魅惑逻辑
                        (defenders as AI_Soldiers).MeiHuo(attacker.OwnerBattlefield.TotalLostTime, attacker);
                    }
                }
                return true;
        }
        return false;
    }
     


    /// <summary>
    /// 计算被动类技能对属性影响
    /// </summary> 
     public static void CalculateBeidongSkillAttr(
        Skill skill, short skillLv,
        HeroOrArmyEnum heroOrArmy,
        I_AAttr MaxHP,
        I_AAttr WuLi,
        I_AAttr TiLi,
        I_AAttr AddFYL,
        I_AAttr Nu,
        I_AAttr AddBSGL,
        I_AAttr Speed
        )
    {
        if (skill == null || skill.SkillType != SkillType.BeiDongChiXu) return;
        foreach(var effect in skill.TakeEffects)
        {
            CalculateBeidongEffectAttr(effect, skillLv, heroOrArmy,
                MaxHP,WuLi,TiLi,
                AddFYL,Nu,AddBSGL,Speed
                );
        }
    }

    /// <summary>
    /// 计算被动类效果对属性影响
    /// </summary>
    public static void CalculateBeidongEffectAttr(
        SkillEffect effect, short skillLv,
        HeroOrArmyEnum heroOrArmy,
        I_AAttr MaxHP,
        I_AAttr WuLi,
        I_AAttr TiLi,
        I_AAttr AddFYL,
        I_AAttr Nu,
        I_AAttr AddBSGL,
        I_AAttr Speed
        )
    {
        var range = effect.SkillRange;
        if (
            effect.EffectType != SkillEffectType.EditAttr ||//不是编辑属性类效果
            range.RangeType != RangeTypeEnum.Obj ||//不是指向目标的
            range.SelfOrEnemy != SelfOrEnemyEnum.Self ||//不是我方
            range.ObjectType != RangeTriggerEnum.Onlyme//不是一个仅包含自己的技能
            )
            return;

        if (
            (heroOrArmy == HeroOrArmyEnum.Hero && range.HeroOrArmy == HeroOrArmyEnum.Soldiers) ||//要求只筛选英雄，实际技能不能对英雄生效
            (heroOrArmy == HeroOrArmyEnum.Soldiers && range.HeroOrArmy == HeroOrArmyEnum.Hero)//要求只筛选士兵，实际技能不能对士兵生效
            )
            return;


        float HitNo = effect.GetEditAttrV(skillLv);   
       
        I_AAttr attr = null;
        switch (effect.ShuxingType)
        {
            case SkillDVType.hpmap://HP上限
                { attr = MaxHP; }
                break;
            case SkillDVType.wl://武力
                { attr = WuLi; }
                break;
            case SkillDVType.tl://体力
                { attr = TiLi; }
                break;
            case SkillDVType.fyl://防御率
                { attr = AddFYL; }
                break;
            case SkillDVType.nu://怒
                { attr = Nu; }
                break;
            case SkillDVType.bsjgl://必杀技使用几率 
                { attr = AddBSGL; }
                break;
            case SkillDVType.speed://移动速度        
                { attr = Speed; }
                break;
            default:
                return;
        } 

        switch (effect.HitType)
        {
            case SkillHitType.Jia:
                attr.JAddV(HitNo);
                break;
            case SkillHitType.JiaBfb:
                attr.JAddBFB(HitNo);
                break;
            case SkillHitType.Jian:
                attr.JAddV(-HitNo);
                break;
            case SkillHitType.JianBfb:
                attr.JAddBFB(-HitNo);
                break;
        }
    } 

    /// <summary>
    /// 修改属性类技能
    /// </summary> 
    static void DoEditAttr(AI_FightUnit attacker, AI_FightUnit defenders, 
        Skill skill,
        SkillEffect effect, int skillLv, bool IsApply, DieEffect dieEffect 
        )
    {
        //HitNo = effect.HitNo+ （技能等级-1）*effect.HitTypeGrow*（表里读的系数）
        float HitNo = 
                effect.EffectType== SkillEffectType.ZhiliEditAttr?
                effect.GetHitPercent(skillLv) * attacker.Zhili.ToFloat() + effect.GetSkillHit(skillLv):
                effect.GetEditAttrV(skillLv);  



        I_AAttr attr = null;
        switch (effect.ShuxingType)
        {
            case SkillDVType.currhp://当前HP
                {
                    switch (effect.HitType)
                    {
                        case SkillHitType.Jia:
                            if (defenders.ActionsLimit.CanHuifu)//没有限制恢复生命才恢复
                            {
                                int addv = (int)HitNo;
                                defenders.AddHP(attacker,addv);
                               
                            }
                            break;
                        case SkillHitType.JiaBfb:
                            if (defenders.ActionsLimit.CanHuifu)//没有限制恢复生命才恢复
                            {
                                int addv = (int)(defenders.CurrHP * HitNo);
                                defenders.AddHP(attacker,addv);
                               
                            }
                            break;
                        case SkillHitType.Jian:
                            {
                                int lostv = (int)HitNo;
                                defenders.LostHP(lostv, attacker, dieEffect, skill.SkillType!= SkillType.General);
                               
                            }
                            break;
                        case SkillHitType.JianBfb:
                            {
                                int lostv = (int)(defenders.CurrHP * HitNo);
                                defenders.LostHP(lostv, attacker, dieEffect, skill.SkillType != SkillType.General);
                               
                            }
                            break;
                    }
                }
                return;
            case SkillDVType.hpmap://HP上限
                { attr = defenders.MaxHP; }
                break;
            case SkillDVType.wl://武力
                { attr = defenders.WuLi; }
                break;
            case SkillDVType.tl://体力
                { attr = defenders.TiLi; }
                break;
            case SkillDVType.fyl://防御率
                { attr = defenders.AddFYL; }
                break;
            case SkillDVType.nu://怒
                { attr = defenders.Nu; }
                break;
            case SkillDVType.bsjgl://必杀技使用几率 
                { attr = defenders.AddBSGL; }
                break;
            case SkillDVType.speed://移动速度        
                { attr = defenders.Speed; }
                break;
            default:
                return;
        };

        if (!IsApply) HitNo = -HitNo;

        switch (effect.HitType)
        {
            case SkillHitType.Jia:
                attr.JAddV(HitNo);
                break;
            case SkillHitType.JiaBfb:
                attr.JAddBFB(HitNo);
                break;
            case SkillHitType.Jian:
                attr.JAddV(-HitNo);
                break;
            case SkillHitType.JianBfb:
                attr.JAddBFB(-HitNo);
                break;
        }

        //防御方属性变更通知
        defenders.OnAttrChanged();
    }

    /// <summary>
    /// 处理攻击类技能伤害
    /// </summary>
    static void DoSkillHit(
        AI_FightUnit attacker, AI_FightUnit defenders,
        Skill skill,
        SkillEffect effect, int skillLv, DieEffect dieEffect
        )
    {
        if (attacker.UnitType == UnitType.Hero)
        {
            if (defenders.UnitType == UnitType.Soldiers)//英雄打士兵
            { 
                int armyHit = effect.EffectType == SkillEffectType.Zhili ?
                    (int)HeroHitSoldiers_Zhili(attacker as AI_Hero, effect, skillLv, (defenders as AI_Soldiers).OwnerArmySquare)
                    : (int)HeroHitSoldiers(attacker as AI_Hero, effect, skillLv, (defenders as AI_Soldiers).OwnerArmySquare);

                if (armyHit > 0) defenders.LostHP(armyHit, attacker, dieEffect, skill.SkillType!= SkillType.General);//士兵伤血
            }
            else if (defenders.UnitType == UnitType.Hero)  //英雄打英雄
            {
                var defenderHero = defenders as AI_Hero;

                int heroHit,armyHit;
                 if(effect.EffectType == SkillEffectType.Zhili )
                     HeroHitHero_Zhili(attacker as AI_Hero, effect, skillLv, defenderHero, out   heroHit, out   armyHit);
                else
                    HeroHitHero(attacker as AI_Hero, effect, skillLv, defenderHero, out   heroHit, out   armyHit);

                if (heroHit > 0) defenders.LostHP(heroHit, attacker, dieEffect, skill.SkillType != SkillType.General);//英雄伤血

                //士兵伤血
                if (armyHit > 0) defenderHero.OwnerArmySquare.SquareLostHP( armyHit, attacker);  
            }
        }
        else if (attacker.UnitType == UnitType.Soldiers)
        {
            if (defenders.UnitType == UnitType.Soldiers)//士兵打士兵
            {
                int armyHit =
                    effect.EffectType == SkillEffectType.Zhili?
                    SoldiersHitSoldiers_Zhili((attacker as AI_Soldiers).OwnerArmySquare, effect, skillLv, (defenders as AI_Soldiers).OwnerArmySquare)
                    :SoldiersHitSoldiers((attacker as AI_Soldiers).OwnerArmySquare, effect, skillLv, (defenders as AI_Soldiers).OwnerArmySquare);
                if (armyHit > 0) defenders.LostHP(armyHit, attacker, dieEffect,false);//士兵伤血
            }
            else if (defenders.UnitType == UnitType.Hero)//士兵打英雄
            {
                var defenderHero = defenders as AI_Hero;
                int heroHit, armyHit;
                if (effect.EffectType == SkillEffectType.Zhili)
                    SoldiersHitHero_Zhili((attacker as AI_Soldiers).OwnerArmySquare, effect, skillLv, defenderHero, out   heroHit, out   armyHit);
                else
                    SoldiersHitHero((attacker as AI_Soldiers).OwnerArmySquare, effect, skillLv, defenderHero, out   heroHit, out   armyHit);

                if (heroHit > 0) defenders.LostHP( heroHit, attacker, dieEffect,false);//英雄伤血

                //士兵伤血
                if (armyHit > 0) defenderHero.OwnerArmySquare.SquareLostHP( armyHit, attacker); 
            }
        }
    }
}


public class BoxHit
{
    public SkillBoxInfo boxInfo;
    public AI_FightUnit unit;
    public byte angleOrder;
}

public class EffectHit
{
   public AI_FightUnit unit;
   public SkillEffect effectInfo;
   public byte angleOrder; 
}