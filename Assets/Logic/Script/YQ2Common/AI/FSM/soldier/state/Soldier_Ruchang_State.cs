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
        at.toXunLu(fsm.Display.ClusterData, soldier.isEnemy, soldier.groupIndex, fsm.Display);

        float DeployTime;
        var ObjId = fsm.Display.MFAModelRender.ObjId;
        if (ObjId.ObjType == ObjectID.ObjectType.EnemySoldier || ObjId.ObjType == ObjectID.ObjectType.EnemyTank)
        {
            DeployTime = DataManager.Single.GetEnemySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
        }
        else
        {
            DeployTime = DataManager.Single.GetMySoldier(fsm.Display.MFAModelRender.ObjId.ID).DeployTime;
        }

        Globals.Instance.StartCoroutine(_waitFor(DeployTime, () =>
        {
            fsm.IsCanRun = true;
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