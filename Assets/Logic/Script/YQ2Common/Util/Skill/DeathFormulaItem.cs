using UnityEngine;
using System;

/// <summary>
/// 死亡节点
/// </summary>
public class DeathFormulaItem : AbstractFormulaItem
{

      /// <summary>
    /// 特效出现位置
    /// 0: 释放者位置
    /// 1: 被释放者位置
    /// 2: 目标点选择的位置
    /// </summary>
    public int TargetPos { get;private set; }


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>是否等待执行完毕 0 否, 1 是
    /// 1>目标位置
    public DeathFormulaItem(string[] array)
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
        // 是否等待完成,特效Key,目标位置,持续时间
        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);

        var targetPos = GetDataOrReplace<int>("TargetPos", array, 1, ReplaceDic);


        FormulaType = formulaType;

        TargetPos = targetPos;

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
  
        IFormula result = new Formula((callback, scope) =>
        {

            if (myTargetPos == 0)//自己死亡
            {
                paramsPacker.ReleaseMember.ClusterData.AllData.MemberData.CurrentHP = -9999;
            }
            else if (myTargetPos == 1)//被释放着死亡
            {
                paramsPacker.ReceiverMenber.ClusterData.AllData.MemberData.CurrentHP = -9999;
            }
 
        //    var pos = GetPosByType(1, paramsPacker, scope);
        //    var display = FightUnitFactory.CreateUnit(3, new CreateActorParam(pos.x, pos.z, level)
        //    {
        //        SoldierID = ID*1000 + level;
        //    });
            
        //display.ClusterData.Begin();

            callback();

        }, myFormulaType);

        return result;
    }
}