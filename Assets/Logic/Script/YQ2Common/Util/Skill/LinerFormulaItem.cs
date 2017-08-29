using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;


/// <summary>
/// 线特效
/// </summary>
public class LinerFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 特效key(或者路径)
    /// </summary>
    public string EffectKey { get; private set; }

    /// <summary>
    /// 释放特效位置
    /// 0: 释放特效单位位置(默认)
    /// 1: 接受单位位置
    /// 2: 目标点选择的位置
    /// </summary>
    public int ReleasePos { get; private set; }

    /// <summary>
    /// 接受特效位置
    /// 0: 释放特效单位位置
    /// 1: 接受单位位置(默认)
    /// 2: 目标点选择的位置
    /// 3: 接收单位(Obj跟随)
    /// </summary>
    public int ReceivePos
    {
        get { return receivePos; }
        set { receivePos = value; }
    }

    /// <summary>
    /// 持续时间
    /// </summary>
    public float DurTime { get; private set; }


    /// <summary>
    /// 接受特效位置
    /// 0: 释放特效单位位置
    /// 1: 接受单位位置(默认)
    /// 2: 目标点选择的位置
    /// 3: 接收单位(Obj跟随)
    /// </summary>
    private int receivePos = 1;



    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据列表</param>
    public LinerFormulaItem(string[] array)
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

        FormulaType = GetDataOrReplace<int>("FormulaType", array, 0);
        EffectKey = GetDataOrReplace<string>("EffectKey", array, 1);
        ReleasePos = GetDataOrReplace<int>("ReleasePos", array, 2);
        ReceivePos = GetDataOrReplace<int>("ReceivePos", array, 3);
        DurTime = GetDataOrReplace<float>("DurTime", array, 4);

    }



    /// <summary>
    /// 生成行为节点
    /// </summary>
    /// <param name="paramsPacker">数据包装类</param>
    /// <returns>行为节点</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        if (paramsPacker == null)
        {
            return null;
        }

        // 替换替换符数据
        ReplaceData(paramsPacker);
        // 数据本地化

        var myFormulaType = FormulaType;
        var myReleasePos = ReleasePos;
        var myReceivePos = ReceivePos;
        IFormula result = null;

        result = new Formula((callback, scope) =>
        {
            // 获取目标位置
            var sourcePos = GetPosByType(myReleasePos, paramsPacker, scope);
            var targetPos = GetPosByType(myReceivePos, paramsPacker, scope);

            EffectBehaviorAbstract effect = null;
            if (ReceivePos == 3)
            {
                effect = EffectsFactory.Single.CreateLinerEffect(EffectKey,
                    // TODO 应该使用挂点
                    paramsPacker.ReleaseMember.ClusterData.transform
                    , paramsPacker.ReceiverMenber.ClusterData.gameObject
                    , DurTime, callback, Utils.EffectLayer);
            }
            else
            {
                effect = EffectsFactory.Single.CreateLinerEffect(EffectKey,
                    ParentManager.Instance().GetParent(ParentManager.BallisticParent).transform,
                    sourcePos, targetPos, DurTime, callback, Utils.EffectLayer);
            }

            effect.Begin();

        }, myFormulaType);



        return result;
    }
}