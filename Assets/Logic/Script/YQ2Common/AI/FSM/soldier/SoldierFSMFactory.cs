using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SoldierFSMFactory
{
    /// <summary>
    /// 士兵类型
    /// </summary>
    public const int SoldierType = 1;

    /// <summary>
    /// 防御塔类型
    /// </summary>
    public const int TurretType = 2;

    /// <summary>
    /// 基地类型
    /// </summary>
    public const int BaseType = 3;

    /// <summary>
    /// 地雷类型
    /// </summary>
    public const int MineType = 4;

    /// <summary>
    /// 获取行为表结构
    /// </summary>
    /// <param name="behaviorType">行为编号</param>
    /// <returns></returns>
    public static Dictionary<SoldierStateID, List<SoldierStateID>> GetBehaviorMappingDicById(int behaviorType)
    {

        Dictionary<SoldierStateID, List<SoldierStateID>> result = null;
        switch (behaviorType)
        {
            case SoldierType:
            {
                // 常规士兵行为
                result = new Dictionary<SoldierStateID, List<SoldierStateID>>()
                {
                    {SoldierStateID.RuChang, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Xingjin
                    }},
                    {SoldierStateID.Xingjin, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                        SoldierStateID.ZhuiJi,
                        SoldierStateID.DaiJi,
                    }},
                    {SoldierStateID.Zhunbeizhandou, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.JinengGongji,
                        SoldierStateID.PutongGongji,
                    }},
                    {SoldierStateID.SiWang, new List<SoldierStateID>()},
                    {SoldierStateID.PutongGongji, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.DaiJi,
                        SoldierStateID.Zhunbeizhandou
                    }},
                    {SoldierStateID.JinengGongji, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.DaiJi,
                    }},
                    {SoldierStateID.ZhuiJi, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                        SoldierStateID.DaiJi,
                    }},
                    {SoldierStateID.DaiJi, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                        SoldierStateID.Xingjin,
                    }},
                };
            }
                break;
            case TurretType:
            {
                // 防御塔行为
                result = new Dictionary<SoldierStateID, List<SoldierStateID>>()
                {
                    {SoldierStateID.RuChang, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.DaiJi,
                        SoldierStateID.Zhunbeizhandou,
                    }},
                    {SoldierStateID.Zhunbeizhandou, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.PutongGongji
                    }},
                    {SoldierStateID.PutongGongji, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                        SoldierStateID.DaiJi,
                    }},
                    {SoldierStateID.DaiJi, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                    }},
                    {SoldierStateID.SiWang, new List<SoldierStateID>()},
                };
            }
                break;
            case BaseType:
            {
                // 基地行为
                result = new Dictionary<SoldierStateID, List<SoldierStateID>>()
                {
                    {SoldierStateID.RuChang, new List<SoldierStateID>()
                    {
                        SoldierStateID.DaiJi,
                        SoldierStateID.SiWang,
                    }},
                    {SoldierStateID.DaiJi, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                    }},
                    {SoldierStateID.SiWang, new List<SoldierStateID>()},
                };
            }
                break;
            case MineType:
            {
                // 地雷行为
                result = new Dictionary<SoldierStateID, List<SoldierStateID>>()
                {
                    {SoldierStateID.RuChang, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                    }},
                    {SoldierStateID.Zhunbeizhandou, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.JinengGongji
                    }},
                    {SoldierStateID.JinengGongji, new List<SoldierStateID>()
                    {
                        SoldierStateID.SiWang,
                        SoldierStateID.Zhunbeizhandou,
                    }},
                    {SoldierStateID.SiWang, new List<SoldierStateID>()},
                };
            }
                break;
        }

        return result;
    }


    /// <summary>
    /// 获取行为表结构
    /// </summary>
    /// <param name="behaviorType">行为编号</param>
    /// <returns></returns>
    public static Dictionary<SoldierTriggerID, Func<SoldierFSMSystem, bool>> GetTriggerFuncDicById(int behaviorType)
    {

        Dictionary<SoldierTriggerID, Func<SoldierFSMSystem, bool>> result = new Dictionary<SoldierTriggerID, Func<SoldierFSMSystem, bool>>();

        // 获取当前行为类型的行为列表
        var behaviorDic = GetBehaviorMappingDicById(behaviorType);
        // 遍历列表获取行为具体内容
        foreach (var kv in behaviorDic)
        {
            var triggerId = GetTriggerByStateId(kv.Key);
            result.Add(triggerId, TriggerFuncFactory.GetTriggerFuncByBehaviorType(triggerId, behaviorType));
        }

        // 构建trigger事件

        return result;
    }

    /// <summary>
    /// triggerId转stateId
    /// </summary>
    /// <param name="id">SoldierTriggerID</param>
    /// <returns>SoldierStateID</returns>
    public static SoldierStateID GetStateIdByTrigger(SoldierTriggerID id)
    {
        switch (id)
        {
            case SoldierTriggerID.RuChang:
                return SoldierStateID.RuChang;
            case SoldierTriggerID.Xingjin:
                return SoldierStateID.Xingjin;
            case SoldierTriggerID.Zhunbeizhandou:
                return SoldierStateID.Zhunbeizhandou;
            case SoldierTriggerID.PutongGongji:
                return SoldierStateID.PutongGongji;
            case SoldierTriggerID.JinengGongji:
                return SoldierStateID.JinengGongji;
            case SoldierTriggerID.SiWang:
                return SoldierStateID.SiWang;
            case SoldierTriggerID.ZhuiJi:
                return SoldierStateID.ZhuiJi;
            case SoldierTriggerID.DaiJi:
                return SoldierStateID.DaiJi;
        }
        return SoldierStateID.NullState;
    }

    /// <summary>
    /// stateId转triggerId
    /// </summary>
    /// <param name="id">SoldierStateID</param>
    /// <returns>SoldierTriggerID</returns>
    public static SoldierTriggerID GetTriggerByStateId(SoldierStateID id)
    {
        switch (id)
        {
            case SoldierStateID.RuChang:
                return SoldierTriggerID.RuChang;
            case SoldierStateID.Xingjin:
                return SoldierTriggerID.Xingjin;
            case SoldierStateID.Zhunbeizhandou:
                return SoldierTriggerID.Zhunbeizhandou;
            case SoldierStateID.PutongGongji:
                return SoldierTriggerID.PutongGongji;
            case SoldierStateID.JinengGongji:
                return SoldierTriggerID.JinengGongji;
            case SoldierStateID.SiWang:
                return SoldierTriggerID.SiWang;
            case SoldierStateID.ZhuiJi:
                return SoldierTriggerID.ZhuiJi;
            case SoldierStateID.DaiJi:
                return SoldierTriggerID.DaiJi;
        }
        return SoldierTriggerID.NullTri;
    }

    /// <summary>
    /// stateId转FSMState类type
    /// </summary>
    /// <param name="id">SoldierStateID</param>
    /// <returns>FSMState类Type</returns>
    public static Type GetStateTypeByStateId(SoldierStateID id)
    {
        switch (id)
        {
            case SoldierStateID.RuChang:
                return typeof(Soldier_Ruchang_State);
            case SoldierStateID.Xingjin:
                return typeof(Soldier_Xingjin_State);
            case SoldierStateID.Zhunbeizhandou:
                return typeof(Soldier_Zhunbeizhandou_State);
            case SoldierStateID.PutongGongji:
                return typeof(Soldier_PutongGongji_State);
            case SoldierStateID.JinengGongji:
                return typeof(Soldier_JinengGongji_State);
            case SoldierStateID.SiWang:
                return typeof(Soldier_Siwang_State);
            case SoldierStateID.ZhuiJi:
                return typeof(Soldier_Zhuiji_State);
            case SoldierStateID.DaiJi:
                return typeof(Soldier_Daiji_State);
        }
        return typeof(Soldier_Ruchang_State);
    }

    /// <summary>
    /// stateId转FSMState类type
    /// </summary>
    /// <param name="id">SoldierTriggerID</param>
    /// <returns>FSMState类Type</returns>
    public static Type GetTriggerTypeByTriggerId(SoldierTriggerID id)
    {
        switch (id)
        {
            case SoldierTriggerID.RuChang:
                return typeof(RuChangTrigger);
            case SoldierTriggerID.Xingjin:
                return typeof(XingjinTrigger);
            case SoldierTriggerID.Zhunbeizhandou:
                return typeof(ZhunbeizhandouTrigger);
            case SoldierTriggerID.PutongGongji:
                return typeof(PutongGongjiTrigger);
            case SoldierTriggerID.JinengGongji:
                return typeof(JinengGongjiTrigger);
            case SoldierTriggerID.SiWang:
                return typeof(SiwangTrigger);
            case SoldierTriggerID.ZhuiJi:
                return typeof(ZhuiJiTrigger);
            case SoldierTriggerID.DaiJi:
                return typeof(DaiJiTrigger);
        }
        return typeof(RuChangTrigger);
    }
}