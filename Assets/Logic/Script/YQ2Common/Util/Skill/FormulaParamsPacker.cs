using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// 行为参数包装类
/// </summary>
public class FormulaParamsPacker
{
    /// <summary>
    /// 技能编号
    /// </summary>
    public int SkillNum { get; set; }

    /// <summary>
    /// 被释放技能等级
    /// </summary>
    public int SkillLevel { get; set; }

    /// <summary>
    /// 数据list
    /// </summary>
    public List<List<string>> DataList { get; set; }

    /// <summary>
    /// 初始位置
    /// </summary>
    public Vector3 StartPos { get; set; }

    /// <summary>
    /// 目标位置
    /// </summary>
    public Vector3 TargetPos { get; set; }

    /// <summary>
    /// 技能释放单位
    /// </summary>
    public DisplayOwner ReleaseMember { get; set; }

    /// <summary>
    /// 技能接受单位
    /// </summary>
    public DisplayOwner ReceiverMenber { get; set; }


    /// <summary>
    /// 目标数量如果为-1则选择范围内所有单位
    /// </summary>
    public int TargetMaxCount
    {
        get { return targetMaxCount; }
        set { targetMaxCount = value; }
    }

    private int targetMaxCount = -1;
}

/// <summary>
/// 图形类型
/// </summary>
public enum GraphicType
{
    Circle = 0,     // 圆
    Rect,   // 举行
    Sector      // 扇形
}