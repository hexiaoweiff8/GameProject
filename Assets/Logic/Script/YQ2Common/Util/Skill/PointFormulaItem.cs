using System;
using UnityEngine;


/// <summary>
/// 点特效
/// </summary>
public class PointFormulaItem : AbstractFormulaItem
{

    /// <summary>
    /// 特效key(或者路径)
    /// </summary>
    public string EffectKey { get; private set; }

    /// <summary>
    /// 特效出现位置
    /// 0: 释放者位置
    /// 1: 被释放者位置
    /// 2: 目标点选择的位置
    /// </summary>
    public int TargetPos { get; private set; }

    /// <summary>
    /// 飞行速度
    /// </summary>
    public float Speed { get; private set; }

    /// <summary>
    /// 持续时间
    /// </summary>
    public float DurTime { get; private set; }

    /// <summary>
    /// X轴缩放
    /// </summary>
    public float ScaleX { get; private set; }

    /// <summary>
    /// Y轴缩放
    /// </summary>
    public float ScaleY { get; private set; }

    /// <summary>
    /// Z轴缩放
    /// </summary>
    public float ScaleZ { get; private set; }


    ///// <summary>
    ///// 初始化
    ///// </summary>
    ///// <param name="formulaType">是否等待执行完毕 0 否, 1 是</param>
    ///// <param name="effectKey">特效key(或路径)</param>
    ///// <param name="targetPos">出现位置</param>
    ///// <param name="speed">播放速度</param>
    ///// <param name="durTime">持续时间</param>
    ///// <param name="scale">缩放</param>
    //public PointFormulaItem(int formulaType, string effectKey, int targetPos, float speed, float durTime, float[] scale = null)
    //{
    //    FormulaType = formulaType;
    //    EffectKey = effectKey;
    //    TargetPos = targetPos;
    //    Speed = speed;
    //    DurTime = durTime;
    //    if (scale != null && scale.Length == 3)
    //    {
    //        ScaleX = scale[0];
    //        ScaleY = scale[1];
    //        ScaleZ = scale[2];
    //    }
    //}

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 0>是否等待执行完毕 0 否, 1 是
    /// 1>特效key(或路径)
    /// 2>出现位置
    /// 3>播放速度
    /// 4>持续时间
    /// 567>缩放
    public PointFormulaItem(string[] array)
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
        // 是否等待完成,特效Key,目标位置,持续时间
        // 如果该项值是以%开头的则作为替换数据
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var effectKey = GetDataOrReplace<string>("EffectKey", array, 1, ReplaceDic);
        var targetPos = GetDataOrReplace<int>("TargetPos", array, 2, ReplaceDic);
        //var speed = GetDataOrReplace<float>("Speed", array, 3, ReplaceDic);
        var durTime = GetDataOrReplace<float>("DurTime", array, 3, ReplaceDic);

        var scaleX = GetDataOrReplace<float>("ScaleX", array, 4, ReplaceDic);
        var scaleY = GetDataOrReplace<float>("ScaleY", array, 5, ReplaceDic);
        var scaleZ = GetDataOrReplace<float>("ScaleZ", array, 6, ReplaceDic);

        FormulaType = formulaType;
        EffectKey = effectKey;
        TargetPos = targetPos;
        //Speed = speed;
        DurTime = durTime;
        ScaleX = scaleX;
        ScaleY = scaleY;
        ScaleZ = scaleZ;
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
        else if (EffectKey == null)
        {
            errorMsg = "特效Key(或路径)为空.";
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
        var myEffectKey = EffectKey;
        var myDurTime = DurTime;
        var mySpeed = Speed;
        var scaleX = ScaleX;
        var scaleY = ScaleY;
        var scaleZ = ScaleZ;
        IFormula result = new Formula((callback, scope) =>
        {
            var pos = GetPosByType(myTargetPos, paramsPacker, scope);
            // 判断发射与接收位置
            EffectsFactory.Single.CreatePointEffect(myEffectKey, null, pos, new Vector3(scaleX, scaleY, scaleZ), myDurTime, mySpeed, callback, Utils.EffectLayer).Begin();
        }, myFormulaType);

        return result;
    }
}