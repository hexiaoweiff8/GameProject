using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;


/// <summary>
/// 净化效果
/// </summary>
internal class CleanBuffFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 目标点
    /// 0: 自己
    /// 1: 目标
    /// </summary>
    public int TargetPos { get; private set; }

    /// <summary>
    /// 清除类型
    /// 0: 清除正面Buff
    /// 1: 清除负面Buff
    /// 2: 清除所有Buff
    /// </summary>
    public int CleanType { get; private set; }


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>单元行为类型(0: 不等待完成, 1: 等待其执行完毕)
    /// 1>目标点

    public CleanBuffFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 3;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        var targetPos = GetDataOrReplace<int>("TargetPos", array, 1);
        var cleanType = GetDataOrReplace<int>("CleanType", array, 2);

        FormulaType = formulaType;
        TargetPos = targetPos;
        CleanType = cleanType;
    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }

        // 替换替换符数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myTargetPos = TargetPos;
        var myCleanType = CleanType;
        var member = paramsPacker.ReleaseMember;
        var target = paramsPacker.ReceiverMenber;
        var myFormulaType = FormulaType;

        if (member == null || member.GameObj == null || member.ClusterData == null)
        {
            return null;
        }

        IFormula result = new Formula((callback, scope) =>
        {
            var tmpTarget = member;
            if (myTargetPos == 1)
            {
                tmpTarget = target;
            }
            for (int i = 0; i < tmpTarget.ClusterData.AllData.BuffInfoList.Count; i++)
            {
                var tmpBuff = tmpTarget.ClusterData.AllData.BuffInfoList[i];
                    if (!tmpBuff.IsCouldNotClear
                        && ((myCleanType == 0 && tmpBuff.IsBeneficial)
                        || myCleanType == 1 && !tmpBuff.IsBeneficial
                        || myCleanType == 2))
                    {
                        tmpTarget.ClusterData.AllData.BuffInfoList.Remove(tmpBuff);
                    }
                }
            callback();
        }, myFormulaType);

        return result;
    }
}