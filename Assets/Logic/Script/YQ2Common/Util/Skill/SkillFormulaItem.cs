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
    /// 当前数据层级
    /// </summary>
    public int Level { get; private set; }

    /// <summary>
    /// 行为节点类型
    /// </summary>
    public int FormulaType { get; private set; }

    /// <summary>
    /// 技能编号
    /// </summary>
    public int SkillNum { get; private set; }

    /// <summary>
    /// 接收技能位置
    /// 0: 释放者, 1: 被释放者
    /// </summary>
    public int ReceivePos { get; private set; }



    /// <summary>
    /// 初始化函数
    /// </summary>
    /// <param name="skillNum">技能编号</param>
    public SkillFormulaItem(int skillNum)
    {
        SkillNum = skillNum;
    }

    /// <summary>
    /// 获取技能行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        // 对上一级选出的目标列表释放
        IFormula result = null;

        // TODO 上级数据的传递?
        // 从堆栈中获取当前一级的数据
        // 数据如何分级


        return result;
    }
}