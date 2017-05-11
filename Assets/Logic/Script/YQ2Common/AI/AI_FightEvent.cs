using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
/// <summary>
/// AI层战斗事件
/// </summary>
public class AI_FightEvent
{
    public delegate void onHeroDie(AI_Hero hero,AI_FightUnit attacker);//武将死亡
    public delegate void onSoldiersDie(AI_Soldiers sb, AI_FightUnit attacker);
    public delegate void onArmyZero(AI_ArmySquare square);//士兵为0
    public delegate void onArmySoldiersFirstLower(AI_ArmySquare square);//士兵数首次小于
    public delegate void onHeroKillHero(AI_Hero attacker,AI_Hero defender);//武将杀死武将
    public delegate void onHeroKillSoldiers(AI_Hero attacker, AI_Soldiers defender);//武将杀死士兵
    public delegate void onLianzhan(AI_FightUnit unit, int lianzhanID, int num);//x连斩,如果数量<1表示此连斩ID失效
    public delegate void onHPFirstGreater(AI_Hero hero);//hp首次高于 ?
    public delegate void onHPFirstLower(AI_Hero hero);//hp首次低于 ?
    public delegate void onHeroLostHP(AI_Hero hero, int num);//武将受到伤害
    public delegate void onHeroHitFirst(AI_Hero hero);//英雄首次造成伤害
    public delegate void onYun(AI_Hero hero);//晕
    public delegate void onBattlefieldStart();//战斗开始


    public delegate void onYinchangInterrupt(AI_Hero hero);//吟唱被打断
    public delegate void onBishaRelease(AI_Hero hero, Skill skill);//必杀释放成功
    public delegate void onShoudongRelease(AI_Hero hero, Skill skill);//手动释放成功
    public delegate void onTexingRelease(AI_Hero hero, Skill skill);//特性释放成功
    public delegate void onGeneralRelease(AI_Hero hero, Skill skill);//普通释放成功

    public delegate void onPowerFull(AI_Hero hero);//能量满

    public delegate void onSquareKill(AI_ArmySquare attacker, AI_FightUnit defender);//阵杀敌


    public event onYinchangInterrupt OnYinchangInterrupt;//吟唱被打断
    public event  onBishaRelease OnBishaRelease;//必杀释放成功
    public event  onShoudongRelease OnShoudongRelease;//手动释放成功
    public event  onTexingRelease OnTexingRelease;//特性释放成功
    public event onGeneralRelease OnGeneralRelease;//普通技能释放成功

    public event onYun OnYun;//晕
    public event onHeroLostHP OnHeroLostHP;
    public event onHeroHitFirst OnHeroHitFirst;
    public event onHeroDie OnHeroDie;
    public event onSoldiersDie OnSoldiersDie;
    public event onPowerFull OnPowerFull;
    public event onArmyZero OnArmyZero;
    public event onArmySoldiersFirstLower OnArmySoldiersFirstLower;
    public event onHeroKillHero OnHeroKillHero;
    public event onHeroKillSoldiers OnHeroKillSoldiers;
    //public event onHPFirstGreater OnHPFirstGreater;
    public event onHPFirstLower OnHPFirstLower;
    public event onLianzhan OnLianzhan;
    public event onBattlefieldStart OnBattlefieldStart;
    public event onSquareKill OnSquareKill;



    public void PostSquareKill(AI_ArmySquare attacker, AI_FightUnit defender)
    {
        OnSquareKill(attacker,defender);
    }

    public void PostHeroDie(AI_Hero hero, AI_FightUnit attacker)
    {
        OnHeroDie(hero, attacker);
    }

    public void PostSoldiersDie(AI_Soldiers sb,AI_FightUnit attacker)
    {
        OnSoldiersDie(sb, attacker);
    }

    public void PostPowerFull(AI_Hero hero)
    {
        OnPowerFull(hero);
    }

    public void PostBattlefieldStart()
    {
        OnBattlefieldStart();
    }

    public void PostHeroLostHP(AI_Hero hero, int num)
    {
        OnHeroLostHP(hero, num);
    }

    public void PostYun(AI_Hero hero)
    {
        OnYun(hero);
    }

    public void PostHeroHitFirst(AI_Hero hero)
    {
        OnHeroHitFirst(hero);
    }

    public void PostYinchangInterrupt(AI_Hero hero)
    {
        OnYinchangInterrupt(hero);
    }

    public void PostBishaRelease(AI_Hero hero, Skill skill)
    {
        OnBishaRelease(hero, skill);
    }

    public void PostGeneralRelease(AI_Hero hero, Skill skill)
    {
        OnGeneralRelease(hero, skill);
    }



    public void PostShoudongRelease(AI_Hero hero, Skill skill)
    {
        OnShoudongRelease(hero, skill);
    }


    public void PostTexingRelease(AI_Hero hero, Skill skill)
    {
        OnTexingRelease(hero, skill);
    }

    public void PostArmyZero(AI_ArmySquare square)
    {
        OnArmyZero(square);
    }

    public void PostSoldiersFirstLower(AI_ArmySquare square)
    {
        OnArmySoldiersFirstLower(square);
    }

    public void PostLianzhan(AI_FightUnit unit,int lianzhanID,int num)
    {
        OnLianzhan(unit, lianzhanID, num);
    }

        

    public void PostHeroKillHero(AI_Hero attacker, AI_Hero defender)
    {
        OnHeroKillHero(attacker,defender);
    }

    public void PostHeroKillSoldiers(AI_Hero attacker, AI_Soldiers defender)
    {
        OnHeroKillSoldiers(attacker, defender);
    }

    //public void PostHPFirstGreater(AI_Hero hero)   { OnHPFirstGreater(hero); }

    public void PostHPFirstLower(AI_Hero hero)
    {
        OnHPFirstLower(hero);
    }

}
 