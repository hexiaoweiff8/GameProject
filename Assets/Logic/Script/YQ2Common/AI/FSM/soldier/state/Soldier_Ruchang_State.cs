using UnityEngine;
using System.Collections;
using System;

public class Soldier_Ruchang_State : SoldierFSMState
{

    public override void Init()
    {
        this.StateID = SoldierStateID.RuChang;
    }

    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        var soldier = fsm.Display.RanderControl;

        soldier.bloodBar.localScale = Vector3.one;
        //soldier.ModelRander.speedScale = 1;
        //soldier.GetComponent<Renderer>().material.shader = PacketManage.Single.GetPacket("core").Load("Avatar_N.shader") as Shader;
        //soldier.ModelRander.SetClip("run".GetHashCode());
        //Vector3 pt = soldier.NowWorldCamera.WorldToScreenPoint(soldier.Head.position);
        //Vector3 ff = UICamera.currentCamera.ScreenToWorldPoint(pt);
        //soldier.bloodBar.position = ff;
        //AstarFight at = GameObject.Find("/AstarFight").GetComponent<AstarFight>();
        //at.toXunLu(fsm.Display.ClusterData as ClusterData, soldier.isEnemy, fsm.Display);
        // 设置单位可被选择
        fsm.Display.ClusterData.CouldSelect = true;
        //Debug.Log("士兵入场, armyID:" + fsm.Display.ClusterData.AllData.MemberData.ArmyID);
        float deployTime = 0f;

        var objId = fsm.Display.ClusterData.AllData.MemberData.ObjID;

        switch (objId.ObjType)
        {
            case ObjectID.ObjectType.EnemySoldier:
            case ObjectID.ObjectType.EnemyTank:
                deployTime = DataManager.Single.GetEnemySoldier(objId.ID).DeployTime;
                break;

            case ObjectID.ObjectType.MySoldier:
            case ObjectID.ObjectType.MyTank:
                deployTime = 1;//DataManager.Single.GetMySoldier(objId.ID).DeployTime;
                break;
        }

        // 抛出入场事件
        SkillManager.Single.SetTriggerData(new TriggerData()
        {
            ReleaseMember = fsm.Display,
            ReceiveMember = fsm.Display,
            TypeLevel1 = TriggerLevel1.Fight,
            TypeLevel2 = TriggerLevel2.Enter
        });

        CoroutineManage.Single.StartCoroutine(_waitFor(deployTime, () =>
        {
            if (fsm.Display != null && fsm.Display.ClusterData != null)
            {
                fsm.IsCanRun = true;
                // 统计战斗数据
                FightDataStatistical.Single.AddCostData(fsm.Display.ClusterData.AllData.ArmyTypeData);

                // 抛出入场结束事件
                SkillManager.Single.SetTriggerData(new TriggerData()
                {
                    ReleaseMember = fsm.Display,
                    ReceiveMember = fsm.Display,
                    TypeLevel1 = TriggerLevel1.Fight,
                    TypeLevel2 = TriggerLevel2.EnterEnd
                });
            }
        }));
    }

    public override void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        fsm.IsCanRun = false;
    }

    public override void Action(SoldierFSMSystem fsm)
    {

    }
    /// <summary>
    /// 战斗单位进入场景以后有一秒钟的等待时间
    /// </summary>
    /// <returns></returns>
    private IEnumerator _waitFor(float DeployTime, Action waitEnd)
    {
        yield return new WaitForSeconds(DeployTime);

        waitEnd();
    }
}