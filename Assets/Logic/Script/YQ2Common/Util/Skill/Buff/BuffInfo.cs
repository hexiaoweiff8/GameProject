using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// buff数据
/// </summary>
public class BuffInfo : SkillBase
{

    /// <summary>
    /// Buff的承受者
    /// </summary>
    public DisplayOwner ReceiveMember { get; set; }

    /// <summary>
    /// buff类型
    /// </summary>
    public BuffType BuffType { get; set; }

    /// <summary>
    /// buff等级
    /// </summary>
    public int BuffRank { get; set; }

    /// <summary>
    /// buff的的优先级
    /// 高等级的buff会覆盖低等级的buff
    /// 反之不会
    /// </summary>
    public int BuffLevel{get { return buffLevel; }set { buffLevel = value; }}

    /// <summary>
    /// buff组 相同组的会互斥, 
    /// 由高Level的顶掉低level的buff
    /// 如果buffGroup为-1则与其他buff完全不冲突
    /// </summary>
    public int BuffGroup
    {
        get { return buffGroup; }
        set { buffGroup = value; }
    }

    /// <summary>
    /// 是增益buff还是负增益buff
    /// </summary>
    public bool IsBeneficial { get; set; }

    ///// <summary>
    ///// 修改数据类型
    ///// 0: 绝对值, 直接加
    ///// 1: 百分比, 直接乘
    ///// </summary>
    //public ChangeDataType ChangeDataType { get; set; }

    /// <summary>
    /// buff持续时间(单位 秒)
    /// </summary>
    public float BuffTime { get; set; }

    ///// <summary>
    ///// 互斥, 叠加 或同时存在
    ///// 0: 互斥
    ///// 1: 叠加
    ///// 2: 共存
    ///// </summary>
    //public BuffExistType ExistType { get; set; }

    /// <summary>
    /// buff是否死亡消失
    /// </summary>
    public bool IsDeadDisappear { get; set; }

    /// <summary>
    /// 是否不致死
    /// </summary>
    public bool IsNotLethal { get; set; }

    /// <summary>
    /// 是否不可被清除
    /// </summary>
    public bool IsCouldNotClear { get; set; }

    /// <summary>
    /// 卡牌Icon地址
    /// </summary>
    public string Icon { get; set; }

    /// <summary>
    /// buff启动时间
    /// </summary>
    public long BuffStartTime { get; set; }

    /// <summary>
    /// Detach触发条件Level1
    /// </summary>
    public TriggerLevel1 DetachTriggerLevel1 { get; set; }

    /// <summary>
    /// Detach触发条件Level2
    /// </summary>
    public TriggerLevel2 DetachTriggerLevel2 { get; set; }

    /// <summary>
    /// Detach生命区间下限
    /// </summary>
    public float DetachHpScopeMin{get { return detachHpScopeMin; } set { detachHpScopeMin = value; }}

    /// <summary>
    /// Detach生命区间上限
    /// </summary>
    public float DetachHpScopeMax{get { return detachHpScopeMax; } set { detachHpScopeMax = value; }}

    /// <summary>
    /// detach-键
    /// </summary>
    public IList<string> DetachQualifiedKeyList = new List<string>();

    /// <summary>
    /// detach条件-操作
    /// </summary>
    public IList<string> DetachQualifiedOptionList = new List<string>();

    /// <summary>
    /// detach条件-值
    /// </summary>
    public IList<string> DetachQualifiedValueList = new List<string>();



    /// <summary>
    /// buff互斥组
    /// </summary>
    private int buffGroup = -1;

    /// <summary>
    /// buff等级
    /// </summary>
    private int buffLevel = 1;

    /// <summary>
    /// Detach生命区间下限
    /// </summary>
    public float detachHpScopeMin = -1;

    /// <summary>
    /// Detach生命区间上限
    /// </summary>
    public float detachHpScopeMax = -1;

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="buffNum">BuffNum</param>
    public BuffInfo(int buffNum)
        : base()
    {
        Num = buffNum;
    }

    /// <summary>
    /// 检测当前buff中的数据, 如果数据符合Detach条件返回true
    /// TODO 检测效率
    /// </summary>
    /// <returns>是否符合Detach条件</returns>
    public bool CheckDetach()
    {
        var result = false;

        // 检测条件
        for (var i = 0; i < DetachQualifiedKeyList.Count; i++)
        {
            var key = DetachQualifiedKeyList[i];
            var op = DetachQualifiedOptionList[i];
            var value = DetachQualifiedValueList[i];
            // 判断类型
            if (value.IndexOf("f", StringComparison.Ordinal) > 0)
            {
                // float
                result = Utils.GetCompare<float>(op)(DataScope.GetFloat(key).Value, Convert.ToSingle(value.Replace("f","")));
            }
            else if (value.EndsWith("L"))
            {
                // long
                result = Utils.GetCompare<long>(op)(DataScope.GetLong(key).Value, Convert.ToInt64(value));
            }
            else if (value.Equals("true") && value.Equals("false"))
            {
                // bool
                result = Utils.GetCompare<bool>(op)(DataScope.GetBool(key).Value, Convert.ToBoolean(value));
            }
            else
            {
                // int
                result = Utils.GetCompare<int>(op)(DataScope.GetInt(key).Value, Convert.ToInt32(value));
            }
        }

        return result;
    }

    /// <summary>
    /// 检测数据是否符合Action条件
    /// </summary>
    /// <returns></returns>
    public bool CheckAction()
    {
        var result = false;

        //// 检测条件
        //for (var i = 0; i < DetachQualifiedKeyList.Count; i++)
        //{
        //    var key = ActionQualifiedKeyList[i];
        //    var op = ActionQualifiedOptionList[i];
        //    var value = ActionQualifiedValueList[i];
        //    // 判断类型
        //    if (value.IndexOf(".", StringComparison.Ordinal) > 0)
        //    {
        //        // float
        //        result = Utils.GetCompare<float>(op)(SkillDataScope.GetFloat(key), Convert.ToSingle(value));
        //    }
        //    else if (value.EndsWith("L"))
        //    {
        //        // long
        //        result = Utils.GetCompare<long>(op)(SkillDataScope.GetLong(key), Convert.ToInt64(value));
        //    }
        //    else if (value.Equals("true") && value.Equals("false"))
        //    {
        //        // bool
        //        result = Utils.GetCompare<bool>(op)(SkillDataScope.GetBool(key), Convert.ToBoolean(value));
        //    }
        //    else
        //    {
        //        // int
        //        result = Utils.GetCompare<int>(op)(SkillDataScope.GetInt(key), Convert.ToInt32(value));
        //    }
        //}

        return result;
    }
}


public enum ChangeDataType
{
    Absolute = 0,       // 绝对值
    Percentage = 1      // 百分比
}


/// <summary>
/// buff类型
/// buff类型可以合并
/// </summary>
public enum BuffType
{
    Attribute = 1,      // 属性相关buff
    DemageOrCure = 2,   // 伤害/治疗的
    Defend = 4,         // 防御,吸收伤害类
    Control = 8,        // 控制类, 眩晕, 沉默
    Hide = 16,          // 隐形
    Taunt = 32,         // 嘲讽
}

///// <summary>
///// buff存在类型
///// </summary>
//public enum BuffExistType
//{
//    Mutex = 0,      // 互斥
//    Stack,          // 叠加
//    Coexist         // 共存

//}