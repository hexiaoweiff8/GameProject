using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 挂载buff行为
/// </summary>
public class BuffFormulaItem : AbstractFormulaItem
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
    /// <param name="array">数据数组</param>
    public BuffFormulaItem(string[] array)
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

        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var buffNum = GetDataOrReplace<int>("BuffNum", array, 1, ReplaceDic);
        var buffTarget = GetDataOrReplace<int>("BuffTarget", array, 2, ReplaceDic);

        FormulaType = formulaType;
        BuffNum = buffNum;
        BuffTarget = buffTarget;
    }



    /// <summary>
    /// 生成buff挂载行为
    /// </summary>
    /// <param name="paramsPacker">数据</param>
    /// <returns>挂载行为</returns>
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
        var myBuffTarget = BuffTarget;
        var myBuffNum = BuffNum;
        var targetDisplayOwner = myBuffTarget == 0 ? paramsPacker.ReleaseMember : paramsPacker.ReceiverMenber;
        // 创建新buff
        var buffInfo = BuffManager.Single.CreateBuffInfo(myBuffNum, targetDisplayOwner, paramsPacker.ReleaseMember);

        // 写入数据


        // buff 的释放者
        buffInfo.ReleaseMember = paramsPacker.ReleaseMember;
        if (buffInfo == null)
        {
            throw new Exception("Buff:" + BuffNum + "不存在");
        }
        result = new Formula((callback, scope) =>
        {
            // 继承数据域
            buffInfo.DataScope = scope;
            // 向目标身上挂载buff
            // 并执行buffAttach
            BuffManager.Single.DoBuff(buffInfo, BuffDoType.Attach, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buffInfo.ReleaseMember, buffInfo.ReceiveMember, buffInfo, 1, buffInfo.IsNotLethal));
            callback();
        },
        FormulaType);

        return result;
    }
}