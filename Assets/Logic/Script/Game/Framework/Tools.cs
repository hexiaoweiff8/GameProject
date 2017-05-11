using UnityEngine;
using System.Collections;
using System.IO;
using System.Text;
using System;
using System.Collections.Generic;

public class Tools
{
    public static object[] CallMethod(string module, string func, params object[] args)
    {
        LuaManager luaMgr = AppFacade.Instance.GetManager<LuaManager>();
        if (luaMgr == null) return null;
        return luaMgr.CallFunction(module + "." + func, args);
    }

    public static string GetOS()
    {
#if UNITY_STANDALONE
        return "Win";
#elif UNITY_ANDROID
        return "Android";
#elif UNITY_IPHONE
        return "iOS";
#endif
    }

    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath
    {
        get
        {
            string game = GameSetting.AppName.ToLower();
            if (Application.isMobilePlatform)
            {
                return Application.persistentDataPath + "/" + game + "/";
            }

            if (GameSetting.DevelopMode)
            {
                return Application.streamingAssetsPath + "/" + GetOS() + "/";
            }

            if (Application.platform == RuntimePlatform.OSXEditor)
            {
                int i = Application.dataPath.LastIndexOf('/');
                return Application.dataPath.Substring(0, i + 1) + game + "/";
            }
            return "c:/" + game + "/";
        }
    }
    /// <summary>
    /// 应用程序内容路径
    /// </summary>
    public static string AppContentPath()
    {
        string path = string.Empty;
        switch (Application.platform)
        {
            case RuntimePlatform.Android:
                path = "jar:file://" + Application.dataPath + "!/assets/";
                break;
            case RuntimePlatform.IPhonePlayer:
                path = Application.dataPath + "/Raw/";
                break;
            default:
                path = Application.streamingAssetsPath + "/";
                break;
        }
        return path;
    }

    public static string GetRelativePath()
    {
        if (Application.isEditor)
        {
            //return "file://" + System.Environment.CurrentDirectory.Replace("\\", "/") + "/Assets/" + AppConst.AssetDir + "/";
            return "file://" + Application.streamingAssetsPath + "/" + GetOS() + "/";
        }
        else if (Application.isMobilePlatform
            || Application.isConsolePlatform)
        {
            return "file:///" + DataPath;
        }

        else // For standalone player.
        {
            return "file://" + Application.streamingAssetsPath + "/" + GetOS() + "/";
        }
    }

    /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    public static string md5file(string file)
    {
        try
        {
            FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }

    /// <summary>
    /// 资源管理器
    /// </summary>
    public static ResourceManager GetResManager()
    {
        return AppFacade.Instance.GetManager<ResourceManager>();
    }

    public static void ChangeChildLayer(Transform t, int layer)
    {
        t.gameObject.layer = layer;
        for (int i = 0; i < t.childCount; ++i)
        {
            Transform child = t.GetChild(i);
            child.gameObject.layer = layer;
            ChangeChildLayer(child, layer);
        }
    }

    public static void AddChildToTarget(Transform target, Transform child)
    {
        child.SetParent(target, false);
        child.localScale = Vector3.one;
        child.localPosition = Vector3.zero;
        child.localRotation = Quaternion.identity;
        ChangeChildLayer(child, target.gameObject.layer);
    }

    public static void AdjustBaseWindowDepth(GameObject rootGameObject, GameObject go, int platformDepth)
    {
        int needDepth = 1;
        needDepth = Mathf.Clamp(GetMaxTargetDepth(rootGameObject, false),
                platformDepth, int.MaxValue);
        SetTargetMinPanelDepth(go, needDepth + 1);
    }

    public static void SetTargetMinPanelDepth(GameObject obj, int depth)
    {
        List<UIPanel> lsPanels = GetPanelSorted(obj, true);
        if (lsPanels != null)
        {
            int i = 0;
            while (i < lsPanels.Count)
            {
                lsPanels[i].depth = depth + i;
                i++;
            }
        }
    }

    public static int GetMaxTargetDepth(GameObject obj, bool includeInactive = true)
    {
        int minDepth = -1;
        List<UIPanel> lsPanels = GetPanelSorted(obj, includeInactive);
        if (lsPanels != null)
            return lsPanels[lsPanels.Count - 1].depth;
        return minDepth;
    }

    private class CompareSubPanels : IComparer<UIPanel>
    {
        public int Compare(UIPanel left, UIPanel right)
        {
            return left.depth - right.depth;
        }
    }

    private static List<UIPanel> GetPanelSorted(GameObject target, bool includeInactive = true)
    {
        UIPanel[] panels = target.transform.GetComponentsInChildren<UIPanel>(includeInactive);
        if (panels.Length > 0)
        {
            List<UIPanel> lsPanels = new List<UIPanel>(panels);
            lsPanels.Sort(new CompareSubPanels());
            return lsPanels;
        }
        return null;
    }

}
