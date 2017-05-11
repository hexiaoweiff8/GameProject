using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using System.IO;

//FileUtil
//文件系统
public class FileSystem
{
    public enum IOMODE
    {
        Write,//写入
        Read//读出
    }

    static FileSystem _Single = null;
    public static FileSystem Single
    {
        get {
            if (_Single == null) _Single = new FileSystem();
            return _Single; 
        }
    }


    public static void XCopy(string resPath, string targetPath, string resExtension, string targetExtension)
    {
        DirectoryInfo resDir = new DirectoryInfo(resPath);
        DirectoryInfo targetDir = new DirectoryInfo(targetPath);

        if (!resDir.Exists)
        {
            Debug.Log(resDir);
            return;
        }

        if(!targetDir.Exists) targetDir.Create();

        FileInfo[] files = resDir.GetFiles();
        foreach (FileInfo curr in files)
        {
            if (resExtension == curr.Extension)
            {
                string name = Path.GetFileNameWithoutExtension(curr.Name);
                string targetFilePath = targetPath + "/" + name + targetExtension;
                FileInfo targetFileInfo = new FileInfo(targetFilePath);
                if (targetFileInfo.Exists && targetFileInfo.LastWriteTime == curr.LastWriteTime)
                    continue;

                File.Copy(curr.FullName, targetFilePath, true);
            }
        }

        //深度复制
        DirectoryInfo[] dirs = resDir.GetDirectories();
        foreach(DirectoryInfo curr in dirs)
        {
            XCopy(resPath + "/" + curr.Name, targetPath + "/" + curr.Name, resExtension, targetExtension);
        }
    }

    public static bool IsMetaTypeFile(string extension)
    {
        return (extension == ".meta");
    }

    //创建文件目录
    /*
    public static void CreateFileParentDirectory(string path)
    {
        string persistentDataDir = Path.GetFileName(persistentDataPath);
        int i = path.IndexOf(persistentDataDir);
        if (i < 0) return;
        int startIndex = i + persistentDataDir.Length + 1;
        if (startIndex >= path.Length) return;
        string subpaths = path.Substring(startIndex, path.Length - startIndex).Replace('\\', '/');
        string[] dirs = subpaths.Split('/');
        string checkPath = persistentDataPath;
        for (int j = 0; j < dirs.Length - 1; j++)
        {
            string curr = dirs[j];
            checkPath += "/" + curr;
            DirectoryInfo dirInfo = new DirectoryInfo(checkPath);
            if (!dirInfo.Exists) dirInfo.Create();
        }
    }*/
     

    public static string BuildRomCfgPath(string cfgName,out RES_LOCATION resLocation)
    {
        return RrelativePath2Absolute_File("romcfg/" + cfgName, IOMODE.Read, out resLocation);
    }

    public static bool IsFileExists(string absUrl)
    {
        FileInfo t = new FileInfo(absUrl);
        return t.Exists;
    }

    public static bool IsDirExists(string absUrl)
    { 
        DirectoryInfo t = new DirectoryInfo(absUrl);
        return t.Exists;
    }


    public enum RES_LOCATION
    {
        auto,//自动
        fileSystem,//文件系统
        externalPack,//外部包
        internalPack//内部包
    }

    public static string persistentDataPath
    {
        get
        {
            switch (Application.platform)
            {
                case RuntimePlatform.WindowsEditor:
                case RuntimePlatform.WindowsPlayer:
                case RuntimePlatform.WindowsWebPlayer:
                case RuntimePlatform.OSXEditor:
                case RuntimePlatform.OSXPlayer:
                case RuntimePlatform.OSXWebPlayer:
                    {
                        string tmp = Application.streamingAssetsPath;
                        int ia = tmp.LastIndexOf('/');
                        int ib = tmp.LastIndexOf('\\');
                        int ii = Math.Max(ia,ib);
                        return tmp.Substring(0,ii) + "/PersistentData";
                    }
                default:
                    return Application.persistentDataPath;
            }
        }
    }

    public static string MakeExternalPackPath(string pack_path, string pack_name)
    {
        return persistentDataPath + "/" + pack_path + "/" + pack_name;
    }

    //相对路径转换为绝对路径
    public static string RrelativePath2Absolute_Packet(string pack_path,
        string pack_name,
        bool autoCreateDevDir, 
        out RES_LOCATION srcType,
        out string devPackDir,
        bool ignoreExternal = false//是否忽略外部包
        )
    {
        string externalPath = MakeExternalPackPath(pack_path, pack_name);
        string externalPath_dev = MakeExternalPackPath(pack_path, "pk_"+pack_name);

        if (!ignoreExternal)
        {
            //外部文件系统
            if (IsDirExists(externalPath_dev))
                devPackDir = externalPath_dev;
            else
            {
                if (autoCreateDevDir)
                {
                    DirectoryInfo tmpDir = new DirectoryInfo(externalPath_dev);
                    tmpDir.Create();
                    devPackDir = externalPath_dev;
                }
                else
                    devPackDir = null;
            }

            //外部路径 
            if (IsFileExists(externalPath))
            {
                srcType = RES_LOCATION.externalPack;
                return externalPath;
            }
        }
        else
            devPackDir = null;

        string streamingAssetsPath = Application.streamingAssetsPath;
       
        //读模式，由于android只支持www方式，所以路径是file开头
        string sealedUrl = //(streamingAssetsPath[0] == '/' ? "file://" : "file:///") + 
           
           streamingAssetsPath + "/" + pack_path + "/" + pack_name;//只读目录
         
        switch(Application.platform)
        {
            case  RuntimePlatform.WindowsEditor:
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.WindowsWebPlayer:
                sealedUrl = "file:///" + sealedUrl;
                break;
            case RuntimePlatform.IPhonePlayer:
            case RuntimePlatform.OSXEditor:
            case RuntimePlatform.OSXPlayer:
            case RuntimePlatform.OSXWebPlayer:
            case RuntimePlatform.OSXDashboardPlayer:
                 sealedUrl = "file://" + sealedUrl;
                break;
        };
        srcType = RES_LOCATION.internalPack;
        return sealedUrl;//内部路径 
    }

    public  static void DumpDirTree( DirectoryInfo dir)
    {
        FileInfo[] files = dir.GetFiles();
        foreach(FileInfo curr in files)
        {
            Debug.Log("[FILE] " + curr.FullName);
        }

       DirectoryInfo[] dirs = dir.GetDirectories();
       foreach (DirectoryInfo curr in dirs)
       {
           Debug.Log("[DIR] " + curr.FullName);
           DumpDirTree(curr);
       }

    }

    public static byte[] ReadFile(string path)
    {
          FileInfo fInfo = new FileInfo(path);
        using (FileStream fs = fInfo.OpenRead())
        {   
            int len = (int)fInfo.Length;
            byte[] buff = new byte[len];
            fs.Read(buff, 0, len);
            fs.Close();

            return buff;
        }
    }


    public static string byte2string(byte[] bytes)
    {
        int byteStartIndex = 0;
        if (bytes.Length >= 3)
        {
            if (bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF)
                byteStartIndex = 3;//跳过utf8文件头
        }
        return Encoding.UTF8.GetString(bytes, byteStartIndex, bytes.Length - byteStartIndex);
    }

    public static string NetFileBuff2String(byte[] buf)
    {
        int startindex = 0;
        if (buf.Length > 3&&buf[0] == 0xEF && buf[1] == 0xBB && buf[2] == 0xBF)
              startindex = 3;

        return Encoding.UTF8.GetString(buf,startindex,buf.Length-startindex);
    }

    public static string RrelativePath2Absolute_File(string path, IOMODE mode, out RES_LOCATION srcType)
    {
        string externalPath = persistentDataPath + "/" + path;


        if (mode == IOMODE.Write)
        {
            srcType = RES_LOCATION.fileSystem;
            return externalPath;
        }

        
        //外部路径
        if (IsFileExists(externalPath))
        {
            srcType = RES_LOCATION.fileSystem;
            return externalPath;
        }

        //读模式，由于android只支持www方式，所以路径是file开头
        string sealedUrl = "file:///" + Application.streamingAssetsPath + "/" + path;//只读目录
        srcType = RES_LOCATION.internalPack;
        return sealedUrl;//内部路径
    }
} 