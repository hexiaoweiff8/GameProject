using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 生命值选择
/// </summary>
public class HealthScopeFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 生命值百分比选择上限
    /// </summary>
    public float HealthUpperLimit { get; private set; }

    /// <summary>
    /// 生命值百分比选择下限
    /// </summary>
    public float HealthLowerLimit { get; private set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据字符串数组</param>
    public HealthScopeFormulaItem(string[] array)
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
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var lower = GetDataOrReplace<float>("HealthLowerLimit", array, 1, ReplaceDic);
        var upper = GetDataOrReplace<int>("HealthUpperLimit", array, 2, ReplaceDic);

        FormulaType = formulaType;
        HealthLowerLimit = lower;
        HealthUpperLimit = upper;
    }

    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        if (paramsPacker == null)
        {
            return null;
        }

        // 数据本地化
        var myUpper = HealthUpperLimit;
        var myLower = HealthLowerLimit;
        var myType = FormulaType;

        result = new Formula((callback) =>
        {
            // 判断单位是否在指定血量百分比内
            //if(paramsPacker.ReceiverMenber)
        }, myType);


        return result;
    }
}