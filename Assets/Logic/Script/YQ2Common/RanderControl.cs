using System.IO;
using ProtoBuf;
using UnityEngine;

public class RanderControl : MonoBehaviour
{
    public BloodBar bloodBarCom;
    [HideInInspector]
    public Transform bloodBar;
    [HideInInspector]
    public Camera NowWorldCamera;
    [HideInInspector]
    public Transform Head;
    [HideInInspector]
    public bool isEnemy = false;
    [HideInInspector]
    public bool isSetShader = false;
    [HideInInspector]
    public int groupIndex;
    //static readonly GameObject ui_fightUgo = ;
    /// <summary>
    /// 显示对象动画控制
    /// </summary>
    [HideInInspector]
    public MFAModelRender ModelRander;
    
    /// <summary>
    /// 显示持有类
    /// </summary>
    private DisplayOwner data;

    /// <summary>
    /// FSM状态机控制器
    /// </summary>
    private SoldierFSMControl _control;
    /// <summary>
    /// 是否已启动
    /// </summary>
    private bool isStart = false;


    public void Begin()
    {
        isStart = true;
        LoadSource();
        StartFSM();

        // TODO 测试确认下兵
        // 添加同步数据
        var msgOp = MsgFactory.GetMsgOptional(1, gameObject.transform.position.x, gameObject.transform.position.y,
            gameObject.transform.position.z, 
                "ObjectId:" + data.ClusterData.AllData.MemberData.ObjID +
                ",UniqueId:" + data.ClusterData.AllData.MemberData.UniqueID);

        // 序列化
        var msgOpSer = SocketManager.Serialize(msgOp);
        // 包装数据
        var msgHead = MsgFactory.GetMsgHead(1, 1, ByteUtils.AddDataHead(msgOpSer));
        var headData = SocketManager.Serialize(msgHead);
        // 发送消息
        SocketManager.Single.Send(headData);
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


    private void OnWillRenderObject()
    {
        if (!isSetShader)
        {
            isSetShader = true;
            GetComponent<Renderer>().material.shader = PacketManage.Single.GetPacket("core").Load("Avatar_N.shader") as Shader;
        }
    }

    /// <summary>
    /// 加载
    /// </summary>
    private void LoadSource()
    {
        NowWorldCamera = GameObject.Find("/PTZCamera/SceneryCamera").GetComponent<Camera>();
        Head = transform.Find("head");
        bloodBar = GameObjectExtension.InstantiateFromPacket("ui_fightU", "blood.prefab", GameObject.Find("ui_fightU")).transform;
        bloodBar.localScale = Vector3.zero;
        bloodBarCom = bloodBar.gameObject.AddComponent<BloodBar>();
        ModelRander = gameObject.GetComponent<MFAModelRender>();
    }

    /// <summary>
    /// 启动状态机
    /// </summary>
    private void StartFSM()
    {
        // TODO 日了狗了 循环引用实在去不掉先这么写有空了改.
        var clusterData = gameObject.GetComponent<ClusterData>();
        data = DisplayerManager.Single.GetElementById(clusterData.AllData.MemberData.ObjID);
        // 数据来源非正常方式, 抽出
        // 启动士兵的状态控制
        _control = new SoldierFSMControl();
        data.RanderControl = this;
        _control.StartFSM(data);
    }


    void Update()
    {
        if (!isStart)
        {
            return;
        }
        // 更新血条
        SetBloodBarValue();
        // 驱动状态机
        _control.UpdateFSM();
    }
    /// <summary>
    /// 销毁状态机
    /// </summary>
    public void DestoryFSM()
    {
        _control.Destory();
        _control = null;
    }

    /// <summary>
    /// 刷新血条
    /// </summary>
    public void SetBloodBarValue()
    {
        if (NowWorldCamera == null || UICamera.currentCamera == null || bloodBar == null || Head == null)
        {
            return;
        }
        Vector3 pt = NowWorldCamera.WorldToScreenPoint(Head.position);
        Vector3 ff = UICamera.currentCamera.ScreenToWorldPoint(pt);
        bloodBar.position = ff;
        var value = data.ClusterData.AllData.MemberData.CurrentHP / data.ClusterData.AllData.MemberData.TotalHp;
        bloodBarCom.SetBloodBarValue(value);
    }

    ///// <summary>
    ///// 启动状态机
    ///// 传入创建的外层持有对象
    ///// </summary>
    ///// <param name="owner">外层持有对象</param>
    //public void StartFSM(DisplayOwner owner)
    //{
    //    //启动士兵的状态控制
    //    _control = new SoldierFSMControl();
    //    _control.StartFSM(owner);
    //}
}
