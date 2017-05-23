using UnityEngine;
using System.Collections;

public class Soldier_JinengGongji_State : SoldierFSMState
{
    /// <summary>
    /// 技能是否释放完毕
    /// </summary>
    private bool skillIsEnd = false;

    public override void Init()
    {
        StateID = SoldierStateID.JinengGongji;
    }

    public override void Action(SoldierFSMSystem fsm)
    {
        // fsm 中带技能ID
        if (!skillIsEnd)
        {
            var skillInfo = fsm.Display.ClusterData.MemberData.Skill1;
            // 检测释放技能
            // 检测范围内单位
            // 筛选单位
            // 对目标单位(或目标点)开始释放技能
            // 数据中拿出技能编号,调用技能编号对应技能脚本
            // 
            // 技能释放完毕, 置状态下一帧切回行进行进状态(或者准备攻击状态)

        }
        else
        {
            // 切换状态到准备攻击
            fsm.IsCanInJinenggongji = false;
            // 技能cd设置IsCanInIjnenggongji = true;
        }
    }
}