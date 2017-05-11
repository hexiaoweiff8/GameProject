using System;
using MonoEX;


/// <summary>
/// 点对对象飞行特效行为构建器
/// </summary>
public class PointToObjFormulaItem : IFormulaItem
{
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


    public PointToObjFormulaItem(int formulaType, string effectKey, float speed, TrajectoryAlgorithmType flyType)
    {
        FormulaType = formulaType;
        EffectKey = effectKey;
        Speed = speed;
        FlyType = flyType;
    }


    /// <summary>
    /// 获取行为构建器
    /// </summary>
    /// <returns>构建完成的单个行为</returns>
    public IFormula GetFormula(FormulaParamsPacker paramsPacker)
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
        else if (paramsPacker.TargetObj == null)
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
                                paramsPacker.TargetObj, paramsPacker.Scale, Speed, FlyType, callback).Begin();
        }, FormulaType);

        return result;
    }
}
