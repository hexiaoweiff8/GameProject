using System;
using System.Collections.Generic;

/// <summary>
/// 战斗AI工具类 (剥离部分比较独立的功能)
/// </summary>
public class AI_FightUtils {
    public static void DoDieUnitCache(List<AI_FightUnit> DieUnitCache, HashSet<UnitLeaveGridT> m_UnitLeaveGridCache)
    {
        if (DieUnitCache.Count > 0)
        {
            foreach (var unit in DieUnitCache)
            {
                AI_Hero hero = unit as AI_Hero;
                if (hero != null)//是英雄死亡
                {
                    /*
                    foreach (var curr in m_ArmySquareList)
                    {
                        if (curr.hero == hero) { curr.hero = null; break; }
                    } */
                }
                else //士兵
                {
                    AI_Soldiers soldiers = unit as AI_Soldiers;
                    var ownerSquare = soldiers.OwnerArmySquare;
                    ownerSquare.soldiers.Remove(soldiers);

                }

                unit.OwnerArmySquare.ChargeKeyUnits.Remove(unit);
                unit.OwnerArmySquare.FindEnemyKeyUnits.Remove(unit);

                m_UnitLeaveGridCache.Add(new UnitLeaveGridT() { unit = unit });
            }
            DieUnitCache.Clear();
        }
    }


    public static void DoFindEnemyCache(List<AI_FightUnit> FindEnemyCache)
    {
        if (FindEnemyCache.Count > 0)
        {
            int count = Math.Min(FindEnemyCache.Count, 10);
            for (int i = 0; i < count; i++)
            {
                var unit = FindEnemyCache[0];
                unit.Enemy = unit.FindEnemy(true);
                FindEnemyCache.RemoveAt(0);
                unit.IsInFindEnemyQueue = false;
            }
        }
    }

    public static void ClearNoOwnerSoldiers(List<AI_ArmySquare> square)
    {
        foreach (var curr in square)
        {
            HashSet<AI_Soldiers> newList = new HashSet<AI_Soldiers>();
            foreach (var curr1 in curr.soldiers)
            {
                if (curr1.ownerGrid == null)
                {
                    curr.ChargeKeyUnits.Remove(curr1);
                    curr.FindEnemyKeyUnits.Remove(curr1);
                }
                else
                    newList.Add(curr1);
            }
            curr.soldiers = newList;
        }
    }

}

//方向
public enum AIDirection
{
    None = -1,//什么也不是
    Up = 0,
    Right = 1,//右
    UpRight = 2,
    LeftUp = 3,
    Left = 4,//左
    DownLeft = 5,
    RightDown = 6,
    Down = 7,
    All = 99,//所有方向
}

public enum ArmyFlag
{
    None,//什么也不是
    Attacker,//进攻者
    Defender,//防御者
    All,//所有
}

public enum FightST
{
    None = 0,
    StartDone = 1,
    Charge = 2,
    FightEnd = 10,//战斗结束,数字大于它的都是结束后的状态   
    FightWin = 12,//战斗胜利
    FightLost = 13,//战斗失败

}

enum CountdownST
{
    Hide,//隐藏中
    Show,//普通显示
    ShowRed,//红色显示
}


public enum AICmdType
{
    SDSkill = 1,
    Charge = 2,
    SetResult = 3,
}
