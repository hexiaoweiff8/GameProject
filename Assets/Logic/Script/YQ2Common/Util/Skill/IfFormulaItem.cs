using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class IfFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 条件Name
    /// </summary>
    public string Condition { get; private set; }

    /// <summary>
    /// 具体条件
    /// </summary>
    public string ConditionArgs { get; private set; }

    /// <summary>
    /// 是否break
    /// 如果>0则会break
    /// break时会跳出整个流程, 后面的不再执行
    /// 如果为0则只会影响其下的二级流程
    /// </summary>
    public int IsBreak { get; private set; }


    /// <summary>
    /// 注册条件类型
    /// </summary>
    private static Dictionary<string, Func<FormulaParamsPacker, string[], bool>> registerCondition = new Dictionary<string, Func<FormulaParamsPacker, string[], bool>>()
    {
        // 判断生命(半分比, 绝对值)
        {
            "Health", (packer, args) =>
            {
                var min = Convert.ToSingle(args[0]);
                var max = Convert.ToSingle(args[1]);
                var data = packer.ReceiverMenber.ClusterData.AllData.MemberData;
                if (data.TotalHp*max*0.01f >= data.CurrentHP - 1 && data.TotalHp*min*0.01f <= data.CurrentHP + 1)
                {
                    return true;
                }
                return false;
            }
        },
        // 阵营
        {
            "Camp", (packer, args) =>
            {
                if (!args.Any()) return false;
                var targetCamp = packer.ReceiverMenber.ClusterData.AllData.MemberData.Camp;
                return args.Any(arg => Convert.ToInt32(arg) == targetCamp);
            }
        },
        // 空地建筑
        {
            "GeneralType", (packer, args) =>
            {
                if (!args.Any()) return false;
                var generalType = packer.ReceiverMenber.ClusterData.AllData.MemberData.GeneralType;
                return args.Any(arg => Convert.ToInt32(arg) == generalType);
            }
        },
        // 隐形
        {
            "IsHide", (packer, args) =>
            {
                if (!args.Any()) return false;
                var isHide = packer.ReceiverMenber.ClusterData.AllData.MemberData.IsHide;
                return args.Any(arg => Convert.ToBoolean(arg) == isHide);
            }
        },
        // 种族
        {
            "ArmyType", (packer, args) =>
            {
                if (!args.Any()) return false;
                var armyType = packer.ReceiverMenber.ClusterData.AllData.MemberData.ArmyType;
                return args.Any(arg => Convert.ToInt32(arg) == armyType);
            }
        },
        // 是否机械
        {
            "IsMechanic", (packer, args) =>
            {
                if (!args.Any()) return false;
                var isMechanic = packer.ReceiverMenber.ClusterData.AllData.MemberData.IsMechanic;
                return args.Any(arg => Convert.ToBoolean(arg) == isMechanic);
            }
        },
        // 是否近战
        {
            "IsMelee", (packer, args) =>
            {
                if (!args.Any()) return false;
                var isMelee = packer.ReceiverMenber.ClusterData.AllData.MemberData.IsMelee;
                return args.Any(arg => Convert.ToBoolean(arg) == isMelee);
            }
        },
        // 是否是XX召唤生物(具体类型ID)
        {
            "Summon", (packer, args) =>
            {
                if (!args.Any()) return false;
                if (packer.ReceiverMenber.ClusterData.AllData.MemberData.IsSummon)
                {
                    var armyId = packer.ReceiverMenber.ClusterData.AllData.MemberData.ArmyID;
                    return args.Any(arg => Convert.ToInt32(arg) == armyId); 
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

        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        var isBreak = GetDataOrReplace<int>("IsBreak", array, 1);
        var condition = GetDataOrReplace<string>("Condition", array, 2);
        var conditionArgs = GetDataOrReplace<string>("ConditionArgs", array, 3);

        FormulaType = formulaType;
        IsBreak = isBreak;
        Condition = condition;
        ConditionArgs = conditionArgs;

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
        var myConditionArgs = ConditionArgs.Replace(" ", "").Split('_');

        var check = registerCondition[myCondition];
        // 创建行为
        result = new Formula((callback, scope) =>
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
                    subSkill.AddActionFormulaItem(SubFormulaItem);
                    SkillManager.Single.DoSkillInfo(subSkill, paramsPacker, true);
                }
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