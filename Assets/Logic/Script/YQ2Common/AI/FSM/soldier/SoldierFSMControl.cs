using System;
using UnityEngine;
using System.Collections;
using System.Linq;

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

    public void StartFSM(DisplayOwner obj)
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
        // 结算技能伤害
        SettlementDamage(TriggerData.TriggerDataTypeSkill);
        // 结算buff伤害
        SettlementDamage(TriggerData.TriggerDataTypeBuff);
        // 检测被触发的Skill事件是否有对应技能
        CheckTrigger(TriggerData.TriggerDataTypeSkill);
        // 检测被触发的Buff事件是否有对应技能
        CheckTrigger(TriggerData.TriggerDataTypeBuff);
    }

    /// <summary>
    /// 检测当前单位的触发事件
    /// </summary>
    private void CheckTrigger(int triggerType)
    {
        var alldata = fsm.Display.ClusterData.AllData;
        if (alldata.MemberData != null && alldata.SkillInfoList != null)
        {
            // 触发当前单位的所有事件
            SkillManager.Single.SetEachAction(alldata.MemberData.ObjID, (type1, type2, trigger) =>
            {
                SkillManager.Single.CheckAndDoSkillInfo(alldata.SkillInfoList, trigger.ReleaseMember,
                    trigger.ReceiveMember,
                    type1, type2);
            },
            true,
            triggerType);
        }
    }

    /// <summary>
    /// 结算当前单位的血量
    /// </summary>
    private void SettlementDamage(int triggerType)
    {
        var alldata = fsm.Display.ClusterData.AllData;
        if (alldata.MemberData != null && alldata.SkillInfoList != null)
        {
            var healthChangeValue = 0f;
            // 获取被击列表
            var attackList = SkillManager.Single.GetSkillTriggerDataList(alldata.MemberData.ObjID, TriggerLevel1.Fight, TriggerLevel2.BeAttack, triggerType);
            // 检测是否被击
            if (attackList != null && attackList.Count > 0)
            {
                // 计算血量变动总和
                healthChangeValue += attackList.Sum(attackMember => attackMember.HealthChangeValue);

                // 如果单位死亡在抛出一个死亡事件
                // 检测致死攻击
                if (alldata.MemberData.CurrentHP - healthChangeValue < Utils.ApproachZero)
                {
                    // 检测最后一个
                    var lastHitMember = attackList[attackList.Count - 1];
                    // 抛出致死攻击事件
                    SkillManager.Single.SetTriggerData(new TriggerData()
                    {
                        HealthChangeValue = lastHitMember.HealthChangeValue,
                        ReceiveMember = lastHitMember.ReceiveMember,
                        ReleaseMember = lastHitMember.ReleaseMember,
                        TypeLevel1 = TriggerLevel1.Fight,
                        TypeLevel2 = TriggerLevel2.FatalHit
                    });
                }

                // 结算血量变动
                fsm.Display.ClusterData.AllData.MemberData.CurrentHP -= healthChangeValue;
                // 刷新血条
                fsm.Display.RanderControl.SetBloodBarValue();
            }

        }
    }


}
