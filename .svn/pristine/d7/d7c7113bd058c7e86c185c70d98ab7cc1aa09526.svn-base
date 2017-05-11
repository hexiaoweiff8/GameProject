using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 

//特性触发器
public class AI_TexingSkillTrigger
{
    public AI_TexingSkillTrigger(AI_Battlefield ownerBattlefield)
    {
        m_OwnerBattlefield = ownerBattlefield;

        m_OwnerBattlefield.Event.OnHeroDie += onHeroDie;
        m_OwnerBattlefield.Event.OnArmyZero += onArmyZero;
        m_OwnerBattlefield.Event.OnHeroKillHero += onHeroKillHero;
        m_OwnerBattlefield.Event.OnHeroKillSoldiers += onHeroKillSoldiers;
        m_OwnerBattlefield.Event.OnSquareKill += onSquareKill;
        //m_OwnerBattlefield.Event. +=onHPFirstGreater
        m_OwnerBattlefield.Event.OnHPFirstLower += onHPFirstLower;
        m_OwnerBattlefield.Event.OnHeroLostHP += onHeroLostHP;
        m_OwnerBattlefield.Event.OnLianzhan += onLianzhan;
        m_OwnerBattlefield.Event.OnBattlefieldStart += onBattlefieldStart;
        m_OwnerBattlefield.Event.OnHeroHitFirst += onHeroHitFirst;
        m_OwnerBattlefield.Event.OnArmySoldiersFirstLower += onSoldiersFirstLower;
        m_OwnerBattlefield.Event.OnYun += onYun;

        m_OwnerBattlefield.Event.OnYinchangInterrupt += onYinchangInterrupt;//吟唱被打断
        m_OwnerBattlefield.Event.OnBishaRelease += onBishaRelease;//必杀释放成功
        m_OwnerBattlefield.Event.OnShoudongRelease += onShoudongRelease;//手动释放成功
        m_OwnerBattlefield.Event.OnTexingRelease += onTexingRelease;//特性释放成功

         m_OwnerBattlefield.Event.OnPowerFull += onPowerFull;//能量满
        
    }

    void onYinchangInterrupt(AI_Hero hero)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null ||
                        ((trigger.TriggerStart != ConditionTriggerEnum.EnemyYinchangDaduan &&
                        trigger.TriggerStart != ConditionTriggerEnum.SelfYinchangDaduan))
                        ) continue;

                    if (
                        RangeTriggerCheckOneStart(  trigger,   self, hero,trigger.TriggerStart == ConditionTriggerEnum.SelfYinchangDaduan)
                        )//该技能满足触发条件
                    {
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                     trigger != null &&
                    ((trigger.TriggerStart == ConditionTriggerEnum.EnemyYinchangDaduan ||
                    trigger.TriggerStart == ConditionTriggerEnum.SelfYinchangDaduan))
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  trigger,   self, hero,trigger.TriggerStart == ConditionTriggerEnum.SelfYinchangDaduan)
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null ||
                            (
                            trigger.TriggerEnd != ConditionTriggerEnum.EnemyYinchangDaduan &&
                            trigger.TriggerEnd != ConditionTriggerEnum.SelfYinchangDaduan
                            )
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(  
                                trigger,self, hero, 
                                trigger.TriggerEnd == ConditionTriggerEnum.SelfYinchangDaduan//是否为我方
                            )
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            } 
        } 

        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) => {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                    trigger == null ||
                    (
                    trigger.TriggerEnd != ConditionTriggerEnum.EnemyYinchangDaduan &&
                    trigger.TriggerEnd != ConditionTriggerEnum.SelfYinchangDaduan
                    )
                    )
                    return;

                if ( 
                    RangeTriggerCheckOneEnd(trigger,box,hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfYinchangDaduan)  
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box); 
                }        
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                 (trigger.TriggerStart != ConditionTriggerEnum.SelfYinchangDaduan && trigger.TriggerStart != ConditionTriggerEnum.EnemyYinchangDaduan)
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, hero, trigger.TriggerStart == ConditionTriggerEnum.SelfYinchangDaduan))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onBishaRelease(AI_Hero hero, Skill _skill)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null ||
                        (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing &&trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing)||
                        (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaTexing)
                        ) continue;

                    if ( 
                         RangeTriggerCheckOneStart(  trigger,   self, hero, trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing)
                        )//该技能满足触发条件
                    {
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                     trigger != null &&
                     (
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyBishaShoudongTexing ||trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing)||
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyBishaTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing)
                    )
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  trigger,   self, hero, trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing)
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing &&trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing)||
                            (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaTexing)
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaTexing) 
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }

        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                     trigger == null ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaTexing)
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaTexing)
                )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }


        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                  (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                    (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaTexing)
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, hero,
                trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onShoudongRelease(AI_Hero hero, Skill _skill)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null ||
                        (
                            (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing &&trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing)&&
                            (trigger.TriggerStart != ConditionTriggerEnum.EnemyShoudong && trigger.TriggerStart != ConditionTriggerEnum.SelfShoudong)
                        )
                        ) continue;

                    if ( 
                         RangeTriggerCheckOneStart(  trigger,   self, hero, 
                             trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing||
                             trigger.TriggerStart == ConditionTriggerEnum.SelfShoudong
                             )
                        )//该技能满足触发条件
                    {
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                     trigger != null &&
                    (
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyBishaShoudongTexing ||trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing)||
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyShoudong || trigger.TriggerStart == ConditionTriggerEnum.SelfShoudong)
                    )
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  trigger,   self, hero, 
                             trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing||
                             trigger.TriggerStart == ConditionTriggerEnum.SelfShoudong
                             )
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null ||
                            ( 
                                (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing &&trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing)&&
                                (trigger.TriggerEnd != ConditionTriggerEnum.EnemyShoudong &&trigger.TriggerEnd != ConditionTriggerEnum.SelfShoudong)
                            )
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfShoudong)
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }

        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                   trigger == null ||
                    (
                        (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing) &&
                        (trigger.TriggerEnd != ConditionTriggerEnum.EnemyShoudong && trigger.TriggerEnd != ConditionTriggerEnum.SelfShoudong)
                    )
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero,
                    trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfShoudong) 
                )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                  (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing) &&
                        (trigger.TriggerStart != ConditionTriggerEnum.EnemyShoudong && trigger.TriggerStart != ConditionTriggerEnum.SelfShoudong)
                )
                return;

            if (
                RangeTriggerCheckOneStart(trigger, box, hero,
                trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfShoudong
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onTexingRelease(AI_Hero hero, Skill _skill)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null ||
                        (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                        (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaTexing)
                        ) continue;

                    if ( 
                         RangeTriggerCheckOneStart(  
                            trigger,   self, hero, 
                            trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing
                             )
                        )//该技能满足触发条件
                    {
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                     trigger != null &&
                     (
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                        (trigger.TriggerStart == ConditionTriggerEnum.EnemyBishaTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing)
                    )
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  
                            trigger,   self, hero, 
                            trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing
                             )
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaTexing)
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaTexing) 
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                   trigger == null ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerEnd != ConditionTriggerEnum.SelfBishaTexing)
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger, box,hero, 
                    trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerEnd == ConditionTriggerEnum.SelfBishaTexing) 
                )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaShoudongTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaShoudongTexing) ||
                (trigger.TriggerStart != ConditionTriggerEnum.EnemyBishaTexing && trigger.TriggerStart != ConditionTriggerEnum.SelfBishaTexing)
                )
                return;

            if (
                RangeTriggerCheckOneStart(trigger, box, hero,
                trigger.TriggerStart == ConditionTriggerEnum.SelfBishaShoudongTexing || trigger.TriggerStart == ConditionTriggerEnum.SelfBishaTexing
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onBattlefieldStart()
    {
        var it = m_OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (trigger==null|| trigger.TriggerStart != ConditionTriggerEnum.BattleStart) continue;
                    DoSkill(self, txSkill);
                } 
        } 
    }

    void onHeroHitFirst(AI_Hero hero)
    { 
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger==null|| 
                        ((trigger.TriggerStart != ConditionTriggerEnum.EnemyHitFirst &&
                        trigger.TriggerStart != ConditionTriggerEnum.SelfHitFirst)  )
                        ) continue;

                    if ( 
                         RangeTriggerCheckOneStart(  
                            trigger,self, hero, 
                            trigger.TriggerStart == ConditionTriggerEnum.SelfHitFirst
                             )
                        )//该技能满足触发条件
                    { 
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill!=null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                     trigger!=null&&
                    ((trigger.TriggerStart == ConditionTriggerEnum.EnemyHitFirst ||
                    trigger.TriggerStart == ConditionTriggerEnum.SelfHitFirst) )
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  
                            trigger,self, hero, 
                            trigger.TriggerStart == ConditionTriggerEnum.SelfHitFirst
                             )
                        )//该技能满足触发条件 
                    { 
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger==null||
                            ( 
                            trigger.TriggerEnd != ConditionTriggerEnum.EnemyHitFirst &&
                            trigger.TriggerEnd != ConditionTriggerEnum.SelfHitFirst 
                            )
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfHitFirst) 
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                   trigger == null ||
                    (
                    trigger.TriggerEnd != ConditionTriggerEnum.EnemyHitFirst &&
                    trigger.TriggerEnd != ConditionTriggerEnum.SelfHitFirst
                    )
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfHitFirst) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }


        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                trigger.TriggerStart != ConditionTriggerEnum.EnemyHitFirst &&
                    trigger.TriggerStart != ConditionTriggerEnum.SelfHitFirst
                )
                return;

            if (
                RangeTriggerCheckOneStart(trigger, box, hero,
              trigger.TriggerStart == ConditionTriggerEnum.SelfHitFirst
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onSoldiersFirstLower(AI_ArmySquare square)
    {
        int SoldiersCount = square.SoldiersCount;
        var it = m_OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null||
                        (trigger.TriggerStart != ConditionTriggerEnum.SelfSoldiersLess && trigger.TriggerStart != ConditionTriggerEnum.EnemySoldiersLess) ||
                        SoldiersCount >= trigger.Int_3rdTriggerStart ||  //当前不比设定值小
                        self.OwnerArmySquare.triggerMinSoldiersNum.IsReleasedSkill(txSkill)//技能已经释放过
                        ) continue;

                    if ( 

                         RangeTriggerCheckOneStart(  
                            trigger,self, square.hero, 
                            trigger.TriggerStart == ConditionTriggerEnum.SelfSoldiersLess
                             )
                        )//该技能满足触发条件
                    {
                        self.OwnerArmySquare.triggerMinSoldiersNum.OnSkillReleased(txSkill);
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger!=null&&
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfSoldiersLess && trigger.TriggerStart != ConditionTriggerEnum.EnemySoldiersLess) &&
                    SoldiersCount < trigger.Int_3rdTriggerStart &&
                    !self.OwnerArmySquare.triggerMinSoldiersNum.IsReleasedSkill(skill)//技能没有释放过
                    )
                    if ( 
                         RangeTriggerCheckOneStart(
                            trigger, self, square.hero,
                            trigger.TriggerStart == ConditionTriggerEnum.SelfSoldiersLess
                             )
                        )//该技能满足触发条件 
                    {
                        self.OwnerArmySquare.triggerMinSoldiersNum.OnSkillReleased(skill);
                        DoSkill(self, skill);
                    }
            }


            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger==null||
                           (trigger.TriggerStart != ConditionTriggerEnum.SelfSoldiersLess && trigger.TriggerStart != ConditionTriggerEnum.EnemySoldiersLess) ||
                            SoldiersCount >= trigger.Int_3rdTriggerStart  //当前不比设定值小
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self, square.hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfSoldiersLess) 
                       )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                  trigger == null ||
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfSoldiersLess && trigger.TriggerStart != ConditionTriggerEnum.EnemySoldiersLess) ||
                    SoldiersCount >= trigger.Int_3rdTriggerStart  //当前不比设定值小
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger, box ,square.hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfSoldiersLess) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
               (trigger.TriggerStart != ConditionTriggerEnum.SelfSoldiersLess && trigger.TriggerStart != ConditionTriggerEnum.EnemySoldiersLess) ||
                    SoldiersCount >= trigger.Int_3rdTriggerStart  //当前不比设定值小
                )
                return;

            if (
                RangeTriggerCheckOneStart(trigger, box, square.hero, trigger.TriggerStart == ConditionTriggerEnum.SelfSoldiersLess
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    /// <summary>
    /// 连斩数变化
    /// </summary>
    /// <param name="lianzhanID">连斩ID,连斩如果不能累计则会换新ID</param>
    /// <param name="num">当前连斩数</param>
    void onLianzhan(AI_FightUnit unit, int lianzhanID, int num)
    {
        if (num < 1)//连斩已失效
        {
            var it = unit.OwnerBattlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var self = it.Current.hero;
                self.OnLianzhanDestroy(lianzhanID);
            }
            return;
        }


        {
            var it = unit.OwnerBattlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var self = it.Current.hero;
                if (self.IsDie) continue;

                var txSkills = self.TexingSkill;
                int len = txSkills.Length;

                //遍历英雄所有特性技能
                if (self.ActionsLimit.CanReleaseTexingSkill)
                    for (int i = 0; i < len; i++)
                    {
                        var txSkill = txSkills[i];
                        var trigger = txSkill.SkillTrigger;
                        if (
                            trigger == null||
                            (trigger.TriggerStart != ConditionTriggerEnum.SelfLianZhan && trigger.TriggerStart != ConditionTriggerEnum.EnemyLianZhan)||
                            num / (self.GetLianzhanReleaseCount(lianzhanID, txSkill) + 1) < trigger.Int_3rdTriggerStart//连斩次数不符合设定
                            )
                            continue;

                        if ( 
                            RangeTriggerCheckOneStart(  
                                trigger,self,unit, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfLianZhan
                             )
                            )//该技能满足触发条件
                        {
                            self.OnLianzhanSkillRelease(lianzhanID, txSkill);//加入释放成功的连斩队列
                            DoSkill(self, txSkill);
                        }
                    }


                //检查手动
                if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
                {
                    var skill = self.ShoudongSkill;
                    var trigger = skill.SkillTrigger;
                    if (
                        trigger!=null&&
                        (
                          trigger.TriggerStart == ConditionTriggerEnum.SelfLianZhan || trigger.TriggerStart == ConditionTriggerEnum.EnemyLianZhan) &&
                          num / (self.GetLianzhanReleaseCount(lianzhanID, skill) + 1) >= trigger.Int_3rdTriggerStart//连斩次数判定
                        )
                        if (
                             RangeTriggerCheckOneStart(
                                trigger, self, unit,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfLianZhan
                             )
                            )//该技能满足触发条件 
                        { 
                            self.OnLianzhanSkillRelease(lianzhanID, skill);//加入释放成功的连斩队列
                            DoSkill(self, skill);
                        }
                }




                //遍历buff,处理特性结束条件的buff
                {
                    self.EffectBuffManage.ForeachTexingBuff(
                        (buff) =>
                        {
                            var trigger = buff.effect.EndSkillTriggerObj;

                            if (
                                trigger==null||
                                (trigger.TriggerEnd != ConditionTriggerEnum.SelfLianZhan && trigger.TriggerEnd != ConditionTriggerEnum.EnemyLianZhan) ||
                                num < trigger.Int_3rdTriggerEnd//连斩次数不符合设定
                                )
                                return;

                            if (
                                RangeTriggerCheckOneEnd(trigger,self,unit,trigger.TriggerEnd == ConditionTriggerEnum.SelfLianZhan) 
                                )//该技能满足条件
                            {
                                RemoveBuff.Add(buff);
                            }
                        }
                    );
                    DoRemoveBuff(self.EffectBuffManage);
                }
            } 
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                  trigger == null ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.SelfLianZhan && trigger.TriggerEnd != ConditionTriggerEnum.EnemyLianZhan) ||
                    num < trigger.Int_3rdTriggerEnd//连斩次数不符合设定
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,unit, trigger.TriggerEnd == ConditionTriggerEnum.SelfLianZhan) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
              (trigger.TriggerStart != ConditionTriggerEnum.SelfLianZhan && trigger.TriggerStart != ConditionTriggerEnum.EnemyLianZhan) ||
                    num < trigger.Int_3rdTriggerStart//连斩次数不符合设定
                )
                return;

            if (
                RangeTriggerCheckOneStart(trigger, box, unit, trigger.TriggerStart == ConditionTriggerEnum.SelfLianZhan
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onPowerFull(AI_Hero hero)
    { 
        {
            var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var self = it.Current.hero;
                if (self.IsDie) continue;

                var txSkills = self.TexingSkill;
                int len = txSkills.Length;

                //遍历英雄所有特性技能
                if (self.ActionsLimit.CanReleaseTexingSkill)
                    for (int i = 0; i < len; i++)
                    {
                        var txSkill = txSkills[i];
                        var trigger = txSkill.SkillTrigger;
                        if (
                            trigger == null ||
                            (trigger.TriggerStart != ConditionTriggerEnum.Poweer)  
                            )
                            continue;

                        if (
                            RangeTriggerCheckOneStart(
                                trigger, self, hero,
                                true
                             )
                            )//该技能满足触发条件 
                            DoSkill(self, txSkill); 
                    }


                //检查手动
                if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
                {
                    var skill = self.ShoudongSkill;
                    var trigger = skill.SkillTrigger;
                    if (
                        trigger != null && 
                        trigger.TriggerStart == ConditionTriggerEnum.Poweer 
                        )
                        if (
                             RangeTriggerCheckOneStart(
                                trigger, self, hero,
                                true
                             )
                            )//该技能满足触发条件  
                            DoSkill(self, skill); 
                }




                //遍历buff,处理特性结束条件的buff
                {
                    self.EffectBuffManage.ForeachTexingBuff(
                        (buff) =>
                        {
                            var trigger = buff.effect.EndSkillTriggerObj;

                            if (
                                trigger == null ||
                                trigger.TriggerEnd != ConditionTriggerEnum.Poweer   
                                )
                                return;

                            if (
                                RangeTriggerCheckOneEnd(trigger,self,hero,true) 
                                )//该技能满足条件
                            {
                                RemoveBuff.Add(buff);
                            }
                        }
                    );
                    DoRemoveBuff(self.EffectBuffManage);
                }
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                  trigger == null ||
                    trigger.TriggerEnd != ConditionTriggerEnum.Poweer
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero,true) 
               )//该技能满足条件 
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box); 
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
               trigger == null ||
                    trigger.TriggerStart != ConditionTriggerEnum.Poweer
                )
                return;

            if (  RangeTriggerCheckOneStart(trigger, box, hero, true ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    void onYun(AI_Hero hero)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
                for (int i = 0; i < len; i++)
                {
                    var txSkill = txSkills[i];
                    var trigger = txSkill.SkillTrigger;
                    if (
                        trigger == null ||
                        (trigger.TriggerStart != ConditionTriggerEnum.SelfYun && trigger.TriggerStart != ConditionTriggerEnum.EnemyYun)  
                        )
                        continue;
                    if (
                         RangeTriggerCheckOneStart(
                                    trigger, self, hero,
                                    trigger.TriggerStart == ConditionTriggerEnum.SelfYun
                                 )
                        )//该技能满足触发条件
                    {
                        DoSkill(self, txSkill);
                    }
                }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger != null &&
                    (trigger.TriggerStart == ConditionTriggerEnum.SelfYun || trigger.TriggerStart == ConditionTriggerEnum.EnemyYun)  
                    )
                    if (
                         RangeTriggerCheckOneStart(
                                trigger, self, hero,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfYun
                             )
                        )//该技能满足触发条件  
                        DoSkill(self, skill); 
            }




            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfYun && trigger.TriggerEnd != ConditionTriggerEnum.EnemyYun)  
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger, self, hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfYun)
                            )//该技能满足条件 
                            RemoveBuff.Add(buff); 
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }



        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                   trigger == null ||
                   (trigger.TriggerEnd != ConditionTriggerEnum.SelfYun && trigger.TriggerEnd != ConditionTriggerEnum.EnemyYun)  
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger, box, hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfYun)
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                 trigger == null ||
                   (trigger.TriggerStart != ConditionTriggerEnum.SelfYun && trigger.TriggerStart != ConditionTriggerEnum.EnemyYun)  
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, hero, trigger.TriggerStart== ConditionTriggerEnum.SelfYun))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    /// <summary>
    /// 英雄掉血
    /// </summary>
    void onHeroLostHP(AI_Hero hero,int num)
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if(self.ActionsLimit.CanReleaseTexingSkill)
            for (int i = 0; i < len; i++)
            {
                var txSkill = txSkills[i];
                var trigger = txSkill.SkillTrigger;
                if (
                    trigger == null||
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfLostHPFirst && trigger.TriggerStart != ConditionTriggerEnum.EnemyLostHPFirst)||
                    num > trigger.Int_3rdTriggerStart//次数超出限制
                    )
                    continue; 
                if ( 
                     RangeTriggerCheckOneStart(  
                                trigger,self,hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfLostHPFirst
                             )
                    )//该技能满足触发条件
                {
                    DoSkill(self,txSkill); 
                }
            }

            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger!=null&&
                    (trigger.TriggerStart == ConditionTriggerEnum.SelfLostHPFirst || trigger.TriggerStart == ConditionTriggerEnum.EnemyLostHPFirst)&&
                    num <= trigger.Int_3rdTriggerStart//次数检查
                    )
                    if ( 
                         RangeTriggerCheckOneStart(  
                                trigger,self,hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfLostHPFirst
                             )
                        )//该技能满足触发条件 
                    { 
                        DoSkill(self, skill);
                    }
            }




            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger==null||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfLostHPFirst && trigger.TriggerEnd != ConditionTriggerEnum.EnemyLostHPFirst)||
                            num > trigger.Int_3rdTriggerStart//次数超出限制
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfLostHPFirst) 
                            )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }



        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                   trigger == null ||
                   (trigger.TriggerEnd != ConditionTriggerEnum.SelfLostHPFirst && trigger.TriggerEnd != ConditionTriggerEnum.EnemyLostHPFirst)||
                    num > trigger.Int_3rdTriggerEnd//次数超出限制
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfLostHPFirst) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                trigger == null ||
                   (trigger.TriggerStart != ConditionTriggerEnum.SelfLostHPFirst && trigger.TriggerStart != ConditionTriggerEnum.EnemyLostHPFirst) ||
                    num > trigger.Int_3rdTriggerStart//次数超出限制
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, hero, trigger.TriggerStart == ConditionTriggerEnum.SelfLostHPFirst))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

 

    void DoRemoveBuff(AI_EffectBuffManage EffectBuffManage)
    {
        if (RemoveBuff.Count > 0)
        {
            foreach (var buff in RemoveBuff)  EffectBuffManage.RemoveBuff(buff);
        }
        RemoveBuff.Clear();
    }
    List<AI_EffectBuff> RemoveBuff = new List<AI_EffectBuff>();


    /// <summary>
    /// 英雄死亡
    /// </summary>
     void onHeroDie(AI_Hero hero,AI_FightUnit attacker )
    {
        var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
            for (int i = 0; i < len; i++)
            {
                var txSkill = txSkills[i];
                var trigger =   txSkill.SkillTrigger;
                if (
                    trigger == null||
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfHeroDie && trigger.TriggerStart != ConditionTriggerEnum.EnemyHeroDie)
                    ) continue;

                 if( 
                      RangeTriggerCheckOneStart(  
                                trigger,self,hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfHeroDie
                             )
                     )//该技能满足触发条件
                 {
                     DoSkill(self, txSkill); 
                 }
            }


            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger!=null&&
                    (trigger.TriggerStart == ConditionTriggerEnum.SelfHeroDie || trigger.TriggerStart == ConditionTriggerEnum.EnemyHeroDie)
                    )
                    if (
                          RangeTriggerCheckOneStart(
                                trigger, self, hero,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfHeroDie
                             )
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }



            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger ==null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfHeroDie && trigger.TriggerEnd != ConditionTriggerEnum.EnemyHeroDie)
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfHeroDie) 
                            
                             )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }



        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                  trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfHeroDie && trigger.TriggerEnd != ConditionTriggerEnum.EnemyHeroDie)
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,hero,  trigger.TriggerEnd == ConditionTriggerEnum.SelfHeroDie) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }



        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                trigger == null ||
                            (trigger.TriggerStart != ConditionTriggerEnum.SelfHeroDie && trigger.TriggerStart != ConditionTriggerEnum.EnemyHeroDie)
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, hero, trigger.TriggerStart== ConditionTriggerEnum.SelfHeroDie))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }


    /// <summary>
    /// 士兵为0
    /// </summary>
    void onArmyZero(AI_ArmySquare square)
     {
         var it = square.OwnerBattlefield.ArmySquareListEnumerator;
         while (it.MoveNext())
         {
             var self = it.Current.hero;
             if (self.IsDie) continue;

             var txSkills = self.TexingSkill;
             int len = txSkills.Length;

             //遍历英雄所有特性技能
             if (self.ActionsLimit.CanReleaseTexingSkill)
             for (int i = 0; i < len; i++)
             {
                 var txSkill = txSkills[i];
                 var trigger = txSkill.SkillTrigger;
                 if (trigger==null||( trigger.TriggerStart != ConditionTriggerEnum.SelfArmyZero && trigger.TriggerStart != ConditionTriggerEnum.EnemyArmyZero)) continue;

                 if ( 
                      RangeTriggerCheckOneStart(  
                                trigger,self,square.hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfArmyZero
                             )
                   )//该技能满足触发条件
                 {
                     DoSkill(self, txSkill); 
                 }
             }



             //检查手动
             if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
             {
                 var skill = self.ShoudongSkill;
                 var trigger = skill.SkillTrigger;
                 if (trigger!=null&&
                     (trigger.TriggerStart == ConditionTriggerEnum.SelfArmyZero || trigger.TriggerStart == ConditionTriggerEnum.EnemyArmyZero)
                     )
                     if (
                           RangeTriggerCheckOneStart(
                                trigger, self, square.hero,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfArmyZero
                             )
                         )//该技能满足触发条件 
                     {
                         DoSkill(self, skill);
                     }
             }



             //遍历buff,处理特性结束条件的buff
             {
                 self.EffectBuffManage.ForeachTexingBuff(
                     (buff) =>
                     {
                         var trigger = buff.effect.EndSkillTriggerObj;

                         if (
                             trigger==null||
                             (trigger.TriggerEnd != ConditionTriggerEnum.SelfArmyZero && trigger.TriggerEnd != ConditionTriggerEnum.EnemyArmyZero)
                             )
                             return;

                         if (
                             RangeTriggerCheckOneEnd(trigger,self,  square.hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfArmyZero) 
                             )//该技能满足条件
                         {
                             RemoveBuff.Add(buff);
                         }
                     }
                 );
                 DoRemoveBuff(self.EffectBuffManage);
             }
         }




         //遍历box,处理特性结束条件的box
         {
             m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
             {
                 var trigger = box.boxInfo.EndSkillTrigger;

                 if (
                   trigger == null ||
                             (trigger.TriggerEnd != ConditionTriggerEnum.SelfArmyZero && trigger.TriggerEnd != ConditionTriggerEnum.EnemyArmyZero)
                     )
                     return;

                 if (
                     RangeTriggerCheckOneEnd(trigger,box,  square.hero,trigger.TriggerEnd == ConditionTriggerEnum.SelfArmyZero) 
                )//该技能满足条件
                 {
                     m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                 }
             });

             m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
         }


         m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
         {
             var trigger = box.boxInfo.StartSkillTrigger;

             if (
               trigger == null ||
                             (trigger.TriggerStart != ConditionTriggerEnum.SelfArmyZero && trigger.TriggerStart != ConditionTriggerEnum.EnemyArmyZero)
                 )
                 return;

             if (RangeTriggerCheckOneStart(trigger, box, square.hero, trigger.TriggerStart == ConditionTriggerEnum.SelfArmyZero))//该技能满足条件
                 m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

         });
     }

    /// <summary>
    /// 英雄杀死英雄
    /// </summary>
    void onHeroKillHero(AI_Hero attacker, AI_Hero defender)
    {  
        var it = attacker.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
            for (int i = 0; i < len; i++)
            {
                var txSkill = txSkills[i];
                var trigger = txSkill.SkillTrigger;
                if (
                    trigger == null||
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfKill && trigger.TriggerStart != ConditionTriggerEnum.EnemyKill)
                    ) continue;

                if ( 
                     RangeTriggerCheckOneStart(  
                                trigger,self,attacker, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfKill
                             )
                    )
                    //该技能满足触发条件
                {
                    DoSkill(self, txSkill); 
                }
            }



            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger!=null&&
                    (trigger.TriggerStart == ConditionTriggerEnum.SelfKill || trigger.TriggerStart == ConditionTriggerEnum.EnemyKill)
                    )
                    if (
                          RangeTriggerCheckOneStart(
                                trigger, self, attacker,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfKill
                             )
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }




            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (trigger==null||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfKill && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKill)
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger,self,attacker,    trigger.TriggerEnd == ConditionTriggerEnum.SelfKill) 
                            )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                 trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfKill && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKill)
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger,box,attacker, trigger.TriggerEnd == ConditionTriggerEnum.SelfKill) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }

        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
            trigger == null ||
                            (trigger.TriggerStart != ConditionTriggerEnum.SelfKill && trigger.TriggerStart != ConditionTriggerEnum.EnemyKill)
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, attacker, trigger.TriggerStart == ConditionTriggerEnum.SelfKill))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

    /// <summary>
    /// 英雄杀死士兵
    /// </summary>
    void onHeroKillSoldiers(AI_Hero attacker, AI_Soldiers defender)
    {
        var it = attacker.OwnerBattlefield.ArmySquareListEnumerator;
        while (it.MoveNext())
        {
            var self = it.Current.hero;
            if (self.IsDie) continue;

            var txSkills = self.TexingSkill;
            int len = txSkills.Length;

            //遍历英雄所有特性技能
            if (self.ActionsLimit.CanReleaseTexingSkill)
            for (int i = 0; i < len; i++)
            {
                var txSkill = txSkills[i];
                var trigger = txSkill.SkillTrigger;
                if (
                    trigger == null||
                    (trigger.TriggerStart != ConditionTriggerEnum.SelfKillArmy && trigger.TriggerStart != ConditionTriggerEnum.EnemyKillArmy&&
                    trigger.TriggerStart != ConditionTriggerEnum.SelfKill  && trigger.TriggerStart != ConditionTriggerEnum.EnemyKill 
                    ) 
                    )
                    continue;

                if (  
                     RangeTriggerCheckOneStart(  
                                trigger,self,attacker,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfKillArmy || trigger.TriggerStart == ConditionTriggerEnum.SelfKill
                             )
                    )//该技能满足触发条件
                {
                    DoSkill(self, txSkill); 
                }
            }


            //检查手动
            if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
            {
                var skill = self.ShoudongSkill;
                var trigger = skill.SkillTrigger;
                if (
                    trigger!=null&&
                    (trigger.TriggerStart == ConditionTriggerEnum.SelfKillArmy || trigger.TriggerStart == ConditionTriggerEnum.EnemyKillArmy||
                    trigger.TriggerStart == ConditionTriggerEnum.SelfKill || trigger.TriggerStart == ConditionTriggerEnum.EnemyKill 
                    )
                    )
                    if (
                           RangeTriggerCheckOneStart(
                                trigger, self, attacker,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfKillArmy || trigger.TriggerStart == ConditionTriggerEnum.SelfKill
                             )
                        )//该技能满足触发条件 
                    {
                        DoSkill(self, skill);
                    }
            }



            //遍历buff,处理特性结束条件的buff
            {
                self.EffectBuffManage.ForeachTexingBuff(
                    (buff) =>
                    {
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (
                            trigger == null||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfKillArmy && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKillArmy&&
                            trigger.TriggerEnd != ConditionTriggerEnum.SelfKill  && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKill 
                            )
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger, self, attacker, trigger.TriggerEnd == ConditionTriggerEnum.SelfKillArmy || trigger.TriggerEnd == ConditionTriggerEnum.SelfKill)
                            )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        }
                    }
                );
                DoRemoveBuff(self.EffectBuffManage);
            }
        }


        //遍历box,处理特性结束条件的box
        {
            m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
            {
                var trigger = box.boxInfo.EndSkillTrigger;

                if (
                 trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfKillArmy && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKillArmy&&
                            trigger.TriggerEnd != ConditionTriggerEnum.SelfKill  && trigger.TriggerEnd != ConditionTriggerEnum.EnemyKill 
                            )
                    )
                    return;

                if (
                    RangeTriggerCheckOneEnd(trigger, box, attacker, trigger.TriggerEnd == ConditionTriggerEnum.SelfKillArmy || trigger.TriggerEnd == ConditionTriggerEnum.SelfKill) 
               )//该技能满足条件
                {
                    m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                }
            });

            m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
        }


        m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
        {
            var trigger = box.boxInfo.StartSkillTrigger;

            if (
                    trigger == null ||
                    (
                    trigger.TriggerStart != ConditionTriggerEnum.SelfKillArmy && trigger.TriggerStart != ConditionTriggerEnum.EnemyKillArmy&&
                    trigger.TriggerStart != ConditionTriggerEnum.SelfKill  && trigger.TriggerStart != ConditionTriggerEnum.EnemyKill 
                    )
                )
                return;

            if (RangeTriggerCheckOneStart(trigger, box, attacker,
                trigger.TriggerStart == ConditionTriggerEnum.SelfKillArmy||trigger.TriggerStart ==  ConditionTriggerEnum.SelfKill
                
                ))//该技能满足条件
                m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

        });
    }

     void onHPFirstGreater(AI_Hero hero)
    {

    }


    /// <summary>
    /// 英雄生命首次小于
    /// </summary>
     void onHPFirstLower(AI_Hero hero)
     {
         float hpBfb = (float)hero.CurrHP / (float)hero.FinalMaxHP;
         var it = hero.OwnerBattlefield.ArmySquareListEnumerator;
         while (it.MoveNext())
         {
             var self = it.Current.hero;
             if (self.IsDie) continue;

             var txSkills = self.TexingSkill;
             int len = txSkills.Length;

             //遍历英雄所有特性技能
             if (self.ActionsLimit.CanReleaseTexingSkill)
             for (int i = 0; i < len; i++)
             {
                 var txSkill = txSkills[i];
                 var trigger = txSkill.SkillTrigger;
                 if (
                     trigger == null||
                     trigger.TriggerStart != ConditionTriggerEnum.EnemyHPLessFirst ||
                     hpBfb>=trigger.Float_3rdTriggerStart||  //当前生命百分比不比设定值小
                     self.triggerMinHP.IsReleasedSkill(txSkill)//技能已经释放过
                     ) continue;

                 if (
                     
                      RangeTriggerCheckOneStart(  
                                trigger,self,hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.EnemyHPLessFirst
                             )
                     
                     )//该技能满足触发条件
                 {
                     self.triggerMinHP.OnSkillReleased(txSkill);
                     DoSkill(self, txSkill); 
                 }
             }


             //检查手动
             if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
             {
                 var skill = self.ShoudongSkill;
                 var trigger = skill.SkillTrigger;
                 if (
                     trigger != null&&
                        trigger.TriggerStart == ConditionTriggerEnum.EnemyHPLessFirst &&
                        hpBfb < trigger.Float_3rdTriggerStart &&
                        !self.triggerMinHP.IsReleasedSkill(skill) 
                     )
                     if (
                          RangeTriggerCheckOneStart(
                                trigger, self, hero,
                                trigger.TriggerStart == ConditionTriggerEnum.EnemyHPLessFirst
                             )
                         )//该技能满足触发条件 
                     {
                         self.triggerMinHP.OnSkillReleased(skill);
                         DoSkill(self, skill);
                     }
             }


             //遍历buff,处理特性结束条件的buff
             {
                 self.EffectBuffManage.ForeachTexingBuff(
                     (buff) =>
                     {
                         var trigger = buff.effect.EndSkillTriggerObj;

                         if (
                             trigger == null||
                             (trigger.TriggerEnd != ConditionTriggerEnum.EnemyHPLessFirst ||
                             hpBfb >= trigger.Float_3rdTriggerEnd)  //当前生命百分比不比设定值小
                             )
                             return;

                         if (               
                             RangeTriggerCheckOneEnd(trigger, self,  hero, trigger.TriggerEnd == ConditionTriggerEnum.EnemyHPLessFirst) 
                        )//该技能满足条件
                         {
                             RemoveBuff.Add(buff);
                         }
                     }
                 );
                 DoRemoveBuff(self.EffectBuffManage);
             }
         }


         //遍历box,处理特性结束条件的box
         {
             m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
             {
                 var trigger = box.boxInfo.EndSkillTrigger;

                 if (
                   trigger == null ||
                    (trigger.TriggerEnd != ConditionTriggerEnum.EnemyHPLessFirst ||
                    hpBfb >= trigger.Float_3rdTriggerEnd)  //当前生命百分比不比设定值小
                     )
                     return;

                 if (
                     RangeTriggerCheckOneEnd(trigger,box,hero,  trigger.TriggerEnd == ConditionTriggerEnum.EnemyHPLessFirst) 
                )//该技能满足条件
                 {
                     m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                 }
             });

             m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);
         }

         m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
         {
             var trigger = box.boxInfo.StartSkillTrigger;

             if (
              trigger == null ||
                    (trigger.TriggerStart != ConditionTriggerEnum.EnemyHPLessFirst ||
                    hpBfb >= trigger.Float_3rdTriggerStart)  //当前生命百分比不比设定值小
                 )
                 return;

             if (RangeTriggerCheckOneStart(trigger, box, hero, trigger.TriggerStart == ConditionTriggerEnum.EnemyHPLessFirst))//该技能满足条件
                 m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

         });
     }




     /// <summary>
     /// 阵杀敌时
     /// </summary>
     void onSquareKill(AI_ArmySquare attacker, AI_FightUnit defender)
     {
         var it = attacker.OwnerBattlefield.ArmySquareListEnumerator;
         while (it.MoveNext())
         {
             var self = it.Current.hero;
             if (self.IsDie) continue;

             var txSkills = self.TexingSkill;
             int len = txSkills.Length;

             //遍历英雄所有特性技能
             if (self.ActionsLimit.CanReleaseTexingSkill)
                 for (int i = 0; i < len; i++)
                 {
                     var txSkill = txSkills[i];
                     var trigger = txSkill.SkillTrigger;
                     if (
                         trigger == null ||
                         (trigger.TriggerStart != ConditionTriggerEnum.SelfSquareKill && trigger.TriggerStart != ConditionTriggerEnum.EnemySquareKill)
                         ) continue;

                     if (
                          
                          RangeTriggerCheckOneStart(  
                                trigger,self,  attacker.hero, 
                                trigger.TriggerStart == ConditionTriggerEnum.SelfSquareKill
                             )
                         )
                     //该技能满足触发条件
                     {
                         DoSkill(self, txSkill);
                     }
                 }



             //检查手动
             if (self.ActionsLimit.CanReleaseShoudongSkill && self.ShoudongSkill != null)
             {
                 var skill = self.ShoudongSkill;
                 var trigger = skill.SkillTrigger;
                 if (
                     trigger != null &&
                     (trigger.TriggerStart == ConditionTriggerEnum.SelfSquareKill || trigger.TriggerStart == ConditionTriggerEnum.EnemySquareKill)
                     )
                     if (
                          RangeTriggerCheckOneStart(
                                trigger, self, attacker.hero,
                                trigger.TriggerStart == ConditionTriggerEnum.SelfSquareKill
                             )
                         )//该技能满足触发条件 
                     {
                         DoSkill(self, skill);
                     }
             }




             //遍历buff,处理特性结束条件的buff
             {
                 self.EffectBuffManage.ForeachTexingBuff(
                     (buff) =>
                     { 
                        var trigger = buff.effect.EndSkillTriggerObj;

                        if (trigger == null ||
                            (trigger.TriggerEnd != ConditionTriggerEnum.SelfSquareKill && trigger.TriggerEnd != ConditionTriggerEnum.EnemySquareKill)
                            )
                            return;

                        if (
                            RangeTriggerCheckOneEnd(trigger, self, attacker.hero, trigger.TriggerEnd == ConditionTriggerEnum.SelfSquareKill)
                            )//该技能满足条件
                        {
                            RemoveBuff.Add(buff);
                        } 
                     }
                 );
                 DoRemoveBuff(self.EffectBuffManage);
             }
         }
         

         //遍历box,处理特性结束条件的box
         {
             m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
             {
                 var trigger = box.boxInfo.EndSkillTrigger;

                 if (
                      trigger == null ||
                      (trigger.TriggerEnd != ConditionTriggerEnum.SelfSquareKill && trigger.TriggerEnd != ConditionTriggerEnum.EnemySquareKill)
                     )
                     return;

                 if ( RangeTriggerCheckOneEnd(trigger,box, attacker.hero,  trigger.TriggerEnd == ConditionTriggerEnum.SelfSquareKill)  )//该技能满足条件
                     m_OwnerBattlefield.SkillBoxManage.CacheRemove(box);
                 
             });

             m_OwnerBattlefield.SkillBoxManage.DoRemove(m_OwnerBattlefield.TotalLostTime);


         }


         m_OwnerBattlefield.SkillBoxManage.ForeachTexingBox((box) =>
         {
             var trigger = box.boxInfo.StartSkillTrigger;

             if (
                  trigger == null ||
                  (trigger.TriggerStart != ConditionTriggerEnum.SelfSquareKill && trigger.TriggerStart != ConditionTriggerEnum.EnemySquareKill)
                 )
                 return;

             if (RangeTriggerCheckOneStart(trigger, box, attacker.hero, trigger.TriggerStart == ConditionTriggerEnum.SelfSquareKill))//该技能满足条件
                 m_OwnerBattlefield.SkillBoxManage.DoBoxEffects(m_OwnerBattlefield.TotalLostTime, box);

         });
     }

    void DoSkill(AI_FightUnit self ,Skill skill)
     { 
         if (skill.SkillType== SkillType.Shoudong)//手动技
         {
             AI_Hero hero = self as AI_Hero;
             if (hero != null) hero.ActiveShoudong(true);
         }else//非手动技能 
            self.AddCacheSkill(skill,true);
     }


    static bool RangeTriggerCheckOneStart(SkillTriggerInfo trigger, AI_FightUnit self, AI_FightUnit other,bool isSelf)
    {
        return AI_TriggerChecker.RangeTriggerCheckOne(
                                     self,
                                     other,
                                     isSelf,//是否为我方
                                     trigger._2ndTriggerStart,
                                     trigger.IsSelfStart,//是否包含自己
                                     trigger.IntArray_4rdTriggerStart,
                                     trigger.Float_4rdTriggerStart,
                                     HeroOrArmyEnum.HeroAndSoldiers
                                     ) ||
                                     RangeTriggerCheckOneStart2(trigger, self, other, isSelf);
    }

    static bool RangeTriggerCheckOneStart2(SkillTriggerInfo trigger, AI_FightUnit self, AI_FightUnit other, bool isSelf)
    { 
        return AI_TriggerChecker.RangeTriggerCheckOne(
                                     self,
                                     other,
                                     isSelf,//是否为我方
                                     trigger._2ndTriggerStart2,
                                     trigger.IsSelfStart2,//是否包含自己
                                     trigger.IntArray_3rdTriggerStart2,
                                     trigger.Float_3rdTriggerStart2,
                                     HeroOrArmyEnum.HeroAndSoldiers
                                     );
    }
     
     
    static bool RangeTriggerCheckOneEnd(SkillTriggerInfo trigger, AI_FightUnit self, AI_FightUnit other, bool isSelf)
    {
        return AI_TriggerChecker.RangeTriggerCheckOne(
                                     self,
                                     other,
                                     isSelf,//是否为我方
                                     trigger._2ndTriggerEnd,
                                     trigger.IsSelfEnd,//是否包含自己
                                     trigger.IntArray_4rdTriggerEnd,
                                     trigger.Float_4rdTriggerEnd,
                                     HeroOrArmyEnum.HeroAndSoldiers
                                     );
    }
    AI_Battlefield m_OwnerBattlefield;
} 