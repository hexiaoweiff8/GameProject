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