using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// 吸血行为
/// </summary>
public class LifeDrainFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 吸血类型
    /// 0:Absolute   绝对值吸血
    /// 1:Percentage 百分比吸血
    /// </summary>
    public DrainType DrainType { get; private set; }

    /// <summary>
    /// 吸取值
    /// 绝对值吸血按照该值恢复生命
    /// 百分比吸血该值为百分比(1为100%)
    /// </summary>
    public float DrainValue { get; private set; }




    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public LifeDrainFormulaItem(string[] array)
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

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        DrainType = GetDataOrReplace<DrainType>("DrainType", array, 1);
        DrainValue = GetDataOrReplace<float>("DrainValue", array, 2);
    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;

        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 替换数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var myDrainType = DrainType;
        var myDrainValue = DrainValue;

        result = new Formula((callback, scope) =>
        {
            // 计算吸取值
            var drainVal = 0f;
            switch (myDrainType)
            {
                case DrainType.Absolute:
                {
                    drainVal = myDrainValue;
                }
                    break;
                case DrainType.Percentage:
                {
                    drainVal = paramsPacker.TriggerData.HealthChangeValue * myDrainValue;
                }
                    break;
            }

            // 抛出治疗事件
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                HealthChangeValue = drainVal,
                ReceiveMember = paramsPacker.ReleaseMember,
                ReleaseMember = paramsPacker.ReleaseMember,
                TypeLevel1 = TriggerLevel1.Fight,
                TypeLevel2 = TriggerLevel2.BeCure,
                IsNotLethal = true,
                DemageType = DemageType.SkillAttackDemage
            });
        },
            myFormulaType);

        return result;
    }
}


public enum DrainType
{
    Absolute = 0,   // 绝对值
    Percentage = 1, // 百分比
}