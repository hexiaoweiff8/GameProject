using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using LuaInterface;

public class NetworkManager : Manager
{
    private LuaState mLuaState = null;
    private LuaTable mLuaTable = null;

    private LuaFunction mLuaOnSocketDataFunc = null;

    private SocketClient mSocketClient;
    static Queue<KeyValuePair<int, byte[]>> sEvents = new Queue<KeyValuePair<int, byte[]>>();

    private SocketClient SocketClient
    {
        get
        {
            if (mSocketClient == null)
            {
                mSocketClient = new SocketClient();
            }
            return mSocketClient;
        }
    }

    private void Awake()
    {
        Init();
    }

    private void Init()
    {
        SocketClient.OnRegister();
    }

    public void SetLuaTable(LuaTable tb)
    {
        mLuaState = SimpleLuaClient.GetMainState();
        if (mLuaState == null) return;

        if (tb == null)
        {
            mLuaTable = mLuaState.GetTable("NetworkManager");
        }
        else
        {
            mLuaTable = tb;
        }

        if (mLuaTable == null)
        {
            Debug.LogWarning("NetworkManager is null:");
            return;
        }
        else
        {
            mLuaOnSocketDataFunc = mLuaTable.GetLuaFunction("on_socket_data") as LuaFunction;
        }
    }

    public void OnSocketData(int key, byte[] value)
    {
        if (mLuaOnSocketDataFunc != null)
        {
            mLuaOnSocketDataFunc.BeginPCall();
            mLuaOnSocketDataFunc.Push(key);
            if (value != null)
            {
                mLuaOnSocketDataFunc.Push(new LuaByteBuffer(value));
            }
            mLuaOnSocketDataFunc.PCall();
            mLuaOnSocketDataFunc.EndPCall();
        }
    }

    private bool CheckValid()
    {
        if (mLuaState == null) return false;
        if (mLuaTable == null) return false;
        return true;
    }

    public void SendConnect()
    {
        SocketClient.SendConnect();
    }

    public void SendMessage(ByteBuffer buffer)
    {
        SocketClient.SendMessage(buffer);
    }

#region  YY UDP 代码块

    //////////////yy UDP
    private Socket ysocket;
    // 建立IP地址对象
    IPAddress ipAddress = IPAddress.Parse("192.168.1.88");
    // 建立端口对象
    private IPEndPoint portObj;
    private const int udpBufferSize = 16384;
    private byte[] buffer = new byte[udpBufferSize];

    //private bool ConnectSuccess = false;

    public Socket getYsocket()
    {
        if (ysocket == null)
        {
            ysocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
            // 建立端口对象
            portObj = new IPEndPoint(ipAddress, 9999);
            ConnectUDP();
        }
        return ysocket;
    }
    public void SendMessageByUDP(byte[] msg)
    {
        
         //ysocket  = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);


        getYsocket().SendTo(msg, portObj);
        
    }

    public bool ConnectUDP()
    {
        Socket socket = getYsocket();
        // 异步请求建立链接
        var result = socket.BeginConnect(portObj, (ayResult) =>
        {
            //ConnectSuccess = true;
            Debug.Log("UDP链接成功");
        }, socket);

        // 强制同步等待连接完成
        
        var isSuccess = result.AsyncWaitHandle.WaitOne(1000, true);
        if (!isSuccess)
        {
            //Close();
            socket.Close();
            Debug.Log("UDP连接超时");
            return false;
        }
        else
        {
            //// 保存IP与Port
            //connectingAddress = ip;
            //connectingPort = port;
            // 接收消息Callback
            AsyncCallback receiveCallback = null;
            receiveCallback = (ayResult) =>
            {
         
                    // 收到消息
                    SocketError se;
                    // 收到的字节数量
                    var receivedByteCount = socket.EndReceive(ayResult, out se);
                    Debug.Log("收到数据, 长度:" + receivedByteCount + ",error:" + se.ToString());
                    if (receivedByteCount > 0)
                    {
                        try
                        {
                            while (ByteUtils.CouldRead(buffer))
                            {
                                var msgData = ByteUtils.ReadMsg(ref buffer);
                                ///吧数据回传给LUA
                                NetworkManager.AddEvent(104, msgData);

                            }
                        }
                        catch (Exception e)
                        {
                            Debug.Log("数据解析错误:" + e.ToString());
                        }
                        buffer = new byte[udpBufferSize];
                        //// 继续接收数据
                        socket.BeginReceive(buffer, 0, udpBufferSize, SocketFlags.None, receiveCallback, socket);
                    }
                    else if (receivedByteCount == 0)
                    {
                        Debug.Log("收到0长度数据");
                    }
                
  
            };
            // 开始接收消息
            socket.BeginReceive(buffer, 0, udpBufferSize, SocketFlags.None, receiveCallback, socket);
        }


        return true;
    }

    /// yy upd
#endregion


    public static void AddEvent(int _event, byte[] data)
    {
        sEvents.Enqueue(new KeyValuePair<int, byte[]>(_event, data));
    }

    /// <summary>
    /// 交给Command，这里不想关心发给谁。
    /// </summary>
    private void Update()
    {
        if (sEvents.Count > 0)
        {
            while (sEvents.Count > 0)
            {
                KeyValuePair<int, byte[]> _event = sEvents.Dequeue();
                GameFacade.SendMessageCommand(NotiConst.DISPATCH_MESSAGE, _event);
            }
        }
    }

    private void OnDestroy()
    {
        OnUnLoad();
        SocketClient.OnRemove();
        Debug.Log("~NetworkManager was destroy");

        if (mLuaOnSocketDataFunc != null)
        {
            mLuaOnSocketDataFunc.Dispose();
            mLuaOnSocketDataFunc = null;
        }

        if (mLuaTable != null)
        {
            mLuaTable.Dispose();
            mLuaTable = null;
        }
    }

    public void OnInit()
    {
        if (!CheckValid()) return;
        LuaFunction OnInitFunc = mLuaTable.GetLuaFunction("on_init") as LuaFunction;
        if (OnInitFunc != null)
        {
            OnInitFunc.BeginPCall();
            OnInitFunc.PCall();
            OnInitFunc.EndPCall();

            OnInitFunc.Dispose();
            OnInitFunc = null;
        }
    }

    public void OnUnLoad()
    {
        if (!CheckValid()) return;
        LuaFunction OnUnLoadFunc = mLuaTable.GetLuaFunction("on_unload") as LuaFunction;
        if (OnUnLoadFunc != null)
        {
            OnUnLoadFunc.BeginPCall();
            OnUnLoadFunc.PCall();
            OnUnLoadFunc.EndPCall();

            OnUnLoadFunc.Dispose();
            OnUnLoadFunc = null;
        }
    }
}
