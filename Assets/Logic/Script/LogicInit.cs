using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
public class LogicInit
{


    //游戏逻辑初始化
    public static IEnumerator InitLogic()
    {
        // Debug.logger.logEnabled = false;

        Application.targetFrameRate = 30;//限定帧率

        m_logicInitProgress = 0;

        List<string> packs = new List<string>();
        // TODO 需要管理包加载
        packs.Add("packets");
        packs.Add("core");
        packs.Add("sc_main");
        packs.Add("tzbd_01");
        packs.Add("tzbd_99");
        packs.Add("uisound");
        packs.Add("scene_main");
        packs.Add("xuebaotujidui");
        // 基地
        packs.Add("jidi");
        // 防御塔
        packs.Add("turret");
        // 特效(攻击特效)
        packs.Add("attackeffect");
        //注册常驻包
        {
            foreach (var curr in packs)
                ResourceRefManage.Single.AddResidentPack(curr);
        }

        //装载内核包和主场景资源
        {
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

            m_logicInitProgress = 0.4f;
            yield return null;
        }

        //实例化服务器虚机
        QKNodeSDK_CLR.Node.AutoInstance();

        DataManager.AutoInstance();
        DisplayerManager.AutoInstance();
        m_logicInitProgress = 0.58f;
        yield return null;

        SData_mapdata.AutoInstance();
        m_logicInitProgress = 0.9f;
        yield return null;

        AI_Single.AutoInstance();

        //设置场景滚动限制参数
        {
            var scrollAreaLimiterObj = GameObject.Find("/ScrollAreaLimiter");
            var scrollAreaLimiter = scrollAreaLimiterObj.GetComponent<ScrollAreaLimiter>();

            var mapData = SData_mapdata.Single.GetDataOfID(1);
            var xmin = mapData.FreeCameraXmin;
            var xmax = mapData.FreeCameraXmax;

            var zmin = mapData.FreeCameraZmin;
            var zmax = mapData.FreeCameraZmax;

            var halfBoxw = (xmax - xmin) / 2;
            var halfBoxh = (zmax - zmin) / 2;

            var centerX = xmin + halfBoxw;
            var centerZ = zmin + halfBoxh;

            scrollAreaLimiter.Area.center = new Vector3(centerX, 300, centerZ);
            scrollAreaLimiter.Area.extents = new Vector3(halfBoxw, 1000, halfBoxh);
            scrollAreaLimiter.SoftArea.center = new Vector3(centerX, 300, centerZ);
            scrollAreaLimiter.SoftArea.extents = new Vector3(
                halfBoxw + 5 * DiamondGridMap.wxs * mapData.terrain_cell_bianchang,
                4000,
                halfBoxh + 5 * DiamondGridMap.VerticalSpacingFactor
                );
        }

        //实例化相机追随物管理器
        DP_CameraTrackObjectManage.AutoInstance();

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