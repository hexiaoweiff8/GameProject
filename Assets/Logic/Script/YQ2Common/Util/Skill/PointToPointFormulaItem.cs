using System;
using UnityEngine;


/// <summary>
/// 点对点飞行特效行为构建器
/// </summary>
public class PointToPointFormulaItem : AbstractFormulaItem
{

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

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="formulaType">行为节点类型</param>
    /// <param name="effectKey">特效Key(或path)</param>
    /// <param name="speed">飞行速度</param>
    /// <param name="releasePos">释放位置(0释放者位置,1被释放者位置)</param>
    /// <param name="receivePos">接收位置(0释放者位置,1被释放者位置)</param>
    /// <param name="flyType">飞行方式(0抛物线, 1直线, 2 sin线</param>
    /// <param name="scale">缩放</param>
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
            ScaleX = scale[0];
            ScaleY = scale[1];
            ScaleZ = scale[2];
        }
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="array">数据数组</param>
    /// 
    /// 0>行为节点类型
    /// 1>特效Key(或path)
    /// 2>飞行速度
    /// 3>释放位置(0释放者位置,1被释放者位置)
    /// 4>接收位置(0释放者位置,1被释放者位置)
    /// 5>飞行方式(0抛物线, 1直线, 2 sin线
    /// 678>缩放
    public PointToPointFormulaItem(string[] array)
    {
        if (array == null)
        {
            throw new Exception("数据列表为空");
        }
        var argsCount = 9;
        // 解析参数
        if (array.Length < argsCount)
        {
            throw new Exception("参数数量错误.需求参数数量:" + argsCount + " 实际数量:" + array.Length);
        }
        // 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),命中位置(0放技能方, 1目标方),速度,飞行轨迹, 缩放
        var formulaType = GetDataOrReplace<int>("FormulaType", array, 0, ReplaceDic);
        var effectKey = GetDataOrReplace<string>("EffectKey", array, 1, ReplaceDic);
        var releasePosArg = GetDataOrReplace<int>("Speed", array, 2, ReplaceDic);
        var receivePosArg = GetDataOrReplace<int>("Speed", array, 3, ReplaceDic);
        var speed = GetDataOrReplace<float>("Speed", array, 4, ReplaceDic);
        var flyType = GetDataOrReplace<TrajectoryAlgorithmType>("FlyType", array, 5, ReplaceDic);


        var scaleX = GetDataOrReplace<float>("ScaleX", array, 6, ReplaceDic);
        var scaleY = GetDataOrReplace<float>("ScaleY", array, 7, ReplaceDic);
        var scaleZ = GetDataOrReplace<float>("ScaleZ", array, 8, ReplaceDic);


        FormulaType = formulaType;
        EffectKey = effectKey;
        Speed = speed;
        this.releasePos = releasePosArg;
        this.receivePos = receivePosArg;
        FlyType = flyType;
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

        // 替换替换符数据
        ReplaceData(paramsPacker);

        // 数据本地化
        var myFormulaType = FormulaType;
        var myRelsPos = releasePos;
        var myRecvPos = receivePos;
        var myEffectKey = EffectKey;
        var mySpeed = Speed;
        var myFlyType = FlyType;
        var scaleX = ScaleX;
        var scaleY = ScaleY;
        var scaleZ = ScaleZ;

        IFormula result = new Formula((callback) =>
        {
            // 判断发射与接收位置
            var releasePosition = myRelsPos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            var receivePosition = myRecvPos == 0 ? paramsPacker.StartPos : paramsPacker.TargetPos;
            // TODO 父级暂时没有
            EffectsFactory.Single.CreatePointToPointEffect(myEffectKey, null, releasePosition,
                                receivePosition, new Vector3(scaleX, scaleY, scaleZ), mySpeed, myFlyType, callback, 12).Begin();
        }, myFormulaType);

        return result;
    }

}
