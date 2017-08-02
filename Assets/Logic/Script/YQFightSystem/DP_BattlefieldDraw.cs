using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

      
/// <summary>
/// 演示层，战场绘制
/// </summary>
class DP_BattlefieldDraw : MonoBehaviour
{


    public static DP_BattlefieldDraw Single = null;

    public void BindMainSceneEvent()
    {
        //YQ2CameraCtrl.Single.OnPoschanged += (v) => { m_PosTrack2DManage.UpdatePos(); };
    }

    public int m_UIDepthOffset = 0;
    public int m_EagleEyeDepthOffset = 0;
    //public YQ2BatchRender GongJianBatchRender { get { return gongJianBatchRender; } }
    public void GetActorTransfrom(int actorID,out Transform tr,out float dirX)
    {
        if(m_ActivityActors.ContainsKey(actorID))
        {
            var actor = m_ActivityActors[actorID];
            if (actor.gameObject == null)
            {
                tr = null;
                dirX = 0;
                return;
            }
            tr = actor.gameObject.transform;
            dirX = 0;
        } else
        {
            tr = null;
            dirX = 0;
        }
    }


    Dictionary<int, DPActor_Desplay> m_ActivityActors = new Dictionary<int, DPActor_Desplay>();//活动的显示层演员       
    QKRandom m_Random;
    float m_totalLostTime = 0;


    Camera eyeCamera = null;
    ShakeManage shakeManage = null;//震动管理器
    //YQ2BatchRender gongJianBatchRender = null;
    Camera uiCamera = null;
}



class DPActor_Desplay
{
    public GameObject gameObject;//游戏物体实例
    public Vector3 pos = Vector3.zero;//位置信息
    //public float retZ = 0;//绕z旋转值
    public Vector3 offset = Vector3.zero;//位置偏移量
    public bool IsUIActor = false;//是否是一个ui演员
    public bool NeedPostMoveEvent = false;//是否需要抛出移动事件
}
