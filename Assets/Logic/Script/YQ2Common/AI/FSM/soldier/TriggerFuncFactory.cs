using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/// <summary>
/// trigger判断条件工厂
/// </summary>
public class TriggerFuncFactory
{

    /// <summary>
    /// 获取对应行为类型的trigger检测方法
    /// </summary>
    /// <param name="triggerId">trigger类型</param>
    /// <param name="behaviorType">行为类型</param>
    /// <returns>检测方法</returns>
    public static Func<SoldierFSMSystem, bool> GetTriggerFuncByBehaviorType(SoldierTriggerID triggerId, int behaviorType)
    {
        Func<SoldierFSMSystem, bool> result = null;

        switch (behaviorType)
        {
            // 常规士兵类型
            case SoldierFSMFactory.SoldierType:
                {
                    // -------------------------------常规士兵类型-----------------------------
                    switch (triggerId)
                    {
                        case SoldierTriggerID.RuChang:
                            // -----------------------入场------------------------------
                            result = (fsm) =>
                            {
                                return false;
                            };
                            break;
                        case SoldierTriggerID.Xingjin:
                            // -----------------------行进------------------------------
                            result = (fsm) =>
                            {
                                if (fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0)
                                {
                                    return false;
                                }
                                switch (fsm.CurrentStateID)
                                {
                                    case SoldierStateID.RuChang:
                                    case SoldierStateID.DaiJi:
                                        return fsm.IsCanRun;
                                    //case SoldierStateID.PutongGongji:
                                    //case SoldierStateID.JinengGongji:
                                    //    return fsm.TargetIsLoseEfficacy;
                                    //case SoldierStateID.ZhuiJi:
                                    //    return !fsm.IsZhuiJi;
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.Zhunbeizhandou:
                            // -----------------------准备战斗------------------------------
                            result = (fsm) =>
                            {
                                // 状态检查路由
                                switch (fsm.CurrentStateID)
                                {
                                    // 行进追击切准备战斗
                                    case SoldierStateID.Xingjin:
                                    case SoldierStateID.ZhuiJi:
                                    case SoldierStateID.DaiJi:
                                    {
                                        return ZhunbeizhandouTrigger.CheckChangeState(fsm);
                                    }
                                    // 技能攻击/普通攻击切准备战斗
                                    case SoldierStateID.PutongGongji:
                                    {
                                        //Debug.Log("普通攻击检测技能释放");
                                        // 检测是否有技能可释放
                                        return ZhunbeizhandouTrigger.CheckSkillRelease(fsm);
                                    }
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.PutongGongji:
                            // -----------------------普通攻击------------------------------
                            result = (fsm) =>
                            {
                                switch (fsm.CurrentStateID)
                                {
                                    case SoldierStateID.Zhunbeizhandou:
                                        return fsm.IsCanInPutonggongji;
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.JinengGongji:
                            // -----------------------技能攻击------------------------------
                            result = (fsm) =>
                            {
                                // 当前单位技能释放判断
                                switch (fsm.CurrentStateID)
                                {
                                    case SoldierStateID.Zhunbeizhandou:
                                        return fsm.IsCanInJinenggongji;
                                    default:
                                        return false;
                                }
                            };
                            break;
                        case SoldierTriggerID.SiWang:
                            // -----------------------死亡------------------------------
                            result = (fsm) =>
                            {
                                return fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0;
                            };
                            break;
                        case SoldierTriggerID.ZhuiJi:
                            result = ZhuiJiTrigger.Check;
                            break;

                        case SoldierTriggerID.DaiJi:
                            result = (fsm) =>
                            {
                                // 状态检查路由
                                switch (fsm.CurrentStateID)
                                {
                                    // 行进追击切准备战斗
                                    case SoldierStateID.Xingjin:
                                    case SoldierStateID.ZhuiJi:
                                        {
                                            return ZhunbeizhandouTrigger.CheckChangeState(fsm);
                                        }
                                    // 技能攻击/普通攻击切准备战斗
                                    case SoldierStateID.PutongGongji:
                                    case SoldierStateID.JinengGongji:
                                        {
                                            return fsm.TargetIsLoseEfficacy;
                                        }
                                }
                                return false;
                            };
                            break;
                    }
                }
                break;
            // 防御塔类型
            case SoldierFSMFactory.TurretType:
                {
                    // --------------------------------防御塔类型------------------------------------
                    switch (triggerId)
                    {
                        case SoldierTriggerID.RuChang:
                            // -----------------------入场------------------------------
                            result = (fsm) =>
                            {
                                return false;
                            };
                            break;
                        case SoldierTriggerID.Zhunbeizhandou:
                            // -----------------------准备战斗------------------------------
                            result = (fsm) =>
                            {
                                // 状态检查路由
                                switch (fsm.CurrentStateID)
                                {
                                    // 行进追击切准备战斗
                                    case SoldierStateID.DaiJi:
                                        {
                                            return ZhunbeizhandouTrigger.CheckNormalAttack(fsm);
                                        }
                                    // 技能攻击/普通攻击切准备战斗
                                    case SoldierStateID.PutongGongji:
                                        {
                                            return false;
                                        }
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.PutongGongji:
                            // -----------------------普通攻击------------------------------
                            result = (fsm) =>
                            {
                                switch (fsm.CurrentStateID)
                                {
                                    case SoldierStateID.Zhunbeizhandou:
                                        return fsm.IsCanInPutonggongji;
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.SiWang:
                            // -----------------------死亡------------------------------
                            result = (fsm) =>
                            {
                                return fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0;
                            };
                            break;
                        case SoldierTriggerID.DaiJi:
                            result = (fsm) =>
                            {
                                // 状态检查路由
                                switch (fsm.CurrentStateID)
                                {
                                    // 行进追击切准备战斗
                                    case SoldierStateID.RuChang:
                                    {
                                        return true;
                                    }
                                    // 技能攻击/普通攻击切准备战斗
                                    case SoldierStateID.PutongGongji:
                                    {
                                        return fsm.TargetIsLoseEfficacy;
                                    }
                                }
                                return false;
                            };
                            break;
                    }
                }
                break;
            // 基地类型
            case SoldierFSMFactory.BaseType:
                {
                    // -----------------------------------基地类型---------------------------------
                    switch (triggerId)
                    {
                        case SoldierTriggerID.RuChang:
                            // -----------------------入场------------------------------
                            result = (fsm) =>
                            {
                                return false;
                            };
                            break;
                        case SoldierTriggerID.DaiJi:
                            //-----------------------待机------------------------------
                            result = (fsm) =>
                            {
                                // 切待机状态
                                return true;
                            };
                            break;
                        case SoldierTriggerID.SiWang:
                            // -----------------------死亡------------------------------
                            result = (fsm) =>
                            {
                                return fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0;
                            };
                            break;
                    }
                }
                break;
            // 地雷类型
            case SoldierFSMFactory.MineType:
                {
                    // ----------------------------------地雷类型---------------------------------
                    switch (triggerId)
                    {
                        case SoldierTriggerID.RuChang:
                            // -----------------------入场------------------------------
                            result = (fsm) =>
                            {
                                return false;
                            };
                            break;
                        case SoldierTriggerID.Zhunbeizhandou:
                            // -----------------------准备战斗------------------------------
                            result = (fsm) =>
                            {
                                // 状态检查路由
                                switch (fsm.CurrentStateID)
                                {
                                    // 行进追击切准备战斗
                                    case SoldierStateID.RuChang:
                                    case SoldierStateID.DaiJi:
                                    case SoldierStateID.ZhuiJi:
                                        {
                                            return ZhunbeizhandouTrigger.CheckChangeState(fsm);
                                        }
                                    // 技能攻击/普通攻击切准备战斗
                                    case SoldierStateID.JinengGongji:
                                        {
                                            return false;
                                        }
                                }
                                return false;
                            };
                            break;
                        case SoldierTriggerID.JinengGongji:
                            // -----------------------技能攻击------------------------------
                            result = (fsm) =>
                            {
                                // 当前单位技能释放判断
                                switch (fsm.CurrentStateID)
                                {
                                    case SoldierStateID.Zhunbeizhandou:
                                        return fsm.IsCanInJinenggongji;
                                    default:
                                        return false;
                                }
                            };
                            break;
                        case SoldierTriggerID.SiWang:
                            // -----------------------死亡------------------------------
                            result = (fsm) =>
                            {
                                return fsm.Display.ClusterData.AllData.MemberData.CurrentHP <= 0;
                            };
                            break;
                    }
                }
                break;

        }

        return result;
    }
}