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
    /// 缩放
    /// </summary>
    private float[] scale = new[] { 1f, 1f, 1f };

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="formulaType">是否等待执行完毕 0 否, 1 是</param>
    /// <param name="effectKey">特效key(或路径)</param>
    /// <param name="targetPos">出现位置</param>
    /// <param name="speed">播放速度</param>
    /// <param name="durTime">持续时间</param>
    /// <param name="scale">缩放</param>
    public PointFormulaItem(int formulaType, string effectKey, int targetPos, float speed, float durTime, float[] scale = null)
    {
        FormulaType = formulaType;
        EffectKey = effectKey;
        TargetPos = targetPos;
        Speed = speed;
        DurTime = durTime;
        if (scale != null)
        {
            this.scale = scale;
        }
    }

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
        var argsCount = 8;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成,特效Key,速度,持续时间
        var formulaType = Convert.ToInt32(array[0]);
        var effectKey = array[1];
        var targetPos = Convert.ToInt32(array[2]);
        var speed = Convert.ToSingle(array[3]);
        var durTime = Convert.ToSingle(array[4]);

        float[] scale = new float[3];
        scale[0] = Convert.ToSingle(array[5]);
        scale[1] = Convert.ToSingle(array[6]);
        scale[2] = Convert.ToSingle(array[7]);

        FormulaType = formulaType;
        EffectKey = effectKey;
        TargetPos = targetPos;
        Speed = speed;
        DurTime = durTime;
        this.scale = scale;
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

        // 数据本地化
        var myFormulaType = FormulaType;
        var myTargetPos = TargetPos;
        var myEffectKey = EffectKey;
        var myDurTime = DurTime;
        var mySpeed = Speed;
        var myScale = scale;

        IFormula result = new Formula((callback) =>
        {
            //Debug.Log("Point");
            var pos = myTargetPos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            // 判断发射与接收位置
            EffectsFactory.Single.CreatePointEffect(myEffectKey, null, pos, new Vector3(myScale[0], myScale[1], myScale[2]), myDurTime, mySpeed, callback).Begin();
        }, myFormulaType);

        return result;
    }
}