using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine.SceneManagement;
using UnityEngine;

public class DP_Battlefield : MonoEX.SingletonAuto<DP_Battlefield>
{
    /// <summary>
    /// 世界中心名称
    /// </summary>
    private const string worldCenterName = "/SceneRoot/WorldCenter";

    /// <summary>
    /// 场景相机名称
    /// </summary>
    private const string sceneCameraName = "/PTZCamera/SceneryCamera";
    //切换场景
    public void SwapScene(int sceneID, List<string> dyDependPacks, Action OnSwapDone)
    {
        if (m_Loading)
        {
            Debug.Log("Scene Is Loading.");
            return; //正在装载中
        }

        EasyTouch.instance.longTapTime = 0.5f;

        m_Loading = true;

        if (m_CurrScene > 0) //存在场景
        {
            string sceneName = string.Format("tzbd_{0:D2}", m_CurrScene); ;
            SceneManage.Single.Unload(sceneName);//卸载掉之前的场景
            m_CurrScene = -1;
        }

        // 转换场景时清空被击列表
        SkillManager.Single.ClearAllSkillTriggerData();

        // 验证sceneID有效性
        if (sceneID > 0)
        {
            string sceneName = string.Format("tzbd_{0:D2}", sceneID);
            SceneManage.Single.Load(sceneName, dyDependPacks, LoadSceneMode.Additive,
                () =>
                {
                    m_CurrScene = sceneID;
                    m_Loading = false;
                    SceneManager.SetActiveScene(SceneManager.GetSceneByName(sceneName));//将新装入的场景设为活动场景

                    //获取世界中心组件
                    {
                        GameObject WorldCenterObj = GameObject.Find(worldCenterName);
                        WorldCenter = WorldCenterObj.GetComponent<YQ2WorldCenter>();
                    }

                    //应用天空盒
                    {
                        GameObject SceneryCameraObj = GameObject.Find(sceneCameraName);
                        Skybox skybox = SceneryCameraObj.GetComponent<Skybox>();
                        skybox.material = WorldCenter.SkyBoxMat;
                    }

                    //应用相机参数
                    {
                        //GameObject PTZCamera = GameObject.Find("/PTZCamera");

                        //YQ2CameraCtrl cameraCtrl = PTZCamera.GetComponent<YQ2CameraCtrl>(); 
                        //cameraCtrl.SetScale(SData_MapData.Single.FreeCamera_Scale);

                        //cameraCtrl.SetYRot(0.5f);
                    }

                    if (OnSwapDone != null) OnSwapDone();
                },
                null
                );
        }
        else
            m_Loading = false;
    }

    /// <summary>
    /// 根据用户等级 配置 以及当前副本 加载对应的基地
    /// </summary>
    public void LoadBase()
    {
        // 不同等级基地不同模型
        //var rightBase = new CreateActorParam(5, false, 0, "lingtong", "lingtong", true, 1008001);
        //var leftBase = new CreateActorParam(5, false, 0, "lingtong", "lingtong", true, 1008001);

        //FightUnitFactory.CreateUnit(1, leftBase);
        //FightUnitFactory.CreateUnit(2, rightBase);
    }

    /// <summary>
    /// 相机关注某英雄
    /// </summary>
    public void CameraFocusFID(bool isLeft, int fid)
    {
    }


    /// <summary>
    /// 清理战斗资源
    /// </summary>
    public void Reset()
    {
            DP_CameraTrackObjectManage.Single.Reset();
            MFAModelManage.Single.Clean();//清缓存的模型和材质
            ClusterManager.Single.ClearAll();
            m_CameraTouchCount = 0;

        if (!m_BindCameraCtrlOK)
        {
            YQ2CameraCtrl.Single.OnUserTouch += OnCameraUserTouch;
            m_BindCameraCtrlOK = true;
        }
    }


    void OnCameraUserTouch()
    {
        m_CameraTouchCount++;
        if (m_CameraTouchCount == 1) DP_FightEvent.PostFirstTouchScene();
    }

    public bool IsLoading { get { return m_Loading; } }
    public YQ2WorldCenter WorldCenter = null;
    int m_CurrScene = -1;
    bool m_Loading = false;
    bool m_BindCameraCtrlOK = false;
    int m_CameraTouchCount = 0;
}
