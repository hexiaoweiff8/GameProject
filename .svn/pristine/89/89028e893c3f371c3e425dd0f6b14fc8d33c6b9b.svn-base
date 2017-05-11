using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;


public enum TargetPlatform
{
    all,
    ios,
    android,
    win32,
    win64
}

public class TargetPlatformTools
{
    public static string Enum2Str(TargetPlatform pt)
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
    public static TargetPlatform GetCurPlatform()
    {
        switch(EditorUserBuildSettings.activeBuildTarget)
        {
            case BuildTarget.iOS:
                return TargetPlatform.ios;
            case BuildTarget.Android:
                return TargetPlatform.android;
            default:
                return TargetPlatform.win64;
        }
    }
    public static void GUI_Item(TargetPlatform pt, ref TargetPlatform selectdPt)
    {
        GUIContent title = new GUIContent(TargetPlatformTools.Enum2Str(pt));
        if (EditorGUILayout.ToggleLeft(title, selectdPt == pt) && selectdPt != pt)
        {
            selectdPt = pt;
        }
    }

    public static void GUI_ItemList(ref TargetPlatform selectdPt, bool canSelectAll)
    {
        EditorGUILayout.LabelField(new GUIContent("选择目标平台"));
        if (canSelectAll) TargetPlatformTools.GUI_Item(TargetPlatform.all, ref selectdPt);
        TargetPlatformTools.GUI_Item(TargetPlatform.ios, ref selectdPt);
        TargetPlatformTools.GUI_Item(TargetPlatform.android, ref selectdPt);
        TargetPlatformTools.GUI_Item(TargetPlatform.win32, ref selectdPt);
        TargetPlatformTools.GUI_Item(TargetPlatform.win64, ref selectdPt);
    }

}