using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LuaInterface;
using UnityEngine;

/// <summary>
/// 场景切换器
/// </summary>
public static class SceneChanger
{

    ///// <summary>
    ///// 切到主场景
    ///// </summary>
    ///// <returns></returns>
    //public static int LoadMainBaseActors()
    //{
    //    //in FightParameter[,talkRecallClass,talkRecallFunc]
    //    //if (FightLoading) return 0;

    //    //var n = lua.GetTop();
    //    FightParameter param = new FightParameter();

    //    param.QixiSquare = null;
    //    param.sceneID = 1;
    //    //param.tuiguan_zhang = 1;
    //    //param.tuiguan_jie = 1;
    //    param.fightType = FightType.Tuiguan;

    //    param.Squares = new List<ArmySquareInfo>();

    //    // TODO 加载数据, 不应该放在这里, 测试
    //    //GlobalData.FightData.SetData(1, 1, 0, 1, 1, 0, 1);
    //    //GlobalData.FightData.IsSetData = true;
    //    //// 设置离线战斗标识
    //    //GlobalData.FightData.IsOnline = false;

    //    return LoadScene(param);
    //}

    /// <summary>
    /// 切战在线斗
    /// </summary>
    /// <returns></returns>
    public static int LoadFight(Action callback = null)
    {
        //in FightParameter[,talkRecallClass,talkRecallFunc]
        //if (FightLoading) return 0;

        //var n = lua.GetTop();
        FightParameter param = new FightParameter();

        param.QixiSquare = null;
        param.sceneID = 1;
        //param.tuiguan_zhang = 1;
        //param.tuiguan_jie = 1;
        param.fightType = FightType.Tuiguan;

        // 发送并请求数据
        // 设置在线战斗标识
        //GlobalData.FightData.IsOnline = true;

        param.Squares = new List<ArmySquareInfo>();
        return LoadScene(param, callback);
    }

    /// <summary>
    /// TODO 切战斗类型选择场景, 测试用
    /// </summary>
    /// <returns></returns>
    public static int LoadChooseFight(Action callback = null)
    {
        FightParameter param = new FightParameter();

        param.QixiSquare = null;
        param.sceneID = 99;
        //param.tuiguan_zhang = 1;
        //param.tuiguan_jie = 1;
        param.fightType = FightType.Tuiguan;

        param.Squares = new List<ArmySquareInfo>();
        return LoadScene(param, callback);
    }


    /// <summary>
    /// 加载场景
    /// </summary>
    /// <param name="param">场景参数</param>
    /// <param name="callback">完成回调</param>
    /// <returns>加载状态</returns>
    public static int LoadScene(FightParameter param, Action callback)
    {
        CoroutineManage.Single.StartCoroutine(CoLoadScene(param, callback));
        return 0;
    }


    /// <summary>
    /// 加载
    /// </summary>
    /// <param name="param">加载参数</param>
    /// <param name="callback">加载完成回调</param>
    /// <returns></returns>
    private static IEnumerator CoLoadScene(FightParameter param, Action callback)
    {
        ////显示战斗装载界面
        //wnd_prefight.Single.Show(Wnd.DefaultDuration);

        //停顿一段时间，等界面显示完全
        {
            float t = Wnd.DefaultDuration;
            while (t > 0)
            {
                yield return null;
                t -= Time.deltaTime;
            }
        }


        //立即回收被隐藏的窗口
        WndManage.Single.DestroyHideWnds();

        //清理战场
        //DP_Battlefield.Single.Reset();

        //卸掉场景
        DP_Battlefield.Single.SwapScene(0, null, null);

        //立即垃圾回收
        //GC.Collect();
        Resources.UnloadUnusedAssets();

        //装载资源包 
        List<string> dyPacks = AI_Single.Single.Battlefield.GeneratePackList();


        //装载场景
        bool loadDone = false;
        DP_Battlefield.Single.SwapScene(param.sceneID, dyPacks, () => loadDone = true);
        //DP_Battlefield.Single.LoadBase();
        while (!loadDone) yield return null; //等待场景装载完成


        //重新装载3D物体预置
        DP_FightPrefabManage.ReLoad3DObjects();


        //隐藏loading
        //wnd_prefight.Single.Hide(Wnd.DefaultDuration);
        //BackgroundMusic = param.Music;


        if (callback != null)
        {
            callback();
        }

        LuaFunction main = LuaClient.GetMainState().GetFunction("Onfs");
        main.Call();
        main.Dispose();
        main = null;
    }
}