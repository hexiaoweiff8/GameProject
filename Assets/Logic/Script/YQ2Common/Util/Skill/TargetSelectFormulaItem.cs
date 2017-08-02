using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// 目标筛选
/// </summary>
public class TargetSelectFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 权重选择数据Id 
    /// </summary>
    public int TargetSelectDataId = -1;

    /// <summary>
    /// 循环次数
    /// </summary>
    public int RepeatTime = -1;

    /// <summary>
    /// 最大目标数量
    /// </summary>
    public int MaxCount = -1;

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array"></param>
    public TargetSelectFormulaItem(string[] array)
    {

        if (array == null)
        {
            throw new Exception("数据列表为空");
        }

        var argsCount = 4;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        TargetSelectDataId = GetDataOrReplace<int>("TargetSelectDataId", array, 1, ReplaceDic);
        RepeatTime = GetDataOrReplace<int>("RepeatTime", array, 2, ReplaceDic);
        MaxCount = GetDataOrReplace<int>("MaxCount", array, 3, ReplaceDic);
    }

    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据包装类</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {

        IFormula result = null;

        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }

        if (TargetSelectDataId < 0)
        {
            errorMsg = "目标选择数据Id非法:" + TargetSelectDataId;
        }
        if (RepeatTime < 0)
        {
            errorMsg = "重复次数非法:" + RepeatTime;
        }
        if (MaxCount < 0)
        {
            errorMsg = "最大目标数量非法:" + MaxCount;
        }
        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 数据替换
        ReplaceData(paramsPacker);

        // 数据本地化
        var myRepeatTime = RepeatTime;
        var myMaxCount = MaxCount;
        // 获取数据
        var targetSelectData = SData_armyaim_c.Single.GetDataOfID(TargetSelectDataId);

        result = new Formula((callback, scope) =>
        {
            // 检查
            //TargetSelecter.Single.TargetFilter()
        });

        return result;
    }
}