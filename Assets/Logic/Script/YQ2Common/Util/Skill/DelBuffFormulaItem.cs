using System;
using System.Collections.Generic;
using System.Linq;


public class DelBuffFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// buff目标单位
    /// 0: 自己
    /// 1: 目标单位
    /// </summary>
    public int BuffTarget { get; private set; }

    /// <summary>
    /// buff的编号
    /// </summary>
    public int BuffNum { get; private set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public DelBuffFormulaItem(string[] array)
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

        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        var buffNum = GetDataOrReplace<int>("BuffNum", array, 1);
        var buffTarget = GetDataOrReplace<int>("BuffTarget", array, 2);

        FormulaType = formulaType;
        BuffNum = buffNum;
        BuffTarget = buffTarget;
    }

    /// <summary>
    /// 生成行为节点
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
        else if (BuffTarget != 0 && BuffTarget != 1)
        {
            errorMsg = "buff目标 不合法.";
        }
        else if (BuffNum <= 0)
        {
            errorMsg = "buff Id错误";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 替换数据
        ReplaceData(paramsPacker);
        // 数据本地化
        var myFormulaType = FormulaType;
        var myBuffTarget = BuffTarget;
        var myBuffNum = BuffNum;
        var targetDisplayOwner = myBuffTarget == 0 ? paramsPacker.ReleaseMember : paramsPacker.ReceiverMenber;

        result = new Formula((callback, scope) =>
        {
            BuffInfo[] buffInfoList = null;
            if (targetDisplayOwner != null && targetDisplayOwner.ClusterData != null)
            {
                // 获取buff
                buffInfoList =
                    targetDisplayOwner.ClusterData.AllData.BuffInfoList.Where(buff => buff.Num == myBuffNum).ToArray();
            }
            if (buffInfoList != null)
            {
                foreach (var buff in buffInfoList)
                {
                    BuffManager.Single.DoBuff(buff, BuffDoType.Detach,
                        FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buff.ReleaseMember, buff.ReceiveMember,
                            buff, 1, buff.IsNotLethal));
                }
            }
            callback();
        },
            myFormulaType);



        return result;
    }
}