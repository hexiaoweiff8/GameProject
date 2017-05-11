using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 目标选择器
/// </summary>
public class ItemSelecter : MonoBehaviour
{
    /// <summary>
    /// 目标选择器单例
    /// </summary>
    public static ItemSelecter Single;

    /// <summary>
    /// 处理器列表
    /// </summary>
    private Dictionary<string, Action<GameObject>> handlerDic = new Dictionary<string, Action<GameObject>>();

    /// <summary>
    /// 处理器列表最大数量
    /// 防止自制框架内存泄漏导致崩溃
    /// </summary>
    private int maxHandlerCount = 1000;

    /// <summary>
    /// 相机引用
    /// TODO 获取方式重新定义
    /// </summary>
    public Camera camera
    {
        get; set;
    }

    /// <summary>
    /// 初始化目标选择
    /// </summary>
    void Start()
    {
        // 创建单例
        Single = this;
    }


    void Update()
    {
        if (camera == null)
        {
            return;
        }

        // 检测鼠标点击, 运行点击事件列表
        if (!Input.GetMouseButtonDown(0))
        {
            return;
        }

        var ray = camera.ScreenPointToRay(Input.mousePosition);
        RaycastHit rayHit;
        if (Physics.Raycast(ray, out rayHit))
        {
            Debug.Log(rayHit.collider.gameObject.name);
            // 调用事件列表
            foreach (var handle in handlerDic)
            {
                // 多线程数据安全
                lock (handlerDic)
                {
                    handle.Value(rayHit.collider.gameObject);
                }
            }
        }
    }

    /// <summary>
    /// 注册目标处理器
    /// </summary>
    /// <param name="handler"></param>
    public  void RegHandler(Action<GameObject> handler)
    {
        if (handler == null)
        {
            return;
        }
        // 验证handler最大数量
        if (handlerDic.Count >= maxHandlerCount)
        {
            Debug.LogError("目标选择器处理列表达到最大数量, 请检查是否有内存泄漏");
            return;
        }
        // 多线程数据安全
        lock (handlerDic)
        {
            handlerDic.Add("", handler);
        }
    }

    public void UnRegHandler(string key)
    {
        // 多线程数据安全
        lock (handlerDic)
        {
            handlerDic.Remove(key);
        }
    }


}