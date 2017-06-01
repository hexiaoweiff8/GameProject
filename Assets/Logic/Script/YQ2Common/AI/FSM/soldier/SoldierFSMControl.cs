using UnityEngine;
using System.Collections;

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
        CheckBeAttack();
    }

    /// <summary>
    /// 检测被击
    /// </summary>
    private void CheckBeAttack()
    {
        var fightVO = fsm.Display.ClusterData.MemberData as FightVO;
        if (fightVO != null && fightVO.SkillInfoList != null)
        {
            // 检测是否被击
            if (fightVO.BeAttack)
            {
                // 检查并执行列表
                SkillManager.Single.CheckAndDoSkillInfo(fightVO.SkillInfoList, fsm.Display, fsm.EnemyTarget,
                    SkillTriggerLevel1.Fight, SkillTriggerLevel2.BeAttack);
                // 检测致死攻击
                if (fightVO.CurrentHP < Utils.ApproachZero)
                {
                    SkillManager.Single.CheckAndDoSkillInfo(fightVO.SkillInfoList, fsm.Display, fsm.EnemyTarget,
                       SkillTriggerLevel1.Fight, SkillTriggerLevel2.FatalHit);
                }
            }
            fsm.Display.ClusterData.MemberData.BeAttack = false;
        }
    }

}
