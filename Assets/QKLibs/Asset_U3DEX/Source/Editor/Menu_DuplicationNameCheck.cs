using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;
using System.IO;

class Menu_DuplicationNameCheck
{
    //[MenuItem("QKTools/资源重名检查", false, 20)]
    static void DuplicationNameCheck()
    {
        Dictionary<string, FileInfo> files = new Dictionary<string, FileInfo>();
        DirectoryInfo dir = new DirectoryInfo(Application.dataPath);

        if (_DuplicationNameCheck(1,dir, files))
        {
            Debug.Log("不存在重名资源");
        }
    }

    static bool _DuplicationNameCheck(int depth,DirectoryInfo dir, Dictionary<string, FileInfo> files)
    {
        FileInfo[] flist = dir.GetFiles();
        foreach (FileInfo curr in flist)
        {
            string fname = Path.GetFileNameWithoutExtension(curr.Name).ToLower();
            if (fname == "newhero") continue;
            //if (fname == "freetype") continue;
            if (curr.Extension == ".meta") continue;

            if (files.ContainsKey(fname))
            {
                Debug.LogError(fname);
                Debug.LogError(string.Format("存在重名资源:{0}\r\n{1}", files[fname].FullName, curr.FullName));
                return false;
            }
            files.Add(fname, curr);
        }

        DirectoryInfo[] dirs = dir.GetDirectories();
        foreach (DirectoryInfo curr in dirs)
        {
            if (depth==1&&
                curr.Name != "PersistentData"&&
                curr.Name != "Resources"
                ) continue;
            if (!_DuplicationNameCheck(depth+1,curr, files)) return false;
        }

        return true;
    }
}
 
