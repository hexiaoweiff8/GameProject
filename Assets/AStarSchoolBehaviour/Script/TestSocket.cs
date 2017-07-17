using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Text;
using ProtoBuf;
using QKSDKUtils;
using Random = System.Random;

public class TestSocket : MonoBehaviour
{

    /// <summary>
    /// 计数器
    /// </summary>
    private int counter = 0;

    /// <summary>
    /// 数据请求头
    /// </summary>
    private byte[] head = null;

    /// <summary>
    /// 数据
    /// </summary>
    private byte[] data = new byte[0];

    /// <summary>
    /// 是否收到服务器心跳消息
    /// 如果收到则回发心跳
    /// </summary>
    private bool isReceivedServerMsg = false;

    /// <summary>
    /// 用户Id
    /// </summary>
    private int userId = 0;


    private void Start()
    {
        // 注册事件
        SocketManager.Single.AddDataAction((data) =>
        {
            isReceivedServerMsg = true;
            var dataStr = Encoding.UTF8.GetString(data);
            //// 判断是否为头数据
            //if (dataStr.StartsWith("head"))
            //{
            //    head = Encoding.UTF8.GetBytes(dataStr.Replace("head", ""));
            //}
            // 接收protoBuf数据并解析打印
            Debug.Log("收到" + dataStr);

            if (data.Length > 3)
            {
                var td = SocketManager.DeSerialize<MsgOptional>(data);
                if (td != null)
                {
                    Debug.Log(td.OpType + "," + td.OpParams);
                }
            }
        });
        Connect();

        var objectId = new ObjectID();
        var json = JsonUtility.ToJson(objectId);
        Debug.Log(objectId.ID);
        Debug.Log(json);
        Debug.Log(JsonUtility.FromJson<ObjectID>(json).ID);
        // 产生随机Id
        userId = new Random(DateTime.Now.Millisecond).Next(int.MaxValue);
        //ByteUtils.ReadMsg();
    }



    private void Update()
    {
        Control();
        // 心跳消息
        SendPointMsg();
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


    public void SendPointMsg()
    {
        if (!isReceivedServerMsg)
        {
            return;
        }
        if (data != null && data.Length > 0)
        {
            // 发送心跳数据给服务器
            SocketManager.Single.Send(data);
            // 清空数据
            data = new byte[0];
            Debug.Log("发送:" + data);
        }
        isReceivedServerMsg = false;
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
        // 包装数据头
        SocketManager.Single.Send(PackageData(Encoding.UTF8.GetBytes("测试数据"),userId, 2));
    }

    /// <summary>
    /// 发送测试消息
    /// </summary>
    private void SendTestMsg()
    {
        //if (head == null)
        //{
        //    Debug.LogError("请先请求head数据");
        //    return;
        //}
        //var msg = Encoding.UTF8.GetBytes("111测试");
        //TestData td = new TestData();
        //td.Att2 = "www";
        //var msg = Serialize(td);
        MsgOptional opMsg = new MsgOptional()
        {
            OpPosX = 0,
            OpPosY = 0,
            OpPosZ = 0,
            OpType = 1
        };
        var stream = new MemoryStream();
        ProtoBuf.Serializer.Serialize(stream, opMsg);
        data = PackageData(stream.ToArray(), userId, 1);
        isReceivedServerMsg = true;
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

    /// <summary>
    /// 打包数据
    /// </summary>
    /// <param name="packageData">被包装数据</param>
    /// <param name="uId">用户Id</param>
    /// <param name="msgId">数据Id</param>
    /// <returns></returns>
    private byte[] PackageData(byte[] packageData, int uId, int msgId)
    {
        byte[] result = null;

        // 将数据打包放入MsgHead的body中
        var dataHead = new MsgHead()
        {
            msgId = msgId,
            userId = uId,
            body = ByteUtils.AddDataHead(packageData),
        };
        var stream = new MemoryStream();
        Serializer.Serialize(stream, dataHead);
        result = stream.ToArray();

        return result;
    }
}

/// <summary>
/// ProtoBuf测试数据
/// </summary>
[ProtoContract]
public class TestData
{
    [ProtoMember(1)]
    public string Att1 = "test数据";
    
    [ProtoMember(2)]
    public string Att2 { get; set; }
}