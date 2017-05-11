using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;
using System.IO;

class UI_ImportConfigs : EditorWindow
{
     [MenuItem("Tools/Import Configs", false, 120)]
    static void Menu_ImportConfigs()
    {
        //创建窗口
        Rect wr = new Rect(0, 0, 300, 300);
        UI_ImportConfigs window = (UI_ImportConfigs)EditorWindow.GetWindowWithRect(typeof(UI_ImportConfigs), wr, true, "Import Configs");
        window.Show();
    }
     

       static DirectoryInfo[] BuildTagList(out string currResTag)
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


     DirectoryInfo[] m_dirs = null;
     string m_CurrResTag = "";
     Vector2 m_ScrollPos = new Vector2();
     bool m_CleanFirst = false;



     static void GUI_SelectTag(DirectoryInfo[] dirs, ref string currResTag)
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


     //绘制窗口时调用
     void OnGUI()
     {

         m_ScrollPos = EditorGUILayout.BeginScrollView(m_ScrollPos, false, false);
         {
             if (m_dirs==null)
                m_dirs = BuildTagList(out m_CurrResTag);
              
             //选择资源版本
             GUI_SelectTag(m_dirs, ref m_CurrResTag);

             GUILayout.Space(25);

             m_CleanFirst = EditorGUILayout.ToggleLeft(new GUIContent("导入前先清理"), m_CleanFirst);


             GUILayout.Space(25);

             if (GUILayout.Button("导入配置表", GUILayout.Width(100)))
             {
                 ImportConfigs(m_CurrResTag, m_CleanFirst);
                 //关闭窗口
                 this.Close();
             }
         }
         EditorGUILayout.EndScrollView();
     }


     public static void ImportConfigs(string resTag, bool cleanFirst)
    {
        string resPath = Application.dataPath + "/../../ResProject/" + resTag + "/Assets/StreamingAssets/config/client_config";
        string targetPath =  Application.dataPath+ "/PersistentData/pack_script/pk_tabs";

        if (cleanFirst)
        {
            HashSet<string> extensions = new HashSet<string>();
            extensions.Add(DEVLuaExtension);
            CleanDir(targetPath, extensions);

            Debug.Log("Clean configs done.");
        }


        {
            FileSystem.XCopy(resPath, targetPath, DEVLuaExtension, DEVLuaExtension);
        }
        Debug.Log("导入配置表完成");
        AssetDatabase.Refresh();
    }



       static void CleanDir(string Path, HashSet<string> extensions)
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

    

     public const string DEVLuaExtension = ".lua";//研发期间的lua扩展名

}
 
