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
    /// 加载对象
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