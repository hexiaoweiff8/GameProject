using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

/// <summary>
/// 准备战斗触发器
/// </summary>
public class ZhunbeizhandouTrigger : SoldierFSMTrigger
{
    /// <summary>
    /// 初始化
    /// </summary>
    public override void Init()
    {
        triggerId = SoldierTriggerID.Zhunbeizhandou;
    }

    /// <summary>
    /// 检测条件
    /// </summary>
    /// <param name="fsm"></param>
    /// <returns></returns>
    public override bool CheckTrigger(SoldierFSMSystem fsm)
    {
        // 状态检查路由
        switch (fsm.CurrentStateID)
        {
            // 行进追击切准备战斗
            case SoldierStateID.Xingjin:
            case SoldierStateID.ZhuiJi:
            {
                return CheckChangeState(fsm);
            }
            // 技能攻击/普通攻击切准备战斗
            case SoldierStateID.PutongGongji:
            case SoldierStateID.JinengGongji:
            {
                //// 如果有正在攻击目标则 不切换状态
                //// 判断是否有正在攻击的目标
                //if ((!fsm.IsCanInJinenggongji && !fsm.IsCanInPutonggongji) || fsm.TargetIsLoseEfficacy)
                //{
                //    // 可以切换
                //    return CheckChangeState(fsm);
                //}

                return false;
            }
        }
        return false;
    }

    /// <summary>
    /// 检查是否可以切换状态
    /// </summary>
    /// <param name="fsm"></param>
    /// <returns></returns>
    private bool CheckChangeState(SoldierFSMSystem fsm)
    {
        var searchData = fsm.Display.ClusterData;
        //var objId = searchData.MemberData.ObjID;

        // 攻击范围内是否有敌人
        var pos = new Vector2(fsm.Display.ClusterData.X, fsm.Display.ClusterData.Y);
        //var list = ClusterManager.Single.CheckRange(objId, pos, fsm.Display.ClusterData.MemberData.AttackRange,
        //    fsm.Display.ClusterData.MemberData.Camp, true);

        // 目标选择器选择目标列表
        var list = TargetSelecter.Single.TargetFilter(searchData,
            ClusterManager.Single.CheckRange(pos, searchData.AllData.MemberData.AttackRange, searchData.AllData.MemberData.Camp, true));

        Utils.DrawGraphics(new CircleGraphics(pos, searchData.AllData.MemberData.AttackRange), Color.yellow);
        if (list.Count > 0)
        {
            // 攻击目标
            fsm.TargetIsLoseEfficacy = false;
            // 检测技能
            if (CheckSkill(fsm, list))
            {
                fsm.IsCanInPutonggongji = false;
                fsm.IsCanInJinenggongji = true;
                return true;
            }
            // 检测普通攻击
            if (SetTarget(fsm, list))
            {
                fsm.IsCanInJinenggongji = false;
                fsm.IsCanInPutonggongji = true;
                return true;
            }
        }
        return false;
    }

    /// <summary>
    /// 是否可以技能攻击
    /// </summary>
    /// <param name="fsm"></param>
    /// <param name="res">目标列表</param>
    /// <returns></returns>
    private bool CheckSkill(SoldierFSMSystem fsm, IList<PositionObject> res)
    {
        var result = false;

        // TODO 使用技能目标选择
        //var myObjid = fsm.Display.MFAModelRender.ObjId;

        // 判断主动技能是否可释放, 可释放则释放技能, 否则普通攻击
        var skillInfoList = fsm.Display.ClusterData.AllData.SkillInfoList;
        //var skillNumList = new List<int>()
        //{
        //    data.Skill1,
        //    data.Skill2,
        //    data.Skill3,
        //    data.Skill4,
        //    data.Skill5,
        //};
        //foreach (var skillNum in skillNumList)
        //{
        //    var type = skillNum/10000;
        //    var triggerType = type%100;
        //    type /= 1000;
        //    var skillType = type%10;
        //    // TODO 判断技能是否适合当前情况释放
        //    // 主动技能并且是范围内有其他单位触发
        //    if (skillType == 1 && triggerType == 1 || skillNum == 10001)
        //    {
        //        // 加入可能可释放列表
        //        skillInfoList.Add(SkillManager.Single.LoadSkillInfo(skillNum));
        //    }
        //}

        if (skillInfoList.Count > 0)
        {
            // 判断技能CD的长短, 释放技能最长的
            foreach (var skill in skillInfoList)
            {
                // TODO 判断是否可以释放
                // TODO 按照技能释放Enum来获取能够释放的技能
                // 触发一个目标是敌人的技能
                // 技能没有在CD中
                if (!CDTimer.Instance().IsInCD(skill.Num, fsm.Display.ClusterData.AllData.MemberData.ObjID.ID, skill.CDGroup))
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
            //System.Random ran = new System.Random();
            var target = res[0];
            fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
        }

        return result;
    }
    
    /// <summary>
    /// 设置目标单位
    /// </summary>
    /// <param name="fsm"></param>
    /// <param name="res"></param>
    /// <returns></returns>
    private bool SetTarget(SoldierFSMSystem fsm, IList<PositionObject> res)
    {
        //var ran = new System.Random();
        // TODO 取最近的
        var target = res[0];
        fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
        return res.Count > 0;
    }
}
