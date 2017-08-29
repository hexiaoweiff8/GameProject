using System;
using System.Collections.Generic;
using System.Linq;



/// <summary>
/// 循环行为节点
/// </summary>
public class ForFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 循环次数
    /// </summary>
    public int LoopTime { get; private set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public ForFormulaItem(string[] array)
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

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        LoopTime = GetDataOrReplace<int>("LoopTime", array, 1);

    }


    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据包装类</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;


        // 替换替换符数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;
        var myLoopTime = LoopTime;

        result = new Formula((callback, scope) =>
        {
            if (SubFormulaItem != null)
            {
                var counter = 0;
                // 子集调用
                Action subCallback = null;
                subCallback = () =>
                {
                    if (counter < myLoopTime)
                    {
                        // 执行子行为链
                        var subSkill = new SkillInfo(paramsPacker.SkillNum);
                        FormulaParamsPackerFactroy.Single.CopyPackerData(paramsPacker, paramsPacker);
                        subSkill.DataList = paramsPacker.DataList;
                        subSkill.AddActionFormulaItem(SubFormulaItem);
                        SkillManager.Single.DoSkillInfo(subSkill, paramsPacker, true, subCallback);
                        counter++;
                    }
                    else
                    {
                        // 结束执行
                        callback();
                    }

                };
                subCallback();
            }
            else
            {
                callback();
            }
        },
            myFormulaType);

        return result;
    }
}