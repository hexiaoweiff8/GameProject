using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Security.Cryptography;
using System.Text;


class UI_ResPacketsImport : EditorWindow
{

    [MenuItem("Tools/Import Resource Bundle", false, 140)]
    static void Menu_ImportGamePackets()
    {
        //创建窗口
        Rect wr = new Rect(0, 0,300, 400);
        UI_ResPacketsImport window = (UI_ResPacketsImport)EditorWindow.GetWindowWithRect(typeof(UI_ResPacketsImport), wr, true, "Import GamePackets");
        window.m_TargetPlatform = TargetPlatformTools.GetCurPlatform();
        window.Show(); 
    }


    TargetPlatform m_TargetPlatform = TargetPlatform.win64;
    DirectoryInfo[] m_dirs = null;
    string m_CurrResTag = "";
    Vector2 m_ScrollPos = new Vector2();
    bool m_CleanOnMakePack = false;
     

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

    //绘制窗口时调用
    void OnGUI()
    { 

        m_ScrollPos = EditorGUILayout.BeginScrollView(m_ScrollPos,false,false);
        {
            //选择目标平台
            TargetPlatformTools.GUI_ItemList(ref m_TargetPlatform, false);

            GUILayout.Space(25);

            if (m_dirs==null) m_dirs = BuildTagList(out m_CurrResTag);

            //选择资源版本
            GUI_SelectTag(m_dirs,ref m_CurrResTag);

            GUILayout.Space(25);

            m_CleanOnMakePack = EditorGUILayout.ToggleLeft(new GUIContent("导入前先清理"), m_CleanOnMakePack);


            GUILayout.Space(25);

            if (GUILayout.Button("导入资源包", GUILayout.Width(100)))
            {
                ImportGamePackets(m_TargetPlatform,m_CurrResTag,m_CleanOnMakePack);
                //关闭窗口
                this.Close();
            }

            GUILayout.Space(25);

            EncryptUI();
        }
        EditorGUILayout.EndScrollView();
    }



    public static void ImportGamePackets(TargetPlatform pt, string currResTag,bool clear)
    {
        switch (pt)
        {
            case TargetPlatform.ios:
                ImportPackets("ios", currResTag,clear);
                break;
            case TargetPlatform.android:
                ImportPackets("android", currResTag,clear);
                break;
            case TargetPlatform.win32:
                ImportPackets("win32", currResTag,clear);
                break;
            case TargetPlatform.win64: 
                ImportPackets("win64", currResTag, clear);
                break;
        }
    }
     


    static void cleanPackets(string Path)
    { 
        HashSet<string> extensions = new HashSet<string>();
        extensions.Add("");
        extensions.Add(".manifest");
        CleanDir(Path, extensions);
    } 
     
    static void ImportPackets(string pt, string currResTag, bool clear)
    {
        /* 先导入到备份目录再复制的流程
        string srcPath = Application.dataPath + "/../../ResProject/" + currResTag + "/Assets/StreamingAssets/" + pt + "/packets";
        string targetPath = Application.dataPath + "/StreamingAssets/pack_res";
        string bkPath = Application.dataPath + "/../../BundlesVersion/Packages/" + pt + "/pack_res";


        Directory.CreateDirectory(bkPath);
        Directory.CreateDirectory(targetPath);

        if (clear)
        {
            cleanPackets(targetPath);
            cleanPackets(bkPath);
            Debug.Log("Clean GamePackets done.");
            AssetDatabase.Refresh();
        }

        DirectoryInfo dirInfo = new DirectoryInfo(srcPath);
        FileInfo[] allFile = dirInfo.GetFiles();
        foreach (FileInfo fi in allFile)
        {
            string extension = fi.Extension.ToLower();
            if (extension == ""
                //|| extension == ".manifest"
                ) 
            {
                FileInfo bkFileInfo;
                {
                    string targetFileName = bkPath + "/" + fi.Name;
                    bkFileInfo = new FileInfo(targetFileName);
                    if (!bkFileInfo.Exists || fi.LastWriteTime != bkFileInfo.LastWriteTime)
                        fi.CopyTo(targetFileName, true);

                    bkFileInfo = new FileInfo(targetFileName);
                }

                {
                    string targetFileName = targetPath + "/" + fi.Name;
                    FileInfo tfInfo = new FileInfo(targetFileName);
                    if (!tfInfo.Exists || bkFileInfo.LastWriteTime != tfInfo.LastWriteTime)
                        bkFileInfo.CopyTo(targetFileName, true);
                }
            }
        }
        AssetDatabase.Refresh();
        Debug.Log(pt+" packets has been imported to complete.");
         */


        string srcPath = Application.dataPath + "/../../ResProject/" + currResTag + "/Assets/StreamingAssets/" + pt + "/packets";
        string TargetPath = Application.dataPath + "/StreamingAssets/pack_res"; 

         
        Directory.CreateDirectory(TargetPath);

        if (clear)
        {
            cleanPackets(TargetPath);
            Debug.Log("Clean GamePackets done.");
            AssetDatabase.Refresh();
        }

        DirectoryInfo dirInfo = new DirectoryInfo(srcPath);
        FileInfo[] allFile = dirInfo.GetFiles();
        foreach (FileInfo fi in allFile)
        {
            string extension = fi.Extension.ToLower();
            if (extension == ""
                //|| extension == ".manifest"
                )
            {
                FileInfo bkFileInfo;
                {
                    string targetFileName = TargetPath + "/" + fi.Name;
                    bkFileInfo = new FileInfo(targetFileName);
                    if (!bkFileInfo.Exists || fi.LastWriteTime != bkFileInfo.LastWriteTime)
                        fi.CopyTo(targetFileName, true);

                    bkFileInfo = new FileInfo(targetFileName);
                } 
            }
        }
        AssetDatabase.Refresh();
        Debug.Log(pt + " packets has been imported to complete.");
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


      string m_dncryptStr = "qwertyuiop";
    /// <summary>
    /// 加密资源包
    /// </summary>
      void EncryptUI()
      {
          EditorGUILayout.LabelField(new GUIContent("加密加标示资源包"));

          GUI.Label(new Rect(10, 325, 90, 20), "资源加密秘钥：");
          m_dncryptStr = GUI.TextField(new Rect(100, 325, 160, 20), m_dncryptStr, 20);

          GUILayout.Space(60);

          if (GUILayout.Button("导入加密标示资源包", GUILayout.Width(150)))
          {
              ImportETPackets(m_TargetPlatform, m_CurrResTag, m_CleanOnMakePack, m_dncryptStr);
              //关闭窗口
              this.Close();
          }
      }
      static void ImportETPackets(TargetPlatform pt, string currResTag, bool clear, string dncryptStr)
      {
          switch (pt)
          {
              case TargetPlatform.ios:
                  ImportTPackets("ios", currResTag, clear, dncryptStr);
                  break;
              case TargetPlatform.android:
                  ImportTPackets("android", currResTag, clear, dncryptStr);
                  break;
              case TargetPlatform.win32:
                  ImportTPackets("win32", currResTag, clear, dncryptStr);
                  break;
              case TargetPlatform.win64:
                  ImportTPackets("win64", currResTag, clear, dncryptStr);
                  break;
          }
      }
      static void ImportTPackets(string pt, string currResTag, bool clear, string dncryptStr)
      {
          if ( dncryptStr == "")
          {
              Debug.LogError("密钥 都不能为空");
          }
          string srcPath = Application.dataPath + "/../../ResProject/" + currResTag + "/Assets/StreamingAssets/" + pt + "/packets";
          string TargetPath = Application.dataPath + "/StreamingAssets/pack_res";


          Directory.CreateDirectory(TargetPath);

          if (clear)
          {
              cleanPackets(TargetPath);
              Debug.Log("Clean GamePackets done.");
              AssetDatabase.Refresh();
          }

          DateTime startTime = DateTime.Now;
          DirectoryInfo dirInfo = new DirectoryInfo(srcPath);
          FileInfo[] allFile = dirInfo.GetFiles();
          foreach (FileInfo fi in allFile)
          {
              string extension = fi.Extension.ToLower();
              if (extension == "")
              {
                  string srcFileName = fi.DirectoryName + "/" + fi.Name;
                  string targetFileName = TargetPath + "/" + fi.Name;

                  if (fi.Name == "rom_version")
                  {
                      fi.CopyTo(targetFileName, true);
                  }
                  else
                  {
                      CpoiFile(srcFileName, targetFileName, dncryptStr);
                  }

              }
          }
          AssetDatabase.Refresh();
          Debug.Log("导包加密总时间 = " + (DateTime.Now - startTime).ToString());
          Debug.Log(pt + " packets has been imported to complete. Encrypt complete!!!");
      }

    /// <summary>
    /// 加密方法
    /// </summary>
#region

      private static byte[] Keys = { 0x41, 0x72, 0x65, 0x79, 0x6F, 0x75, 0x6D, 0x79,
                                             0x53,0x6E, 0x6F, 0x77, 0x6D, 0x61, 0x6E, 0x3F };

      /// <summary>
      /// 特殊加密方式 对指定文件加密 输出一个新的文件
      /// </summary>
      private static bool CpoiFile(string InputFile, string OutputFile, string decryptKey)
      {
          try
          {
              using (FileStream fr = new FileStream(InputFile, FileMode.Open))
              {
                  using (FileStream fren = new FileStream(OutputFile, FileMode.Create))
                  {
                      int bylength = (int)fr.Length;
                      int hleng = 1024;//头部加密长度
                      byte[] bytearrayinput = new byte[bylength];
                      int encCount = Math.Min(bylength, hleng);//要加密的字节数

                      //加密资源信息
                      CryptoStream Enfr = EncryptFileStream(fren, decryptKey);

                      fr.Read(bytearrayinput, 0, bylength);
                      Enfr.Write(bytearrayinput, 0, encCount);
                      if (bylength >= hleng)
                      {
                          byte[] los = new byte[bylength - hleng];
                          Buffer.BlockCopy(bytearrayinput, hleng, los, 0, bylength - hleng);
                          fren.Write(los, 0, bylength - hleng);
                      }

                      //加密流结束会在尾部写入16字节随机无用字节 所以不要close
                  }
              }

          }
          catch
          {
              //文件异常
              return false;
          }
          return true;
      }

      /// <summary>
      /// 加密文件流
      /// </summary>
      private static CryptoStream EncryptFileStream(FileStream fs, string decryptKey)
      {
          decryptKey = GetSubString(decryptKey, 0, 32, "");
          decryptKey = decryptKey.PadRight(32, ' ');

          RijndaelManaged rijndaelProvider = new RijndaelManaged();
          rijndaelProvider.Key = Encoding.UTF8.GetBytes(decryptKey);
          rijndaelProvider.IV = Keys;

          ICryptoTransform encrypto = rijndaelProvider.CreateEncryptor();
          CryptoStream cytptostreamEncr = new CryptoStream(fs, encrypto, CryptoStreamMode.Write);
          return cytptostreamEncr;
      }
      /// <summary>
      /// 按字节长度(按字节,一个汉字为2个字节)取得某字符串的一部分 补齐密码
      /// </summary>
      /// <param name="sourceString">源字符串</param>
      /// <param name="startIndex">索引位置，以0开始</param>
      /// <param name="length">所取字符串字节长度</param>
      /// <param name="tailString">附加字符串(当字符串不够长时，尾部所添加的字符串，一般为"...")</param>
      /// <returns>某字符串的一部分</returns>
      private static string GetSubString(string sourceString, int startIndex, int length, string tailString)
      {
          string myResult = sourceString;

          //当是日文或韩文时(注:中文的范围:\u4e00 - \u9fa5, 日文在\u0800 - \u4e00, 韩文为\xAC00-\xD7A3)
          if (System.Text.RegularExpressions.Regex.IsMatch(sourceString, "[\u0800-\u4e00]+") ||
              System.Text.RegularExpressions.Regex.IsMatch(sourceString, "[\xAC00-\xD7A3]+"))
          {
              //当截取的起始位置超出字段串长度时
              if (startIndex >= sourceString.Length)
              {
                  return string.Empty;
              }
              else
              {
                  return sourceString.Substring(startIndex,
                      ((length + startIndex) > sourceString.Length) ? (sourceString.Length - startIndex) : length);
              }
          }

          //中文字符，如"中国人民abcd123"
          if (length <= 0)
          {
              return string.Empty;
          }
          byte[] bytesSource = Encoding.Default.GetBytes(sourceString);

          //当字符串长度大于起始位置
          if (bytesSource.Length > startIndex)
          {
              int endIndex = bytesSource.Length;

              //当要截取的长度在字符串的有效长度范围内
              if (bytesSource.Length > (startIndex + length))
              {
                  endIndex = length + startIndex;
              }
              else
              {   //当不在有效范围内时,只取到字符串的结尾
                  length = bytesSource.Length - startIndex;
                  tailString = "";
              }

              int[] anResultFlag = new int[length];
              int nFlag = 0;
              //字节大于127为双字节字符
              for (int i = startIndex; i < endIndex; i++)
              {
                  if (bytesSource[i] > 127)
                  {
                      nFlag++;
                      if (nFlag == 3)
                      {
                          nFlag = 1;
                      }
                  }
                  else
                  {
                      nFlag = 0;
                  }
                  anResultFlag[i] = nFlag;
              }
              //最后一个字节为双字节字符的一半
              if ((bytesSource[endIndex - 1] > 127) && (anResultFlag[length - 1] == 1))
              {
                  length = length + 1;
              }

              byte[] bsResult = new byte[length];
              Array.Copy(bytesSource, startIndex, bsResult, 0, length);
              myResult = Encoding.Default.GetString(bsResult);
              myResult = myResult + tailString;

              return myResult;
          }

          return string.Empty;

      }
#endregion

}
 
