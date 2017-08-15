using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 单位AOE数据
/// </summary>
public class ArmyAOEData
{
    /// <summary>
    /// 兵种ID
    /// </summary>
    public int ArmyID { get; set; }

    /// <summary>
    /// AOE目标
    /// 范围攻击区中心点（1.AOE范围中心点为目标单位、2.AOE范围中心点为发动攻击时目标的座标位置、3.AOE范围中心点为自身、4.AOE范围中心在自身前方）
    /// </summary>
    public int AOEAim { get; set; }

    /// <summary>
    /// AOE区域形状
    /// 范围攻击区形状（1.Round圆形/Sector扇形，2.矩形（矩形中心点需要计算））
    /// </summary>
    public int AOEArea { get; set; }

    /// <summary>
    /// AOE (只有扇形)开口角度
    /// </summary>
    public int AOEAngle { get; set; }

    /// <summary>
    /// AOE半径(只有圆形与扇形)
    /// </summary>
    public float AOERadius { get; set; }

    /// <summary>
    /// AOE宽度(只有矩形
    /// </summary>
    public float AOEWidth { get; set; }

    /// <summary>
    /// AOE高度(只有矩形)
    /// </summary>
    public float AOEHeight { get; set; }

    ///// <summary>
    ///// 子弹模型
    ///// </summary>
    ////public string BulletModel { get; set; }

    ///// <summary>
    ///// 子弹飞行轨迹
    ///// </summary>
    ////public int BulletPath { get; set; }

    ///// <summary>
    ///// 子弹弹道特效
    ///// </summary>
    ////public string Ballistic { get; set; }

    ///// <summary>
    ///// 范围伤害特效
    ///// </summary>
    ////public string DamageEffect { get; set; }

    ///// <summary>
    ///// 范围特效持续时间
    ///// </summary>
    ////public float EffectTime { get; set; }


    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="aoeData">AOE数据</param>
    public ArmyAOEData(armyaoe_cInfo aoeData)
    {
        ArmyID = aoeData.ArmyID;
        AOEAim = aoeData.AOEAim;
        AOEArea = aoeData.AOEArea;
        AOEAngle = aoeData.AOEAngle;
        AOERadius = aoeData.AOERadius;
        AOEWidth = aoeData.AOEWidth;
        AOEHeight = aoeData.AOELength;
//        BulletModel = aoeData.BulletModel;
//        BulletPath = aoeData.BulletPath;
//        Ballistic = aoeData.Ballistic;
//        DamageEffect = aoeData.DamageEffect;
//        EffectTime = aoeData.EffectTime;
    }

}