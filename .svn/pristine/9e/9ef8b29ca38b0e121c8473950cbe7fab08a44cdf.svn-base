using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using UnityEngine;
using MonoEX;

public class Module_U3DEX : IModule
{

    public static void MonoEXLogout(MonoEX.LOG_TYPE lgtp, string msg)
    {
        switch(lgtp)
        {
            case MonoEX.LOG_TYPE.LT_DEBUG:
            case MonoEX.LOG_TYPE.LT_INFO:
                UnityEngine.Debug.Log(msg);
                break;
            case MonoEX.LOG_TYPE.LT_WARNING:
                UnityEngine.Debug.LogWarning(msg);
                break;
            default:
                UnityEngine.Debug.LogError(msg);
                break;
        }
    }

    public IEnumerator Init()
    {
        MonoEX.Debug.LogoutHandle = MonoEXLogout;//设定日志输出回调

        //初始化数据表管理器
        new TabReaderManage(new U3dTabFactory());

        //挂载协程管理组件
        CoroutineManage.AutoInstance();
        yield return null;//等待携程管理器初始化完成

        //资源引用管理器
        //new ResourceRefManage();

        //挂载TimeLine组件
        UROMSystem.Single.AddComponent<UTimeLine>();
         

        //挂载场景管理组件
        //UROMSystem.Single.AddComponent<SceneManage>();

     
        //挂载UI景深渲染组件
        /*
        GameObject UIForegroundCameraObj = GameObject.Find("/UIRoot/UICameras/Camera_UIForeground");
        UIForegroundScreenTexture cmUIForegroundScreenTexture = UIForegroundCameraObj.AddComponent<UIForegroundScreenTexture>();
        cmUIForegroundScreenTexture.m_camera = UIForegroundCameraObj.GetComponent<Camera>();
        cmUIForegroundScreenTexture.m_targetUITexture =  GameObject.Find("/UIRoot/UIForegroundLayer/UIForegroundTexture");
        */

        //装载rom资源
        {
            List<string> packs = new List<string>();
            packs.Add("packets");
            packs.Add("rom_upd");//更新界面所需要资源
            packs.Add("rom_share");//更新界面和逻辑公共资源
            PacketLoader loader = new PacketLoader();
            loader.Start(PackType.Res, packs,null);

            //等待资源装载完成
            while (loader.Result == PacketLoader.ResultEnum.Loading)
                yield return null;
        }

         
        //初始化romcfg
        GameObject gameConfig = GameObjectExtension.InstantiateFromPacket("rom_share", "GameConfig", null);
        GameObject.DontDestroyOnLoad(gameConfig);
        yield return null; 
    }
}
