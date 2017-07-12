using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// 状态机主类 管理各状态切换
/// </summary>
public class SoldierFSMSystem {


    /// <summary>
    /// 允许状态机持有显示对象
    /// 修改为外层持有对象
    /// </summary>
    public DisplayOwner Display;

    /// <summary>
    /// 通过目标选择器筛选并锁定的敌人
    /// </summary>
    public DisplayOwner EnemyTarget;

    /// <summary>
    /// 是否可以开始走的标记 只被用在判断士兵入场以后是否已经经过了一秒的等待
    /// </summary>
    public bool IsCanRun = false;

    /// <summary>
    /// 是否已经做好战斗准备 可以进入战斗的标记（普通攻击）
    /// </summary>
    public bool IsCanInPutonggongji = false;

    /// <summary>
    /// 是否已经做好战斗准备 可以进入战斗的标记（普通攻击）
    /// </summary>
    public bool IsCanInJinenggongji = false;

    /// <summary>
    /// 是否追击
    /// </summary>
    public bool IsZhuiJi = false;

    /// <summary>
    /// 标记角色血量是否为0
    /// </summary>
    public bool IsDie = false;

    /// <summary>
    /// 标记攻击目标是否失效 如果目标失效需要切除状态
    /// </summary>
    public bool TargetIsLoseEfficacy;

    /// <summary>
    /// 被释放技能
    /// </summary>
    public SkillInfo Skill = null;


    /// <summary>
    /// 当前状态ID
    /// 不要直接修改这个变量，之所以让他公有是因为得让其他脚本调用这个变量。
    /// </summary>
    public SoldierStateID CurrentStateID { get { return _currentStateId; } }

    /// <summary>
    /// 当前状态
    /// </summary>
    public SoldierFSMState CurrentState { get { return _currentState; } }

    /// <summary>
    /// 来源状态
    /// </summary>
    public SoldierStateID SourceStateID { get; set; }

    // ----------------------------私有属性----------------------------

    /// <summary>
    /// 现有状态列表
    /// </summary>
    private List<SoldierFSMState> _states;

    /// <summary>
    /// 当前状态Id
    /// </summary>
    private SoldierStateID _currentStateId;

    /// <summary>
    /// 当前状态
    /// </summary>
    private SoldierFSMState _currentState;

    // -----------------------------公共方法-----------------------------


    /// <summary>
    /// 初始化
    /// </summary>
    public SoldierFSMSystem()
    {
        _states = new List<SoldierFSMState>();
    }

    /// <summary>
    /// 增加状态转换对 第一次添加的状态是默认状态
    /// </summary>
    /// <param name="s"></param>
    public void AddState(SoldierFSMState s)
    {
        //_currentState = _states.Find((e) => e.StateID == s.StateID);
        if (s == null)
        {
            Debug.LogError("SoldierFSM ERROR: Null reference is not allowed");
        }

        if (_states.Count == 0)
        {
            _states.Add(s);
            ChangeState(s.StateID);
            return;
        }
        //排除相同的状态
        foreach (SoldierFSMState state in _states)
        {
            if (state.StateID == s.StateID)
            {
                Debug.LogError("SoldierFSM ERROR: Impossible to add state " + s.StateID.ToString() +
                               " because state has already been added");
                return;
            }
        }
        _states.Add(s);
    }

    /// <summary>
    /// 查找并切换对应id的状态 
    /// </summary>
    /// <param name="stateId"></param>
    public void ChangeState(SoldierStateID stateId)
    {
        if (stateId == SoldierStateID.NullState)
        {
            Debug.LogError("SoldierFSM ERROR: 不允许切换空状态");
        }

        //遍历此状态容器 
        foreach (SoldierFSMState state in _states)
        {
            if (state.StateID == stateId)
            {
                if (null != _currentState)
                {
                    _currentState.DoBeforeLeaving(this);
                }
                // 设置前置状态
                SourceStateID = _currentStateId;
                //只允许在这里切换状态
                _currentState = state;
                _currentStateId = state.StateID;
                //Debug.Log("执行状态切换-------------------" + state.StateID);
                if (null != _currentState)
                {
                    _currentState.DoBeforeEntering(this);
                }
                // TODO 同步状态切换操作
                // 同步数据包括 状态, FSM数据, 单位属性, 单位位置, 单位方向, 目标点列表(路径), 目标(技能/攻击目标)
                break;
            }
        }
    }

    /// <summary>
    /// 销毁
    /// </summary>
    public void Destory()
    {
        foreach (var state in _states)
        {
            state.Destory();
        }
        _states.Clear();
    }

    /// <summary>
    /// 设置数据
    /// </summary>
    /// <param name="fsm"></param>
    public void SetData(SoldierFSMControl fsm)
    {

    }
}