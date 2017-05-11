using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
   /*
static public class ListEX
{
    public static List<T> Clone<T> (this List<T> list) where T:new()
    {
        List<T>  re = new List<T>();
        foreach (var curr in list) re.Add(curr);
        return re;
    }

  
    public static List<string> Clone (this List<string> list)  
    {
        List<string> re = new List<string>();
        foreach (var curr in list) re.Add(curr);
        return re;
    }
} */

public class SceneManage : MonoEX.SingletonAuto<SceneManage> // : MonoBehaviour
{ 
    class SceneInfo
    {
       public string levelName;
       public List<string> dependPacks = new List<string>();
    }


    /// <summary>
    /// 注册一个场景
    /// </summary>
    /// <param name="levelName">场景名</param>
    /// <param name="dependPacks">依赖包</param>
    public void RegScene(string levelName,string[] dependPacks)
    {
        SceneInfo scInfo = new SceneInfo();
        scInfo.levelName = levelName;

        Array.ForEach(dependPacks, i => scInfo.dependPacks.Add(i)); 

        m_ScenesDefine.Add(levelName, scInfo);
    }

    /// <summary>
    /// 反注册一个场景
    /// </summary>
    /// <param name="levelName">场景名</param>
    public void UnregScene(string levelName)
    {
        if (!IsRegd(levelName)) return;
        m_ScenesDefine.Remove(levelName);
    }


    /// <summary>
    /// 是否是一个已注册的场景
    /// </summary>
    public bool IsRegd(string levelName)
    {
        return m_ScenesDefine.ContainsKey(levelName);
    }
   
    /// <summary>
    /// 装载一个场景
    /// </summary>
    public void Load(string levelName,List<string> dyDependPacks ,  LoadSceneMode mode, Action complateCallBack, Action<float> progressCallBack)
    {
        if (m_IsLoading) throw new Exception("场景装载过程中，不允许执行卸载场景任务");

        if (mode == LoadSceneMode.Additive)
        {
            if (m_ActivedScene.ContainsKey(levelName))
            {
                if (!Unload(levelName)) throw new Exception();//通常是场景尚未装载成功时卸载
            }
        }else
        {
            Dictionary<string, ActivedSceneInfo> tmp = new Dictionary<string, ActivedSceneInfo>();
            foreach (KeyValuePair<string, ActivedSceneInfo> curr in m_ActivedScene) tmp.Add(curr.Key, curr.Value);
            foreach (KeyValuePair<string, ActivedSceneInfo> curr in tmp)
            {
                if (!Unload(curr.Key)) throw new Exception();//通常是场景尚未装载成功时卸载
            }
        }

        CoroutineManage.Single.StartCoroutine(_Load(levelName,dyDependPacks, mode, complateCallBack, progressCallBack));
    }


    /// <summary>
    /// 卸载一个场景
    /// </summary>
    public bool Unload(string sceneName)
    {
        if (m_IsLoading) throw new Exception("场景装载过程中，不允许执行卸载场景任务");
        if(!m_ActivedScene.ContainsKey(sceneName)) return false;

        bool re = SceneManager.UnloadScene(sceneName);
        if (re)
        {
            var info = m_ActivedScene[sceneName];
            
            m_ActivedScene.Remove(sceneName);

            //卸载静态资源包
            if (info.scInfo != null)
            {
                foreach (var packName in info.scInfo.dependPacks) ResourceRefManage.Single.SubRef(packName);
            }

            //卸载动态资源包
            if (info.dyDependPacks != null)
            {
                foreach (var packName in info.dyDependPacks) ResourceRefManage.Single.SubRef(packName);
            }
        }
        return re;
    }
     
    IEnumerator _Load(string levelName,List<string> dyDependPacks, LoadSceneMode mode, Action complateCallBack, Action<float> progressCallBack)
    {
        if (m_IsLoading) throw new Exception("场景装载过程中，不允许执行其它装载场景任务");

        using (new MonoEX.SafeCall(BeginLoad, EndLoad))
        {
            float res_jd = 0;
            SceneInfo info = null;
            //装载静态依赖包
            if (m_ScenesDefine.ContainsKey(levelName))
            {
                info = m_ScenesDefine[levelName];
                foreach (var packName in info.dependPacks) ResourceRefManage.Single.AddRef(packName);//立即增加资源包引用记数


                bool loadDone = false;
                PacketLoader loader = new PacketLoader();
                {
                    List<string> dependPacks = info.dependPacks;
                    loader.Start(PackType.Res, dependPacks, (isok) =>
                    {
                        if (isok == false) { throw new Exception(string.Format("装载场景{0}的依赖资源失败", levelName)); }
                        loadDone = true;
                    });
                }

                while (!loadDone)
                {
                    if (progressCallBack != null) progressCallBack(loader.Progress * 0.3f);
                    yield return null;//等待资源装载完成
                }

                res_jd = 0.3f;
            }

            //装载动态资源包
            if (dyDependPacks != null && dyDependPacks.Count>0)
            {
                foreach (var packName in dyDependPacks) ResourceRefManage.Single.AddRef(packName);//立即增加资源包引用记数


                bool loadDone = false;
                PacketLoader loader = new PacketLoader();
                { 
                    loader.Start(PackType.Res, dyDependPacks, (isok) =>
                    {
                        if (isok == false) { throw new Exception(string.Format("装载场景{0}的动态资源失败", levelName)); }
                        loadDone = true;
                    }
                    );
                }

                while (!loadDone)
                {
                    if (progressCallBack != null) progressCallBack(loader.Progress * 0.2f + 0.3f);
                    yield return null;//等待资源装载完成
                }
                res_jd = 0.5f;
            }


            //装载场景
            {
                AsyncOperation m_async = SceneManager.LoadSceneAsync(levelName, mode);

                while (!m_async.isDone)
                {
                    if (progressCallBack != null) progressCallBack(m_async.progress * (1 - res_jd) + res_jd);
                    yield return null;
                }
            }


            List<string> ClonedDyPackList = null;

            if (dyDependPacks != null && dyDependPacks.Count > 0)
            {
                ClonedDyPackList = new List<string>();
                foreach (string v in dyDependPacks) ClonedDyPackList.Add(v);
            }
            var asceneinfo = new ActivedSceneInfo() { dyDependPacks = ClonedDyPackList, scInfo = info };
            m_ActivedScene.Add(levelName, asceneinfo);

            if (complateCallBack != null) 
                complateCallBack(); 
        }
    }

    class ActivedSceneInfo
    {
        public SceneInfo scInfo;//场景信息
        public List<string> dyDependPacks = new List<string>();//动态依赖包
    }

    void BeginLoad()
    {
        m_IsLoading = true;
    }

    void EndLoad()
    {
        m_IsLoading = false;
    }

    bool m_IsLoading = false;//当前是否正在装载中
    Dictionary<string, ActivedSceneInfo> m_ActivedScene = new Dictionary<string, ActivedSceneInfo>();//活跃的场景
    Dictionary<string, SceneInfo> m_ScenesDefine = new Dictionary<string,SceneInfo>(); //场景定义
}



