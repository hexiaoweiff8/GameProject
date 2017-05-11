using UnityEngine;
using System.Collections;

/// <summary>
/// 入场状态触发器 入场状态为一次性 所以不存在其他状态切换为入场状态的情况
/// </summary>
public class RuChangTrigger : SoldierFSMTrigger
{
    private bool _startRuchang;
    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        return false;
    }

    public override void Init()
    {
        triggerId = SoldierTriggerID.RuChang;
    }
}
