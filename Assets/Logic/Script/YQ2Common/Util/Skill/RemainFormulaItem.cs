using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 挂载范围技能(光环/范围持续伤害)
/// </summary>
public class RemainFormulaItem : AbstractFormulaItem
{


    /// <summary>
    /// 目标单位
    /// 0: 自己
    /// 1: 目标单位
    /// 2: 已选目标点
    /// </summary>
    public int Target;

    /// <summary>
    /// 被加载范围技能编号
    /// </summary>
    public int RemainNum;

    /// <summary>
    /// 是否跟随单位
    /// </summary>
    public bool IsFollow;


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public RemainFormulaItem(string[] array)
    {

        if (array == null)
        {
            throw new Exception("数据列表为空");
        }

        var argsCount = 4;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        Target = GetDataOrReplace<int>("Target", array, 1, ReplaceDic);
        RemainNum = GetDataOrReplace<int>("RemainNum", array, 2, ReplaceDic);
        IsFollow = GetDataOrReplace<bool>("IsFollow", array, 3, ReplaceDic);

    }

    /// <summary>
    /// 生成行为链
    /// </summary>
    /// <param name="paramsPacker"></param>
    /// <returns></returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        IFormula result = null;
        string errorMsg = null;
        if (paramsPacker == null)
        {
            errorMsg = "调用参数 paramsPacker 为空.";
        }
        else if (RemainNum <= 0)
        {
            errorMsg = "Remain Id错误";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }
        // 数据替换
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;
        var myTarget = Target;
        var myRemainNum = RemainNum;
        var myIsFollow = IsFollow;

        // 挂载单位
        DisplayOwner member = null;
        var isGetPos = false;
        var posX = 0f;
        var posY = 0f;
        switch (myTarget)
        {
            case 0:
            {
                member = paramsPacker.ReleaseMember;
                posX = member.ClusterData.X;
                posY = member.ClusterData.Y;
                isGetPos = true;
            }
                break;
            case 1:
            {
                member = paramsPacker.ReceiverMenber;
                posX = member.ClusterData.X;
                posY = member.ClusterData.Y;
                isGetPos = true;
            }
                break;
            case 2:
            {
                member = paramsPacker.ReleaseMember;
            }
                break;
        }

        var remain = RemainManager.Single.CreateRemainInfo(myRemainNum, member);
        remain.IsFollow = myIsFollow;

        result = new Formula((callback, scope) =>
        {
            // 继承数据域
            remain.DataScope = scope;

            if (!myIsFollow)
            {
                if (!isGetPos)
                {
                    posX = remain.DataScope.GetFloat(Utils.TargetPointSelectorXKey) ?? 0f;
                    posY = remain.DataScope.GetFloat(Utils.TargetPointSelectorYKey) ?? 0f;
                }

                remain.FixPostion = new Vector2(posX, posY);
            }
            member.ClusterData.AllData.RemainInfoList.Add(remain);
            callback();
        },
        myFormulaType);


        // 返回结果
        return result;
    }
}