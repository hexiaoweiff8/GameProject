using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

/// <summary>
/// buff值编辑界面
/// </summary>
public class BuffTriggerScriptEditor : BaseTriggerScriptEditor
{
    public override void InitParams()
    {
        ParamTitles = new[]
        {
            new List<string>(), 
            new List<string>(), 
            new List<string>(), 
            // 类型标识:V3,Txt,Int,Float
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "释放位置(0放技能方, 1目标方):", "命中位置(0放技能方, 1目标方):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","持续时间:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "检测位置(0放技能方, 1目标方):", "检测范围形状(0圆, 1方):", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):", "碰撞单位被释放技能ID:", "范围大小(方 第一个宽, 第二个长, 第三个旋转角度, 圆的就取第一个值当半径, 扇形第一个半径, 第二个开口角度, 第三个旋转角度有更多的参数都放进来):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "滑动速度:", "检测宽度:", "检测总长度:", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "音效Key(或Path):", "起始时间:", "播放时长:","是否循环(0/1):", "循环次数:"},
            new List<string>() {"是否等待执行完(0否,1是):", "Buff ID:"},
            new List<string>() {"是否等待执行完(0否,1是):", "固定/百分比(0/1)","伤害/治疗(0/1):", "目标(自己/对方)(0/1):","数值固定/百分比(0-1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "移动速度:", "是否瞬移(0/1 如果为1速度无效):"},
            new List<string>() {"是否等待执行完(0否,1是):", "Skill ID:"},
            new List<string>() {"是否等待执行完(0否,1是):", "是否停止后面(0/1):", "条件:","条件内容:"},
            new List<string>() {"是否等待执行完(0否,1是):", "吸收量:", "每次百分比(0-1):","是否吸收过量伤害(true/false):"},
        };
        DataParamTitles = new[]
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
            new List<string>(){"Buff时间(单位秒):"},
            new List<string>(){"Buff类型:"},
            new List<string>(){"Detach事件1:"},
            new List<string>(){"Detach事件2:"},
            new List<string>(){"Buff优先级:"},
            new List<string>(){"Buff互斥组:"},
            new List<string>(){"是否有益:"},
            new List<string>(){"Detach条件Key:", "条件对比(>,<,=)", "对比值"},
            new List<string>(){"是否死亡消失:"},
            new List<string>(){"是否不致死:"},
        };
    }


    void OnGUI()
    {
        GUILayout.BeginVertical();
        var typePos = 0;
        List<String>[] titles = null;
        if (ParamsType == 1)
        {
            typePos = (int)TriggerType;
            titles = ParamTitles;
        }
        else if (ParamsType == 2)
        {
            typePos = (int)DataType;
            titles = DataParamTitles;
        }

        for (int i = 0; i < titles[typePos].Count; i++)
        {
            Params[i] = EditorGUILayout.TextField(titles[typePos][i], Params[i]);
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
    /// 链接构造脚本内容
    /// </summary>
    /// <returns></returns>
    public override string ConnectParams()
    {
        string ret = String.Empty;
        // 是否需要括号
        var needBraket = false;
        if (ParamsType == 1)
        {
            switch (TriggerType)
            {
                //case TriigerType.PlayAnimation:
                //    ret += "PlayAnimation";
                //    break;
                //case TriigerType.SingleDamage:
                //    ret += "SingleDamage";
                //    break;
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
                default:
                    return String.Empty;
            }
        }
        else if (ParamsType == 2)
        {
            switch (DataType)
            {
                //case TriigerType.PlayAnimation:
                //    ret += "PlayAnimation";
                //    break;
                //case TriigerType.SingleDamage:
                //    ret += "SingleDamage";
                //    break;
                case DataType.LevelData:
                    ret += "";
                    needBraket = true;
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
                case DataType.BuffTime:
                    ret += "BuffTime";
                    break;
                case DataType.BuffType:
                    ret += "BuffType";
                    break;
                case DataType.DetachTriggerLevel1:
                    ret += "DetachTriggerLevel1";
                    break;
                case DataType.DetachTriggerLevel2:
                    ret += "DetachTriggerLevel2";
                    break;
                case DataType.BuffLevel:
                    ret += "BuffLevel";
                    break;
                case DataType.BuffGroup:
                    ret += "BuffGroup";
                    break;
                case DataType.IsBeneficial:
                    ret += "IsBeneficial";
                    break;
                case DataType.DetachQualified:
                    ret += "DetachQualified";
                    break;
                case DataType.IsDeadDisappear:
                    ret += "IsDeadDisappear";
                    break;
                case DataType.IsNotLethal:
                    ret += "IsNotLethal";
                    break;
                    
                default:
                    return String.Empty;
            }
        }
        // 拼合参数数据
        if (Params.Length > 0)
        {
            ret += needBraket ? "" : "(";
            for (int i = 0; i < Params.Length; i++)
            {
                string str = Params[i];
                ret += str;
                if (i != Params.Length - 1)
                    ret += ", ";
            }
            ret += needBraket ? "" : ");";
        }
        return ret;
    }
}