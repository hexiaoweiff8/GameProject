using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;
using Util;

/// <summary>
/// Socket管理器
/// 发送接收消息
/// 建立Socket链接
/// </summary>
public class SocketManager : ILoopItem
{

    // -------------------------单例--------------------------------
    /// <summary>
    /// 单例
    /// </summary>
    public static SocketManager Single
    {
        get
        {
            if (single == null)
            {
                single = new SocketManager();
                // 启动循环器
                single.Start();
            }
            return single;
        }
    }

    /// <summary>
    /// 单例对象
    /// </summary>
    private static SocketManager single = null;

    // -------------------------单例--------------------------------


    // ------------------------公共属性-----------------------------
    /// <summary>
    /// 是否链接成功
    /// </summary>
    public bool ConnectSuccess { get; private set; }

    /// <summary>
    /// Socket状态
    /// </summary>
    public int SocketState { get; set; }


    // --------------------------常量-------------------------------

    /// <summary>
    /// 缓冲大小 32字节
    /// </summary>
    public const int BuffSize = 32768;

    /// <summary>
    /// 连接超时时间, 单位毫秒
    /// </summary>
    public const int WaitTime = 3000;

    /// <summary>
    /// 数据头长度
    /// </summary>
    public const int DataHeadLength = 4;


    // ------------------------私有属性-----------------------------

    ///// <summary>
    ///// 缓冲区
    ///// </summary>
    //private readonly byte[] buffer = new byte[BuffSize];

    /// <summary>
    /// 已接收到的消息如果尚未能够解读则保存等待拼接
    /// </summary>
    private byte[] receivedBuffer = new byte[0];

    /// <summary>
    /// socket链接对象
    /// </summary>
    private Socket socket;

    ///// <summary>
    ///// 监听器列表
    ///// </summary>
    //private Dictionary<int, Action<int, string>> msgListenerDic = new Dictionary<int, Action<int, string>>();

    /// <summary>
    /// 已连接地址
    /// </summary>
    private string connectingAddress = null;

    /// <summary>
    /// 已连接接口
    /// </summary>
    private int connectingPort = 0;

    /// <summary>
    /// 数据Action
    /// 当有能够读取的数据时调用所有Action
    /// </summary>
    private Dictionary<int, List<Action<MsgHead>>> dataActionList = new Dictionary<int, List<Action<MsgHead>>>();

    ///// <summary>
    ///// 事件自增编号
    ///// </summary>
    //private static int ActionId
    //{
    //    get { return actionId++; }
    //}

    ///// <summary>
    ///// 自增编号
    ///// </summary>
    //private static int actionId = 1024;

    /// <summary>
    /// 循环器ID
    /// </summary>
    private long looperId = -1;


    // --------------------------公共方法----------------------------

    ///// <summary>
    ///// 增加监听器
    ///// </summary>
    ///// <param name="msgId"></param>
    ///// <param name="listener"></param>
    //public void AddMsgListener(int msgId, Action<int, string> listener)
    //{
    //    msgListenerDic.Add(msgId, listener);
    //}

    ///// <summary>
    ///// 删除msgId监听器
    ///// </summary>
    ///// <param name="msgId"></param>
    //public void RemoveMsgListener(int msgId)
    //{
    //    if (ContainsMsgListener(msgId))
    //    {
    //        msgListenerDic.Remove(msgId);
    //    }
    //}

    ///// <summary>
    ///// 检查是否包含msgId的监听器
    ///// </summary>
    ///// <param name="msgId"></param>
    ///// <returns></returns>
    //public bool ContainsMsgListener(int msgId)
    //{
    //    return msgListenerDic.ContainsKey(msgId);
    //}

    /// <summary>
    /// 启动
    /// </summary>
    public void Start()
    {
        if (looperId > 0)
        {
            LooperManager.Single.Remove(looperId);
        }
        looperId = LooperManager.Single.Add(this);
        dataActionList.Clear();
    }

    /// <summary>
    /// 停止运行
    /// </summary>
    public void Stop()
    {
        LooperManager.Single.Remove(looperId);
    }

    /// <summary>
    /// 添加事件
    /// </summary>
    /// <param name="msgId">消息Id</param>
    /// <param name="action"></param>
    public void RegAction(int msgId, Action<MsgHead> action)
    {
        if (action == null)
        {
            return;
        }
        if (ContainsAction(msgId))
        {
            dataActionList[msgId].Add(action);
        }
        else
        {
            dataActionList.Add(msgId, new List<Action<MsgHead>>()
            {
                action
            });
        }
    }

    /// <summary>
    /// 添加事件
    /// </summary>
    /// <param name="msgId">消息Id</param>
    /// <param name="actionList">事件列表</param>
    public void RegAction(int msgId, List<Action<MsgHead>> actionList)
    {
        foreach (var action in actionList)
        {
            RegAction(msgId, action);
        }
    }

    /// <summary>
    /// 是否存在该Id事件
    /// </summary>
    /// <param name="msgId"></param>
    /// <returns></returns>
    public bool ContainsAction(int msgId)
    {
        return dataActionList.ContainsKey(msgId);
    }

    /// <summary>
    /// 删除事件
    /// </summary>
    /// <param name="msgId"></param>
    public void RemoveAction(int msgId)
    {
        if (ContainsAction(msgId))
        {
            dataActionList.Remove(msgId);
        }
    }

    /// <summary>
    /// 清空所有action
    /// </summary>
    public void ClearAllAction()
    {
        dataActionList.Clear();
    }


    ///// <summary>
    ///// 链接Socket udp
    ///// </summary>
    ///// <param name="ip">目标IP</param>
    ///// <param name="port">目标端口</param>
    ///// <returns>是否链接成功</returns>
    //public bool ConnectUDP(string ip, int port)
    //{
    //    // 关闭已有链接.
    //    Close();
    //    Debug.Log("开始链接:" + ip + ":" + port);

    //    // 建立链接类
    //    socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp); 

    //    // 建立IP地址对象
    //    var ipAddress = IPAddress.Parse(ip);
    //    // 建立端口对象
    //    var portObj = new IPEndPoint(ipAddress, port);

    //    // 异步请求建立链接
    //    var result = socket.BeginConnect(portObj, (ayResult) =>
    //    {
    //        ConnectSuccess = true;
    //        Debug.Log("链接成功");
    //    }, socket);

    //    // 强制同步等待连接完成
    //    var isSuccess = result.AsyncWaitHandle.WaitOne(WaitTime, true);
    //    if (!isSuccess)
    //    {
    //        Close();
    //        Debug.Log("连接超时");
    //        return false;
    //    }
    //    else
    //    {
    //        // 保存IP与Port
    //        connectingAddress = ip;
    //        connectingPort = port;
    //        // 接收消息Callback
    //        AsyncCallback receiveCallback = null;
    //        receiveCallback = (ayResult) =>
    //        {
    //            try
    //            {
    //                // 收到消息
    //                SocketError se;
    //                // 收到的字节数量
    //                var receivedByteCount = socket.EndReceive(ayResult, out se);
    //                Debug.Log("收到数据, 长度:" + receivedByteCount + ",error:" + se.ToString());
    //                if (receivedByteCount > 0)
    //                {
    //                    // 保证线程数据安全
    //                    lock (receivedBuffer)
    //                    {
    //                        receivedBuffer = ByteUtils.ConnectByte(receivedBuffer, buffer, 0, receivedByteCount);
    //                    }
    //                    // 继续接收数据
    //                    socket.BeginReceive(buffer, 0, BuffSize, SocketFlags.None, receiveCallback, socket);
    //                }
    //                else if (receivedByteCount == 0)
    //                {
    //                    Debug.Log("收到0长度数据");
    //                }
    //            }
    //            catch (Exception e)
    //            {
    //                Debug.Log("数据解析错误:" + e.ToString());
    //            }
    //        };
    //        // 开始接收消息
    //        socket.BeginReceive(buffer, 0, BuffSize, SocketFlags.None, receiveCallback, socket);
    //    }

    //    return true;
    //}


    /// <summary>
    /// 链接Socket TCP
    /// </summary>
    /// <param name="ip">目标IP</param>
    /// <param name="port">目标端口</param>
    /// <returns>是否链接成功</returns>
    public bool Connect(string ip, int port)
    {// 关闭已有链接.
        Close();
        Debug.Log("开始链接:" + ip + ":" + port);

        // 建立链接类
        socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

        // 建立IP地址对象
        var ipAddress = IPAddress.Parse(ip);
        var ipEndPoint = new IPEndPoint(ipAddress, port);
        // 异步请求建立链接
        var async = socket.BeginConnect(ipEndPoint, (ia) =>
        {
            // 链接成功
            ConnectSuccess = true;
            // 保存IP与Port
            connectingAddress = ip;
            connectingPort = port;
            var buffer = new byte[BuffSize];
            // 接收消息Callback
            AsyncCallback receiveCallback = null;
            receiveCallback = (ayResult) =>
            {
                try
                {
                    // 收到消息
                    SocketError se;
                    // 收到的字节数量
                    var receivedByteCount = socket.EndReceive(ayResult, out se);
                    Debug.Log("收到数据, 长度:" + receivedByteCount + ",error:" + se.ToString());
                    if (receivedByteCount > 0)
                    {
                        // 保证线程数据安全
                        lock (receivedBuffer)
                        {
                            receivedBuffer = ByteUtils.ConnectByte(receivedBuffer, buffer, 0, receivedByteCount);
                        }
                        // 继续接收数据
                        socket.BeginReceive(buffer, 0, BuffSize, SocketFlags.None, receiveCallback, socket);
                    }
                    else if (receivedByteCount == 0)
                    {
                        Debug.Log("收到0长度数据");
                    }
                }
                catch (Exception e)
                {
                    Debug.Log("数据解析错误:" + e.ToString());
                }
            };
            // 开始接收消息
            socket.BeginReceive(buffer, 0, BuffSize, SocketFlags.None, receiveCallback, socket);
        }, socket);

        async.AsyncWaitHandle.WaitOne(WaitTime, true);

        socket.EndConnect(async);

        return true;
    }

    /// <summary>
    /// 发送消息
    /// </summary>
    /// <param name="msg">数据msg</param>
    /// <returns></returns>
    public bool Send(byte[] msg)
    {
        if (socket == null || !socket.Connected)
        {
            Debug.LogError("请先链接再发送消息");
            return false;
        }
        if (msg == null || msg.Length == 0)
        {
            Debug.Log("数据为空");
            return false;
        }

        try
        {
            // 数据格式化
            msg = ByteUtils.AddDataHead(msg);
            var asyncSend = socket.BeginSend(msg, 0, msg.Length, SocketFlags.None, (ayResult) =>
            {
                Debug.Log("发送成功");
            }, socket);
            if (asyncSend == null)
            {
                Debug.LogError("发送失败异步发送等待为空");
                return false;
            }
            if (asyncSend.AsyncWaitHandle.WaitOne(WaitTime, true))
            {
                return true;
            }
            socket.EndSend(asyncSend);
            Debug.LogError("发送失败" + asyncSend);
        }
        catch (Exception e)
        {
            Debug.LogError("发送失败:" + e.Message);
        }

        return false;
    }

    /// <summary>
    /// 发送消息
    /// </summary>
    /// <param name="msgList">数据list</param>
    /// <returns></returns>
    public bool SendList(List<byte[]> msgList)
    {
        if (socket == null || !socket.Connected)
        {
            if (string.IsNullOrEmpty(connectingAddress) || connectingPort == 0)
            {
                Debug.LogError("请先链接再发送消息");
                return false;
            }
            if (!Connect(connectingAddress, connectingPort))
            {
                Debug.LogError("链接失败");
                return false;
            }
        }

        if (msgList == null || msgList.Count == 0)
        {
            Debug.Log("数据为空");
            return false;
        }
        try
        {
            var cbMsg = new byte[0];
            // 合并数据
            foreach (var msg in msgList)
            {
                var addHeadMsg = ByteUtils.AddDataHead(msg);
                cbMsg = ByteUtils.ConnectByte(cbMsg, addHeadMsg, 0, addHeadMsg.Length);
            }
            var asyncSend = socket.BeginSend(cbMsg, 0, cbMsg.Length, SocketFlags.None, (ayResult) =>
            {
                Debug.Log("发送成功");
            }, socket);
            if (asyncSend == null)
            {
                Debug.LogError("发送失败异步发送等待为空");
                return false;
            }
            if (asyncSend.AsyncWaitHandle.WaitOne(WaitTime, true))
            {
                return true;
            }
            socket.EndSend(asyncSend);
            Debug.LogError("发送失败" + asyncSend);
        }
        catch (Exception e)
        {
            Debug.LogError("发送失败:" + e.Message);
        }

        return false;
    }

    /// <summary>
    /// 将消息序列化为二进制的方法
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="model"></param>
    /// <returns></returns>
    public static byte[] Serialize<T>(T model)
    {
        try
        {
            //涉及格式转换，需要用到流，将二进制序列化到流中
            using (var ms = new MemoryStream())
            {
                //使用ProtoBuf工具的序列化方法
                ProtoBuf.Serializer.Serialize(ms, model);
                //定义二级制数组，保存序列化后的结果
                var result = new byte[ms.Length];
                //将流的位置设为0，起始点
                ms.Position = 0;
                //将流中的内容读取到二进制数组中
                ms.Read(result, 0, result.Length);
                return result;
            }
        }
        catch (Exception ex)
        {
            Debug.Log("序列化失败: " + ex.ToString());
            return null;
        }
    }

    // 将收到的消息反序列化成对象
    // < returns>The serialize.< /returns>
    // < param name="msg">收到的消息.</param>
    public static T DeSerialize<T>(byte[] msg)
    {
        try
        {
            using (MemoryStream ms = new MemoryStream())
            {
                //将消息写入流中
                ms.Write(msg, 0, msg.Length);
                //将流的位置归0
                ms.Position = 0;
                //使用工具反序列化对象
                T result = ProtoBuf.Serializer.Deserialize<T>(ms);
                return result;
            }
        }
        catch (Exception ex)
        {
            Debug.Log("反序列化失败: " + ex.ToString());
            return default(T);
        }
    }


    /// <summary>
    /// 关闭连接
    /// </summary>
    public void Close()
    {
        ConnectSuccess = false;
        if (socket != null && socket.Connected)
        {
            // 禁用发送与接收
            socket.Shutdown(SocketShutdown.Both);
            socket.Close();
            Debug.Log("链接已关闭");
        }
        socket = null;
    }

    /// <summary>
    /// 循环Action
    /// </summary>
    public void Do()
    {
        // 是否开启
        if (!ConnectSuccess)
        {
            return;
        }
        // 检查数据是否有数据
        var bContinue = true;
        while (bContinue)
        {
            byte[] data = null;
            lock (receivedBuffer)
            {
                bContinue = ByteUtils.CouldRead(receivedBuffer);
                if (bContinue)
                {
                    data = ByteUtils.ReadMsg(ref receivedBuffer);

                    // 解析数据头
                    var msgHead = DeSerialize<MsgHead>(data);
                    // 抛出数据事件
                    foreach (var actionList in dataActionList)
                    {
                        if (msgHead.msgId == actionList.Key)
                        {
                            foreach (var action in actionList.Value)
                            {
                                action(msgHead);
                            }
                        }
                    }
                }
                else
                {
                    // 数据读取完毕, 清空缓存区
                    if (receivedBuffer.Length != 0)
                    {
                        receivedBuffer = new byte[0];
                    }
                }
            }
        }
    }

    /// <summary>
    /// 是否循环结束
    /// </summary>
    /// <returns></returns>
    public bool IsEnd()
    {
        // 启动后一直运行
        return false;
    }

    /// <summary>
    /// 销毁
    /// </summary>
    public void OnDestroy()
    {
        Close();
        looperId = -1;
        ClearAllAction();
    }
}

/// <summary>
/// 数据工具
/// </summary>
public static class ByteUtils
{
    /// <summary>
    /// 连接二个字节数组
    /// </summary>
    /// <param name='byte1'>第一个数组</param>
    /// <param name='bytes2'>第二个数组</param>
    /// <param name="byte2Index">第二个字节数组起始偏移</param>
    /// <param name="byte2Length">第二个字节数组读取长度</param>
    /// <returns>返回一个 连接好的字节流</returns>
    public static byte[] ConnectByte(byte[] byte1, byte[] bytes2, int byte2Index, int byte2Length)
    {
        var result = new byte[byte1.Length + byte2Length - byte2Index];
        Array.Copy(byte1, 0, result, 0, byte1.Length);
        Array.Copy(bytes2, byte2Index, result, byte1.Length, byte2Length);
        //Debug.Log(Encoding.UTF8.GetString(result));
        return result;
    }

    /// <summary>
    /// 检查一个数组长度是不是满足要求 网络接收时用
    /// </summary>
    /// <param name='data'>是否符合可读取条件</param>
    public static bool CouldRead(byte[] data)
    {
        if (data.Length < 4)
        {
            return false;
        }
        // 数据长度
        //var len = BitConverter.ToUInt32(data, 0);
        var len = BytesToInt32(data, 0);
        // 数据是否达到长度
        return len > 0 && data.Length - 4 >= len;
    }

    /// <summary>
    /// 从字节数组中读取一条消息
    /// 并将已经读取的数据移除
    /// </summary>
    public static byte[] ReadMsg(ref byte[] msg)
    {
        // 数据长度
        //var len = BitConverter.ToUInt32(msg, 0);
        var len = BytesToInt32(msg, 0);
        if (len <= 0)
        {
            // 清空数据
            msg = new byte[0];
            Debug.Log("长度数据为0." + msg);
            return msg;
        }
        var result = new byte[len];
        // 从数组中将一条信息读取
        Array.Copy(msg, 4, result, 0, len);

        // 把原数据 进行剪切
        var c = new byte[msg.Length - len - 4];
        Array.Copy(msg, len + 4, c, 0, c.Length);

        msg = c;
        return result;
    }



    /// <summary>
    /// 格式化数据
    /// 给数据加上数据长度
    /// </summary>
    /// <param name="msg"></param>
    /// <returns></returns>
    public static byte[] AddDataHead(byte[] msg)
    {
        if (msg == null)
        {
            return null;
        }
        var lenthData = ByteUtils.ConnectByte(ByteUtils.Int32ToBytes(msg.Length), msg, 0, msg.Length);

        return lenthData;
    }

    /// <summary>
    /// 获取数据(去掉头)
    /// </summary>
    /// <param name="msg"></param>
    /// <returns></returns>
    public static byte[] GetDataWithHead(byte[] msg)
    {
        if (msg == null)
        {
            return null;
        }
        var result = ByteUtils.GetSubBytes(msg, 4, msg.Length - 4);

        return result;
    }

    /// <summary>
    /// 获取数据头
    /// </summary>
    /// <param name="msg"></param>
    /// <returns></returns>
    public static int GetDataHead(byte[] msg)
    {
        if (msg == null || msg.Length == 0)
        {
            return -1;
        }
        var lenthData = ByteUtils.BytesToInt32(msg, 0);

        return lenthData;
    }


    /// <summary>
    /// 裁切子数组
    /// </summary>
    /// <param name="bytes">被裁切数组</param>
    /// <param name="start">裁切起始位置</param>
    /// <param name="length">裁切长度</param>
    /// <returns></returns>
    public static byte[] GetSubBytes(byte[] bytes, int start, int length)
    {
        if (bytes == null)
        {
            return null;
        }

        var result = ConnectByte(new byte[0], bytes, start, length);

        return result;
    }

    /// <summary>
    /// int转bytes 大端在前
    /// </summary>
    /// <param name="num"></param>
    /// <returns></returns>
    public static byte[] Int32ToBytes(Int32 num)
    {
        byte[] src = new byte[4];
        src[0] = (byte)((num >> 24) & 0xFF);
        src[1] = (byte)((num >> 16) & 0xFF);
        src[2] = (byte)((num >> 8) & 0xFF);
        src[3] = (byte)(num & 0xFF);
        return src;  
    }

    /// <summary>
    /// bytes转int 大端在前
    /// 只去数组前四位
    /// </summary>
    /// <param name="data">数据数组</param>
    /// <param name="offset">数据偏移</param>
    /// <returns></returns>
    public static int BytesToInt32(byte[] data, int offset)
    {
        int value;
        value = (int)(((data[offset] & 0xFF) << 24)
                | ((data[offset + 1] & 0xFF) << 16)
                | ((data[offset + 2] & 0xFF) << 8)
                | (data[offset + 3] & 0xFF));
        return value;  
    }
}