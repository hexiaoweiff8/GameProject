using UnityEngine;
using System.Collections;
using System.Collections.Generic;
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
