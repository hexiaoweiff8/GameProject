using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using QKSDKUtils;

public class TestSocket : MonoBehaviour
{

    /// <summary>
    /// 创建线程数量
    /// </summary>
    public int ThreadCount = 100;


    /// <summary>
    /// 计数器
    /// </summary>
    private int counter = 0;

    /// <summary>
    /// 数据请求头
    /// </summary>
    private byte[] head = null;


    private void Start()
    {
        // 注册事件
        SocketManager.Single.AddDataAction((data) =>
        {
            var dataStr = Encoding.UTF8.GetString(data);
            // 判断是否为头数据
            if (dataStr.StartsWith("head"))
            {
                head = Encoding.UTF8.GetBytes(dataStr.Replace("head", ""));
            }
            Debug.Log("收到" + dataStr);
        });
        Connect();
        //ByteUtils.ReadMsg();
    }



    private void Update()
    {
        Control();
    }


    public void Control()
    {
        // 发送消息
        if (Input.GetMouseButtonUp(0))
        {
            SendTestMsg();
        }
        // 重新链接
        if (Input.GetKeyUp(KeyCode.R))
        {
            Connect();
        }
        if (Input.GetKeyUp(KeyCode.T))
        {
            // 创建测试发送线程
        }
    }


    private void OnDestroy()
    {
        SocketManager.Single.Close();
    }

    /// <summary>
    /// 链接服务器
    /// </summary>
    private void Connect()
    {
        SocketManager.Single.Connect("127.0.0.1", 6000);
        SocketManager.Single.Send(Encoding.UTF8.GetBytes("GetHead"));
    }

    /// <summary>
    /// 发送测试消息
    /// </summary>
    private void SendTestMsg()
    {
        if (head == null)
        {
            Debug.LogError("请先请求head数据");
            return;
        }
        var msg = "111测试";
        Debug.Log("发送:" + msg);
        SocketManager.Single.Send(new List<byte[]>()
        {
            head,
            Encoding.UTF8.GetBytes(msg)
        });
    }

    /// <summary>
    /// 获取格式化
    /// </summary>
    /// <param name="msg"></param>
    /// <returns></returns>
    private byte[] GetFormatedData(byte[] msg)
    {
        return ByteUtils.ConnectByte(head, msg, 0, msg.Length);
    }
}