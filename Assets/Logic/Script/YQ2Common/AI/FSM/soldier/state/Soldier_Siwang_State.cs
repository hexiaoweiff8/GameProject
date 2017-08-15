using UnityEngine;
using System.Collections;
using System;
using Object = UnityEngine.Object;

public class Soldier_Siwang_State : SoldierFSMState
{
    public override void Init()
    {
        this.StateID = SoldierStateID.SiWang;
    }
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        base.DoBeforeEntering(fsm);

        // 释放死亡时技能
        var allData = fsm.Display.ClusterData.AllData;

        // 判断死亡单位类型
        switch (allData.MemberData.ArmyType)
        {
            // 人族
            case Utils.HumanArmyType:
            // 兽族
            case Utils.OrcArmyType:
            // 机械
            case Utils.MechanicArmyType:

                break;

            // 基地
            case Utils.BaseArmyType:
            {
                // 一方胜利
                Debug.Log("一方基地被摧毁,战斗结束.");
            }
                break;
            // 防御塔
            case Utils.TurretArmyType:
            {
                Debug.Log("一方防御塔被摧毁,可拖兵范围变更.");
            }
                break;
        }

        // 死亡时检测技能
        if (allData.SkillInfoList != null)
        {
            // 抛出死亡事件
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                ReleaseMember = fsm.Display,
                ReceiveMember = fsm.Display,
                TypeLevel1 = TriggerLevel1.Fight,
                TypeLevel2 = TriggerLevel2.Death
            });
        }
        // 统计死亡数量
        FightDataStatistical.Single.AddBeKillCount("" + allData.MemberData.ObjID.ID, 1, allData.MemberData.Camp, allData.MemberData.ArmyType, allData.MemberData.GeneralType);
        // 清除费用统计
        FightDataStatistical.Single.DelCostData(allData.ArmyTypeData);
        // 删除单位
        //DisplayerManager.Single.DelDisplay(fsm.Display);
        FightUnitFactory.DeleteUnit(fsm.Display.ClusterData.AllData.MemberData);
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        //throw new NotImplementedException();
    }
}