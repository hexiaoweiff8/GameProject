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
    public int BuffLevel = 1;

    /// <summary>
    /// buff组 相同组的会互斥, 
    /// 由高Level的顶掉低level的buff
    /// 如果buffGroup为-1则与其他buff完全不冲突
    /// </summary>
    public int BuffGroup = -1;

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
    /// 描述
    /// </summary>
    public string Description { get; set; }

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
    /// 初始化
    /// </summary>
    /// <param name="buffNum">BuffNum</param>
    public BuffInfo(int buffNum)
        : base()
    {
        Num = buffNum;
    }


    /// <summary>
    /// 添加触发行为生成器
    /// </summary>
    /// <param name="formulaItem">行为单元生成器</param>
    public void AddActionFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (actionFormulaItem == null)
        {
            actionFormulaItem = formulaItem;
        }
        else
        {
            actionFormulaItem.After(formulaItem);
        }
    }
    
    /// <summary>
    /// 添加创建行为生成器
    /// </summary>
    /// <param name="formulaItem">行为单元生成器</param>
    public void AddAttachFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (attachFormulaItem == null)
        {
            attachFormulaItem = formulaItem;
        }
        else
        {
            attachFormulaItem.After(formulaItem);
        }
    }
    
    /// <summary>
    /// 添加销毁行为生成器
    /// </summary>
    /// <param name="formulaItem">行为单元生成器</param>
    public void AddDetachFormulaItem(IFormulaItem formulaItem)
    {
        if (formulaItem == null)
        {
            throw new Exception("行为节点为空");
        }
        if (detachFormulaItem == null)
        {
            detachFormulaItem = formulaItem;
        }
        else
        {
            detachFormulaItem.After(formulaItem);
        }
    }



    public IFormulaItem GetActionFormulaItem()
    {
        return actionFormulaItem;
    }

    public IFormulaItem GetAttachFormulaItem()
    {
        return attachFormulaItem;
    }

    public IFormulaItem GetDetachFormulaItem()
    {
        return detachFormulaItem;
    }


    /// <summary>
    /// 获取buff创建时行为
    /// </summary>
    /// <param name="paramsPacker">构造行为数据</param>
    /// <returns>创建时行为链</returns>
    public IFormula GetAttachFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        if (paramsPacker == null)
        {
            throw new Exception("参数封装为空.");
        }
        if (attachFormulaItem == null)
        {
            return result;
        }
        result = GetIFormula(paramsPacker, attachFormulaItem);

        return result;
    }


    /// <summary>
    /// 获取buff销毁行为
    /// </summary>
    /// <param name="paramsPacker">构造行为数据</param>
    /// <returns>销毁时行为链</returns>
    public IFormula GetDetachFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        if(paramsPacker == null)
        {
            throw new Exception("参数封装为空.");
        }
        if (detachFormulaItem == null)
        {
            return result;
        }
        result = GetIFormula(paramsPacker, detachFormulaItem);
        //if (result != null)
        //{
        //    result.After(new Formula((callback) =>
        //    {
        //        Debug.Log("删除buff:" + addtionId);
        //        // 执行结束删除当前buff的具体实现引用
        //        BuffManager.Single.DelBuffInstance(AddtionId);
        //        callback();
        //    }));
        //}
        return result;
    }

    /// <summary>
    /// 获取buff触发行为
    /// </summary>
    /// <param name="paramsPacker">参数封装</param>
    /// <returns>行为链</returns>
    public IFormula GetActionFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            throw new Exception("参数封装为空.");
        }
        IFormula result = null;

        if (actionFormulaItem == null)
        {
            return null;
        }
        result = GetIFormula(paramsPacker, actionFormulaItem);
        return result;
    }


    /// <summary>
    /// 获取替换数据后的技能说明
    /// </summary>
    /// <returns>技能说明(用数据替换掉替换符的说明)</returns>
    public string GetReplacedDescription(int level)
    {
        if (level <= 0)
        {
            return null;
        }
        if (DataList == null || DataList.Count == 0)
        {
            throw new Exception("没有数据,DataList为空");
        }
        if (level > DataList.Count)
        {
            throw new Exception("输入等级:" + level + "大于最高等级" + DataList.Count);
        }

        // 复制说明, 防止修改原有数据
        var result = string.Copy(Description);

        var dataLine = DataList[level - 1];
        for (var i = 0; i < dataLine.Count; i++)
        {
            result = result.Replace("{%" + i + "}", dataLine[i]);
        }

        return result;
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
                result = Utils.GetCompare<float>(op)(SkillDataScope.GetFloat(key).Value, Convert.ToSingle(value.Replace("f","")));
            }
            else if (value.EndsWith("L"))
            {
                // long
                result = Utils.GetCompare<long>(op)(SkillDataScope.GetLong(key).Value, Convert.ToInt64(value));
            }
            else if (value.Equals("true") && value.Equals("false"))
            {
                // bool
                result = Utils.GetCompare<bool>(op)(SkillDataScope.GetBool(key).Value, Convert.ToBoolean(value));
            }
            else
            {
                // int
                result = Utils.GetCompare<int>(op)(SkillDataScope.GetInt(key).Value, Convert.ToInt32(value));
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