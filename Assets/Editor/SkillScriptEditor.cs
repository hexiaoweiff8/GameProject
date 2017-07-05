using System;
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using UnityEditor;

public class SkillScriptEditor : BaseScriptEditor
{

    [MenuItem("ScriptEditor/Open Skill Script Editor")]
    static void OpenSkillScriptEditor()
    {
        SkillScriptEditor window = GetWindow<SkillScriptEditor>(true, "SkillScriptEditor");
        window.Init();
    }

    /// <summary>
    /// 文件名称
    /// </summary>
    public override string FileName
    {
        get { return "SkillScript"; }
    }


    /// <summary>
    /// 脚本起始内容
    /// </summary>
    public override string NumStart
    {
        get { return "Skill"; }
    }

    /// <summary>
    /// GUI绘制
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
        SkillTriggerScriptEditor.GetIns();

        if (GUILayout.Button("子级左括号"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.LeftBracket, this.position);
        }
        if (GUILayout.Button("子级右括号"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.RightBracket, this.position);
        }
        if (GUILayout.Button("点对点特效"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToPoint, this.position);
        }
        if (GUILayout.Button("点对对象特效(跟踪)"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.PointToObj, this.position);
        }
        if (GUILayout.Button("点特效"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Point, this.position);
        }
        if (GUILayout.Button("范围碰撞检测"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.CollisionDetection, this.position);
        }
        if (GUILayout.Button("滑动碰撞检测"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.SlideCollisionDetection, this.position);
        }
        if (GUILayout.Button("音效"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Audio, this.position);
        }
        if (GUILayout.Button("Buff"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Buff, this.position);
        }
        if (GUILayout.Button("Skill"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Skill, this.position);
        }
        if (GUILayout.Button("If"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.If, this.position);
        }
        if (GUILayout.Button("伤害/治疗结算"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.HealthChange, this.position);
        }
        if (GUILayout.Button("伤害吸收"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.ResistDemage, this.position);
        }
        if (GUILayout.Button("移动"))
        {
            SkillTriggerScriptEditor.ShowTriggerScriptWindow(this, TriggerType.Move, this.position);
        }
        GUI.color = Color.white;
        EditorGUILayout.EndVertical();
        #endregion

        #region Data
        // 技能
        EditorGUILayout.BeginVertical("box");
        GUI.color = Color.green;

        if (GUILayout.Button("技能等级数据"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.LevelData, this.position);
        }
        if (GUILayout.Button("技能CD值"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.CDTime, this.position);
        }
        if (GUILayout.Button("技能CD组"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.CDGroup, this.position);
        }
        if (GUILayout.Button("技能可释放次数"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.ReleaseTime, this.position);
        }
        if (GUILayout.Button("触发事件Level1"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.TriggerLevel1, this.position);
        }
        if (GUILayout.Button("触发事件Level2"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.TriggerLevel2, this.position);
        }
        if (GUILayout.Button("数据修正"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.ChangeData, this.position);
        }
        if (GUILayout.Button("技能描述"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.Description, this.position);
        }
        if (GUILayout.Button("技能Icon路径"))
        {
            SkillTriggerScriptEditor.ShowDataScriptWindow(this, DataType.Icon, this.position);
        }
        EditorGUILayout.EndVertical();
        #endregion
        #endregion

        EditorGUILayout.EndVertical();
        EditorGUILayout.EndHorizontal();
    }


    /// <summary>
    /// 转换脚本内容
    /// </summary>
    /// <param name="filename">被加载文件路径</param>
    /// <returns>是否加载成功</returns>
    protected override bool ParseScript(string filename)
    {
        bool ret = false;
        try
        {
            var fileData = Utils.LoadFileInfo(filename);
            // 解析内容
            var splitData = fileData.Split('\n');

            bool scriptBracket = false;
            bool dataBracket = false;
            for (var i = 0; i < splitData.Length; i++)
            {
                var line = splitData[i];
                // 消除空格
                line = line.Trim();
                // 跳过空行
                if (string.IsNullOrEmpty(line))
                {
                    continue;
                }
                // 跳过注释行
                if (line.StartsWith("//"))
                {
                    continue;
                }

                // 如果是技能描述开始
                if (line.StartsWith("SkillNum"))
                {
                    // 读取技能号
                    var start = line.IndexOf("(", StringComparison.Ordinal);
                    var end = line.IndexOf(")", StringComparison.Ordinal);
                    if (start < 0 || end < 0)
                    {
                        throw new Exception("转换行为链失败: ()符号不完整, 行数:" + (i + 1));
                    }
                    // 编号长度
                    var length = end - start - 1;
                    if (length <= 0)
                    {
                        throw new Exception("转换行为链失败: ()顺序错误, 行数:" + (i + 1));
                    }

                    // 读取技能ID
                    var strSkillId = line.Substring(start + 1, length);
                    Num = Convert.ToInt32(strSkillId);
                    // 创建新技能
                }
                else if (line.StartsWith("{"))
                {
                    // 开始括号内容
                    scriptBracket = true;
                }
                else if (line.StartsWith("}"))
                {
                    // 关闭括号内容
                    scriptBracket = false;
                }
                else if (line.StartsWith("["))
                {
                    // 开始括号内容
                    dataBracket = true;
                }
                else if (line.StartsWith("]"))
                {
                    // 关闭括号内容
                    dataBracket = false;
                }
                else
                {
                    // 解析内容
                    if (scriptBracket)
                    {
                        // 参数列表内容
                        var start = line.IndexOf("(", StringComparison.Ordinal);
                        var end = line.IndexOf(")", StringComparison.Ordinal);

                        if (start < 0 || end < 0)
                        {
                            throw new Exception("转换行为链失败: ()符号不完整, 行数:" + (i + 1));
                        }
                        // 编号长度
                        var length = end - start - 1;
                        if (length <= 0)
                        {
                            throw new Exception("转换行为链失败: ()顺序错误, 行数:" + (i + 1));
                        }

                        //// 行为类型
                        //var type = line.Substring(0, start);
                        //// 行为参数
                        //var args = line.Substring(start + 1, length);
                        //// 消除参数空格
                        //args = args.Replace(" ", "");
                        
                        ActionScriptContent.Add(line.Replace("\t", ""));
                    }
                    if (dataBracket)
                    {
                        // 解析数据内容
                        dataContent.Add(line.Replace("\t", ""));
                    }
                }
            }
            ret = true;
        }
        catch (Exception e)
        {
            string err = "Exception:" + e.Message + "\n" + e.StackTrace + "\n";
            //LogSystem.ErrorLog(err);
        }
        return ret;
    }
}