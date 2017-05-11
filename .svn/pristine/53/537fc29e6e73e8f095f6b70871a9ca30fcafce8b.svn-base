using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;
using System.IO;

class RomEditor
{
    public const string DEVLuaExtension = ".lua";//研发期间的lua扩展名

    public static void CleanDir(string Path, HashSet<string> extensions)
    {
        DirectoryInfo dirInfo = new DirectoryInfo(Path);
        if (!dirInfo.Exists) return;
        FileInfo[] allFile = dirInfo.GetFiles();
        foreach (FileInfo fi in allFile)
        {
            string extension = fi.Extension.ToLower();
            if (extensions.Contains(extension))
                fi.Delete();
        }

        DirectoryInfo[] dirs = dirInfo.GetDirectories();
        foreach (DirectoryInfo dir in dirs)
            dir.Delete(true);
    }

    

    public enum TargetPlatform
    {
        all,
        ios,
        android,
        win32,
        win64
    }

    public static DirectoryInfo[] BuildTagList(out string currResTag)
    {
        string resPath = Application.dataPath + "/../../ResProject";
        DirectoryInfo dirInfo = new DirectoryInfo(resPath);
        DirectoryInfo[] dirs = dirInfo.GetDirectories();
        if (dirs.Length > 1)
        {
            if (dirs[0].Name == ".svn")
                currResTag = dirs[1].Name;
            else
                currResTag = dirs[0].Name;
        }
        else
            currResTag = "";

        return dirs;
    }

    public static string TargetPlatformEnum2Str(TargetPlatform pt)
    {
        switch (pt)
        {
            case TargetPlatform.all:
                return "all";
            case TargetPlatform.ios:
                return "ios";
            case TargetPlatform.android:
                return "android";
            case TargetPlatform.win32:
                return "win32";
            case TargetPlatform.win64:
                return "win64";
        }
        return "none";
    }

    static void GUI_TargetPlatformItem(TargetPlatform pt, ref TargetPlatform selectdPt)
    {
        GUIContent title = new GUIContent(TargetPlatformEnum2Str(pt));
        if (EditorGUILayout.ToggleLeft(title, selectdPt == pt) && selectdPt != pt)
        {
            selectdPt = pt;
        }
    }

    public static void GUI_SelectTargetPlatform(ref TargetPlatform selectdPt, bool canSelectAll)
    {
        EditorGUILayout.LabelField(new GUIContent("选择目标平台"));
        if (canSelectAll) GUI_TargetPlatformItem(TargetPlatform.all, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.ios, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.android, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.win32, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.win64, ref selectdPt);
    }

}
 
