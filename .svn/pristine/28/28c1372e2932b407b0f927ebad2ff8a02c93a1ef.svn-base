using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;

public class RanderControl : MonoBehaviour
{
    public Transform BloodBar;
    public Camera NowWorldCamera;
    public Transform Head;
    public bool isEnemy = false;
    public bool isSetShader = false;
    public int groupIndex;
    private UISprite BloodBarSprite;
    /// <summary>
    /// 显示对象动画控制
    /// </summary>
    public MFAModelRender ModelRander;

    private SoldierFSMControl _control;
    //private float Fomat;
    void Start()
    {
        NowWorldCamera = GameObject.Find("/PTZCamera/SceneryCamera").GetComponent<Camera>();
        Head = transform.Find("head");
        //Fomat = Vector3.Distance(Head.position, nowWorldCamera.transform.position);
        BloodBar = GameObjectExtension.InstantiateFromPacket("ui_fightU", "blood.prefab", GameObject.Find("ui_fightU")).transform;
        BloodBar.localScale = Vector3.zero;
        BloodBarSprite = BloodBar.GetComponent<UISprite>();
        ModelRander = gameObject.GetComponent<MFAModelRender>();

        // 数据来源非正常方式, 抽出
        //启动士兵的状态控制
        var displayOwner = DisplayerManager.Single.GetElementById(ModelRander.ObjId);
        _control = new SoldierFSMControl();
        displayOwner.RanderControl = this;
        _control.StartFSM(displayOwner);
    }



    private void OnWillRenderObject()
    {
        if (!isSetShader)
        {
            isSetShader = true;
            GetComponent<Renderer>().material.shader = PacketManage.Single.GetPacket("core").Load("Avatar_N.shader") as Shader;
        }
    }
    void Update()
    {
        //transform.Translate(0, 0, 10 * Time.deltaTime);

        ////float newFomat = Fomat / Vector3.Distance(Head.position, nowWorldCamera.transform.position);
        Vector3 pt = NowWorldCamera.WorldToScreenPoint(Head.position);
        Vector3 ff = UICamera.currentCamera.ScreenToWorldPoint(pt);
        //ff.z = 0;
        BloodBar.position = ff;
        _control.UpdateFSM();
        //blood.localScale = Vector3.one * newFomat;


    }

    public void setBloodBarSpritefillAmount(float value)
    {
        BloodBarSprite.fillAmount = value;
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
