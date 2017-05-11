using UnityEngine;


/// <summary>
/// 行为参数包装类
/// </summary>
public class FormulaParamsPacker
{
    ///// <summary>
    ///// 技能ID
    ///// </summary>
    //public int SkillNum { get; set; }

    /// <summary>
    /// 初始位置
    /// </summary>
    public Vector3 StartPos { get; set; }

    /// <summary>
    /// 目标位置
    /// </summary>
    public Vector3 TargetPos { get; set; }

    /// <summary>
    /// 起始单位
    /// </summary>
    public GameObject StartObj { get; set; }

    /// <summary>
    /// 目标单位
    /// </summary>
    public GameObject TargetObj { get; set; }




    // --------------------技能实际数据---------------------

    /// <summary>
    /// 目标数量如果为-1则选择范围内所有单位
    /// </summary>
    public int TargetMaxCount
    {
        get { return targetMaxCount; }
        set { targetMaxCount = value; }
    }

    ///// <summary>
    ///// 子集技能ID, 如果为-1则没有子集技能
    ///// </summary>
    //public int NextSkillNum { get; set; }

    ///// <summary>
    ///// 释放技能单位的阵营编号
    ///// </summary>
    //public int SenderCamp { get; set; }

    ///// <summary>
    ///// 单位列表
    ///// </summary>
    //public TargetList<PositionObject> TargetList { get; set; }

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