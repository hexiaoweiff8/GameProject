using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using JetBrains.Annotations;
using System.Reflection;

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

        // 初始化行为状态机
        InitState(obj.ClusterData.AllData.MemberData.BehaviorType);
    }

    public void UpdateFSM() //作为驱动源
    {
        if (_iSAwake) return;
        fsm.CurrentState.CheckTrigger(fsm);
        fsm.CurrentState.Action(fsm);
    }

    public void Destory()
    {
        fsm.Destory();
    }

    /// <summary>
    /// 初始化行为状态机
    /// </summary>
    /// <param name="behaviorType"></param>
    public void InitState(int behaviorType)
    {
        SetStateMappingConfig(SoldierFSMFactory.GetBehaviorMappingDicById(behaviorType), 
            SoldierFSMFactory.GetTriggerFuncDicById(behaviorType));
    }


    /// <summary>
    /// 设置切换映射关系
    /// </summary>
    /// <param name="mapDic">切换关系列表</param>
    /// <param name="triggerFuncDic">节点具体行为列表</param>
    public void SetStateMappingConfig(Dictionary<SoldierStateID, List<SoldierStateID>> mapDic, Dictionary<SoldierTriggerID, Func<SoldierFSMSystem, bool>> triggerFuncDic)
    {
        if (mapDic == null)
        {
            return;
        }

        foreach (var kv in mapDic)
        {
            var keyType = SoldierFSMFactory.GetStateTypeByStateId(kv.Key);
            var keyStateInvoke = (SoldierFSMState)keyType.InvokeMember("", BindingFlags.Public | BindingFlags.CreateInstance,
                null, null, null);

            foreach (var mapStateId in kv.Value)
            {
                // 设置映射关系
                keyStateInvoke.AddMappingTrigger(SoldierFSMFactory.GetTriggerByStateId(mapStateId), triggerFuncDic[SoldierFSMFactory.GetTriggerByStateId(mapStateId)]);
            }
            // 添加状态
            fsm.AddState(keyStateInvoke);
        }
    }

    /// <summary>
    /// 停止攻击当前目标
    /// </summary>
    public void CleanTarget()
    {
        // 终止普通攻击目标
        if (fsm.CurrentStateID == SoldierStateID.PutongGongji)
        {
            fsm.CurrentState.DoBeforeLeaving(fsm);
        }
        // 终止技能攻击目标

    }

    ///// <summary>
    ///// 修改该单位的当前状态
    ///// </summary>
    //public void SetState(SoldierFSMSystem targetFsm)
    //{
    //    // 设置状态数据
    //    fsm = targetFsm;
    //    // 切到目标状态

    //}

}