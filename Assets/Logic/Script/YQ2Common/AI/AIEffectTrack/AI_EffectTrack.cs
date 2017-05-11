using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//进攻者抽象接口
/*
public interface I_FightRole  
{
      I_FightRole Enemy { get; }

      int HeroLevel { get; }

      int HeroPosX { get; }
      int HeroPosZ { get; }     
      AAttr HeroHP { get; }

      AAttr HeroWuLi { get; }
     

      BoundingBox2D Box { get; set; }

      AIDirection Dir { get; }

      ArmyFlag Flag { get; }
      ArmyFlag EnemyFlag { get; } 
      
      int Round { get; }

      bool IsDie { get; }

      ArmyInfo StaticArmyInfo { get; }

      //MonsterInfo StaticMonsterInfo { get; }


      float SoldierWuliDefenseRatio { get; }

      float HeroWuliDefenseRatio { get; }

      int SoldiersCount { get; }

      int GetSkillLevel(int skillID);
}
*/

public interface ISkillEffectDo
{
    SkillArriveInfo ArriveInfo { get; }

    SkillRangeInfo SkillRange { get; }

    void DoSkillEffect(
        float time,//触发时间
        AI_FightUnit Attack,//进攻者
        AI_FightUnit Defender,//防御者　
        Skill skill,//技能
        short skillLevel,//技能等级
        bool IsGrazes,//是否为擦伤
        float dirX,
        float dirZ,
        DieEffect dieEffect
        );
}

public class SkillEffectDo : ISkillEffectDo
{  
    public SkillEffectDo(SkillEffect effect)
    {
        skillEffect = effect;
    }


      SkillEffect skillEffect;//技能效果 

    public SkillArriveInfo ArriveInfo { get { return skillEffect.SkillArriveObj; } }

    public void DoSkillEffect(
        float time,//触发时间
        AI_FightUnit Attack,//进攻者
        AI_FightUnit Defender,//防御者　
        Skill skill,//技能
        short skillLevel,//技能等级
        bool IsGrazes,//是否为擦伤
        float dirX,
        float dirZ,
        DieEffect dieEffect
        )
    {
        //执行技能效果
        AI_SkillHit.DoSkillEffect(Attack, Defender, skill, skillEffect, skillLevel, dieEffect, IsGrazes);

        //创建被击特效
        AI_CreateFX.CreateBeijiFX(time, skillEffect, Defender, -dirX, -dirZ);
    }

    public SkillRangeInfo SkillRange { get { return skillEffect.SkillRange; } }
}

public class SkillBoxDo : ISkillEffectDo
{
    public SkillBoxDo(SkillBoxInfo box)
    {
        skillBox = box;
    }


    SkillBoxInfo skillBox;

    public SkillArriveInfo ArriveInfo { get { return skillBox.SkillArriveObj; } }

    public void DoSkillEffect(
        float time,//触发时间
        AI_FightUnit Attack,//进攻者
        AI_FightUnit Defender,//防御者　
        Skill skill,//技能
        short skillLevel,//技能等级
        bool IsGrazes,//是否为擦伤
        float dirX,
        float dirZ,
        DieEffect dieEffect
        )
    {
        AI_SkillBox nBox = new AI_SkillBox();
        nBox.attacker = Attack;
        nBox.boxInfo = skillBox;
        if (skillBox.BoxDanwei == BoxDanweiEnum.Grid)
        {
            nBox.ownerGridX = Defender.ownerGrid.GredX;
            nBox.ownerGridZ = Defender.ownerGrid.GredZ;
        }
        else 
            nBox.ownerUnit = Defender;

        nBox.skill = skill;
        nBox.skillLevel = skillLevel;
        nBox.IsGrazes = IsGrazes;
        nBox.dieEffect = dieEffect;

        Attack.OwnerBattlefield.SkillBoxManage.MountBox(time, nBox);
    }

    public SkillRangeInfo SkillRange { get { return skillBox.SkillRange; } }
}


//技能效果追踪器
public abstract class AI_EffectTrack : AI_Object
{
    public AI_FightUnit Attack;//进攻者
    public AI_FightUnit Defender;//防御者　

    public Skill skill;//技能
    public short skillLevel;//技能等级


    public ISkillEffectDo SkillEffectDo;//技能效果执行器

    public DPActor_Base Actor = null;//演员
    public DieEffect dieEffect;//死亡效果
    public bool IsGrazes;//是否是被擦伤的
    public abstract void Update(float lostTime);

    public abstract bool Valid { get; }
}
