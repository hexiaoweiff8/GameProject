using UnityEngine;
using System.Collections;

public abstract class SoldierFSMTrigger {
    /// <summary>
    /// 触发器id 对应状态转换
    /// </summary>
    public SoldierTriggerID triggerId;

    public SoldierFSMTrigger()
    {
        Init();
    }

    public abstract void Init();

    public abstract bool CheckTrigger(SoldierFSMSystem fsm);
}
