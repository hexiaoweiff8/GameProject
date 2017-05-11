﻿using UnityEngine;
using System.Collections;
using System;
/// <summary>
/// 士兵的行军状态 在行军中主要执行的是寻路和寻敌等操作
/// </summary>
public class Soldier_Xingjin_State : SoldierFSMState
{
    public override void Init()
    {
        StateID = SoldierStateID.Xingjin;
    }
    /// <summary>
    /// 初始化血条和寻路 士兵开始行走
    /// </summary>
    /// <param name="fsm"></param>
    public override void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        var soldier = fsm.Display.RanderControl;

        soldier.BloodBar.localScale = Vector3.one;
        soldier.ModelRander.speedScale = 1;


        soldier.GetComponent<Renderer>().material.shader = PacketManage.Single.GetPacket("core").Load("Avatar_N.shader") as Shader;
        soldier.ModelRander.SetClip("run".GetHashCode());
        AstarFight at = GameObject.Find("/AstarFight").GetComponent<AstarFight>();

        at.toXunLu(fsm.Display.ClusterData, soldier.isEnemy, soldier.groupIndex, fsm.Display);

        Vector3 pt = soldier.NowWorldCamera.WorldToScreenPoint(soldier.Head.position);
        Vector3 ff = UICamera.currentCamera.ScreenToWorldPoint(pt);
        soldier.BloodBar.position = ff;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        
    }

}
