using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 技能触发数据类
/// </summary>
public class SkillTriggerData
{
    /// <summary>
    /// 技能类列表
    /// </summary>
    //public List<SkillInfo> SkillInfoList { get; set; }

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
    public SkillTriggerLevel1 TypeLevel1 { get; set; }

    /// <summary>
    /// 技能分类Level2
    /// </summary>
    public SkillTriggerLevel2 TypeLevel2 { get; set; }

    /// <summary>
    /// 伤害量
    /// </summary>
    public float HealthChangeValue { get; set; }

}