using System;
using MonoEX;
using UnityEngine;


/// <summary>
/// 点对对象飞行特效行为构建器
/// </summary>
public class PointToObjFormulaItem : AbstractFormulaItem
{
    /// <summary>
    /// 当前数据层级
    /// </summary>
    public int Level { get; private set; }

    /// <summary>
    /// 行为类型
    /// 0: 不等待其执行结束继续
    /// 1: 等待期执行结束调用callback
    /// </summary>
    public int FormulaType { get; private set; }

    /// <summary>
    /// 特效key(或者路径)
    /// </summary>
    public string EffectKey { get; private set; }

    /// <summary>
    /// 飞行速度
    /// </summary>
    public float Speed { get; private set; }

    /// <summary>
    /// 飞行轨迹
    /// </summary>
    public TrajectoryAlgorithmType FlyType { get; private set; }


    /// <summary>
    /// 缩放
    /// </summary>
    private float[] scale = new[] { 1f, 1f, 1f };


    public PointToObjFormulaItem(int formulaType, string effectKey, float speed, TrajectoryAlgorithmType flyType, float[] scale = null)
    {
        FormulaType = formulaType;
        EffectKey = effectKey;
        Speed = speed;
        FlyType = flyType;
        if (scale != null)
        {
            this.scale = scale;
        }
    }


    /// <summary>
    /// 获取行为构建器
    /// </summary>
    /// <returns>构建完成的单个行为</returns>
    public override IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        //UnityEngine.Debug.Log("点对对象");
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
        else if (Speed <= 0)
        {
            errorMsg = "物体飞行速度不合法, <=0";
        }
        else if (paramsPacker.ReceiverMenber == null)
        {
            errorMsg = "弹道特效目标对象为空.";
        }

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }

        IFormula result = new Formula((callback) =>
        {
            // 判断发射与接收位置
            // TODO 父级暂时没有
            EffectsFactory.Single.CreatePointToObjEffect(EffectKey, null, paramsPacker.StartPos,
                                paramsPacker.ReceiverMenber.GameObj, new Vector3(scale[0], scale[1], scale[2]), Speed, FlyType, callback).Begin();
        }, FormulaType);

        return result;
    }
}
