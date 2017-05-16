using System;
using UnityEngine;
using System.Collections.Generic;
using UnityEditor;

public class SkillTriggerScriptEditor : EditorWindow
{
    private static SkillTriggerScriptEditor instance = null;
    public enum TriigerType
    {
        None,
        // 子级功能左右括号
        LeftBracket,
        RightBracket,
        //PlayAnimation,
        //SingleDamage,
        PointToPoint,
        PointToObj,
        Point,
        CollisionDetection,
        SlideCollisionDetection,
        Audio,
        Buff,
        Calculate,
        Move,

    }
    private static List<string>[] paramTitles = new List<string>[]
    {
        new List<string>(), 
        new List<string>(), 
        new List<string>(), 
        //new List<string>() {"StartTime:", "Animation ID:"},
        //new List<string>()
        //{
        //    "StartTime:", "ConstPhyDmg:", "PercentPhyDmg:", "ConstSprDmg:", "PercentSprDmg:", 
        //"ConstRealDmg:", "PercentRealDmg:", "CertainHit", "CertainCrit"
        //},
        //是否等待完成, 滑动速度, 检测宽度, 检测总长度, 目标阵营(-1:都触发, 1: 己方, 2: 非己方)
        new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "释放位置(0放技能方, 1目标方):", "命中位置(0放技能方, 1目标方):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
        new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
        new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","持续时间:","缩放(三位 1,1,1):"},
        new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "检测位置(0放技能方, 1目标方):", "检测范围形状(0圆, 1方):", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):", "碰撞单位被释放技能ID:", "范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来):"},
        new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "滑动速度:", "检测宽度:", "检测总长度:", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):"},
        new List<string>() {"是否等待执行完(0否,1是):", "音效Key(或Path):", "起始时间:", "播放时长:","是否循环(0/1):", "循环次数:"},
        new List<string>() {"是否等待执行完(0否,1是):", "Buff ID:"},
        new List<string>() {"是否等待执行完(0否,1是):", "技能数据 ID:"},
        new List<string>() {"是否等待执行完(0否,1是):", "移动速度:", "是否瞬移(0/1 如果为1速度无效):"},
    };


    /*
     * 结构例子
     * SkillNum(10000)
     * {
     *    PointToPoint(1,key,0,1,10,1,1),     // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
     *    Point(0,key,1,0,3),                // 不需要等待其结束, 特效key(对应key,或特效path), 释放位置, 播放速度, 持续3秒
     *    CollisionDetection(1, 1, 10, 0, 10001)
     *    {
     *        Skill(1, 10002, 1)
     *    }
     * }
     * 
     * -----------------特效-------------------- 
     * PointToPoint 点对点特效        参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),命中位置(0放技能方, 1目标方),速度,飞行轨迹,缩放(三位)
     * PointToObj 点对对象特效        参数 是否等待完成,特效Key,速度,飞行轨迹,缩放(三位)
     * Point 点特效                   参数 是否等待完成,特效Key,速度,持续时间,缩放(三位)
     * Scope 范围特效                 参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),持续时间,范围半径
     * 
     * --------------目标选择方式---------------
     * CollisionDetection 碰撞检测    参数 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方), 
     * 目标阵营(-1:都触发, 0: 己方, 1: 非己方),碰撞单位被释放技能ID范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
     * {
     *   功能
     * }
     *  SlideCollisionDetection 滑动碰撞检测   参数 是否等待完成, 滑动速度, 检测宽度, 检测总长度, 目标阵营(-1:都触发, 0: 己方, 1: 非己方)
     * {
     *   功能
     * }
     * Skill 释放技能                 参数 是否等待完成,被释放技能,技能接收方(0释放者,1被释放者)
     * -----------------音效--------------------
     * Audio 音效                     参数 是否等待完成,点音,持续音,持续时间
     * 
     * -----------------buff--------------------
     * Buff buff                      参数 是否等待完成,buffID
     * 
     * -----------------结算--------------------
     * Calculate 结算                 参数 是否等待完成,伤害或治疗(0,1),技能编号
     * 
     * -----------------技能--------------------
     * Skill 释放技能                 参数 是否等待完成,技能编号
     * 
     * -----------------位置--------------------
     * Move 位置移动                  参数 是否等待完成,移动速度,是否瞬移(0: 否, 1: 是(如果是瞬移则速度无效))
     * 
     */

    private TriigerType _triigerType = TriigerType.None;
    private string[] _params;

    public static void ShowSkillTriggerScriptWindow(TriigerType triigerType, Rect pos)
    {
        if (instance == null)
        {
            instance = new SkillTriggerScriptEditor();
        }

        instance._triigerType = triigerType;
        instance._params = new string[paramTitles[(int)triigerType].Count];

        float width = 500;
        float height = 20 * (paramTitles[(int)triigerType].Count + 1);
        float left = pos.center.x - width / 2;
        float top = pos.center.y - height / 2;
        instance.position = new Rect(left, top, width, height);
        instance.ShowPopup();
    }

    void OnDestroy()
    {
        instance = null;
    }

    void OnGUI()
    {
        GUILayout.BeginVertical();
        for (int i = 0; i < paramTitles[(int)_triigerType].Count; i++)
        {
            _params[i] = EditorGUILayout.TextField(paramTitles[(int)_triigerType][i], _params[i]);
        }
        GUILayout.EndVertical();

        GUILayout.BeginHorizontal();
        GUI.color = Color.green;
        if (GUILayout.Button("Add"))
        {
            SkillScriptEditor.AddContent(ConnectParams());
            this.Close();
        }

        GUI.color = Color.red;

        if (GUILayout.Button("Cancel"))
        {
            this.Close();
        }

        GUI.color = Color.white;
        GUILayout.EndHorizontal();
    }

    string ConnectParams()
    {
        string ret = String.Empty;
        switch (_triigerType)
        {
            //case TriigerType.PlayAnimation:
            //    ret += "PlayAnimation";
            //    break;
            //case TriigerType.SingleDamage:
            //    ret += "SingleDamage";
            //    break;
            case TriigerType.LeftBracket:
                ret += "{";
                break;
            case TriigerType.RightBracket:
                ret += "}";
                break;
            case TriigerType.PointToPoint:
                ret += "PointToPoint";
                break;
            case TriigerType.PointToObj:
                ret += "PointToObj";
                break;
            case TriigerType.Point:
                ret += "Point";
                break;
            case TriigerType.CollisionDetection:
                ret += "CollisionDetection";
                break;
            case TriigerType.SlideCollisionDetection:
                ret += "SlideCollisionDetection";
                break;
            case TriigerType.Audio:
                ret += "Audio";
                break;
            case TriigerType.Buff:
                ret += "Buff";
                break;
            case TriigerType.Calculate:
                ret += "Calculate";
                break;
            case TriigerType.Move:
                ret += "Move";
                break;
            default:
                return String.Empty;
        }
        // 拼合参数数据
        if (_params.Length > 0)
        {
            ret += "(";
            for (int i = 0; i < _params.Length; i++)
            {
                string str = _params[i];
                ret += str;
                if (i != _params.Length - 1)
                    ret += ", ";
            }
            ret += ");";
        }
        return ret;
    }
}