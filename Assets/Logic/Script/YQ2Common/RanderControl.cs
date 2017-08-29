using System;
using System.IO;
using ProtoBuf;
using UnityEngine;

public class RanderControl : MonoBehaviour
{
    private const float UIcamare_defaulZ = 554; 

    /// <summary>
    /// 血条对象
    /// </summary>
    public BloodBar bloodBarCom;
    
    /// <summary>
    /// 血条transform
    /// </summary>
    [HideInInspector]
    public Transform bloodBar;

    /// <summary>
    /// 世界相机
    /// </summary>
    [HideInInspector]
    public Camera NowWorldCamera;

    /// <summary>
    /// 单位头位置
    /// </summary>
    [HideInInspector]
    public Transform Head;

    /// <summary>
    /// 单位是否为敌人
    /// </summary>
    [HideInInspector]
    public bool isEnemy = false;

    /// <summary>
    /// 单位是否已经设置Shader
    /// TODO 不应这么解决该问题
    /// </summary>
    [HideInInspector]
    public bool isSetShader = false;

    /// <summary>
    /// 单位位置单位
    /// </summary>
    [HideInInspector]
    public PositionObject PosObj;

    /// <summary>
    /// 模型身上的动画组件
    /// </summary>
    private Animation _ani;

    /// <summary>
    /// FSM状态机控制器
    /// </summary>
    private SoldierFSMControl _control;
    /// <summary>
    /// 是否已启动
    /// </summary>
    private bool isStart = false;

    /// <summary>
    /// 同步数据(网络对战时使用, 本机AI不用调用)
    /// </summary>
    public void SyncData()
    {
        if (GlobalData.FightData.IsOnline)
        {
            // 如果是联网战斗则同步数据
            //GetDisplayOwner();
            FightDataSyncer.Single.AddOptionalData(PosObj.AllData.MemberData.ObjID);
            Debug.Log("网络单位创建:" + transform.position.x + "," + transform.position.z);
        }
        else
        {
            // 否则直接调用begin
            Begin();
        }
    }

    /// <summary>
    /// 开始行动
    /// </summary>
    public void Begin()
    {
        //GetDisplayOwner();
        LoadSource();
        StartFSM();
        isStart = true;
    }

    ///// <summary>
    ///// 当绘制单位时设置shader
    ///// TODO 解决加载单位没有shader问题
    ///// </summary>
    //private void OnWillRenderObject()
    //{
    //    if (!isSetShader)
    //    {
    //        isSetShader = true;
    //        var rander = GetComponent<Renderer>();
    //        if (rander != null)
    //        {
    //            var core = PacketManage.Single.GetPacket("core");
    //            if (core != null)
    //            {
    //                var shader = core.Load("Avatar_N.shader") as Shader;
    //                if (shader != null)
    //                {
    //                    rander.material.shader = shader;
    //                }
    //            }

    //        }
    //    }
    //}

    /// <summary>
    /// 加载
    /// </summary>
    private void LoadSource()
    {
        NowWorldCamera = GameObject.Find("/PTZCamera/SceneryCamera").GetComponent<Camera>();
        Head = transform.Find("head").gameObject.transform;
        GameObject parent = GameObject.Find("ui_fightU/bloodParent");
        bloodBar = GameObjectExtension.InstantiateFromPacket("ui_fightu", "blood.prefab", parent ).transform;
        bloodBar.localPosition = Vector3.zero;
        bloodBar.localScale = Vector3.one;
        bloodBarCom = bloodBar.gameObject.AddComponent<BloodBar>();
        //ModelRander = gameObject.GetComponent<MFAModelRender>();
    }

    /// <summary>
    /// 启动状态机
    /// </summary>
    private void StartFSM()
    {
        // 启动士兵的状态控制
        _control = new SoldierFSMControl();
        _control.StartFSM(PosObj.AllData.MemberData.ObjID);
    }

    public void OnEnable()
    {
        _ani = transform.GetComponent<Animation>();
    }

    /// <summary>
    /// 播放模型身上对应名字的动作 
    /// </summary>
    /// <param name="aniName">动画名称</param>
    /// <param name="mode">播放方式</param>
    public void PlayAni(string aniName,WrapMode mode)
    {
        if (null == _ani)
        {
             Debug.LogError("模型身上需要挂Animation组件:" + gameObject.name);
             return;
        }
        try
        {
            if (_ani.clip.name != aniName)
            {
                _ani.Stop();
                _ani.wrapMode = mode;
                _ani.Play(aniName);
            }
        }
        catch (Exception ex)
        {
            Debug.LogError("播放动画失败！error:" + ex.Message);
            //throw new Exception("播放动画失败！error:"+ex.Message);
        }
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
        if (_control != null)
        {
            _control.Destory();
            _control = null;
        }
    }
//    void OnGUI()
//    {
////        print("OnGui");
//        Vector3 pt = NowWorldCamera.WorldToScreenPoint(Head.position);
//        GUI.Button(new Rect(pt.x, Screen.height - pt.y, 200f, 30f), pt.x + "::::::" + pt.y);
//
//    }
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
        Vector3 ff = UIAdaptation.UICamera.ScreenToWorldPoint(pt);
        bloodBar.position = ff;

        var value = PosObj.AllData.MemberData.CurrentHP / PosObj.AllData.MemberData.TotalHp;
        bloodBarCom.SetBloodBarValue(value);
    }

    /// <summary>
    /// 清除当前攻击目标
    /// </summary>
    public void CleanTarget()
    {
        _control.CleanTarget();
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
