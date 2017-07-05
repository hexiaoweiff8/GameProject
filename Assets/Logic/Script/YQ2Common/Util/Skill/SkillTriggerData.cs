
/// <summary>
/// 触发数据类
/// </summary>
public class TriggerData
{

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
    /// 伤害/治疗量
    /// 如果是伤害则会返回当前值的负值
    /// </summary>
    public float HealthChangeValue
    {
        get
        {
            return healthChangeValue;
        }
        set { healthChangeValue = value; }
    }

    ///// <summary>
    ///// 触发类型
    ///// 0: 技能
    ///// 1: buff
    ///// </summary>
    //public int TriggerDataType { get; set; }

    /// <summary>
    /// 是否buff造成的事件
    /// </summary>
    public bool IsBuff { get; set; }

    /// <summary>
    /// 是否不致死
    /// </summary>
    public bool IsNotLethal { get; set; }

    /// <summary>
    /// 伤害是否被吸收
    /// </summary>
    public bool IsAbsorption { get; set; }

    /// <summary>
    /// 生命值变动量
    /// </summary>
    private float healthChangeValue = 0f;

}