using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;


public class RemainScriptEditor : BaseScriptEditor
{
    [MenuItem("ScriptEditor/Open Remain Script Editor")]
    static void OpenRemainScriptEditor()
    {
        RemainScriptEditor window = GetWindow<RemainScriptEditor>(true, "RemainScriptEditor");
        window.Init();
    }


    /// <summary>
    /// 文件名称
    /// </summary>
    public override string FileName
    {
        get { return "RemainScript"; }
    }

    /// <summary>
    /// 脚本起始内容
    /// </summary>
    public override string NumStart
    {
        get { return "Remain"; }
    }


    /// <summary>
    /// GUI刷新
    /// </summary>
    void OnGUI()
    {
        Refresh();
        scrollPos = EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width(640), GUILayout.Height(800));
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.BeginVertical("box", GUILayout.Width(400), GUILayout.Height(400));
        #region ScrollView - Script Content

        EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width(400), GUILayout.Height(400));
        //GUIStyle style = new GUIStyle(GUI.skin.button);
        for (int i = 0; i < WorkingScriptContent.Count; i++)
        {
            var index = i;
            if (selectScriptContentIndex == index)
                GUI.color = Color.green;

            if (GUILayout.Button(WorkingScriptContent[index]))
            {
                selectScriptContentIndex = index;
                selectDataContentIndex = -1;
            }
            GUI.color = Color.white;
        }

        EditorGUILayout.EndScrollView();
        #endregion

        #region ScrollView - Data Content

        EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width(400), GUILayout.Height(400));
        //GUIStyle style = new GUIStyle(GUI.skin.button);
        for (int i = 0; i < dataContent.Count; i++)
        {
            int index = i;
            if (selectDataContentIndex == index)
                GUI.color = Color.cyan;

            if (GUILayout.Button(dataContent[index]))
            {
                selectDataContentIndex = index;
                selectScriptContentIndex = -1;
            }
            GUI.color = Color.white;
        }

        EditorGUILayout.EndScrollView();
        #endregion
        EditorGUILayout.EndVertical();
        EditorGUILayout.BeginVertical("box", GUILayout.Width(200), GUILayout.Height(440));
        #region UI
        Num = EditorGUILayout.IntField("script ID:", Num);
        if (GUILayout.Button("输入ID加载脚本"))
            LoadScript();
        if (GUILayout.Button("保存脚本"))
            SaveScript();
        if (GUILayout.Button("创建新脚本"))
            ClearContent();
        if (GUILayout.Button("删除行"))
            DeleteContent();
        if (GUILayout.Button("上移"))
            MoveUpContent();
        if (GUILayout.Button("下移"))
            MoveDownContent();
        #region Add Trigger
        EditorGUILayout.BeginVertical("box");
        GUI.color = Color.yellow;

        // 获取的实例
        RemainTriggerScriptEditor.WinType = 3;
        RemainTriggerScriptEditor.GetIns();

        if (GUILayout.Button("子级左括号"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.LeftBracket, this.position);
        }
        if (GUILayout.Button("子级右括号"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.RightBracket, this.position);
        }
        if (GUILayout.Button("点对点特效"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToPoint, this.position);
        }
        if (GUILayout.Button("点对对象特效(跟踪)"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToObj, this.position);
        }
        if (GUILayout.Button("点特效"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Point, this.position);
        }
        if (GUILayout.Button("连线特效"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Liner, this.position);
        }
        if (GUILayout.Button("范围碰撞检测"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.CollisionDetection, this.position);
        }
        if (GUILayout.Button("滑动碰撞检测"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.SlideCollisionDetection, this.position);
        }
        if (GUILayout.Button("音效"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Audio, this.position);
        }
        if (GUILayout.Button("Buff"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Buff, this.position);
        }
        if (GUILayout.Button("清除Buff"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.CleanBuff, this.position);
        }
        if (GUILayout.Button("删除指定Buff"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.DelBuff, this.position);
        }
        if (GUILayout.Button("Skill"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Skill, this.position);
        }
        if (GUILayout.Button("If"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.If, this.position);
        }
        if (GUILayout.Button("伤害/治疗结算"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.HealthChange, this.position);
        }
        if (GUILayout.Button("秒杀"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Death, this.position);
        }
        if (GUILayout.Button("伤害吸收"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ResistDemage, this.position);
        }
        if (GUILayout.Button("免疫伤害"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ImmuneDemage, this.position);
        }
        if (GUILayout.Button("免疫致死"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ImmuneDeath, this.position);
        }
        if (GUILayout.Button("受到伤害上限"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.UpperLimit, this.position);
        }
        if (GUILayout.Button("吸血"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.LifeDrain, this.position);
        }
        if (GUILayout.Button("分担伤害"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ShareDamage, this.position);
        }
        if (GUILayout.Button("移动"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Move, this.position);
        }
        if (GUILayout.Button("范围持续技"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Remain, this.position);
        }
        if (GUILayout.Button("目标点选择"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.TargetPointSelector, this.position);
        }
        if (GUILayout.Button("清除攻击目标"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.CleanTarget, this.position);
        }
        if (GUILayout.Button("循环"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.For, this.position);
        }
        if (GUILayout.Button("减技能CD"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.SubCD, this.position);
        }
        if (GUILayout.Button("召唤"))
        {
            RemainTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Summoned, this.position);
        }
        GUI.color = Color.white;
        EditorGUILayout.EndVertical();
        #endregion

        #region Data

        EditorGUILayout.BeginVertical("box");
        GUI.color = Color.green;

        if (GUILayout.Button("Remain等级数据"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.LevelData, this.position);
        }
        if (GUILayout.Button("作用范围"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.Range, this.position);
        }
        if (GUILayout.Button("作用总时间"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.DuringTime, this.position);
        }
        if (GUILayout.Button("Action时间间隔"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.ActionTime, this.position);
        }
        if (GUILayout.Button("是否跟随释放者"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.IsFollow, this.position);
        }
        if (GUILayout.Button("作用阵营"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.ActionCamp, this.position);
        }
        if (GUILayout.Button("是否可以作用到空中单位"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.CouldActionOnAir, this.position);
        }
        if (GUILayout.Button("是否可以作用到地面单位"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.CouldActionOnSurface, this.position);
        }
        if (GUILayout.Button("是否可以作用到建筑单位"))
        {
            RemainTriggerScriptEditor.ShowDataScriptWindow(this, (int)RemainDataType.CouldActionOnBuilding, this.position);
        }

        EditorGUILayout.EndVertical();
        #endregion
        #endregion

        EditorGUILayout.EndVertical();
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.EndScrollView();
    }

    /// <summary>
    /// 反向加载
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    protected override bool ParseScript(string filename)
    {
        throw new NotImplementedException();
    }


    /// <summary>
    /// 保存脚本
    /// </summary>
    public new void SaveScript()
    {
        string content = String.Empty;
        content += string.Format(NumStart + "Num({0})", Num);

        // 行为内容
        content += "\r\nAction\r\n{\r\n";
        foreach (var str in ActionScriptContent)
        {
            content += "\t";
            content += str;
            content += "\r\n";
        }
        content += "}";
        if (AttachScriptContent.Count > 0)
        {
            content += "\r\nEnter\r\n{\r\n";
            foreach (var str in AttachScriptContent)
            {
                content += "\t";
                content += str;
                content += "\r\n";
            }
            content += "}";
        }
        if (DetachScriptContent.Count > 0)
        {
            content += "\r\nOut\r\n{\r\n";
            foreach (var str in DetachScriptContent)
            {
                content += "\t";
                content += str;
                content += "\r\n";
            }
            content += "}";
        }

        // 数据内容
        content += "\r\n[\r\n";
        foreach (var str in dataContent)
        {
            content += "\t";
            content += str;
            content += "\r\n";
        }
        content += "]";
        Utils.CreateOrOpenFile(Application.streamingAssetsPath + "/", FileName + Num + ".txt", content);
        Debug.Log("保存成功");
    }

}

/// <summary>
/// 技能数据类型
/// </summary>
public enum RemainDataType
{
    LevelData = 0,      // 技能等级数据

    // ------------Remain特有----------
    Range = 1,              // 作用范围
    DuringTime = 2,         // 作用总时间
    ActionTime = 3,
    IsFollow = 4,           // 是否跟随释放者
    ActionCamp = 5,         // 作用阵营
    CouldActionOnAir = 6,   // 是否可以作用到空中单位
    CouldActionOnSurface = 7,   // 是否可以作用到地面单位
    CouldActionOnBuilding = 8,   // 是否可以作用到建筑单位
}