using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 对象池加载器
/// </summary>
public class PoolLoader : Singleton<PoolLoader>
{

    /// <summary>
    /// 对象池
    /// </summary>
    private Dictionary<string, GameObject> pool = new Dictionary<string, GameObject>();

    ///// <summary>
    ///// 加载对象-Res方式
    ///// </summary>
    ///// <param name="path">被加载路径</param>
    ///// <returns>对象单位</returns>
    //public GameObject Load(string path)
    //{
    //    if (pool.ContainsKey(path) && pool[path].Count > 0)
    //    {
    //        var result = pool[path].Dequeue();
    //        result.SetActive(true);
    //        return result;
    //    }
    //    return ResourcesLoader.Single.Load(path);
    //}

    /// <summary>
    /// 加载对象-AB包方式
    /// </summary>
    /// <param name="key">预设名称(带后缀)</param>
    /// <param name="package">包名称</param>
    /// <param name="parent">父级</param>
    /// <returns></returns>
    public GameObject Load(string key, string package, Transform parent = null)
    {
        GameObject result = null;
        if (pool.ContainsKey(key))
        {
            result = GameObject.Instantiate(pool[key]);
            result.transform.parent = parent;
            result.SetActive(true);
            return result;
        }
        else
        {
            var newObj = ResourcesLoader.Single.Load(key, package);
            newObj.transform.parent = parent;
            pool.Add(key, newObj);
            result = GameObject.Instantiate(newObj);
            newObj.SetActive(false);
        }
        if (result == null)
        {
            throw new Exception("包:" + package + ", key:" + key + "不存在.");
        }
        return result;
    }

    /// <summary>
    /// 回收对象
    /// </summary>
    /// <param name="path">对象加载路径</param>
    /// <param name="obj">对象实例</param>
    /// <param name="clean">清理对象方法 默认为空</param>
    public void CircleBack(GameObject obj, Action clean = null)
    {
        //if (pool.ContainsKey(path))
        //{
        //    obj.SetActive(false);
        //    pool[path].Enqueue(obj);
        //}
        //else
        //{
        //    var queue = new Queue<GameObject>();
        //    queue.Enqueue(obj);
        //    pool.Add(path, queue);
        //}
        // 销毁单位
        GameObject.Destroy(obj);
        if (clean != null)
        {
            clean();
        }


    }

    /// <summary>
    /// 清理数据
    /// </summary>
    public void Clear()
    {
        pool.Clear();
    }
}
