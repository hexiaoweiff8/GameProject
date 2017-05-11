using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public partial class AI_Soldiers  
{

    /// <summary>
    /// 关键位置寻敌
    /// </summary>
    public void FindEnemyK()
    {
        //距离 - 士兵找士兵的优先距离 – 士兵同行优先距离
        float tonghang = SData_FightKeyValue.Single.GetArmyTonghangByType(Data.Type);//士兵同行优先距离

        float ArmyToArmyDis = SData_FightKeyValue.Single.ArmyToArmyDis;//士兵找士兵的优先距离

        float minDis = 10000000f;
        AI_FightUnit minObj = null;
        var Battlefield = OwnerBattlefield;

        float WorldX = ownerGrid.WorldX;
        float WorldZ = ownerGrid.WorldZ;

        //在策划填写的关键单位中找
        {
            var it = Battlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查关键单位
                _FindEnemyK(asquare.FindEnemyKeyUnits, WorldX, WorldZ, ArmyToArmyDis, tonghang,
                   ref   minDis,
                   ref   minObj
                );
            }
        }

        //在程序计算的关键单位中找
        if (minObj==null)
        {
            var it = Battlefield.ArmySquareListEnumerator;
            while (it.MoveNext())
            {
                var asquare = it.Current;
                if (asquare.flag == OwnerArmySquare.flag) continue;//同阵营的跳过

                //检查关键单位
                _FindEnemyK(asquare.ChargeKeyUnits, WorldX, WorldZ, ArmyToArmyDis, tonghang,
                   ref   minDis,
                   ref   minObj
                );
            }
        }

        if (minObj != null) { Enemy = minObj; }
    }

    void _FindEnemyK(HashSet<AI_FightUnit> units, float WorldX, float WorldZ, float ArmyToArmyDis, float tonghang,
        ref float minDis,
        ref AI_FightUnit minObj
        )
    {
        //检查关键单位
        foreach (var currUnit in units)
        {
            if (currUnit.IsDie) continue;
            var grid = currUnit.ownerGrid;
            var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);

            var zhdis = distance;//综合距离

            if (currUnit.UnitType == UnitType.Soldiers) zhdis -= ArmyToArmyDis;//士兵打士兵优先
            if (currUnit.ownerGrid.GredZ == ownerGrid.GredZ)
                zhdis -= tonghang;//同行优先

            if (zhdis < minDis) { minDis = zhdis; minObj = currUnit; }
        }
    }

    /// <summary>
    /// 精准寻敌
    /// </summary>
    public override AI_FightUnit FindEnemy(bool findSoldiers)
    {
        if (IsEnemyValid) return Enemy;//已经拥有有效的敌人

        //距离 - 士兵找士兵的优先距离 – 士兵同行优先距离
        var tonghang = SData_FightKeyValue.Single.GetArmyTonghangByType(
            SoldierType.Dao//自身类型
            );//士兵同行优先距离

        float ArmyToArmyDis = SData_FightKeyValue.Single.ArmyToArmyDis;//士兵找士兵的优先距离

        float minDis = 10000000f;
        AI_FightUnit minObj = null;
        var Battlefield = OwnerBattlefield;
        var it = Battlefield.ArmySquareListEnumerator;
        float WorldX = ownerGrid.WorldX;
        float WorldZ = ownerGrid.WorldZ;

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

                        var zhdis = distance - ArmyToArmyDis;//综合距离
                        if (currUnit.ownerGrid.GredZ == ownerGrid.GredZ)
                            zhdis -= tonghang;//同行优先

                        if (zhdis < minDis) { minDis = zhdis; minObj = currUnit; }
                    }

                //检查英雄
                if (!asquare.hero.IsDie)
                {
                    var grid = asquare.hero.ownerGrid;
                    var distance = AI_Math.V2Distance(WorldX, WorldZ, grid.WorldX, grid.GredZ);
                    var zhdis = distance;//综合距离 
                    if (grid.GredZ == ownerGrid.GredZ)
                        zhdis -= tonghang;//同行优先

                    if (zhdis < minDis) { minDis = zhdis; minObj = asquare.hero; }
                }
            }
             
            return minObj;
        }else
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

                        var zhdis = distance - ArmyToArmyDis;//综合距离
                        if (currUnit.ownerGrid.GredZ == ownerGrid.GredZ)
                            zhdis -= tonghang;//同行优先

                        if (!WithinShot)//在找到射程范围内目标之前
                        {
                            if (AI_Math.WithinShot(this,currUnit, atkRange))//新的目标在射程范围内
                                WithinShot = true;

                            if (zhdis < minDis) { minDis = zhdis; minObj = currUnit; }
                        }
                        else
                        {
                            //选择射程范围内最远的
                            if (zhdis > minDis && AI_Math.WithinShot(this,currUnit, atkRange))
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
                    var zhdis = distance;//综合距离 
                    if (grid.GredZ == ownerGrid.GredZ)
                        zhdis -= tonghang;//同行优先

                    if (!WithinShot)//在找到射程范围内目标之前
                    {
                        if (AI_Math.WithinShot(this,asquare.hero, atkRange))//新的目标在射程范围内 
                            WithinShot = true; 

                        if (zhdis < minDis) { minDis = zhdis; minObj = asquare.hero; }
                    }else
                    {
                        //选择射程范围内最远的
                        if (zhdis > minDis && AI_Math.WithinShot(this,asquare.hero, atkRange))
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
