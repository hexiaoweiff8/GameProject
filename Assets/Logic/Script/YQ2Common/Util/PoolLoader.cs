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
    private Dictionary<string, Queue<GameObject>> pool = new Dictionary<string, Queue<GameObject>>();

    /// <summary>
    /// 加载对象-Res方式
    /// </summary>
    /// <param name="path">被加载路径</param>
    /// <returns>对象单位</returns>
    public GameObject Load(string path)
    {
        if (pool.ContainsKey(path) && pool[path].Count > 0)
        {
            var result = pool[path].Dequeue();
            result.SetActive(true);
            return result;
        }
        return ResourcesLoader.Single.Load(path);
    }

    /// <summary>
    /// 加载对象-AB包方式
    /// TODO 加载时创建原始单位,
    /// TODO 其他单位使用完毕后销毁
    /// </summary>
    /// <param name="key"></param>
    /// <param name="package"></param>
    /// <returns></returns>
    public GameObject Load(string key, string package)
    {
        if (pool.ContainsKey(key) && pool[key].Count > 0)
        {
            var result = pool[key].Dequeue();
            result.SetActive(true);
            return result;
        }
        return ResourcesLoader.Single.Load(key, package);
    }

    /// <summary>
    /// 回收对象
    /// </summary>
    /// <param name="path">对象加载路径</param>
    /// <param name="obj">对象实例</param>
    /// <param name="clean">清理对象方法 默认为空</param>
    public void CircleBack(string path, GameObject obj, Action clean = null)
    {
        if (pool.ContainsKey(path))
        {
            obj.SetActive(false);
            pool[path].Enqueue(obj);
        }
        else
        {
            var queue = new Queue<GameObject>();
            queue.Enqueue(obj);
            pool.Add(path, queue);
        }
        if (clean != null)
        {
            clean();
        }
    }
}
