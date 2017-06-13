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
        var objId = fsm.Display.ClusterData.MemberData.ObjID;

        // 攻击范围内是否有敌人
        var pos = new Vector2(fsm.Display.ClusterData.X, fsm.Display.ClusterData.Y);
        var list = CheckRange(objId, pos, fsm.Display.ClusterData.MemberData.AttackRange,
            fsm.Display.ClusterData.MemberData.Camp, true);
        Utils.DrawGraphics(new CircleGraphics(pos, fsm.Display.ClusterData.MemberData.AttackRange), Color.yellow);
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
            return false;
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
            fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
            fsm.TargetIsLoseEfficacy = false;
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
        var ran = new System.Random();
        // TODO 取最近的
        var target = res[ran.Next(0, res.Count)];
        fsm.EnemyTarget = DisplayerManager.Single.GetElementByPositionObject(target);
        return res.Count > 0;
    }

    /// <summary>
    /// 检测范围内单位
    /// </summary>
    /// <param name="objId">筛选者Id</param>
    /// <param name="pos">检测位置</param>
    /// <param name="range">检测半径</param>
    /// <param name="myCamp">当前单位阵营</param>
    /// <param name="isExceptMyCamp">是否排除己方阵营</param>
    /// <returns>范围内单位</returns>
    private IList<PositionObject> CheckRange(ObjectID objId, Vector2 pos, float range, int myCamp = -1, bool isExceptMyCamp = false)
    {
        var memberInSightScope =
                ClusterManager.Single.GetPositionObjectListByGraphics(
                    new CircleGraphics(pos, range));

        IList<PositionObject> list = new List<PositionObject>();
        foreach (var member in memberInSightScope)
        {
            // 区分自己
            if (objId.ID == member.MemberData.ObjID.ID)
            {
                continue;
            }
            // 区分阵营
            if (member.MemberData.CurrentHP > 0 
                && (myCamp == -1 
                || (isExceptMyCamp && member.MemberData.Camp != myCamp)
                || (!isExceptMyCamp && member.MemberData.Camp == myCamp)))
            {
                list.Add(member);
            }
        }

        return list;
    }
}
