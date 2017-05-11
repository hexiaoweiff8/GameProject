using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
/// <summary>
/// 战斗结束判断 
/// </summary>
public class FightEndAdjust {

    public static void FightEnd(float TotalLostTime, List<AI_ArmySquare> m_ArmySquareList, DP_TimeLine DPTimeLine, FightST m_FightST)
    {
        var time = TotalLostTime;

        //剪裁所有武将关键帧
        foreach (var currSquare in m_ArmySquareList)
        {

            if (!currSquare.hero.IsDie)
                currSquare.hero.Shape.RH.CutKyes(time);

            if (!currSquare.IsDie)
                currSquare.OverheadPanel.CutKyes(time);
        }

        //清除出生点在当前时间点之后的所有演员
        DPTimeLine.Cut(time);

        var ZhanhouAudioFxObj = SData_FightKeyValue.Single.ZhanhouAudioFxObj;
        if (m_FightST == FightST.FightWin)
        {
            foreach (var currSquare in m_ArmySquareList)
            {
                if (currSquare.flag == ArmyFlag.Attacker)
                {
                    //进攻方全军播放欢呼
                    if (!currSquare.hero.IsDie)
                    {
                        currSquare.hero.Shape.RH.AddKey_PlayAct(time, "wait", false, 0, 0, -1);

                        AI_CreateFX.CreateFX(time, ZhanhouAudioFxObj, currSquare.hero, 1, 0);
                    }

                    int i = 0;
                    foreach (var currSoldiers in currSquare.soldiers)
                    {
                        if (!currSoldiers.IsDie)
                        {
                            currSoldiers.Shape.RH.AddKey_PlayAct(time, "wait", true, 0, 0, -1);

                            if (i++ % 50 == 0) AI_CreateFX.CreateFX(time, ZhanhouAudioFxObj, currSoldiers, 1, 0);
                        }
                    }

                }
                else
                {
                    //防御方全军逃跑
                    if (!currSquare.hero.IsDie)
                        currSquare.hero.DoEscape(null, time);

                    foreach (var currSoldiers in currSquare.soldiers)
                    {
                        if (!currSoldiers.IsDie)
                            currSoldiers.DoEscape(null, time);
                    }

                }
            }
        }
        else
        {
            foreach (var currSquare in m_ArmySquareList)
            {
                if (currSquare.flag ==ArmyFlag.Attacker)
                {
                    //进攻方全军逃跑
                    if (!currSquare.hero.IsDie)
                        currSquare.hero.DoEscape(null, time);


                    foreach (var currSoldiers in currSquare.soldiers)
                    {
                        if (!currSoldiers.IsDie)
                            currSoldiers.DoEscape(null, time);
                    }
                }
                else
                {
                    //防御方全军播放欢呼 
                    if (!currSquare.hero.IsDie)
                    {
                        currSquare.hero.Shape.RH.AddKey_PlayAct(time, "wait", false, 0, 0, -1);
                        AI_CreateFX.CreateFX(time, ZhanhouAudioFxObj, currSquare.hero, 1, 0);
                    }

                    int i = 0;
                    foreach (var currSoldiers in currSquare.soldiers)
                    {
                        if (!currSoldiers.IsDie)
                        {
                            currSoldiers.Shape.RH.AddKey_PlayAct(time, "wait", true, 0, 0, -1);
                            if (i++ % 50 == 0) AI_CreateFX.CreateFX(time, ZhanhouAudioFxObj, currSoldiers, 1, 0);
                        }
                    }
                }
            }
        }
    }

    public static FightResult CreateFightResult(FightST m_FightST, float FightLostTime, List<AI_ArmySquare> m_ArmySquareList)
    {
        FightResult re = new FightResult();
        re.IsWin = (m_FightST == FightST.FightWin);
        re.FightTime = Math.Min(SData_FightKeyValue.Single.BattleTime, FightLostTime);

        ArmyFlag winFlag = re.IsWin ? ArmyFlag.Attacker : ArmyFlag.Defender;

        foreach (var square in m_ArmySquareList)
        {
            HeroFightResult reHeroInfo = new HeroFightResult();
            reHeroInfo.fid = square.BaseAttr.fid;
            reHeroInfo.staticDataID = square.BaseAttr.staticHeroID;
            reHeroInfo.HitCount = square.hero.HitCount;
            reHeroInfo.NursedCount = square.hero.NursedCount;
            reHeroInfo.KillSoldiersCount = square.hero.KillSoldiersCount;
            reHeroInfo.currHP = Math.Max(square.hero.CurrHP, 0);

            reHeroInfo.heroLevel = square.BaseAttr.heroLevel;//英雄等级
            reHeroInfo.heroXJ = square.BaseAttr.hxj;//英雄星级
            reHeroInfo.MaxHP = square.hero.FinalMaxHP;//最大血量
            reHeroInfo.AliveSoldiers = winFlag == square.flag ? square.soldiers.Count : 0;


            if (square.flag == ArmyFlag.Attacker)
                re.LeftHeros.Add(reHeroInfo);
            else
                re.RightHeros.Add(reHeroInfo);
        }
        return re;
    }

  
}
