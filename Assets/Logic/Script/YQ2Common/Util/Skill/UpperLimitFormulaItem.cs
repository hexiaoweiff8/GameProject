using System;
using UnityEngine;
using System.Collections;

/// <summary>
/// 承受伤害上限技能节点
/// </summary>
public class UpperLimitFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 伤害上限值
    /// </summary>
    public float LimitDemage { get; set; }

    public UpperLimitFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }

        var argsCount = 2;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }


        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        LimitDemage = GetDataOrReplace<float>("LimitDemage", array, 1, ReplaceDic);

    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
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

        IFormula result = null;
        // 替换数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var myLimitDemage = LimitDemage;
        var myTrigger = paramsPacker.TriggerData;
       

        result = new Formula((callback, scope) =>
        {
            callback();
        },
        myFormulaType);

        //如果承受伤害大于上限伤害则改变承受伤害
        if ( myTrigger.TypeLevel2 == TriggerLevel2.BeAttack && myTrigger.HealthChangeValue >= myLimitDemage)
        {
            myTrigger.HealthChangeValue = myLimitDemage;
        }
        Debug.Log(myTrigger.HealthChangeValue);

        return result;
    }
}
