
/// <summary>
/// 触发数据类
/// </summary>
public class TriggerData
{
    /// <summary>
    /// 数据触发类型-技能
    /// </summary>
    public const int TriggerDataTypeSkill = 0;

    /// <summary>
    /// 数据触发类型-buff
    /// </summary>
    public const int TriggerDataTypeBuff = 1;

    /// <summary>
    /// 释放技能单位
    /// </summary>
    public DisplayOwner ReleaseMember { get; set; }

    /// <summary>
    /// 接受技能单位
    /// </summary>
    public DisplayOwner ReceiveMember { get; set; }

    /// <summary>
    /// 技能分类Level1
    /// </summary>
    public TriggerLevel1 TypeLevel1 { get; set; }

    /// <summary>
    /// 技能分类Level2
    /// </summary>
    public TriggerLevel2 TypeLevel2 { get; set; }

    /// <summary>
    /// 伤害量
    /// </summary>
    public float HealthChangeValue { get; set; }

    /// <summary>
    /// 触发类型
    /// 0: 技能
    /// 1: buff
    /// </summary>
    public int TriggerDataType { get; set; }

}