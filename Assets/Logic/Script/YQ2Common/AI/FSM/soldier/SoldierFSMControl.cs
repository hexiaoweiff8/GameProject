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
        // 结算伤害
        SettlementDamage();
        // 检测被触发的事件是否有对应技能
        CheckTrigger();
    }

    /// <summary>
    /// 检测当前单位的触发事件
    /// </summary>
    private void CheckTrigger()
    {
        var fightVo = fsm.Display.ClusterData.MemberData as FightVO;
        if (fightVo != null && fightVo.SkillInfoList != null)
        {
            // 触发当前单位的所有事件
            SkillManager.Single.SetEachAction(fightVo.ObjID, (type1, type2, trigger) =>
            {
                SkillManager.Single.CheckAndDoSkillInfo(fightVo.SkillInfoList, trigger.ReleaseMember,
                    trigger.ReceiveMember,
                    type1, type2);
            }, true);
        }
    }

    /// <summary>
    /// 结算当前单位的血量
    /// </summary>
    private void SettlementDamage()
    {
        var fightVO = fsm.Display.ClusterData.MemberData as FightVO;
        if (fightVO != null && fightVO.SkillInfoList != null)
        {
            var healthChangeValue = 0f;
            // 获取被击列表
            var attackList = SkillManager.Single.GetSkillTriggerDataList(fightVO.ObjID, SkillTriggerLevel1.Fight, SkillTriggerLevel2.BeAttack);
            // 检测是否被击
            if (attackList != null && attackList.Count > 0)
            {
                // 计算血量变动总和
                healthChangeValue += attackList.Sum(attackMember => attackMember.HealthChangeValue);

                // 如果单位死亡在抛出一个死亡事件
                // 检测致死攻击
                if (fightVO.CurrentHP - healthChangeValue < Utils.ApproachZero)
                {
                    // 检测最后一个
                    var lastHitMember = attackList[attackList.Count - 1];
                    // 抛出致死攻击事件
                    SkillManager.Single.SetSkillTriggerData(new SkillTriggerData()
                    {
                        HealthChangeValue = lastHitMember.HealthChangeValue,
                        ReceiveMember = lastHitMember.ReceiveMember,
                        ReleaseMember = lastHitMember.ReleaseMember,
                        TypeLevel1 = SkillTriggerLevel1.Fight,
                        TypeLevel2 = SkillTriggerLevel2.FatalHit
                    });
                }

                // 结算血量变动
                fsm.Display.ClusterData.MemberData.CurrentHP -= healthChangeValue;
                // 刷新血条
                fsm.Display.RanderControl.SetBloodBarValue();
            }

        }
    }


}
