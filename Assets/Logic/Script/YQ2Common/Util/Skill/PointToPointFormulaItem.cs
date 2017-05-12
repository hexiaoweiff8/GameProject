using System;
using UnityEngine;


/// <summary>
/// 点对点飞行特效行为构建器
/// </summary>
public class PointToPointFormulaItem : IFormulaItem
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
    /// 释放特效位置
    /// 0: 释放特效单位(默认)
    /// 1: 接受单位位置
    /// </summary>
    private int releasePos = 0;

    /// <summary>
    /// 接受特效位置
    /// 0: 释放特效单位
    /// 1: 接受单位位置(默认)
    /// </summary>
    private int receivePos = 1;

    /// <summary>
    /// 缩放
    /// </summary>
    private float[] scale = new[] { 1f, 1f, 1f };


    public PointToPointFormulaItem(int formulaType, string effectKey, float speed, int releasePos, int receivePos, TrajectoryAlgorithmType flyType, float[] scale = null)
    {
        FormulaType = formulaType;
        EffectKey = effectKey;
        Speed = speed;
        this.releasePos = releasePos;
        this.receivePos = receivePos;
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
    public IFormula GetFormula(FormulaParamsPacker paramsPacker)
    {
        // UnityEngine.Debug.Log("点对对象");
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

        if (!string.IsNullOrEmpty(errorMsg))
        {
            throw new Exception(errorMsg);
        }
        var tmpRelsPos = releasePos;
        var tmpRecvPos = receivePos;

        IFormula result = new Formula((callback) =>
        {
            // 判断发射与接收位置
            var releasePosition = tmpRelsPos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            var receivePosition = tmpRecvPos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            // TODO 父级暂时没有
            EffectsFactory.Single.CreatePointToPointEffect(EffectKey, null, releasePosition,
                                receivePosition, new Vector3(scale[0], scale[1], scale[2]), Speed, FlyType, callback).Begin();
        }, FormulaType);

        return result;
    }
}
