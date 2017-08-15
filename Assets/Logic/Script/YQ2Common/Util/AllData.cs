using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 数据持有类 隶属于ClusterData, 所有数据放入该类
/// </summary>
public class AllData : ISelectWeightDataHolder
{
    /// <summary>
    /// 目标筛选数据
    /// </summary>
    public VOBase MemberData { get; set; }

    /// <summary>
    /// 目标选择权重数据
    /// </summary>
    public SelectWeightData SelectWeightData { get; set; }

    /// <summary>
    /// 单位AOE数据
    /// </summary>
    public ArmyAOEData AOEData { get; set; }

    /// <summary>
    /// 单位特效数据
    /// </summary>
    public EffectData EffectData { get; set; }

    /// <summary>
    /// 单位类型数据
    /// </summary>
    public ArmyTypeData ArmyTypeData { get; set; }

    /// <summary>
    /// 技能列表
    /// </summary>
    public IList<SkillInfo> SkillInfoList { get; set; }

    /// <summary>
    /// buff列表
    /// </summary>
    public IList<BuffInfo> BuffInfoList = new List<BuffInfo>();

    /// <summary>
    /// 光环列表
    /// </summary>
    public IList<RemainInfo> RemainInfoList = new List<RemainInfo>();

}