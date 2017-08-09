using UnityEngine;
using System;

/// <summary>
/// 召唤单位节点技能
/// </summary>
public class SummonedFormulaItem : AbstractFormulaItem
{


    /// <summary>
    /// 单位出现位置
    /// 0 释放着位置
    /// 1 被释放者位置
    /// 2 目标点选择的位置
    /// </summary>
    public int TargetPos { get; private set; }
    /// <summary>
    /// 召唤单位类型
    /// </summary>
    public int UnitType { get; private set; }
    /// <summary>
    /// 召唤单位ID
    /// </summary>
    public int UnitID { get; private set; }
    /// <summary>
    /// 召唤单位等级
    /// </summary>
    public int Level { get; private set; }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0> 是否等待执行完毕 0 否 ，1 是
    /// 1> 出现位置
    /// 2> 召唤单位类型(参考ObjectID.ObjectType)
    /// 3> 单位ID
    /// 4> 等级
    public SummonedFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 5;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成,特效Key,目标位置,持续时间
        // 如果该项值是以%开头的则作为替换数据

        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var targetPos = GetDataOrReplace<int>("TargetPos", array, 1, ReplaceDic);
        var unitType = GetDataOrReplace<int>("UnitType", array, 2, ReplaceDic);
        var unitID = GetDataOrReplace<int>("UnitID", array, 3, ReplaceDic);
        var level = GetDataOrReplace<int>("Level", array, 4, ReplaceDic);


        FormulaType = formulaType;
        TargetPos = targetPos;
        UnitType = unitType;
        UnitID = unitID;
        Level = level;

    }

    /// <summary>
    /// 获取行为构建器
    /// </summary>
    /// <returns>构建完成的单个行为</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        // 验证数据正确, 如果有问题直接抛错误
        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }
        

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        // 替换替换符数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;
        var myTargetPos = TargetPos;
        var myUnitType = UnitType;
        var myUnitID = UnitID;
        var myLevel = Level;
        

        IFormula result = new Formula((callback, scope) =>
        {

            var pos = GetPosByType(myTargetPos, paramsPacker, scope);
            DisplayOwner display;
            try
            {
                display = FightUnitFactory.CreateUnit(myUnitType, new CreateActorParam(pos.x, pos.z, myLevel)
                {
                    SoldierID = myUnitID*1000 + myLevel
                });
                display.ClusterData.Begin();
                display.ClusterData.ContinueMove();
            }
            catch (Exception e)
            {
                Debug.LogError(e);
                throw;
            }

            callback();

        }, myFormulaType);

        return result;
    }
}
