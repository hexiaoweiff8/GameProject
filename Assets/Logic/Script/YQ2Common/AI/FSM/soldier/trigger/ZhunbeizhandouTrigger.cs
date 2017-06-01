using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
/// <summary>
/// 准备战斗触发器
/// </summary>
public class ZhunbeizhandouTrigger : SoldierFSMTrigger{
    public override void Init()
    {
        triggerId = SoldierTriggerID.Zhunbeizhandou;
    }

    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        
        // TODO 目标选择器
        var myObjid = fsm.Display.MFAModelRender.ObjId;

        var enemy = DisplayerManager.Single.GetOpposingCamps(myObjid);

        IList<DisplayOwner> list = new List<DisplayOwner>();
        foreach (var display in enemy)
        {
            //排除掉已经死了的目标
            if (display.Value.ClusterData.MemberData.CurrentHP > 0)
            {
                list.Add(display.Value);
            }
        }
        var res = TargetSelecter.GetCollisionItemList(list, fsm.Display.ClusterData.X, fsm.Display.ClusterData.Y, fsm.Display.ClusterData.MemberData.SightRange);

        if (res.Count > 0)
        {
            return CheckSkill(fsm, res) || CheckPuTongGongji(fsm, res);
        }
        return false;
    }

    /// <summary>
    /// 是否可以技能攻击
    /// </summary>
    /// <param name="fsm"></param>
    /// <param name="res">目标列表</param>
    /// <returns></returns>
    private bool CheckSkill(SoldierFSMSystem fsm, IList<DisplayOwner> res)
    {
        var result = false;

        // TODO 使用技能目标选择
        var myObjid = fsm.Display.MFAModelRender.ObjId;

        // 判断主动技能是否可释放, 可释放则释放技能, 否则普通攻击
        var data = fsm.Display.ClusterData.MemberData;
        var skillNumList = new List<int>()
        {
            data.Skill1,
            data.Skill2,
            data.Skill3,
            data.Skill4,
            data.Skill5,
        };
        var skillInfoList = new List<SkillInfo>();
        foreach (var skillNum in skillNumList)
        {
            var type = skillNum/10000;
            var triggerType = type%100;
            type /= 1000;
            var skillType = type%10;
            // TODO 判断技能是否适合当前情况释放
            // 主动技能并且是范围内有其他单位触发
            if (skillType == 1 && triggerType == 1 || skillNum == 10001)
            {
                // 加入可能可释放列表
                skillInfoList.Add(SkillManager.Single.LoadSkillInfo(skillNum));
            }
        }

        if (skillInfoList.Count > 0)
        {
            // 判断技能CD的长短, 释放技能最长的
            foreach (var skill in skillInfoList)
            {
                // 技能没有在CD中
                if (CDTimer.Instance().IsInCD(myObjid.ID, skill.SkillNum))
                {
                    continue;
                }
                if (fsm.Skill == null)
                {
                    fsm.Skill = skill;
                    result = true;
                }
                else if (fsm.Skill.CDTime < skill.CDTime)
                {
                    fsm.Skill = skill;
                }
            }
        }

        if (result)
        {
            // 确定释放技能, 设置目标
            System.Random ran = new System.Random();
            var target = res[ran.Next(0, res.Count)];
            fsm.EnemyTarget = target;
            fsm.TargetIsLoseEfficacy = false;
        }

        return result;
    }

    /// <summary>
    /// 是否可以普通攻击
    /// </summary>
    /// <param name="fsm"></param>
    /// <param name="res">目标列表</param>
    /// <returns></returns>
    private bool CheckPuTongGongji(SoldierFSMSystem fsm, IList<DisplayOwner> res)
    {
        var ran = new System.Random();
        var target = res[ran.Next(0, res.Count)];
        fsm.EnemyTarget = target;
        fsm.TargetIsLoseEfficacy = false;
        return res.Count > 0;
    }
}
