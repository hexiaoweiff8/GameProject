using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 状态机主类 管理各状态切换
/// </summary>
public class SoldierFSMSystem {

    private List<SoldierFSMState> _states;

    /// <summary>
    /// 允许状态机持有显示对象
    /// 修改为外层持有对象
    /// </summary>
    public DisplayOwner Display;

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
    /// 标记角色血量是否为0
    /// </summary>
    public bool IsDie = false;


    private SoldierStateID _currentStateId;

    //不要直接修改这个变量，之所以让他公有是因为得让其他脚本调用这个变量。
    public SoldierStateID CurrentStateID { get { return _currentStateId; } }

    //记录当前状态
    private SoldierFSMState _currentState;

    public SoldierFSMState CurrentState { get { return _currentState; } }

    /// <summary>
    /// 通过目标选择器筛选并锁定的敌人
    /// </summary>
    public DisplayOwner EnemyTarget;

    /// <summary>
    /// 标记攻击目标是否失效 如果目标失效需要切除状态
    /// </summary>
    public bool TargetIsLoseEfficacy;


    /// <summary>
    /// 被释放技能
    /// </summary>
    public SkillInfo Skill = null;

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

        foreach (SoldierFSMState state in _states)//遍历此状态容器 
        {
            if (state.StateID == stateId)
            {
                if (null != _currentState)
                {
                    _currentState.DoBeforeLeaving(this);
                }
                //只允许在这里切换状态
                _currentState = state;
                _currentStateId = state.StateID;
                //Debug.Log("执行状态切换-------------------" + state.StateID);
                if (null != _currentState)
                {
                    _currentState.DoBeforeEntering(this);
                }
                break;
            }
        }
    }

    public void Destory()
    {
        foreach (var state in _states)
        {
            state.Destory();
        }
        _states.Clear();
    }
}
