using System;
using UnityEngine;
using System.Collections;

/// <summary>
/// 免疫死亡技能节点
/// </summary>
public class ImmuneToDeathFormulaItem : AbstractFormulaItem
{




    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>是否等待执行完毕 0 否, 1 是
    /// 1>目标位置
    public ImmuneToDeathFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 1;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成,特效Key,目标位置,持续时间
        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);


        FormulaType = formulaType;


    }


    /// <summary>
    /// 获取行为构建器
    /// </summary>
    /// <returns>构建完成的单个行为</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        // 验证数据正确, 如果有问题直接抛错误
        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }
        Debug.Log("免疫致命攻击");

        // 替换替换符数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;

        IFormula result = new Formula((callback, scope) =>
        {
            callback();

        }, myFormulaType);


        if (paramsPacker.ReceiverMenber.ClusterData.AllData.MemberData.CurrentHP <= 0)
        {
            paramsPacker.ReceiverMenber.ClusterData.AllData.MemberData.CurrentHP = 1;
            paramsPacker.TriggerData.HealthChangeValue = 0;
        }


        return result;
    }
}
