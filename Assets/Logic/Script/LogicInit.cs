﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using LuaInterface;
//using UniLua;
using UnityEngine;
using UnityEngine.SceneManagement;
public class LogicInit
{


    //游戏逻辑初始化
    public static IEnumerator InitLogic()
    {

        Application.targetFrameRate = 30;//限定帧率

        m_logicInitProgress = 0;

        List<string> packs = new List<string>();
        packs.Add("packets");
        packs.Add("core");
        packs.Add("sc_main");
        packs.Add("uisound");
        packs.Add("scene_main");






        //注册常驻包
        {
            foreach (var curr in packs)
                ResourceRefManage.Single.AddResidentPack(curr);
        }

        //装载内核包和主场景资源
        {
            packs.Add("bsv");

            PacketLoader loader = new PacketLoader();
            loader.Start(PackType.Res, packs, null);

            //等待资源装载完成
            while (loader.Result == PacketLoader.ResultEnum.Loading)
                yield return null;
        }
        m_logicInitProgress = 0.3f;
        yield return null;

        {
            bool sc_main_loadComplate = false;

            //增量装载场景公共资源 LoadSceneMode.Additive 加载场景的时候不关闭上一个场景
            SceneManage.Single.Load(
                "sc_main", null, LoadSceneMode.Additive,
                () => sc_main_loadComplate = true,//装载完成通知
                null
                );

            //等待主场景装载完成
            while (!sc_main_loadComplate) yield return null;

            m_logicInitProgress = 0.35f;
            yield return null;

            //初始化战斗预置管理器
            DP_FightPrefabManage.Init();

            m_logicInitProgress = 0.4f;
            yield return null;
        }

        //实例化服务器虚机
        QKNodeSDK_CLR.Node.AutoInstance();

        SData_SenceDefine.AutoInstance();
        m_logicInitProgress = 0.5f;
        yield return null;

        SData_Id2String.AutoInstance();
        m_logicInitProgress = 0.55f;
        yield return null;

        DataManager.AutoInstance();
        DisplayerManager.AutoInstance();
        m_logicInitProgress = 0.58f;
        yield return null;

        //英雄相关
        //SData_HeroType.AutoInstance();
        SData_HeroData.AutoInstance();
        m_logicInitProgress = 0.6f;
        yield return null;

        SData_MonsterData.AutoInstance();
        m_logicInitProgress = 0.65f;
        yield return null;

        SData_EquipData.AutoInstance();
        m_logicInitProgress = 0.66f;
        yield return null;

        SData_RangeXingzhuang.AutoInstance();
        m_logicInitProgress = 0.67f;
        yield return null;



        //SData_HeroShuxingGrow.AutoInstance();
        //m_logicInitProgress = 0.7f;
        //yield return null;

        SData_GrowWithLv.AutoInstance();
        m_logicInitProgress = 0.71f;
        yield return null;

        SData_AudioFx.AutoInstance();
        m_logicInitProgress = 0.72f;
        yield return null;

        SData_Texiao.AutoInstance();
        m_logicInitProgress = 0.73f;
        yield return null;

        SData_Vibration.AutoInstance();
        m_logicInitProgress = 0.74f;
        yield return null;

        SData_Audio.AutoInstance();
        m_logicInitProgress = 0.745f;
        yield return null;


        SData_Army.AutoInstance();
        m_logicInitProgress = 0.75f;
        yield return null;

        SData_Zhenfa.AutoInstance();
        m_logicInitProgress = 0.8f;
        yield return null;

        SData_FightKeyValueMath.AutoInstance();
        m_logicInitProgress = 0.81f;
        yield return null;

        SData_Skill.AutoInstance();
        m_logicInitProgress = 0.85f;
        yield return null;

        SData_SkillBox.AutoInstance();
        m_logicInitProgress = 0.86f;
        yield return null;

        SData_SkillTrigger.AutoInstance();
        m_logicInitProgress = 0.88f;
        yield return null;

        SData_SkillRange.AutoInstance();
        m_logicInitProgress = 0.89f;
        yield return null;

        SData_FightKeyValue.AutoInstance();

        SData_MapData.AutoInstance();
        m_logicInitProgress = 0.9f;
        yield return null;

        SData_SkillArrive.AutoInstance();
        m_logicInitProgress = 0.93f;
        yield return null;

        //构建静态数据关联
        SData_Skill.Single.BuildLinks();
        SData_MonsterData.Single.BuildLinks();
        SData_HeroData.Single.BuildLinks();
        SData_Army.Single.BuildLinks();
        SData_AudioFx.Single.BuildLinks();
        SData_FightKeyValue.Single.BuildLinks();
        SData_SkillArrive.Single.BuildLinks();
        SData_SkillBox.Single.BuildLinks();

        DirectionGuideSchemeManage.AutoInstance();

        //卸载bsv包
        PacketManage.Single.UnLoadPacket("bsv");

        //实例化战役系统
        //AI_Battlefield.AutoInstance();
        //DP_TimeLine.AutoInstance();
        //AI_EffectTrackManage.AutoInstance();
        AI_Single.AutoInstance();

        //设置场景滚动限制参数
        {
            GameObject ScrollAreaLimiterObj = GameObject.Find("/ScrollAreaLimiter");
            ScrollAreaLimiter scrollAreaLimiter = ScrollAreaLimiterObj.GetComponent<ScrollAreaLimiter>();

            var xmin = SData_MapData.Single.FreeCameraXmin;
            var xmax = SData_MapData.Single.FreeCameraXmax;
            //TODODO 设置相机最右距离
            xmax = 1196;
            var zmin = SData_MapData.Single.FreeCameraZmin;
            var zmax = SData_MapData.Single.FreeCameraZmax;

            float halfBoxw = (xmax - xmin) / 2;
            float halfBoxh = (zmax - zmin) / 2;

            float centerX = xmin + halfBoxw;
            float centerZ = zmin + halfBoxh;

            scrollAreaLimiter.Area.center = new Vector3(centerX, 300, centerZ);
            scrollAreaLimiter.Area.extents = new Vector3(halfBoxw, 1000, halfBoxh);
            scrollAreaLimiter.SoftArea.center = new Vector3(centerX, 300, centerZ);
            scrollAreaLimiter.SoftArea.extents = new Vector3(
                halfBoxw + 5 * DiamondGridMap.wxs * SData_MapData.Single.TerrainCellBianchang,
                4000,
                halfBoxh + 5 * DiamondGridMap.VerticalSpacingFactor
                );
        }

        //实例化相机追随物管理器
        DP_CameraTrackObjectManage.AutoInstance();

        //初始化AI线程
        //new AI_Thread();

        //初始化场景中需要用到的界面元素
        //new wnd_scene();

        //new wnd_fight();

        //new wnd_prefight();

        m_logicInitProgress = 1.0f;
        yield return null;
    }

    public static float LogicInitProgress
    {
        get
        {
            return m_logicInitProgress;
        }
    }
    /// <summary>
    /// 记录加载进度 创建进度条用
    /// </summary>
    static float m_logicInitProgress = 0;


}