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
            string sceneName = SData_SenceDefine.SceneID2LevelName(m_CurrScene);
            SceneManage.Single.Unload(sceneName);//卸载掉之前的场景
            m_CurrScene = -1;
        }

        // 验证sceneID有效性
        if (sceneID > 0)
        {
            string sceneName = SData_SenceDefine.SceneID2LevelName(sceneID);
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
    /// 相机关注某英雄
    /// </summary>
    public void CameraFocusFID(bool isLeft, int fid)
    {
        if (!YQ2CameraCtrl.Single.EnabledTouch) return;//相机当前已禁操

        int actorID;
        //界面控制
        if (isLeft)
        {
            actorID = wnd_fight.Single.LeftHeroPanel.SetCurrHeroFID(fid);
            wnd_fight.Single.RightHeroPanel.SetCurrHeroFID(-1);
        }
        else
        {
            wnd_fight.Single.LeftHeroPanel.SetCurrHeroFID(-1);
            actorID = wnd_fight.Single.RightHeroPanel.SetCurrHeroFID(fid);
        }

        //相机控制器聚焦该英雄
        DP_CameraTrackObjectManage.Single.SetTrackActor(DPActorType.Avatar, actorID, false);
    }

    /// <summary>
    /// 相机关注某对象
    /// </summary>
    public void CameraFocusActorID(DPActorType actorType, int actorID, bool lockOP)
    {
        if (actorType == DPActorType.Avatar)
        {
            //界面控制
            if (wnd_fight.Single.LeftHeroPanel.SetCurrHeroActorID(actorID))
                wnd_fight.Single.RightHeroPanel.SetCurrHeroFID(-1);
            else if (wnd_fight.Single.RightHeroPanel.SetCurrHeroActorID(actorID))
                wnd_fight.Single.LeftHeroPanel.SetCurrHeroFID(-1);
        }

        //相机控制器聚焦该英雄
        DP_CameraTrackObjectManage.Single.SetTrackActor(actorType, actorID, lockOP);
    }


    /// <summary>
    /// 设置战斗速度
    /// </summary>
    /// <param name="scale">倍率 0暂停 1正常</param>
    public void SetFightSpeed(float scale)
    {
        Time.timeScale = scale;

    }

    /// <summary>
    /// 清理战斗资源
    /// </summary>
    public void Reset()
    {
        lock (AI_Thread.Single.MutexLock)
        {
            DP_CameraTrackObjectManage.Single.Reset();
            AI_Thread.Single.T_Reset();//ai线程清理
            //wnd_fight.Single.Reset();
            DP_BattlefieldDraw.Single.Reset();
            AI_Single.Single.Battlefield.Reset();
            MFAModelManage.Single.Clean();//清缓存的模型和材质
            m_CameraTouchCount = 0;
        }

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
