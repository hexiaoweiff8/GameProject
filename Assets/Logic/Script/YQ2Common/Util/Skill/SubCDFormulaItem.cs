using System;
using System.Collections.Generic;
using System.Linq;


/// <summary>
/// 减少CD
/// </summary>
public class SubCDFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 减少CD时间
    /// </summary>
    public float SubTime { get; private set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public SubCDFormulaItem(string[] array)
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
        SubTime = GetDataOrReplace<float>("SubTime", array, 1);
    }

    /// <summary>
    /// 获取行为节点
    /// </summary>
    /// <param name="paramsPacker">数据包装类</param>
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
        var mySubTime = SubTime;

        result = new Formula((callback, scope) =>
        {
            // 减少自身主动技能的CD时间
            var skillList = paramsPacker.ReleaseMember.ClusterData.AllData.SkillInfoList;
            foreach (var skill in skillList)
            {
                if (skill.IsActive && !SkillManager.Single.SkillCouldRelease(skill))
                {
                    // 执行减CD
                    SkillManager.Single.SubSkillCD(skill, mySubTime);
                }
            }
        }, myFormulaType);



        return result;
    }
}