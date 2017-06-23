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

        // 数据本地化
        var myBuffTarget = BuffTarget;
        var myBuffNum = BuffNum;
        var targetDisplayOwner = myBuffTarget == 0 ? paramsPacker.ReleaseMember : paramsPacker.ReceiverMenber;
        // 创建新buff
        var buffInfo = BuffManager.Instance().CreateBuffInfo(myBuffNum, targetDisplayOwner, paramsPacker.ReleaseMember);
        // buff 的释放者
        buffInfo.ReleaseMember = paramsPacker.ReleaseMember;
        if (buffInfo == null)
        {
            throw new Exception("Buff:" + BuffNum + "不存在");
        }
        result = new Formula((callback) =>
        {
            // 向目标身上挂载buff
            BuffManager.Instance().DoBuff(buffInfo, BuffDoType.Attach);
        },
        FormulaType);

        return result;
    }
}