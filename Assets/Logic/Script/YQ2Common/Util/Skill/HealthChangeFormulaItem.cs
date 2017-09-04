using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 生命值变动行为
/// </summary>
public class HealthChangeFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 伤害/治疗类型
    /// </summary>
    public DemageOrCure DemageOrCure { get; set; }

    /// <summary>
    /// 生命值变动类型
    /// </summary>
    public HealthChangeType HealthChangeType { get; set; }

    /// <summary>
    /// 生命值变更类型
    /// </summary>
    public HealthChangeCalculationType CalculationType { get; set; }

    /// <summary>
    /// 生命值变更目标
    /// 0: 自己
    /// 1: 目标
    /// </summary>
    public int HealthChangeTarget { get; set; }

    /// <summary>
    /// 生命值变动量
    /// </summary>
    public FormulaItemValueComputer Value { get; set; }

    /// <summary>
    /// 生命值变更系数
    /// </summary>
    public FormulaItemValueComputer Coefficient { get; set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 
    /// 0>行为节点类型
    /// 1>特效Key(或path)
    /// 2>飞行速度
    /// 3>飞行方式(0抛物线, 1直线, 2 sin线
    /// 456>缩放
    public HealthChangeFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 7;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成,特效Key,速度,飞行轨迹
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        var healthChangeType = GetDataOrReplace<HealthChangeType>("HealthChangeType", array, 1);
        var demageOrCure = GetDataOrReplace<DemageOrCure>("DemageOrCure", array, 2);
        var healthChangeTarget = GetDataOrReplace<int>("HealthChangeTarget", array, 3);
        var value = GetDataOrReplace<FormulaItemValueComputer>("Value", array, 4);
        var coefficient = GetDataOrReplace<FormulaItemValueComputer>("Coefficient", array, 5);
        var calculationType = GetDataOrReplace<HealthChangeCalculationType>("CalculationType", array, 6);


        FormulaType = formulaType;
        HealthChangeType = healthChangeType;
        DemageOrCure = demageOrCure;
        HealthChangeTarget = healthChangeTarget;
        Value = value;
        CalculationType = calculationType;
        Coefficient = coefficient;
    }



    /// <summary>
    /// 获生命值变动行为节点
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns>生命值变动节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }
        else if (HealthChangeTarget != 0 && HealthChangeTarget != 1)
        {
            errorMsg = "目标标志错误, 应为0或1, 实际值:" + HealthChangeTarget;
        }
        else if ((paramsPacker.ReceiverMenber == null && HealthChangeTarget == 1) ||
            (paramsPacker.ReleaseMember == null))
        {
            errorMsg = "伤害/治疗目标对象为空.";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 替换数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;
        var myHealthChageType = HealthChangeType;
        var myDemageOrCure = DemageOrCure;
        var myValue = Value.GetValue();
        var myCoefficient = Coefficient.GetValue();
        var myHealthChangeTarget = HealthChangeTarget;
        var targetDisPlayOwner = myHealthChangeTarget == 0 ? paramsPacker.ReleaseMember : paramsPacker.ReceiverMenber;
        var myIsNotLethal = paramsPacker.IsNotLethal;

        // 创建行为节点
        result = new Formula((callback, scope) =>
        {
            // 验证数据
            if (targetDisPlayOwner.ClusterData == null)
            {
                return;
            }

            // 计算伤害/治疗量
            var changeValue = 0f;
            // 区分伤害类型, 固定伤害, 计算伤害
            changeValue = HurtResult.GetHurtForSkill(paramsPacker.ReleaseMember, targetDisPlayOwner,
                myDemageOrCure, myHealthChageType, CalculationType, myValue);
            // 伤害系数
            changeValue *= myCoefficient;

            // 创建伤害/治疗事件
            SkillManager.Single.SetTriggerData(new TriggerData()
            {
                HealthChangeValue = changeValue,
                ReceiveMember = paramsPacker.ReleaseMember,
                ReleaseMember = targetDisPlayOwner,
                TypeLevel1 = TriggerLevel1.Fight,
                TypeLevel2 = myDemageOrCure == DemageOrCure.Cure ? TriggerLevel2.BeCure : TriggerLevel2.BeAttack,
                IsNotLethal = myIsNotLethal,
                DemageType = DemageType.SkillAttackDemage
            });
            callback();
        }, myFormulaType);

        return result;
    }

}

/// <summary>
/// 伤害/治疗类型
/// </summary>
public enum DemageOrCure
{
    Demage = 0,         // 伤害
    Cure = 1            // 治疗
}

/// <summary>
/// 伤害类型-技能攻击, 普通攻击
/// </summary>
public enum DemageType
{
    None = 0,
    NormalAttackDemage = 1,
    SkillAttackDemage = 2,
}

/// <summary>
/// 伤害类型-攻击, 被攻击
/// </summary>
public enum AttackOrBeAttach
{
    Attack = 0,
    BeAttach = 1,
}

/// <summary>
/// 生命值变动类型
/// </summary>
public enum HealthChangeType
{
    Fixed = 0,          // 固定值
    Percentage = 1,     // 百分比
}

/// <summary>
/// 生命值变更计算类型
/// </summary>
public enum HealthChangeCalculationType
{
    Fix = 0,        // 固定变更
    Calculation = 1,// 计算变更
}