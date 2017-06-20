using System;
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using UnityEditor;

public class SkillScriptEditor : EditorWindow
{

    [MenuItem("SkillScriptEditor/Open Script Editor")]
    static void OpenSkillScriptEditor()
    {
        SkillScriptEditor window = GetWindow<SkillScriptEditor>(true, "SkillScriptEditor");
        window.Init();
    }

    private int skillId = 1000;
    private int selectScriptContentIndex = -1;
    private int selectDataContentIndex = -1;
    private Vector2 scrollPos = Vector2.zero;

    /// <summary>
    /// 事件内容
    /// </summary>
    private static List<string> scriptContent = new List<string>();

    /// <summary>
    /// 数据内容
    /// </summary>
    private static List<string> dataContent = new List<string>(); 

    void Init()
    {
        selectScriptContentIndex = -1;
        selectDataContentIndex = -1;
        scriptContent.Clear();
        dataContent.Clear();
    }

    void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.BeginVertical("box", GUILayout.Width(400), GUILayout.Height(400));
        #region ScrollView - Script Content

        EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width(400), GUILayout.Height(400));
        //GUIStyle style = new GUIStyle(GUI.skin.button);
        for (int i = 0; i < scriptContent.Count; i++)
        {
            int index = i;
            if (selectScriptContentIndex == index)
                GUI.color = Color.green;

            if (GUILayout.Button(scriptContent[index]))
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
        skillId = EditorGUILayout.IntField("script ID:", skillId);
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

        if (GUILayout.Button("子级左括号"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.LeftBracket, this.position);
        }
        if (GUILayout.Button("子级右括号"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.RightBracket, this.position);
        }
        if (GUILayout.Button("点对点特效"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.PointToPoint, this.position);
        }
        if (GUILayout.Button("点对对象特效(跟踪)"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.PointToObj, this.position);
        }
        if (GUILayout.Button("点特效"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.Point, this.position);
        }
        if (GUILayout.Button("范围碰撞检测"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.CollisionDetection, this.position);
        }
        if (GUILayout.Button("滑动碰撞检测"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.SlideCollisionDetection, this.position);
        }
        if (GUILayout.Button("音效"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.Audio, this.position);
        }
        if (GUILayout.Button("Buff"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.Buff, this.position);
        }
        if (GUILayout.Button("伤害/治疗结算"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.Calculate, this.position);
        }
        if (GUILayout.Button("移动"))
        {
            SkillTriggerScriptEditor.ShowSkillTriggerScriptWindow(SkillTriggerScriptEditor.TriggerType.Move, this.position);
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
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.LevelData, this.position);
        }
        if (GUILayout.Button("技能CD值"))
        {
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.CDTime, this.position);
        }
        if (GUILayout.Button("技能CD组"))
        {
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.CDGroup, this.position);
        }
        if (GUILayout.Button("技能可释放次数"))
        {
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.ReleaseTime, this.position);
        }
        if (GUILayout.Button("技能描述"))
        {
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.Description, this.position);
        }
        if (GUILayout.Button("技能Icon路径"))
        {
            SkillTriggerScriptEditor.ShowSkillDataScriptWindow(SkillTriggerScriptEditor.DataType.Icon, this.position);
        }
        EditorGUILayout.EndVertical();
        #endregion
        #endregion

        EditorGUILayout.EndVertical();
        EditorGUILayout.EndHorizontal();
    }



    void DeleteContent()
    {
        if (selectScriptContentIndex != -1)
        {
            scriptContent.RemoveAt(selectScriptContentIndex);
        }
        if (selectDataContentIndex != -1)
        {
            dataContent.RemoveAt(selectDataContentIndex);
        }
        selectScriptContentIndex = -1;
        selectDataContentIndex = -1;
    }

    void ClearContent()
    {
        dataContent.Clear();
        scriptContent.Clear();
    }

    /// <summary>
    /// 添加事件内容
    /// </summary>
    /// <param name="str">事件</param>
    public static void AddScriptContent(string str)
    {
        scriptContent.Add(str);
    }

    /// <summary>
    /// 添加数据内容
    /// </summary>
    /// <param name="str">数据</param>
    public static void AddDataContent(string str)
    {
        dataContent.Add(str);
    }

    void MoveUpContent()
    {
        if (selectScriptContentIndex != -1 && selectScriptContentIndex > 0)
        {
            string temp = scriptContent[selectScriptContentIndex];
            scriptContent[selectScriptContentIndex] = scriptContent[selectScriptContentIndex - 1];
            scriptContent[selectScriptContentIndex - 1] = temp;
            selectScriptContentIndex -= 1;
        }
    }

    void MoveDownContent()
    {
        if (selectScriptContentIndex != -1 && selectScriptContentIndex < scriptContent.Count - 1)
        {
            string temp = scriptContent[selectScriptContentIndex];
            scriptContent[selectScriptContentIndex] = scriptContent[selectScriptContentIndex + 1];
            scriptContent[selectScriptContentIndex + 1] = temp;
            selectScriptContentIndex += 1;
        }
    }

    void SaveScript()
    {
        string content = String.Empty;
        content += string.Format("SkillNum({0})", skillId);

        // 行为内容
        content += "\r\n{\r\n";
        foreach (var str in scriptContent)
        {
            content += "\t";
            content += str;
            content += "\r\n";
        }
        content += "}";

        // 数据内容
        content += "\r\n[\r\n";
        foreach (var str in dataContent)
        {
            content += "\t";
            content += str;
            content += "\r\n";
        }
        content += "]";
        Utils.CreateOrOpenFile(Application.streamingAssetsPath + "/", "SkillScript" + skillId.ToString() + ".txt", content);
        //Debug.Log(ret);
    }

    void LoadScript()
    {
        ClearContent();
        bool ret = ParseScript(Application.streamingAssetsPath + "/" + "SkillScript" + skillId.ToString() + ".txt");
    }

    private bool ParseScript(string filename)
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
                    skillId = Convert.ToInt32(strSkillId);
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
                        
                        scriptContent.Add(line.Replace("\t", ""));
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

    //private bool LoadScriptFromStream(StreamReader sr)
    //{
    //    bool bracket = false;
    //    do
    //    {
    //        string line = sr.ReadLine();

    //        if (line == null)
    //            break;

    //        line = line.Trim();

    //        if (line.StartsWith("//") || line == "")
    //            continue;

    //        if (line.StartsWith("skill"))
    //        {
    //            int start = line.IndexOf("(");
    //            int end = line.IndexOf(")");
    //            if (start == -1 || end == -1)
    //                Debug.LogError(string.Format("ParseScript Error, start == -1 || end == -1  {0}", line));

    //            int length = end - start - 1;
    //            if (length <= 0)
    //            {
    //                Debug.LogError(string.Format("ParseScript Error, length <= 1, {0}", line));
    //                return false;
    //            }

    //            string args = line.Substring(start + 1, length);
    //            int skillId = (int)Convert.ChangeType(args, typeof(int));
    //        }
    //        else if (line.StartsWith("{"))
    //        {
    //            bracket = true;
    //        }
    //        else if (line.StartsWith("}"))
    //        {
    //            bracket = false;
    //        }
    //        else
    //        {
    //            // 解析trigger
    //            if (bracket == true)
    //            {
    //                int start = line.IndexOf("(");
    //                int end = line.IndexOf(")");
    //                if (start == -1 || end == -1)
    //                    Debug.LogError(string.Format("ParseScript Error, {0}", line));

    //                int length = end - start - 1;
    //                if (length <= 0)
    //                {
    //                    Debug.LogError(string.Format("ParseScript Error, length <= 1,  {0}", line));
    //                    return false;
    //                }
    //                line = line.Replace("\t", "");
    //                scriptContent.Add(line);
    //            }
    //        }
    //    } while (true);


    //    return true;
    //}
}