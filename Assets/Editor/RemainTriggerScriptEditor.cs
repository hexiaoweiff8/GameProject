using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;


public class RemainTriggerScriptEditor : BaseTriggerScriptEditor
{

    /// <summary>
    /// 初始化
    /// </summary>
    public override void InitParams()
    {
        ParamTitles = new[]
        {
            new List<string>(), 
            new List<string>(), 
            new List<string>(), 
            // 类型标识:V3,Txt,Int,Float
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "释放位置(0放技能方, 1目标方,2):", "命中位置(0放技能方, 1目标方,2):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "速度:","飞行轨迹:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效资源Key(或Path):", "位置(0放技能方, 1目标方,2):", "速度:","持续时间:","缩放(三位 1,1,1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "检测位置(0放技能方, 1目标方,2):", "检测范围形状(0圆, 1方):", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):", "Arg1:", "Arg2:", "Arg3:", "目标筛选数据ID:", "是否跟随旋转:"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标数量上限:", "目标位置(0放技能方, 1目标方,2):", "释放位置(0放技能方, 1目标方,2):", "滑动速度:", "检测宽度:", "检测总长度:", "目标阵营(-1:都触发, 1: 己方, 2: 非己方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "音效Key(或Path):", "起始时间:", "播放时长:","是否循环(0/1):", "循环次数:"},
            new List<string>() {"是否等待执行完(0否,1是):", "Buff ID:", "Buff目标(0自己/1对方)"},
            new List<string>() {"是否等待执行完(0否,1是):", "固定/百分比(0/1)","伤害/治疗(0/1):", "目标(自己/对方)(0/1):","数值固定/百分比(0-1):", "伤害系数:", "变更类型(0真实/1):"},
            new List<string>() {"是否等待执行完(0否,1是):", "被移动单位(0自己,1目标):","目标位置:","移动速度:", "是否瞬移(0/1 如果为1速度无效):"},
            new List<string>() {"是否等待执行完(0否,1是):", "Skill ID:"},
            new List<string>() {"是否等待执行完(0否,1是):", "是否停止后面(0/1):", "条件:","条件内容:"},
            new List<string>() {"是否等待执行完(0否,1是):", "吸收量:", "每次百分比(0-1):","是否吸收过量伤害(true/false):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标(0自己/1对方/2):", "Remain编号:","是否跟随:"},
            new List<string>() {"是否等待执行完(0否,1是):", "相对(0自己/1对方/2选择点/3我到你方向/4你到我方向):", "距离:","角度:"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标(0自己/1对方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标(0自己/1对方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "目标(0自己/1对方):"},
            new List<string>() {"是否等待执行完(0否,1是):", "循环次数:"},
            new List<string>() {"是否等待执行完(0否,1是):", "伤害类型:"},
            new List<string>() {"是否等待执行完(0否,1是):"},
            new List<string>() {"是否等待执行完(0否,1是):", "吸血类型(0:绝对值,1:百分比:", "吸血量:"},
            new List<string>() {"是否等待执行完(0否,1是):", "特效路径:", "释放位置:", "接收位置:", "持续时间:"},
            new List<string>() {"是否等待执行完(0否,1是):", "buff状态(Attach,Action,Detach):"},
            new List<string>() {"是否等待执行完(0否,1是):", "减少时间(单位秒):"},
            new List<string>() {"是否等待执行完(0否,1是):", "召唤位置(0/1/2):", "召唤类型:", "召唤单位ID:", "召唤单位等级:"},
            new List<string>() {"是否等待执行完(0否,1是):", "伤害上限:"},
            new List<string>() {"是否等待执行完(0否,1是):", "Buff ID:", "Buff目标(0自己/1对方)"},
        };
        DataParamTitles = new[]
        {
            new List<string>(){"参数0","参数1","参数2","参数3","参数4","参数5","参数6","参数7","参数8","参数9"},
            new List<string>(){"作用范围:"},
            new List<string>(){"作用总时间:"},
            new List<string>(){"Action时间间隔:"},
            new List<string>(){"是否跟随释放者:"},
            new List<string>(){"作用阵营:"},
            new List<string>(){"是否可以作用到空中单位:"},
            new List<string>(){"是否可以作用到地面单位:"},
            new List<string>(){"是否可以作用到建筑单位:"},
        };
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
                case TriggerType.CleanBuff:
                    ret += "CleanBuff";
                    break;
                case TriggerType.CleanTarget:
                    ret += "CleanTarget";
                    break;
                case TriggerType.DelBuff:
                    ret += "DelBuff";
                    break;
                case TriggerType.Death:
                    ret += "Death";
                    break;
                case TriggerType.For:
                    ret += "For";
                    break;
                case TriggerType.ImmuneDemage:
                    ret += "ImmuneDemage";
                    break;
                case TriggerType.ImmuneDeath:
                    ret += "ImmuneDeath";
                    break;
                case TriggerType.LifeDrain:
                    ret += "LifeDrain";
                    break;
                case TriggerType.Liner:
                    ret += "Liner";
                    break;
                case TriggerType.ShareDamage:
                    ret += "ShareDamage";
                    break;
                case TriggerType.SubCD:
                    ret += "SubCD";
                    break;
                case TriggerType.Summoned:
                    ret += "Summoned";
                    break;
                case TriggerType.UpperLimit:
                    ret += "UpperLimit";
                    break;

                default:
                    return String.Empty;
            }
        }
        else if (ParamsType == 2)
        {
            /*
         
            Range       // 作用范围
            DuringTime  // 作用总时间
            ActionTime  // Action时间间隔
            IsFollow    // 是否跟随释放者
            ActionCamp  // 作用阵营
            CouldActionOnAir        // 是否可以作用到空中单位
            CouldActionOnSurface    // 是否可以作用到地面单位
            CouldActionOnBuilding   // 是否可以作用到建筑单位
             */
            switch (MyDataType)
            {
                case (int)RemainDataType.LevelData:
                    ret += "";
                    needBraket = true;
                    break;
                case (int)RemainDataType.Range:
                    ret += "Range";
                    break;
                case (int)RemainDataType.ActionTime:
                    ret += "ActionTime";
                    break;
                case (int)RemainDataType.DuringTime:
                    ret += "DuringTime";
                    break;
                case (int)RemainDataType.IsFollow:
                    ret += "IsFollow";
                    break;
                case (int)RemainDataType.ActionCamp:
                    ret += "ActionCamp";
                    break;
                case (int)RemainDataType.CouldActionOnAir:
                    ret += "CouldActionOnAir";
                    break;
                case (int)RemainDataType.CouldActionOnSurface:
                    ret += "CouldActionOnSurface";
                    break;
                case (int)RemainDataType.CouldActionOnBuilding:
                    ret += "CouldActionOnBuilding";
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
            typePos = (int)MyDataType;
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
}