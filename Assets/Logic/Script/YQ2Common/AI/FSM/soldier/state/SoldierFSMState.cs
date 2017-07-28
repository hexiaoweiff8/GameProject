using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 抽象类，所有状态必须继承它 并在子类中实例化
/// </summary>
public abstract class SoldierFSMState
{

    public SoldierStateID StateID
    {
        get { return _stateId; }
        set { _stateId = value; }
    }

    ///// <summary>
    ///// 来源状态
    ///// </summary>
    //public SoldierStateID SourceStateID { get; set; }


    /// <summary>
    /// 状态ID
    /// </summary>
    protected SoldierStateID _stateId;

    /// <summary>
    /// 本状态是否过期
    /// </summary>
    protected bool _stateIsLose = false;

    /// <summary>
    /// state-trigger对应关系表
    /// </summary>
    private Dictionary<SoldierTriggerID, SoldierStateID> dict = new Dictionary<SoldierTriggerID, SoldierStateID>();

    /// <summary>
    /// 当前状态可切换状态的trigger检测列表
    /// </summary>
    private List<SoldierFSMTrigger> _fsmTrriggerList = new List<SoldierFSMTrigger>();

    /// <summary>
    /// 初始化
    /// </summary>
    public SoldierFSMState()
    {
        Init();
    }

    /// <summary>
    /// 初始化方法
    /// </summary>
    public abstract void Init();

    /// <summary>
    /// 添加状态 转换和状态id必须成对存在 且唯一
    /// </summary>
    /// <param name="trigger"></param>
    /// <param name="id"></param>
    public void AddTrigger(SoldierTriggerID trigger, SoldierStateID id)//增加关联对（转换，状态ID）
    {
        //-----------------------------验证参数的合法性-----------------------------------
        if (dict.ContainsKey(trigger))
        {
            Debug.LogError("SoldierFSMState ERROR: SoldierTriggerID" + id + " 已经存在" + trigger);
            return;
        }
        dict.Add(trigger, id);
        ////通过转换反射出对应的触发器再把触发器添加到触发器列表
        //Type type = Type.GetType(trigger + "Trigger");
        //SoldierFSMTrigger fsmtrigger = Activator.CreateInstance(type) as SoldierFSMTrigger;
        //_fsmTrriggerList.Add(fsmtrigger);
        SoldierFSMFactory.GetTrigger(trigger, _fsmTrriggerList);
    }

    /// <summary>
    /// 删除某个转换 
    /// </summary>
    /// <param name="trigger"></param>
    public void DeleteTrigger(SoldierTriggerID trigger)
    {

        if (dict.ContainsKey(trigger))
        {
            dict.Remove(trigger);
            return;
        }
        Debug.LogError("FSMState ERROR: " + trigger + " 不存在");
    }

    /// <summary>
    ///  根据当前转换获取对应的状态
    /// </summary>
    /// <param name="trigger"></param>
    /// <returns></returns>
    public SoldierStateID GetStateByTrigger(SoldierTriggerID trigger)
    {
        if (dict.ContainsKey(trigger))
        {
            return dict[trigger];
        }
        return SoldierStateID.NullState;
    }

    /// <summary>
    /// 子类中覆写，进入状态前的准备工作
    /// </summary>
    public virtual void DoBeforeEntering(SoldierFSMSystem fsm)
    {
        _stateIsLose = false;
    }

    /// <summary>
    /// 子类中覆写，离开状态之前的处理工作 清理当前状态的过期数据等
    /// </summary>
    public virtual void DoBeforeLeaving(SoldierFSMSystem fsm)
    {
        _stateIsLose = true;
    }

    /// <summary>
    /// 状态的改变发生在这里 
    /// </summary>
    public void CheckTrigger(SoldierFSMSystem fsm)
    {
        for (int i = 0; i < _fsmTrriggerList.Count; i++)
        {
            // TODO 多个Trigger同事触发会保持最后一个的状态
            if (_fsmTrriggerList[i].CheckTrigger(fsm))
            {
                var state = SoldierFSMFactory.GetStateIDByTrigger(_fsmTrriggerList[i].triggerId);
                fsm.ChangeState(state);
                break;
            }
        }
    }
    /// <summary>
    /// 模型切换动作 往往配合状态切换
    /// </summary>
    public void SwitchAnim(SoldierFSMSystem fsm, string aniName,WrapMode mode)
    {
        var myself = fsm.Display.RanderControl;
        myself.PlayAni(aniName, mode);
    }

    /// <summary>
    /// 删除对应id的触发器 
    /// </summary>
    /// <param name="triggerId"></param>
    public void RemoveTrigger(SoldierTriggerID triggerId)
    {
        if (dict.ContainsKey(triggerId))
        {
            dict.Remove(triggerId);
            _fsmTrriggerList.Remove(_fsmTrriggerList.Find((e) => triggerId == e.triggerId));
        }
    }

    /// <summary>
    /// 销毁
    /// </summary>
    public void Destory()
    {
        _fsmTrriggerList.Clear();
        dict.Clear();
    }

    /// <summary>
    /// 该事件行为
    /// </summary>
    /// <param name="fsm"></param>
    public abstract void Action(SoldierFSMSystem fsm);
}









/// <summary>
/// 士兵的各个状态
/// </summary>
public enum SoldierStateID
{
    //入场
    RuChang,
    //待机
    DaiJi,
    //行进
    Xingjin,
    //死亡
    SiWang,
    //尸体
    ShiTi,
    //准备战斗状态 因为攻击分为普通攻击和技能攻击 所以扩展准备战斗状态 在这个状态里决定是哪种战斗
    Zhunbeizhandou,
    //隐身
    YinShen,
    //普通攻击中状态
    PutongGongji,
    //技能攻击中状态
    JinengGongji,
    // 追击状态
    ZhuiJi,
    //受击状态
    Shouji,
    //混乱状态
    Hunluan,
    NullState = -10001
}

/// <summary>
/// 定义Transition(转换)类型的枚举变量，以后根据需要扩展
/// </summary>
public enum SoldierTriggerID
{
    //入场
    RuChang,
    //待机
    DaiJi,
    //行进
    Xingjin,
    //死亡
    SiWang,
    //尸体
    ShiTi,
    //准备战斗
    Zhunbeizhandou,
    //隐身
    YinShen,
    //普通攻击
    PutongGongji,
    //技能攻击
    JinengGongji,
    // 追击
    ZhuiJi,
    //受击
    Shouji,
    //混乱
    Hunluan,
    NullTri = -10001
}
