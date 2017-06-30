using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

/// <summary>
/// 脚本编辑器主窗口base
/// </summary>
public abstract class BaseScriptEditor : EditorWindow
{
    /// <summary>
    /// 脚本编号
    /// </summary>
    protected int Num = 10000;

    /// <summary>
    /// 文件名称
    /// 需重载
    /// </summary>
    protected string FileName = "Script";

    /// <summary>
    /// 被选择的行为脚本index
    /// </summary>
    protected int selectScriptContentIndex = -1;

    /// <summary>
    /// 被选择的数据脚本index
    /// </summary>
    protected int selectDataContentIndex = -1;

    /// <summary>
    /// 滚动窗口起始点
    /// </summary>
    protected Vector2 scrollPos = Vector2.zero;

    /// <summary>
    /// Action事件内容
    /// </summary>
    protected static List<string> ActionScriptContent = new List<string>();

    /// <summary>
    /// Attach事件内容
    /// </summary>
    protected static List<string> AttachScriptContent = new List<string>();

    /// <summary>
    /// Detach事件内容
    /// </summary>
    protected static List<string> DetachScriptContent = new List<string>();

    /// <summary>
    /// 工作中Content
    /// </summary>
    protected static List<string> WorkingScriptContent = ActionScriptContent;

    /// <summary>
    /// 数据内容
    /// </summary>
    protected static List<string> dataContent = new List<string>();

    /// <summary>
    /// 当前工作区
    /// </summary>
    private int workContentIndex = 0;

    /// <summary>
    /// 初始化方法
    /// </summary>
    public void Init()
    {
        selectScriptContentIndex = -1;
        selectDataContentIndex = -1;
        WorkingScriptContent.Clear();
        ActionScriptContent.Clear();
        AttachScriptContent.Clear();
        DetachScriptContent.Clear();
        dataContent.Clear();
    }

    /// <summary>
    /// 删除节点
    /// </summary>
    public void DeleteContent()
    {
        if (selectScriptContentIndex != -1)
        {
            WorkingScriptContent.RemoveAt(selectScriptContentIndex);
        }
        if (selectDataContentIndex != -1)
        {
            dataContent.RemoveAt(selectDataContentIndex);
        }
        selectScriptContentIndex = -1;
        selectDataContentIndex = -1;
    }

    public void ClearContent()
    {
        dataContent.Clear();
        WorkingScriptContent.Clear();
    }

    /// <summary>
    /// 添加行为content
    /// </summary>
    /// <param name="script">行为content内容</param>
    public void AddScriptContent(string script)
    {
        WorkingScriptContent.Add(script);
    }

    /// <summary>
    /// 添加数据content
    /// </summary>
    /// <param name="script">数据content内容</param>
    public void AddDataContent(string script)
    {
        dataContent.Add(script);
    }

    /// <summary>
    /// 向上移动content
    /// </summary>
    public void MoveUpContent()
    {
        if (selectScriptContentIndex != -1 && selectScriptContentIndex > 0)
        {
            string temp = ActionScriptContent[selectScriptContentIndex];
            ActionScriptContent[selectScriptContentIndex] = ActionScriptContent[selectScriptContentIndex - 1];
            ActionScriptContent[selectScriptContentIndex - 1] = temp;
            selectScriptContentIndex -= 1;
        }
    }

    /// <summary>
    /// 向下移动content
    /// </summary>
    public void MoveDownContent()
    {
        if (selectScriptContentIndex != -1 && selectScriptContentIndex < ActionScriptContent.Count - 1)
        {
            string temp = ActionScriptContent[selectScriptContentIndex];
            ActionScriptContent[selectScriptContentIndex] = ActionScriptContent[selectScriptContentIndex + 1];
            ActionScriptContent[selectScriptContentIndex + 1] = temp;
            selectScriptContentIndex += 1;
        }
    }


    public void Refresh()
    {
        EditorGUILayout.BeginHorizontal();
        if (workContentIndex == 0)
        {
            GUI.color = Color.red;
        }
        if (GUILayout.Button("Action区"))
        {
            ChangeWorkingScriptContent(0);
            workContentIndex = 0;
        }
        if (workContentIndex == 0)
        {
            GUI.color = Color.white;
        }
        if (workContentIndex == 1)
        {
            GUI.color = Color.red;
        }
        if (GUILayout.Button("Attach区"))
        {
            ChangeWorkingScriptContent(1);
            workContentIndex = 1;
        }
        if (workContentIndex == 1)
        {
            GUI.color = Color.white;
        }
        if (workContentIndex == 2)
        {
            GUI.color = Color.red;
        }
        if (GUILayout.Button("Detach区"))
        {
            ChangeWorkingScriptContent(2);
            workContentIndex = 2;
        }
        if (workContentIndex == 2)
        {
            GUI.color = Color.white;
        }
        EditorGUILayout.EndHorizontal();
    }

    /// <summary>
    /// 切换工作区
    /// </summary>
    /// <param name="index"></param>
    public void ChangeWorkingScriptContent(int index)
    {
        selectDataContentIndex = -1;
        switch (index)
        {
            case 0:
                WorkingScriptContent = ActionScriptContent;
                break;
            case 1:
                WorkingScriptContent = AttachScriptContent;
                break;
            case 2:
                WorkingScriptContent = DetachScriptContent;
                break;
        }
    }


    /// <summary>
    /// 保存脚本
    /// </summary>
    public void SaveScript()
    {
        string content = String.Empty;
        content += string.Format("SkillNum({0})", Num);

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
            content += "\r\nAttach\r\n{\r\n";
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
            content += "\r\nDetach\r\n{\r\n";
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


    /// <summary>
    /// 加载脚本
    /// </summary>
    public void LoadScript()
    {
        ClearContent();
        var filePath = Application.streamingAssetsPath + "/" + FileName + Num + ".txt";
        var ret = ParseScript(filePath);
        if (!ret)
        {
            Debug.LogError("脚本保存失败:" + filePath);
        }
        else
        {
            Debug.LogError("脚本保存成功:" + filePath);
        }
    }

    /// <summary>
    /// 转换脚本
    /// </summary>
    /// <param name="filename">被转换文件</param>
    /// <returns></returns>
    protected abstract bool ParseScript(string filename);
}