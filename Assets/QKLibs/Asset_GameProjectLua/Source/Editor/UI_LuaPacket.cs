using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

class UI_LuaPacket : EditorWindow
{
    //enum TargetPlatform
    //{
    //    all,
    //    ios,
    //    android,
    //    win32,
    //    win64
    //}


    [MenuItem("Tools/Lua Pack Generate", false, 130)]
    static void Menu_Make()
    {
        //创建窗口
        Rect wr = new Rect(0, 0, 300, 300);
        UI_LuaPacket window = (UI_LuaPacket)EditorWindow.GetWindowWithRect(typeof(UI_LuaPacket), wr, true, "Make LuaPacket");
        window.m_TargetPlatform = TargetPlatformTools.GetCurPlatform();
        window.Show();
    }
     
    TargetPlatform m_TargetPlatform = TargetPlatform.win64;

    static void GUI_SelectTargetPlatform(ref TargetPlatform selectdPt, bool canSelectAll)
    {
        EditorGUILayout.LabelField(new GUIContent("选择目标平台"));
        if (canSelectAll) GUI_TargetPlatformItem(TargetPlatform.all, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.ios, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.android, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.win32, ref selectdPt);
        GUI_TargetPlatformItem(TargetPlatform.win64, ref selectdPt);
    }

    static void GUI_TargetPlatformItem(TargetPlatform pt, ref TargetPlatform selectdPt)
    {
        GUIContent title = new GUIContent(TargetPlatformEnum2Str(pt));
        if (EditorGUILayout.ToggleLeft(title, selectdPt == pt) && selectdPt != pt)
        {
            selectdPt = pt;
        }
    }

    static string TargetPlatformEnum2Str(TargetPlatform pt)
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

    //绘制窗口时调用
    void OnGUI()
    {

        m_ScrollPos = EditorGUILayout.BeginScrollView(m_ScrollPos, false, false);
        {
            //选择目标平台
            GUI_SelectTargetPlatform(ref m_TargetPlatform, false);

            GUILayout.Space(25);

            if (m_dirs==null)
            m_dirs = BuildTagList(out m_CurrResTag);

            //选择资源版本
            GUI_SelectTag(m_dirs, ref m_CurrResTag);
            GUILayout.Space(25);

            if (GUILayout.Button("制作Lua资源包", GUILayout.Width(100)))
            {
                MakePackets(m_TargetPlatform,m_CurrResTag);

                //关闭窗口
                this.Close();
            }
        }
        EditorGUILayout.EndScrollView();
    }

    public static DirectoryInfo[] BuildTagList(out string currResTag)
    {
        string resPath = Application.dataPath + "/../../BundlesVersion/Packages";
        DirectoryInfo dirInfo = new DirectoryInfo(resPath);
        if (!dirInfo.Exists) { currResTag = ""; return new DirectoryInfo[0]; }
        DirectoryInfo[] dirs = dirInfo.GetDirectories();
        if (dirs.Length > 1)
        {
            if (dirs[0].Name == ".svn")
                currResTag = dirs[1].Name;
            else
                currResTag = dirs[0].Name;
        }
        else
            currResTag = dirs.Length == 1 && dirs[0].Name != ".svn" ? dirs[0].Name : "";

        return dirs;
    }
     
     


    DirectoryInfo[] m_dirs = null;
    string m_CurrResTag = "";

    public static void GUI_SelectTag(DirectoryInfo[] dirs, ref string currResTag)
    {
        EditorGUILayout.LabelField(new GUIContent("选择版本"));
        foreach (DirectoryInfo item in dirs)
        {
            if (item.Name == ".svn") continue;
            GUI_ResTagItem(item.Name, ref currResTag);
        }
    }

    static void GUI_ResTagItem(string tagName, ref string currResTag)
    {
        GUIContent title = new GUIContent(tagName);
        if (EditorGUILayout.ToggleLeft(title, tagName == currResTag) && currResTag != tagName)
        {
            currResTag = tagName;
        }
    }

    Vector2 m_ScrollPos = new Vector2();

    static void MakePackets(TargetPlatform pt, string currResTag)
    {
        switch (pt)
        {
            case TargetPlatform.ios:
                Lua_MakePacketsForIOS(currResTag);
                break;
            case TargetPlatform.android:
                Lua_MakePacketsForAndroid(currResTag);
                break;
            case TargetPlatform.win32:
                Lua_MakePacketsForWin32(currResTag);
                break;
            case TargetPlatform.win64:
                Lua_MakePacketsForWin64(currResTag);
                break;
        }
    }

    static void Lua_MakePacketsForIOS(string currResTag)
    {
        _MakePackets(BuildTarget.iOS, "ios", currResTag);
    }

    static void Lua_MakePacketsForAndroid(string currResTag)
    {
        _MakePackets(BuildTarget.Android, "android", currResTag);
    }

    static void Lua_MakePacketsForWin32(string currResTag)
    {
        _MakePackets(BuildTarget.StandaloneWindows, "win32", currResTag);
    }

    static void Lua_MakePacketsForWin64(string currResTag)
    {
        _MakePackets(BuildTarget.StandaloneWindows64, "win64", currResTag);
    }

    static void _MakePackets(BuildTarget bt, string suffix,string currResTag)
    {
        //增量设置包名
        SetLuaAssetBundleName("pk_script", "script");
        SetLuaAssetBundleName("pk_tabs", "tabs");
        SetLuaAssetBundleName("pk_lualibs", "lualibs");
        

        /*
         " + suffix + "/
         */
        //打包
        string outPath = Application.streamingAssetsPath + "/pack_script";
        string bkPath = Application.dataPath + "/../../BundlesVersion/Packages/" + currResTag + "/" + suffix + "/pack_script";

        Directory.CreateDirectory(outPath);
        Directory.CreateDirectory(bkPath);

      //  RecoveryManifest(outPath);//恢复增量打包关联文件
        BuildPipeline.BuildAssetBundles(bkPath,
                                         //BuildAssetBundleOptions.UncompressedAssetBundle |
                                         BuildAssetBundleOptions.DeterministicAssetBundle,
                                        bt
                                        );

        FileSystem.XCopy(bkPath, outPath, "", "");
       // BackupManifest(outPath);//备份增量打包关联文件

        

        AssetDatabase.Refresh();
        Debug.Log("Lua打包完成 " + outPath);
    }


    /*

    static void BackupManifest(string Path)
    {
        DirectoryInfo dirInfo = new DirectoryInfo(Path);
        if (!dirInfo.Exists) return;

        FileInfo[] allFile = dirInfo.GetFiles();
        foreach (FileInfo fi in allFile)
        {
            string extension = fi.Extension.ToLower();
            if (extension == ".manifest")
            {
                string newPath = fi.FullName.Substring(0, fi.FullName.Length - 9) + "_.bkmft";
                //Debug.Log("BackupManifest " + newPath);
                fi.MoveTo(newPath);
            }
        }
    }

    static void RecoveryManifest(string Path)
    {
        DirectoryInfo dirInfo = new DirectoryInfo(Path);
        if (!dirInfo.Exists) return;

        FileInfo[] allFile = dirInfo.GetFiles();
        foreach (FileInfo fi in allFile)
        {
            string extension = fi.Extension.ToLower();
            if (extension == ".bkmft")
            {
                string newPath = fi.FullName.Substring(0, fi.FullName.Length - 7) + ".manifest";
                fi.MoveTo(newPath);
            }
        }
    }*/
    static void SetLuaAssetBundleName(string dirname, string packname)
    {   
        string luaBytesDir = Application.dataPath + "/LuaBytes/" + dirname;
        //清理中间目录
        {
            DirectoryInfo delDir = new DirectoryInfo(luaBytesDir);
            if (delDir.Exists) delDir.Delete(true);
        }

        //复制文件到中间目录,并变更扩展名
        {
            string resourcesDir = FileSystem.persistentDataPath + "/pack_script/" + dirname;
            FileSystem.XCopy(resourcesDir, luaBytesDir, UI_ImportConfigs.DEVLuaExtension, ".bytes");
        }
        AssetDatabase.Refresh();


        {
            DirectoryInfo dirObj = new DirectoryInfo(luaBytesDir);
            SetAssetBundleName(packname, dirObj);
            AssetDatabase.Refresh();
        } 
    }


    static void SetAssetBundleName(string _packetName, DirectoryInfo dir)
    {
        FileInfo[] allFiles = dir.GetFiles();
        foreach (FileInfo currFile in allFiles)
        {
            string extension = currFile.Extension;
            if (FileSystem.IsMetaTypeFile(extension))
                continue;

            if (extension != ".bytes")
            {
                Debug.Log("SetAssetBundleName#1");
                continue;
            }


            string dataPath = Application.dataPath.Substring(0, Application.dataPath.Length - 6);
            string prePath = currFile.FullName.Substring(dataPath.Length, currFile.FullName.Length - dataPath.Length);
           
            string packetName = _packetName;

            

            AssetImporter importer =  AssetImporter.GetAtPath(prePath);
            if(string.IsNullOrEmpty(importer.assetBundleName)||importer.assetBundleName!=packetName)
            {
                importer.assetBundleName = packetName;
                importer.SaveAndReimport();
            } 
        }

        DirectoryInfo[] alldirs = dir.GetDirectories();
        foreach (DirectoryInfo d in alldirs)
        {
            SetAssetBundleName(_packetName, d);
        }
    } 
	 
}
 
