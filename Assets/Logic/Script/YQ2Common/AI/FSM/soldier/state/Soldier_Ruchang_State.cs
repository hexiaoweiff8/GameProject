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
        soldier.ModelRander.speedScale = 1;
        soldier.GetComponent<Renderer>().material.shader = PacketManage.Single.GetPacket("core").Load("Avatar_N.shader") as Shader;
        soldier.ModelRander.SetClip("run".GetHashCode());
        Vector3 pt = soldier.NowWorldCamera.WorldToScreenPoint(soldier.Head.position);
        Vector3 ff = UICamera.currentCamera.ScreenToWorldPoint(pt);
        soldier.bloodBar.position = ff;
        AstarFight at = GameObject.Find("/AstarFight").GetComponent<AstarFight>();
        at.toXunLu(fsm.Display.ClusterData as ClusterData, soldier.isEnemy, soldier.groupIndex, fsm.Display);
        Debug.Log("士兵入场, armyID:" + fsm.Display.ClusterData.AllData.MemberData.ArmyID);
        float DeployTime = 0f;
        var ObjId = fsm.Display.MFAModelRender.ObjId;
        //if (ObjId.ObjType == ObjectID.ObjectType.EnemySoldier || ObjId.ObjType == ObjectID.ObjectType.EnemyTank)
        //{
        //    DeployTime = DataManager.Single.GetEnemySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
        //}
        //else
        //{
        //    DeployTime = DataManager.Single.GetMySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
        //}
        switch (ObjId.ObjType)
        {
            case ObjectID.ObjectType.EnemySoldier:
            case ObjectID.ObjectType.EnemyTank:
                DeployTime = DataManager.Single.GetEnemySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
                break;

            case ObjectID.ObjectType.MySoldier:
            case ObjectID.ObjectType.MyTank:
                DeployTime = DataManager.Single.GetMySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
                break;
        }


        var alldata = fsm.Display.ClusterData.AllData;
        // 入场检测技能
        if (alldata != null && alldata.SkillInfoList != null)
        {
            SkillManager.Single.CheckAndDoSkillInfo(alldata.SkillInfoList, fsm.Display, fsm.EnemyTarget, SkillTriggerLevel1.Fight, SkillTriggerLevel2.Enter);
        }

        Globals.Instance.StartCoroutine(_waitFor(DeployTime, () =>
        {
            fsm.IsCanRun = true;

            // 入场结束检测技能
            if (alldata != null && alldata.SkillInfoList != null)
            {
                SkillManager.Single.CheckAndDoSkillInfo(alldata.SkillInfoList, fsm.Display, fsm.EnemyTarget, SkillTriggerLevel1.Fight, SkillTriggerLevel2.EnterEnd);
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