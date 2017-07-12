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
    private DisplayOwner data;
    private SoldierFSMControl _control;

    void Start()
    {
        LoadSource();
        StartFSM();
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
