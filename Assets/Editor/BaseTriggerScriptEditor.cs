using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;


/// <summary>
/// 脚本编辑器数据窗口base
/// </summary>
public abstract class BaseTriggerScriptEditor : EditorWindow
{
    /// <summary>
    /// 单例
    /// </summary>
    //protected static SkillTriggerScriptEditor instance = null;

    /// <summary>
    /// 行为窗口内容列表
    /// </summary>
    protected static List<string>[] ParamTitles;

    /// <summary>
    /// data窗口内容列表
    /// </summary>
    protected static List<string>[] DataParamTitles;

    /// <summary>
    /// 参数类型 1: 触发器 2: 数据
    /// </summary>
    protected int ParamsType = 1;

    /// <summary>
    /// 类型事件
    /// </summary>
    protected TriggerType TriggerType = TriggerType.None;

    /// <summary>
    /// 参数
    /// </summary>
    protected string[] Params;

    /// <summary>
    /// 数据类型
    /// </summary>
    protected DataType DataType = DataType.LevelData;


    protected BaseScriptEditor scriptEditor;


    protected static BaseTriggerScriptEditor TriggerScriptEditor;


    /// <summary>
    /// 
    /// </summary>
    /// <param name="scriptEditor"></param>
    /// <param name="triggerType"></param>
    /// <param name="pos"></param>
    public static void ShowTriggerScriptWindow(BaseScriptEditor scriptEditor, TriggerType triggerType, Rect pos)
    {
        var window = TriggerScriptEditor;
        window.InitParams();
        window.scriptEditor = scriptEditor;
        window.ParamsType = 1;
        window.TriggerType = triggerType;
        window.Params = new string[ParamTitles[(int)triggerType].Count];

        float width = 500;
        float height = 20 * (ParamTitles[(int)triggerType].Count + 1);
        float left = pos.center.x - width / 2;
        float top = pos.center.y - height / 2;
        window.position = new Rect(left, top, width, height);
        window.ShowPopup();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="scriptEditor"></param>
    /// <param name="dataType"></param>
    /// <param name="pos"></param> 
    public static void ShowDataScriptWindow(BaseScriptEditor scriptEditor, DataType dataType, Rect pos)
    {
        var window = TriggerScriptEditor;
        window.InitParams();
        window.scriptEditor = scriptEditor;
        window.ParamsType = 2;
        window.DataType = dataType;
        window.Params = new string[DataParamTitles[(int)dataType].Count];

        float width = 500;
        float height = 20 * (DataParamTitles[(int)dataType].Count + 1);
        float left = pos.center.x - width / 2;
        float top = pos.center.y - height / 2;
        window.position = new Rect(left, top, width, height);
        window.ShowPopup();
    }

    /// <summary>
    /// 初始化参数内容
    /// </summary>
    public abstract void InitParams();

    /// <summary>
    /// 创建脚本内容
    /// </summary>
    /// <returns></returns>
    public abstract string ConnectParams();


    public static void GetIns()
    {
        TriggerScriptEditor = new BuffTriggerScriptEditor();
    }

}



/// <summary>
/// 事件类型
/// </summary>
public enum TriggerType
{
    None = 0,
    // 子级功能左右括号
    LeftBracket = 1,
    RightBracket = 2,
    //PlayAnimation,
    //SingleDamage,
    PointToPoint = 3,
    PointToObj = 4,
    Point = 5,
    CollisionDetection = 6,
    SlideCollisionDetection = 7,
    Audio = 8,
    Buff = 9,
    HealthChange = 10,
    Move = 11,
    Skill = 12,
    If = 13,
    ResistDemage = 14,
}

/// <summary>
/// 技能数据类型
/// </summary>
public enum DataType
{
    LevelData = 0,      // 技能等级数据
    CDTime = 1,         // 技能CD时间
    CDGroup = 2,        // 技能CD组
    ReleaseTime = 3,    // 技能可释放次数
    Description = 4,    // 技能描述
    Icon = 5,           // 技能Icon
    TriggerLevel1 = 6,
    TriggerLevel2 = 7,
    TickTime = 8,
    ChangeData = 9,

    // -----------buff特有---------
    BuffTime,
    BuffType,
    DetachTriggerLevel1,
    DetachTriggerLevel2,
    BuffLevel,
    BuffGroup,
    IsBeneficial,
    DetachQualified,
    IsDeadDisappear,
    IsNotLethal,

}