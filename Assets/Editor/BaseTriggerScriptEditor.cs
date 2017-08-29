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

    public static int WinType = -1;
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
    protected int MyDataType = 0;


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
    public static void ShowDataScriptWindow(BaseScriptEditor scriptEditor, int dataType, Rect pos)
    {
        var window = TriggerScriptEditor;
        window.InitParams();
        window.scriptEditor = scriptEditor;
        window.ParamsType = 2;
        window.MyDataType = dataType;
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
        switch (WinType)
        {
            case 1:
                TriggerScriptEditor = new SkillTriggerScriptEditor();
                break;
            case 2:
                TriggerScriptEditor = new BuffTriggerScriptEditor();
                break;
            case 3:
                TriggerScriptEditor = new RemainTriggerScriptEditor();
                break;
        }
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
    Remain = 15,                // 挂载光环
    TargetPointSelector = 16,   // 目标点选择
    CleanBuff = 17,             // 清除buff
    CleanTarget = 18,           // 清除当前目标
    Death = 19,                 // 秒杀效果
    For = 20,                   // 循环
    ImmuneDemage = 21,          // 免疫伤害
    ImmuneDeath = 22,           // 免疫致死伤害
    LifeDrain = 23,             // 吸血
    Liner = 24,                 // 连线特效
    ShareDamage = 25,           // 分担伤害
    SubCD = 26,                 // 减CD
    Summoned = 27,              // 召唤
    UpperLimit = 28,            // 伤害上限
    DelBuff = 29,               // 删除buff
}