using System;
using UnityEngine;
using System.Collections.Generic;
using UnityEditor;

public class SkillTriggerScriptEditor : BaseTriggerScriptEditor
{


    /*
    SkillNum(10000)
    {
       PointToPoint(1,key,0,1,10,1,1),     // 需要等待其结束, 特效key(对应key,或特效path), 释放位置, 命中位置, 速度10, 飞行轨迹类型
       Point(0,key,1,0,3),                // 不需要等待其结束, 特效key(对应key,或特效path), 释放位置, 播放速度, 持续3秒
       CollisionDetection(1, 1, 10, 0, 10001)
       {
           Calculate(1,0,%0)
       }
    }
    [
        // 触发事件Level1
        TriggerLevel1(1)
        // 触发事件Level2
        TriggerLevel2(1)
        // cd时间
        CDTime(10)
        // cd组ID(不一样的组ID不会共享同一个公共CD
        CDGroup(1)
        // 可释放次数
        ReleaseTime(10)
        Description(交换空间撒很快就阿萨德阖家安康收到货%0, %1)
        // 数据
        1, 100,,,,,
        2, 200
      
    ]
   // -----------------特效-------------------- 
   // PointToPoint 点对点特效        参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),命中位置(0放技能方, 1目标方),速度,飞行轨迹,缩放(三位)
   // PointToObj 点对对象特效        参数 是否等待完成,特效Key,速度,飞行轨迹,缩放(三位)
   // Point 点特效                   参数 是否等待完成,特效Key,检测位置(0放技能方, 1目标方),持续时间,缩放(三位)
   // --Scope 范围特效                 参数 是否等待完成,特效Key,释放位置(0放技能方, 1目标方),持续时间,范围半径

   // --------------目标选择方式---------------
   // CollisionDetection 碰撞检测    参数 是否等待完成, 目标数量, 检测位置(0放技能方, 1目标方), 检测范围形状(0圆, 1方), 
   // 目标阵营(-1:都触发, 0: 己方, 1: 非己方),碰撞单位被释放技能ID范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来)
   //{
   //  功能
   //}
   // SlideCollisionDetection 滑动碰撞检测   参数 是否等待完成, 滑动速度, 检测宽度, 检测总长度, 目标阵营(-1:都触发, 0: 己方, 1: 非己方)
   //{
   //  功能
   //}
   // Skill 释放技能                   参数 是否等待完成,被释放技能,技能接收方(0释放者,1被释放者)
   // -----------------音效--------------------
   // Audio 音效                       参数 是否等待完成,点音,持续音,持续时间

   // -----------------buff--------------------
   // Buff buff                        参数 是否等待完成,buffID

   // -----------------结算--------------------
   // Calculate 结算                   参数 是否等待完成,伤害或治疗(0,1),伤害/治疗值
   // HealthChange 生命值变动          参数 是否等待完成,生命值变动类型(0固定值,1百分比), 伤害/治疗(0伤害, 1治疗), 目标(0 释放者自己,1 选定的目标单位), 伤害/治疗值(如果是百分比的话这里填1为秒杀100%, 填0.01位1%)
   // ResistDemage 伤害吸收            参数 是否等待完成,吸收量,吸收百分比(0-1),是否吸收过量伤害

   // -----------------技能--------------------
   // Skill 释放技能                   参数 是否等待完成,技能编号

   // -----------------位置--------------------
   // Move 位置移动                    参数 是否等待完成,移动速度,是否瞬移(0: 否, 1: 是(如果是瞬移则速度无效))

   // -----------------条件选择----------------
   // If 条件选择                      参数 是否等待完成,条件
   // --HealthScope 血量范围选择       参数 是否等待完成,血量下限(最小0), 血量上限(最大100)
    
   // -----------------操作属性----------------
   // ChangeData(属性名称(对应类里的属性名),变更值, 数据变更类型(0:绝对值(加), 1: 百分比(乘)))
   // 
   // 

   // -----------------数据--------------------
   // TriggerLevel1 事件触发level1             参数 0-6 参照TriggerLevel1枚举
   // TriggerLevel2 事件触发level2             参数 0-20 参照TriggerLevel2枚举
   // TickTime      tick执行时间               参数 时间(正值)
   // CDTime        cd时间                     参数 时间(正值)
   // CDGroup       cd组(不同组的cd不同公共cd)  参数 0-无穷(整数)
   // ReleaseTime   可释放次数                 参数 1-无穷(整数)
   // Description   描述(中间替换符可被替换)    参数 描述描述中可填写占位符%0123...同样适用数据替换与技能值相同
   // Icon          icon地址                   参数 地址(或key)
   // ChangeData(属性名称(对应类里的属性名),变更值, 数据变更类型(0:绝对值(加), 1: 百分比(乘)))
    
    */


    void OnGUI()
    {
        GUILayout.BeginVertical();
        var typePos = 0;
        List<String>[] titles = null;
        if (ParamsType == 1)
        {
            typePos = (int) TriggerType;
            titles = ParamTitles;
        }
        else if (ParamsType == 2)
        {
            typePos = (int)DataType;
            titles = DataParamTitles;
        }

        for (int i = 0; i < titles[typePos].Count; i++)
        {
            Params[i] = EditorGUILayout.TextField(titles[typePos][i],Params[i]);
        }
        GUILayout.EndVertical();

        GUILayout.BeginHorizontal();
        GUI.color = Color.green;
        if (GUILayout.Button("Add"))
        {
            if (ParamsType == 1)
            {
                scriptEditor.AddScriptContent(ConnectParams());
            }
            else if (ParamsType == 2)
            {
                scriptEditor.AddDataContent(ConnectParams());
            }
            Close();
        }

        GUI.color = Color.red;

        if (GUILayout.Button("Cancel"))
        {
            this.Close();
        }

        GUI.color = Color.white;
        GUILayout.EndHorizontal();
    }

    /// <summary>
    /// 初始化参数内容
    /// </summary>
    public override void InitParams()
    {
        ParamTitles = new []
        {
            new List<string>(), 
            new List<string>(), 
            new List<string>(), 
            // 类型标识:V3,Txt,Int,Float
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "释放位置(0放技能方, 1目标方,2):", "命中位置(0放技能方, 1目标方,2):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "位置(0放技能方, 1目标方,2):", "速度:","持续时间:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "检测位置(0放技能方, 1目标方,2):", "检测范围形状(0圆, 1方):", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):", "范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "目标位置(0放技能方, 1目标方,2):", "释放位置(0放技能方, 1目标方,2):", "滑动速度:", "检测宽度:", "检测总长度:", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "音效Key(或Path):", "起始时间:", "播放时长:","是否循环(0/1):", "循环次数:"},
            new List<string>() {"是否等待执行完(0否,1是):", "Buff ID:", "Buff目标(0自己/1对方)"},
            new List<string>() {"是否等待执行完(0否,1是):", "固定/百分比(0/1)","伤害/治疗(0/1):", "目标(自己/对方)(0/1):","数值固定/百分比(0-1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "移动速度:", "是否瞬移(0/1 如果为1速度无效):"},
            new List<string>() {"是否等待执行完(0否,1是):", "Skill ID:"},
            new List<string>() {"是否等待执行完(0否,1是):", "是否停止后面(0/1):", "条件:","条件内容:"},
            new List<string>() {"是否等待执行完(0否,1是):", "吸收量:", "每次百分比(0-1):","是否吸收过量伤害(true/false):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标(0自己/1对方/2):", "Remain编号:","是否跟随:"},
            new List<string>() {"是否等待执行完(0否,1是):", "相对(0自己/1对方/2选择点/3我到你方向/4你到我方向):", "距离:","角度:"},
        };
        DataParamTitles = new []
        {
            new List<string>(){"参数0","参数1","参数2","参数3","参数4","参数5","参数6","参数7","参数8","参数9"},
            new List<string>(){"CD时间"},
            new List<string>(){"CD组:"},
            new List<string>(){"可释放次数:"},
            new List<string>(){"说明(可用替换符):"},
            new List<string>(){"图标(地址):"},
            new List<string>(){"事件Level1:"},
            new List<string>(){"事件Level2:"},
            new List<string>(){"tick时间(单位秒):"},
            new List<string>(){"变更属性:", "变更值:", "变更类型(0绝对值,1百分比0-1):"},
            new List<string>(){"是否为主动技能(true/false,目标选择数据Id):"},
        };
        
    }

    /// <summary>
    /// 将参数内容合并
    /// </summary>
    /// <returns></returns>
    public override string ConnectParams()
    {
        string ret = String.Empty;
        var isLevelData = false;
        if (ParamsType == 1)
        {
            switch (TriggerType)
            {
                case TriggerType.LeftBracket:
                    ret += "{";
                    break;
                case TriggerType.RightBracket:
                    ret += "}";
                    break;
                case TriggerType.PointToPoint:
                    ret += "PointToPoint";
                    break;
                case TriggerType.PointToObj:
                    ret += "PointToObj";
                    break;
                case TriggerType.Point:
                    ret += "Point";
                    break;
                case TriggerType.CollisionDetection:
                    ret += "CollisionDetection";
                    break;
                case TriggerType.SlideCollisionDetection:
                    ret += "SlideCollisionDetection";
                    break;
                case TriggerType.Audio:
                    ret += "Audio";
                    break;
                case TriggerType.Buff:
                    ret += "Buff";
                    break;
                case TriggerType.Skill:
                    ret += "Skill";
                    break;
                case TriggerType.If:
                    ret += "If";
                    break;
                case TriggerType.HealthChange:
                    ret += "HealthChange";
                    break;
                case TriggerType.ResistDemage:
                    ret += "ResistDemage";
                    break;
                case TriggerType.Move:
                    ret += "Move";
                    break;
                case TriggerType.Remain:
                    ret += "Remain";
                    break;
                case TriggerType.TargetPointSelector:
                    ret += "TargetPointSelector";
                    break;
                default:
                    return String.Empty;
            }
        }
        else if (ParamsType == 2)
        {
            switch (DataType)
            {
                case DataType.LevelData:
                    ret += "";
                    isLevelData = true;
                    break;
                case DataType.CDTime:
                    ret += "CDTime";
                    break;
                case DataType.CDGroup:
                    ret += "CDGroup";
                    break;
                case DataType.ReleaseTime:
                    ret += "ReleaseTime";
                    break;
                case DataType.Description:
                    ret += "Description";
                    break;
                case DataType.Icon:
                    ret += "Icon";
                    break;
                case DataType.TriggerLevel1:
                    ret += "TriggerLevel1";
                    break;
                case DataType.TriggerLevel2:
                    ret += "TriggerLevel2";
                    break;
                case DataType.TickTime:
                    ret += "TickTime";
                    break;
                case DataType.ChangeData:
                    ret += "ChangeData";
                    break;
                case DataType.IsActive:
                    ret += "IsActive";
                    break;
                    
                default:
                    return String.Empty;
            }
        }
        // 拼合参数数据
        if (Params.Length > 0)
        {
            ret += isLevelData ? "" : "(";
            for (int i = 0; i < Params.Length; i++)
            {
                string str = Params[i];
                ret += str;
                if (i != Params.Length - 1)
                    ret += ", ";
            }
            ret += isLevelData ? "" : ");";
        }
        return ret;
    }

    public static void GetIns()
    {
        TriggerScriptEditor = new SkillTriggerScriptEditor();
    }
}