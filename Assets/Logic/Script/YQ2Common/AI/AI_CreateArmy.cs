﻿using UnityEngine;
using System.Collections;
using System;

public class AI_CreateArmy {
    public static AI_ArmySquare CreateArmySquare(float time, ArmySquareInfo info, bool IsQixi,
                                                  AI_Battlefield battlefield,
                                                  DiamondGridMap GridMap,
                                                  BehindInfo m_BehindInfo
                                                  )
    {

        UnitsInfo heroUnitsInfo = new UnitsInfo();

        AI_Hero hero = new AI_Hero(info.fid, info.staticHeroID, heroUnitsInfo.indent);

        if (info.flag == ArmyFlag.Attacker)
        {
            hero.dirx = 1;
            hero.dirz = 0;
        }
        else
        {
            hero.dirx = -1;
            hero.dirz = 0;
        }

        AI_ArmySquare armySquare = new AI_ArmySquare(battlefield);
        armySquare.BaseAttr = info;
        armySquare.flag = info.flag;
        armySquare.hero = hero;
        armySquare.ArmyData = hero.Data.Army;
        armySquare.IsQixi = IsQixi;


        armySquare.InitAtrr();
        DiamondGrid ownerGrid;

        bool isYuanjun = false;

            ownerGrid = GridMap.GetGrid(
                AI_Math.CalculateMassifX(heroUnitsInfo.x, heroUnitsInfo.z, info.flag, heroUnitsInfo.indent) + DiamondGridMap.SideSize,
                heroUnitsInfo.z + DiamondGridMap.SideSize
                );

        armySquare.hero.ownerGrid = ownerGrid;
        if (ownerGrid == null)
            throw new Exception(string.Format("格子超出战斗区域 {0},{1}", AI_Math.CalculateMassifX(heroUnitsInfo.x, heroUnitsInfo.z, info.flag, heroUnitsInfo.indent) + DiamondGridMap.SideSize, heroUnitsInfo.z + DiamondGridMap.SideSize));


        //for(int i=0;i<info.sklv.Length;i++) info.sklv[i]=1;
        hero.InitAttrs(armySquare, info.hp);
        //armySquare.hero.SetGridObj(armySquare.hero, true);

        //初始化士兵
        armySquare.SoldiersCount = armySquare.soldiers.Count;//填充初始的士兵总数  

        if (!IsQixi)
        {
            byte LeftBehindX = 255;
            if (info.flag == ArmyFlag.Attacker)
            {

                if (hero.ownerGrid.GredX < LeftBehindX)
                {
                    LeftBehindX = hero.ownerGrid.GredX;
                    m_BehindInfo.LeftBehindX = hero;
                    m_BehindInfo.LeftBehind = armySquare;
                }

                foreach (var curr in armySquare.soldiers)
                {
                    if (curr.ownerGrid.GredX < LeftBehindX)
                    {
                        LeftBehindX = curr.ownerGrid.GredX;
                        m_BehindInfo.LeftBehindX = curr;
                        m_BehindInfo.LeftBehind = armySquare;
                    }
                }
            }
            else
            {
                byte RightBehindX = 0;
                if (hero.ownerGrid.GredX > RightBehindX)
                {
                    RightBehindX = hero.ownerGrid.GredX;
                    m_BehindInfo.RightBehindX = hero;
                    m_BehindInfo.RightBehind = armySquare;
                }
                foreach (var curr in armySquare.soldiers)
                {
                    if (curr.ownerGrid.GredX > RightBehindX)
                    {
                        RightBehindX = curr.ownerGrid.GredX;
                        m_BehindInfo.RightBehindX = curr;
                        m_BehindInfo.RightBehind = armySquare;
                    }
                }
            }
        }
        return armySquare;
    }
  
}
