using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 using UnityEngine;

/// <summary>
/// 演示层战斗事件
/// </summary>
static class DP_FightEvent
{
    /// <summary>
    /// 英雄移动事件
    /// </summary>
    //public static event onHeroMove OnHeroMove;

    /// <summary>
    /// 抛出英雄移动事件
    /// </summary>
    //public static void PostHeroMove(bool isAttack, int dataID, Vector3 newPos) { OnHeroMove(isAttack, dataID, newPos); }



    //public delegate void onHeroMove(bool isAttack, int dataID, Vector3 newPos);


    /// <summary>
    /// 演员移动事件
    /// </summary>
    public static event onActorMove OnActorMove;
    public delegate void onActorMove(int actorID);

    /// <summary>
    /// 手动激活事件
    /// </summary>
    public static event onShoudongActive OnShoudongActive;
    public delegate void onShoudongActive(int heroID, int count);

    /// <summary>
    /// 场景被首次拖动
    /// </summary>
    public static event Action OnFirstTouchScene;



    public static void PostFirstTouchScene() { if(OnFirstTouchScene!=null) OnFirstTouchScene(); }



} 
