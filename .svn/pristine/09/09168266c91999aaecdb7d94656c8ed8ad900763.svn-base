using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class AI_Limit
{
    public AI_Limit(AI_FightUnit owner)
    {
        m_Owner = owner;
    }

    /// <summary>
    /// 是否可移动
    /// </summary>
    public bool CanMove
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasStateM(SkillEffectBOOLST.Dingshen, SkillEffectBOOLST.Yun);
        }
    }


    /// <summary>
    /// 手动技能是否可释放
    /// </summary>
    public bool CanReleaseShoudongSkill
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasStateM(SkillEffectBOOLST.Fengji, SkillEffectBOOLST.Jiaoxie, SkillEffectBOOLST.Yun);
        }
    }

    List<AI_EffectBuff> tmpBuffList = new List<AI_EffectBuff>();


    /// <summary>
    /// 是否能受到伤害
    /// </summary>
    public bool CanInjured(AI_FightUnit enemy)
    {
        SkillEffectBOOLST boolST = m_Owner.UnitType == UnitType.Hero ? SkillEffectBOOLST.HeroWudi : SkillEffectBOOLST.ArmyWudi;

        tmpBuffList.Clear();
        m_Owner.EffectBuffManage.GetBuffs(boolST, tmpBuffList);
        if (tmpBuffList.Count < 1) return true;//没有无敌buff,则允许受到攻击

        //检查子条件是否满足
        foreach (var buff in tmpBuffList)
        {
            var rangeEnum = (RangeTriggerEnum)buff.effect._2ndZhuangtai;
            if (AI_TriggerChecker.RangeTriggerCheckOne(m_Owner, enemy, false, rangeEnum, false, null, 0, HeroOrArmyEnum.HeroAndSoldiers))
                return false;//被免疫
        }

        return true;
    }


    /// <summary>
    /// 必杀技技能是否可释放
    /// </summary>
    public bool CanReleaseBishaSkill
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasStateM(SkillEffectBOOLST.Fengji, SkillEffectBOOLST.Jiaoxie, SkillEffectBOOLST.Yun);
        }
    }


    /// <summary>
    /// 特性技能是否可释放
    /// </summary>
    public bool CanReleaseTexingSkill
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasStateM(SkillEffectBOOLST.Fengji, SkillEffectBOOLST.Jiaoxie, SkillEffectBOOLST.Yun);
        }
    }

    /// <summary>
    /// 普通攻击是否可释放
    /// </summary>
    public bool CanReleasePutongSkill
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasStateM(SkillEffectBOOLST.Jiaoxie, SkillEffectBOOLST.Yun);
        }
    }

    public bool CanHuifu
    {
        get
        {
            return !m_Owner.EffectBuffManage.HasState(SkillEffectBOOLST.Zhongdu);
        }
    }
    AI_FightUnit m_Owner;
}
