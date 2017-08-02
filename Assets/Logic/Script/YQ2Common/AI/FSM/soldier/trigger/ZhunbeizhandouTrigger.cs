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
        var list = TargetSelecter.TargetFilter(searchData,
            ClusterManager.Single.CheckRange(pos, searchData.AllData.MemberData.AttackRange, searchData.AllData.MemberData.Camp, true));

        Utils.DrawGraphics(new CircleGraphics(pos, searchData.AllData.MemberData.AttackRange), Color.yellow);
        if (list != null && list.Count > 0)
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

        // 判断主动技能是否可释放, 可释放则释放技能, 否则普通攻击
        var skillInfoList = fsm.Display.ClusterData.AllData.SkillInfoList;

        if (skillInfoList.Count > 0)
        {
            // 判断技能CD的长短, 释放技能最长的
            foreach (var skill in skillInfoList)
            {
                // 是否为主动技能
                // 技能没有在CD中
                if (!skill.IsActive || !CDTimer.Instance().IsInCD(skill.Num, fsm.Display.ClusterData.AllData.MemberData.ObjID.ID, skill.CDGroup))
                {
                    continue;
                }
                // 按照技能的CD事件从大到小排释放顺序
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
        if (res == null || res.Count == 0)
        {
            return false;
        }
        // TODO 取最近的
        var target = res[0];
        fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
        return fsm.EnemyTarget != null;
    }
}
