using UnityEngine;
using System.Collections;
using LuaInterface;
using System.IO;
using System.Text;

public class SimpleLuaResLoader : LuaFileUtils
{
    private StringBuilder mSb = new StringBuilder(42);
    public SimpleLuaResLoader()
    {
        instance = this;
        if (GameSetting.DevelopMode)
        {
            if (GameSetting.LuaBundleMode)
            {
                beZip = true;
            }
            else
            {
                beZip = false;
            }
        }
        else
        {
            beZip = true;
        }
    }

    public override byte[] ReadFile(string fileName)
    {
        if (GameSetting.DevelopMode)
        {
            byte[] buffer = base.ReadFile(fileName);
            if (buffer == null)
            {
                buffer = ReadResourceFile(fileName);
            }
            if (buffer == null)
            {
                buffer = ReadDownLoadFile(fileName);
            }
            return buffer;
        }
        else
        {
            byte[] buffer = ReadDownLoadFile(fileName);
            if (buffer == null)
            {
                buffer = ReadResourceFile(fileName);
            }
            if (buffer == null)
            {
                buffer = base.ReadFile(fileName);
            }
            return buffer;
        }
    }

    private byte[] ReadResourceFile(string fileName)
    {
        byte[] buffer = null;
        string path = "Lua/" + fileName;
        TextAsset text = Resources.Load(path, typeof(TextAsset)) as TextAsset;

        if (text != null)
        {
            buffer = text.bytes;
            Resources.UnloadAsset(text);
        }

        return buffer;
    }

    private byte[] ReadDownLoadFile(string fileName)
    {
        string path = fileName;
        if (!Path.IsPathRooted(fileName))
        {
            string dir = Application.persistentDataPath.Replace('\\', '/');
            mSb.Remove(0, mSb.Length).Append(dir).Append("/").Append(GetOSDir())
                .Append("/Lua/").Append(fileName);
            path = mSb.ToString();
        }
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        return null;
    }
}

public class SimpleLuaClient : LuaClient
{
    protected override LuaFileUtils InitLoader()
    {
        return new SimpleLuaResLoader();
    }

    protected override void LoadLuaFiles()
    {
    }

    protected override void OpenLibs()
    {
        base.OpenLibs();
    }

    protected override void CallMain()
    {
        base.CallMain();
    }

    protected override void StartMain()
    {
        base.StartMain();
    }

    protected override void Bind()
    {
        base.Bind();
    }

    protected override void OnLoadFinished()
    {
    }

    public void OnLuaFilesLoaded()
    {
        if (GameSetting.EnableLuaDebug)
        {
            OpenZbsDebugger();
        }

        luaState.Start();
        StartLooper();
        StartMain();
    }
}

public class LuaManager : Manager
{
    private SimpleLuaClient mSimpleLuaClient;

    private void InitLuaPath()
    {
        if (!GameSetting.DevelopMode)
        {
            SimpleLuaClient.GetMainState().AddSearchPath(Tools.DataPath + "lua");
        }
    }

    private void Awake()
    {
        mSimpleLuaClient = gameObject.AddComponent<SimpleLuaClient>();
    }

    private void AddBundle(string bundleName)
    {
        string url = Tools.DataPath + "lua/" + bundleName;
        if (File.Exists(url))
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(url);
            if (bundle != null)
            {
                bundleName = bundleName.Replace("lua/", "");
                bundleName = bundleName.Replace(".assetbundle", "");
                LuaFileUtils.Instance.AddSearchBundle(bundleName.ToLower(), bundle);
            }
        }
    }

    /// <summary>
    /// 初始化LuaBundle
    /// </summary>
    void InitLuaBundle()
    {
        //TODODO
        //if (/*!GameSetting.DevelopMode&&*/ GameSetting.LuaBundleMode)
        if (!GameSetting.DevelopMode&& GameSetting.LuaBundleMode)
        {
            AddBundle("lua.assetbundle");
            AddBundle("lua_cjson.assetbundle");
            AddBundle("lua_common.assetbundle");
            AddBundle("lua_eventsystem.assetbundle");
            AddBundle("lua_framework.assetbundle");
            AddBundle("lua_globalization_en.assetbundle");
            AddBundle("lua_globalization_zh.assetbundle");
            AddBundle("lua_lpeg.assetbundle");
            AddBundle("lua_lua.assetbundle");
            AddBundle("lua_manager.assetbundle");
            AddBundle("lua_misc.assetbundle");
            AddBundle("lua_protobuf.assetbundle");
            AddBundle("lua_proto.assetbundle");
            AddBundle("lua_socket.assetbundle");
            AddBundle("lua_system.assetbundle");
            AddBundle("lua_system_reflection.assetbundle");
            AddBundle("lua_uiscripts.assetbundle");
            AddBundle("lua_unityengine.assetbundle");
        }
    }

    public void InitStart()
    {
        InitLuaPath();
        InitLuaBundle();
        mSimpleLuaClient.OnLuaFilesLoaded();
    }

    public object[] CallFunction(string funcName, params object[] args)
    {
        LuaFunction func = SimpleLuaClient.GetMainState().GetFunction(funcName);
        if (func != null)
        {
            return func.Call(args);
        }
        return null;
    }

    public void Close()
    {
    }
}
