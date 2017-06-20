using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class IfFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 条件Name
    /// </summary>
    public string Condition = null;

    /// <summary>
    /// 具体条件
    /// </summary>
    public string[] ConditionArgs = null;

    /// <summary>
    /// 是否break
    /// 如果>0则会break
    /// break时会跳出整个流程, 后面的不再执行
    /// 如果为0则只会影响其下的二级流程
    /// </summary>
    public int IsBreak = 0;


    /// <summary>
    /// 注册条件类型
    /// </summary>
    private static Dictionary<string, Func<FormulaParamsPacker, string[], bool>> registerCondition = new Dictionary<string, Func<FormulaParamsPacker, string[], bool>>()
    {
        // 判断生命
        {"Health", (packer, args) =>
        {
            var min = Convert.ToSingle(args[0]);
            var max = Convert.ToSingle(args[1]);
            var data = packer.ReceiverMenber.ClusterData.AllData.MemberData;
            if (data.TotalHp*max*0.01f >= data.CurrentHP && data.TotalHp*min*0.01f <= data.CurrentHP)
            {
                return true;
            }
            return false;
        }
        },
    };


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    public IfFormulaItem(string[] array)
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
        var isBreak = GetDataOrReplace<int>("IsBreak", array, 1, ReplaceDic);
        var condition = GetDataOrReplace<string>("Condition", array, 2, ReplaceDic);
        var conditionArgs = GetDataOrReplace<string>("ConditionArgs", array, 3, ReplaceDic);

        FormulaType = formulaType;
        IsBreak = isBreak;
        Condition = condition;
        ConditionArgs = conditionArgs.Replace(" ","").Split(',');

    }


    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">行为数据</param>
    /// <returns>行为节点类</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;

        // 数据本地化
        var myCondition = Condition;
        var myConditionArgs = ConditionArgs;

        var check = registerCondition[myCondition];
        // 创建行为
        result = new Formula((callback) =>
        {
            // 如果符合条件则执行子级技能
            // 否则继续
            if (check(paramsPacker, myConditionArgs))
            {
                // 获取子级技能
                if (SubFormulaItem != null)
                {
                    // 执行子级技能
                    var subSkill = new SkillInfo(paramsPacker.SkillNum);
                    subSkill.DataList = paramsPacker.DataList;
                    subSkill.AddFormulaItem(SubFormulaItem);
                    SkillManager.Single.DoShillInfo(subSkill, paramsPacker, true);
                }
                // 执行子技能

            }
            else if (IsBreak > 0)
            {
                // 跳出其后面的所有流程
                result.CanMoveNext = false;
            }

        }, FormulaType);


        return result;
    }


    class ConditionPacker<T>
    {
        public T Arg1;

        public T Arg2;
    }
}