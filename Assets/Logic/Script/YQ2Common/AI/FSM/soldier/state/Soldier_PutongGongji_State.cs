﻿using UnityEngine;
using System.Collections;

public class Soldier_PutongGongji_State : SoldierFSMState {
    public override void Init()
    {
        StateID = SoldierStateID.PutongGongji;
    }

    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        Vector3 dir = fsm.EnemyTarget.ClusterData.Position - fsm.Display.ClusterData.Position;
        dir = dir.normalized;

        var bullet = GameObject.CreatePrimitive(PrimitiveType.Cube);
        bullet.transform.localScale = new Vector3(10, 10, 10);
        // Effect层
        bullet.layer = 12;

        var ballistic = BallisticFactory.Single.CreateBallistic(bullet, fsm.Display.ClusterData.Position, dir,
                        fsm.EnemyTarget.ClusterData.Position,
                        10f, 3,trajectoryType: TrajectoryAlgorithmType.Line);


        ballistic.Complete = (a, b) =>
        {
            GameObject.Destroy(a.gameObject);
            Debug.Log("进入结算---------------------------------------------------------------------"+ fsm.Display.ClusterData.Position+"-------"+ fsm.EnemyTarget.ClusterData.Position);
        };
    }

    public override void Action(SoldierFSMSystem fsm)
    {
    }
}
