using System;
using UnityEngine;
using System.Collections;
using System.Linq;
using JetBrains.Annotations;

public class SoldierFSMControl{

    private SoldierFSMSystem fsm;//内置一个fsm

    /// <summary>
    /// 标记状态机是否唤醒的 如果宿主在对象池中需要把它置为休眠
    /// </summary>
    private bool _iSAwake = false;

    /// <summary>
    /// 进入休眠状态
    /// </summary>
    public void Sleep()
    {
        _iSAwake = true;
    }

    /// <summary>
    /// 重新唤醒状态机 一般用在从对象池中pop出宿主的时候
    /// </summary>
    public void Awaken()
    {
        _iSAwake = false;
    }

    public void StartFSM([NotNull]DisplayOwner obj)
    {
        //初始化状态机
        fsm = new SoldierFSMSystem();
        fsm.Display = obj;

        ConfigureState();
    }

    /// <summary>
    /// 配置状态 持续扩展
    /// </summary>
    private void ConfigureState()
    {
        Soldier_Ruchang_State ruchang = new Soldier_Ruchang_State();
        ruchang.AddTrigger(SoldierTriggerID.RuChang, SoldierStateID.RuChang);
        fsm.AddState(ruchang);

        Soldier_Daiji_State daiji = new Soldier_Daiji_State();
        daiji.AddTrigger(SoldierTriggerID.DaiJi, SoldierStateID.DaiJi);
        fsm.AddState(daiji);

        Soldier_Xingjin_State xingjin = new Soldier_Xingjin_State();
        xingjin.AddTrigger(SoldierTriggerID.Xingjin, SoldierStateID.Xingjin);
        fsm.AddState(xingjin);

        Soldier_Zhunbeizhandou_State zhunbeizhandou = new Soldier_Zhunbeizhandou_State();
        zhunbeizhandou.AddTrigger(SoldierTriggerID.Zhunbeizhandou, SoldierStateID.Zhunbeizhandou);
        fsm.AddState(zhunbeizhandou);

        Soldier_PutongGongji_State putong = new Soldier_PutongGongji_State();
        putong.AddTrigger(SoldierTriggerID.PutongGongji, SoldierStateID.PutongGongji);
        fsm.AddState(putong);

        Soldier_JinengGongji_State jineng = new Soldier_JinengGongji_State();
        jineng.AddTrigger(SoldierTriggerID.JinengGongji, SoldierStateID.JinengGongji);
        fsm.AddState(jineng);

        Soldier_Siwang_State siwang = new Soldier_Siwang_State();
        siwang.AddTrigger(SoldierTriggerID.SiWang, SoldierStateID.SiWang);
        fsm.AddState(siwang);

        Soldier_Zhuiji_State zhuiji = new Soldier_Zhuiji_State();
        zhuiji.AddTrigger(SoldierTriggerID.ZhuiJi, SoldierStateID.ZhuiJi);
        fsm.AddState(zhuiji);
    }

    public void Destory()
    {
        fsm.Destory();
    }

    public void UpdateFSM() //作为驱动源
    {
        if (_iSAwake) return;
        fsm.CurrentState.CheckTrigger(fsm);
        fsm.CurrentState.Action(fsm);
        // 检测被触发的Skill事件是否有对应技能
        //TriggerAction();
        //// 设置血条
        //fsm.Display.RanderControl.SetBloodBarValue(fsm.Display.ClusterData.AllData.MemberData);
        Debug.Log("当前状态:" + fsm.CurrentStateID);
    }

    /// <summary>
    /// 修改该单位的当前状态
    /// </summary>
    public void SetState(SoldierFSMSystem targetFsm)
    {
        // 设置状态数据
        fsm = targetFsm;
    }

}