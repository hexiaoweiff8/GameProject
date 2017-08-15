using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// 兵种类型数据类
/// </summary>
public class ArmyTypeData
{
    /// <summary>
    /// 兵种ID
    /// </summary>
    public int ArmyId { get; set; }

    /// <summary>
    /// 兵种类型
    /// </summary>
    public short ArmyType { get; set; }

    /// <summary>
    /// 自身空地属性
    /// </summary>
    public short GeneralType { get; set; }

    /// <summary>
    /// 阵营
    /// </summary>
    public short Camp { get; set; }

    /// <summary>
    /// 是否对空
    /// </summary>
    public short IsAntiAir { get; set; }

    /// <summary>
    /// 是否对地
    /// </summary>
    public short IsAntiSurface { get; set; }

    /// <summary>
    /// 是否反隐
    /// </summary>
    public short IsAntiHide { get; set; }

    /// <summary>
    /// 是否对群
    /// </summary>
    public short IsAntiGroup { get; set; }

    /// <summary>
    /// 是否隐形单位
    /// </summary>
    public short IsHide { get; set; }

    /// <summary>
    /// 是否为群体单位
    /// </summary>
    public short IsGroup { get; set; }

    /// <summary>
    /// 单位费用
    /// </summary>
    public int SingleCost { get; set; }

    /// <summary>
    /// 初始化数据
    /// </summary>
    public ArmyTypeData(UnitFightData_cInfo unitFightData)
    {
        ArmyId = unitFightData.ArmyID;
        ArmyType = unitFightData.ArmyType;
        GeneralType = unitFightData.GeneralType;
        IsAntiAir = unitFightData.AntiAir;
        IsAntiSurface = unitFightData.AntiSurface;
        IsAntiHide = unitFightData.AntiHide;
        IsAntiGroup = unitFightData.AntiGroup;
        IsHide = unitFightData.Hide;
        IsGroup = unitFightData.Group;
        SingleCost = unitFightData.CostPerUnit;
    }
}