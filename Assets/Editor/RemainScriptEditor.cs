using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
        BuffTriggerScriptEditor.GetIns();

        if (GUILayout.Button("子级左括号"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.LeftBracket, this.position);
        }
        if (GUILayout.Button("子级右括号"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.RightBracket, this.position);
        }
        if (GUILayout.Button("点对点特效"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToPoint, this.position);
        }
        if (GUILayout.Button("点对对象特效(跟踪)"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToObj, this.position);
        }
        if (GUILayout.Button("点特效"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Point, this.position);
        }
        if (GUILayout.Button("范围碰撞检测"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.CollisionDetection, this.position);
        }
        if (GUILayout.Button("滑动碰撞检测"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.SlideCollisionDetection, this.position);
        }
        if (GUILayout.Button("音效"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Audio, this.position);
        }
        if (GUILayout.Button("Buff"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Buff, this.position);
        }
        if (GUILayout.Button("Skill"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Skill, this.position);
        }
        if (GUILayout.Button("If"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.If, this.position);
        }
        if (GUILayout.Button("伤害/治疗结算"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.HealthChange, this.position);
        }
        if (GUILayout.Button("伤害吸收"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ResistDemage, this.position);
        }
        if (GUILayout.Button("移动"))
        {
            BuffTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Move, this.position);
        }
        GUI.color = Color.white;
        EditorGUILayout.EndVertical();
        #endregion

        #region Data
        // Buff
        EditorGUILayout.BeginVertical("box");
        GUI.color = Color.green;

        if (GUILayout.Button("Remain等级数据"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.LevelData, this.position);
        }
        if (GUILayout.Button("作用范围"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.Range, this.position);
        }
        if (GUILayout.Button("作用总时间"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.DuringTime, this.position);
        }
        if (GUILayout.Button("Action时间间隔"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.TickTime, this.position);
        }
        if (GUILayout.Button("是否跟随释放者"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.IsFollow, this.position);
        }
        if (GUILayout.Button("作用阵营"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.ActionCamp, this.position);
        }
        if (GUILayout.Button("是否可以作用到空中单位"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.CouldActionOnAir, this.position);
        }
        if (GUILayout.Button("是否可以作用到地面单位"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.CouldActionOnSurface, this.position);
        }
        if (GUILayout.Button("是否可以作用到建筑单位"))
        {
            BuffTriggerScriptEditor.ShowDataScriptWindow(this, DataType.CouldActionOnBuilding, this.position);
        }

        EditorGUILayout.EndVertical();
        #endregion
        #endregion

        EditorGUILayout.EndVertical();
        EditorGUILayout.EndHorizontal();
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