using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 子集技能技能行为单位
/// </summary>
public class SkillFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 行为节点类型
    /// </summary>
    public int FormulaType { get; private set; }

    /// <summary>
    /// 技能编号
    /// </summary>
    public int SkillNum { get; private set; }


    /// <summary>
    /// 初始化函数
    /// </summary>
    /// <param name="formulaType">行为类型(0不等待完成, 1等待完成)</param>
    /// <param name="skillNum">技能编号</param>
    public SkillFormulaItem(int formulaType, int skillNum)
    {
        FormulaType = formulaType;
        SkillNum = skillNum;
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>行为类型(0不等待完成, 1等待完成)
    /// 1>技能编号
    /// 2>技能接收方(0: 释放者, 1: 被释放者)
    public SkillFormulaItem(string[] array)
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
        // 解析参数
        // 是否等待完成, 技能编号, 技能未接收方(0: 释放者, 1: 被释放者)
        var formulaType = Convert.ToInt32(array[0]);
        var skillNum = Convert.ToInt32(array[1]);

        FormulaType = formulaType;
        SkillNum = skillNum;
    }

    /// <summary>
    /// 获取技能行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }
        // 对上一级选出的目标列表释放
        IFormula result = null;

        // 数据本地化
        var myFormulaType = FormulaType;
        var mySkillNum = SkillNum;

        result = new Formula((callback) =>
        {
            // 数据依靠传递
            SkillManager.Single.DoSkillNum(mySkillNum, paramsPacker);
            callback();
        }, myFormulaType);

        return result;
    }
}