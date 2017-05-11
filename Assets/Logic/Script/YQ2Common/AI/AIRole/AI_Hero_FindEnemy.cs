using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public partial class AI_Hero  
{


    /// <summary>
    /// 关键位置寻敌
    /// </summary>
    public void FindEnemyK()
    {
        //距离 - 武将找武将的优先距离 – 武将同行优先距离
        var tonghang = SData_FightKeyValue.Single.GetHeroTonghangByType(Data.Type);//同行优先距离

        float HeroToHeroDis = SData_FightKeyValue.Single.HeroToHeroDis;//武将找武将的优先距离

        float minDis = 10000000f;
        AI_FightUnit minObj = null;
        var Battlefield = OwnerBattlefield;

        float WorldX = ownerGrid.WorldX;
        float WorldZ = ownerGrid.WorldZ;

        //优先从策划表找
        {
            var it = Battlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查关键单位
                _FindEnemyK(asquare.FindEnemyKeyUnits, WorldX, WorldZ, tonghang, HeroToHeroDis, ref   minDis, ref   minObj);
            }
        }

        //从程序计算的关键单位找
        if (minObj == null)
        {
            var it = Battlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查关键单位
                _FindEnemyK(asquare.ChargeKeyUnits, WorldX, WorldZ, tonghang, HeroToHeroDis, ref   minDis, ref   minObj);
            }
        }

        if (minObj != null) { Enemy = minObj; }
    }

    void _FindEnemyK(HashSet<AI_FightUnit> units, float WorldX, float WorldZ, float tonghang, float HeroToHeroDis, ref float minDis, ref AI_FightUnit minObj)
    {
        //检查关键单位
        foreach (var currUnit in units)
        {
            if (currUnit.IsDie) continue;

            var grid = currUnit.ownerGrid;
            var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);

            var zhdis = distance;//综合距离

            if (currUnit.UnitType == UnitType.Hero) zhdis -= HeroToHeroDis;//武将打武将优先

            if (grid.GredZ == ownerGrid.GredZ) zhdis -= tonghang;
            if (zhdis < minDis) { minDis = zhdis; minObj = currUnit; }
        }
    }


    /// <summary>
    /// 精准寻敌
    /// </summary>
    public override AI_FightUnit FindEnemy(bool findSoldiers)
    {
        if (IsEnemyValid) return Enemy;//已经拥有有效的敌人
        if (m_HitMeEnemy != null && !m_HitMeEnemy.IsDie)
        {
            var bk = m_HitMeEnemy;
            m_HitMeEnemy = null;
            return bk;//选择反击对象
        }

        //距离 - 武将找武将的优先距离 – 武将同行优先距离
        var tonghang = SData_FightKeyValue.Single.GetHeroTonghangByType(
            HeroType.Meng//自身类型
            );//同行优先距离

        float HeroToHeroDis = SData_FightKeyValue.Single.HeroToHeroDis;//武将找武将的优先距离

        float WorldX = ownerGrid.WorldX;
        float WorldZ = ownerGrid.WorldZ;

        float minDis = 10000000f;
        AI_FightUnit minObj = null;
        var Battlefield = OwnerBattlefield;
        var it = Battlefield.ArmySquareListEnumerator;

        if (IsMelee)
        { 
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查士兵
                if (findSoldiers)
                    foreach (var currUnit in asquare.soldiers)
                    {
                        if (currUnit.IsDie) continue;

                        var grid = currUnit.ownerGrid;
                        var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);

                        var zhdis = distance;//综合距离
                        if (grid.GredZ == ownerGrid.GredZ) zhdis -= tonghang;
                        if (zhdis < minDis) { minDis = zhdis; minObj = currUnit; }
                    }

                //检查英雄
                if (!asquare.hero.IsDie)
                {
                    var grid = asquare.hero.ownerGrid;
                    var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);
                    var zhdis = distance - HeroToHeroDis;//综合距离
                    if (grid.GredZ == ownerGrid.GredZ) zhdis -= tonghang;
                    if (zhdis < minDis) { minDis = zhdis; minObj = asquare.hero; }
                }
            }
            return minObj;
        }else //远战寻敌
        {
            var atkRange = Data.AtkRange; 
          
            bool WithinShot = false;
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查士兵
                if (findSoldiers)
                    foreach (var currUnit in asquare.soldiers)
                    {
                        if (currUnit.IsDie) continue;

                        var grid = currUnit.ownerGrid;
                        var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);

                        var zhdis = distance;//综合距离
                        if (grid.GredZ == ownerGrid.GredZ) zhdis -= tonghang;

                        if (!WithinShot)//在找到射程范围内目标之前
                        {
                            if (zhdis < minDis) //挑选离我最近的
                            {
                                if (AI_Math.WithinShot(this,currUnit, atkRange))//新的目标在射程范围内
                                    WithinShot = true;

                                minDis = zhdis; minObj = currUnit;
                            }
                        }
                        else
                        {
                            //选择射程范围内最远的
                            if (zhdis > minDis && AI_Math.WithinShot(this, currUnit, atkRange))
                            {
                                minDis = zhdis; minObj = currUnit;
                            }
                        }
                    }

                //检查英雄
                if (!asquare.hero.IsDie)
                {
                    var grid = asquare.hero.ownerGrid;
                    var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);
                    var zhdis = distance - HeroToHeroDis;//综合距离
                    if (grid.GredZ == ownerGrid.GredZ) zhdis -= tonghang;

                    if (!WithinShot)//在找到射程范围内目标之前
                    {
                        if (zhdis < minDis) {
                            if (AI_Math.WithinShot(this, asquare.hero, atkRange))//新的目标在射程范围内 
                                WithinShot = true; 

                            minDis = zhdis; minObj = asquare.hero; 
                        }
                    }else
                    {
                        //选择射程范围内最远的
                        if (zhdis > minDis && AI_Math.WithinShot(this, asquare.hero, atkRange))
                        {
                            minDis = zhdis; minObj = asquare.hero;
                        }
                    }
                }
            }
            return minObj;
        }
    }

}