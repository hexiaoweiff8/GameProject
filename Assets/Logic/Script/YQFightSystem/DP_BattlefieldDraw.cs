﻿using System;
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
   
    public DP_BattlefieldDraw()
    {
        Single = this;
    }

   // void OnEnable() { CoroutineManage.Single.RegComponentUpdate(IUpdate); }


   // void OnDestroy()  {     CoroutineManage.Single.UnRegComponentUpdate(IUpdate); }
    //
    void FillObj3DDesplayObj(DPActor_Desplay dspActor, DPActor_Obj3D act)
    { 
        //创建游戏物体
        dspActor.gameObject = DP_FightPrefabManage.InstantiateObject3D(act.Res.ResName);

        //应用偏移值
        dspActor.gameObject.transform.localPosition = new Vector3(-999999, 0, 0); 

        //创建动画控制器
        dspActor.desplayController = new DesplayController_3DObj(dspActor.gameObject);
          
    }

    private void FillAvatarDesplayObj(DPActor_Desplay dspActor, DPActor_Avatar act)
    {
        bool isHero = act.Res.IsHero;

        //创建游戏物体
        //dspActor.gameObject = DP_FightPrefabManage.InstantiateAvatar(
        //    new CreateActorParam(act.Res.cmType,
        //// act.Res.MaskColor,
        //act.Res.colorMat,
        //act.Res.FlogColorIndex,
        //act.Res.MeshPackName,
        //act.Res.TexturePackName,
        //isHero));
         
        //应用偏移值
        dspActor.gameObject.transform.localPosition = new Vector3(-999999,0,0);
        
        string eIcon;
        if(isHero)
        {
            eIcon = SData_Hero.Get(act.Res.DataID).HeroFace;
        }else
            eIcon = "army"; 
        
        //创建动画控制器
        dspActor.desplayController = new DesplayController_Avatar(dspActor.gameObject,
            act.Res,//.CmType, 
            //act.Res.MaskColor,
            //act.Res.ColorMat, act.Res.FlogColorIndex,
            eIcon, 
            isHero,
             dspActor.actor.ID,
            1);

        dspActor.NeedPostMoveEvent = act.Res.NeedPostMoveEvent;

        var txtMesh = dspActor.gameObject.GetComponentInChildren<TextMesh>();
        if (txtMesh != null) txtMesh.text = dspActor.actor.ID.ToString();
        
    }
    /// <summary>
    /// 填充头顶头像
    /// </summary>
    /// <param name="dspActor"></param>
    /// <param name="act"></param>
    void FillOverheadPanelDesplayObj(DPActor_Desplay dspActor, DPActor_OverheadPanel act)
    {
        var res = act.Res;
        //创建头顶头像
        dspActor.gameObject = wnd_scene.Single.CreateOverhead();

        dspActor.pos = new Vector3(res.x, 0, res.z);
        //应用初始位置
        //Vector3 vPos = eyeCamera.WorldToScreenPoint(dspActor.pos);
        //vPos.z = 1f; 
        //dspActor.gameObject.transform.localPosition = uiCamera.ScreenToWorldPoint(vPos);   
        
        //创建动画控制器
        dspActor.desplayController = new DesplayController_OverheadPanel(
            eyeCamera,
            uiCamera,
            m_PosTrack2DManage,
            act.Res,dspActor.gameObject);

        //设定ui演员标志
        dspActor.IsUIActor = true; 
    }

    
    void FillBelowPanelDesplayObj(DPActor_Desplay dspActor, DPActor_BelowPanel act)
    {
        var res = act.Res;
        //创建游戏物体
        dspActor.gameObject = wnd_scene.Single.CreateBelow();

        dspActor.pos = Vector3.zero; //new Vector3(res.x, res.y, res.z);
        //应用初始位置
        //Vector3 vPos = eyeCamera.WorldToScreenPoint(dspActor.pos);
        //vPos.z = 1f;
        //dspActor.gameObject.transform.localPosition = uiCamera.ScreenToWorldPoint(vPos);

        //创建动画控制器
        dspActor.desplayController = new DesplayController_BelowPanel(
            eyeCamera,
            uiCamera,
            m_PosTrack2DManage,
            act.Res, dspActor.gameObject);

        //设定ui演员标志
        dspActor.IsUIActor = true; 
    } 

    void FillEmptyDesplayObj(DPActor_Desplay dspActor, DPActor_World act)
    {
         //创建游戏物体
        dspActor.gameObject = new GameObject(); 
         
        //创建动画控制器
        dspActor.desplayController = new DesplayController_World( ); 
    }


    /*
    void FillGongJianDesplayObj(DPActor_Desplay dspActor, DPActor_GongJian act)
    {
        var res = act.Res;
        string gjres = string.Format("GongJian{0:D2}", res.GongJianID);
        
        //创建游戏物体
        var pack = PacketManage.Single.GetPacket("gongjian");
        GameObject gameObj = pack.Load(gjres) as GameObject;

        dspActor.gameObject = GameObject.Instantiate(gameObj);

        //应用初始位置
        dspActor.gameObject.transform.localPosition = new Vector3(res.x, res.y, res.z);

        //设置朝向
        //var quad = dspActor.gameObject.GetComponent<YQ2BathQuad>();
        //if (!res.IsDirRight)
        //{
         //   float swaptmp = quad.lt_u; quad.lt_u = quad.rb_u; quad.rb_u = swaptmp;
        //} 
        //quad.OwnerBatch = gongJianBatchRender;
        //dspActor.gameObject.transform.rotation = Dir2Rotation.Radian2ActRot(res.dirx, res.dirz);

        //创建动画控制器
        dspActor.desplayController = new DesplayController_Gongjian(dspActor.gameObject, res);
    }*/

    void FillEffectDesplayObj(DPActor_Desplay dspActor, DPActor_Effect act)
    {
        var res = act.Res;
        //创建游戏物体
        //var pack = PacketManage.Single.GetPacket(res.PackName);
        //GameObject gameObj = new GameObject(); //pack.Load("main") as GameObject;

        var fx = CreateAudioFx3D(res.AudioFxID, res.LiveTime, res.dirx, res.dirz);

        dspActor.gameObject = fx.gameObject;

        //应用初始位置
        dspActor.gameObject.transform.localPosition = new Vector3(res.x, res.y, res.z);

        //设置朝向
        var roty = -(180 / Mathf.PI * AI_Math.Dir2Radian(res.dirx, res.dirz));
        dspActor.gameObject.transform.rotation = Quaternion.Euler(0, roty, 0); //Dir2Rotation.Radian2ActRot(res.dirx, res.dirz);

        //创建动画控制器
        dspActor.desplayController = new DesplayController_Effect(dspActor.gameObject,res);

        dspActor.NeedPostMoveEvent = act.Res.NeedPostMoveEvent;

        dspActor.gameObject.SetActive(false);
    }

    public YQ2AudioFx CreateAudioFx3D(int audioFxID,float liveTime,float dirX,float dirZ)
    {
        var gameObject = new GameObject();//GameObject.Instantiate(gameObj);
       gameObject.name = "Effect";
        var fx = gameObject.AddComponent<YQ2AudioFx>();

        //设置效果参数
        fx.AudioFxID = audioFxID;//效果ID
        fx.LiveTime = liveTime;//用新的生存时间替代配置的生存时间，大于0生效
        fx.DirX = dirX;
        fx.DirZ = dirZ;
        fx.shakeManage = shakeManage;
       // fx.batchRender = gongJianBatchRender;
        return fx;
    }


    //演员出生
    void DPActorBirth()
    {
        //演员出生
        LinkList<DPActor_Base> notbornActors = AI_Single.Single.Battlefield.DPTimeLine.m_NotbornActors;
        LinkList<DPActor_Base>.Node frontNode = notbornActors.Front;
        while (frontNode != null)
        {
            if (frontNode.v.BirthTime <= m_totalLostTime)
            {
                //创建演员显示实例
                DPActor_Desplay dspActor = new DPActor_Desplay();
                dspActor.actor = frontNode.v;
                switch (dspActor.actor.ActorType)
                {
                    case DPActorType.Avatar:
                        {
                            DPActor_Avatar act = dspActor.actor as DPActor_Avatar;
                            FillAvatarDesplayObj(dspActor, act); 
                        }
                        break;
                    case DPActorType.Effect:
                        {
                            DPActor_Effect act = dspActor.actor as DPActor_Effect;
                            FillEffectDesplayObj(dspActor, act); 
                        }
                        break;
                    case DPActorType.BelowPanel://脚下面板
                        {
                            var act = dspActor.actor as DPActor_BelowPanel;
                            FillBelowPanelDesplayObj(dspActor, act);  
                        }
                        break;
                    case DPActorType.World://世界演员
                        {
                            var act = dspActor.actor as DPActor_World;
                            FillEmptyDesplayObj(dspActor, act);  
                        }
                        break;
                    case DPActorType.Obj3D://3D物体
                        {
                            var act = dspActor.actor as DPActor_Obj3D;
                            FillObj3DDesplayObj(dspActor, act);
                        }
                        break;
                }
                m_ActivityActors.Add(dspActor.actor.ID, dspActor);
                m_ActivityActorList.Add(dspActor);

                //弹出已经出生的演员
                notbornActors.PopFront();
                frontNode = notbornActors.Front;
            }else
                break;//当前还未满足出生条件
        }

    }

    //绘制演员
    void DrawActors(float frameLostTime)
    {
        //将演示层当前数据，展示出来
        
        //foreach (var kv in m_ActivityActors)
        for (int i1 = 0; i1 < m_ActivityActorList.Count; i1++)
        {
            DPActor_Desplay dspObj = m_ActivityActorList[i1];//kv.Value;
            //插值计算出当前演员显示效果，并展示出来

            bool needSetPos = false;
            bool needSetAlpha = false;
            bool needRot = false;
            bool needSetBrightness = false;
            bool needSetScale = false;
            float alphaV = 0;
            float rotV = 0;
            //遍历活动的关键帧
            List<DP_Key> activatedKeys = dspObj.actor.ActivatedKeys; 
            for(int i=0;i< activatedKeys.Count;i++)
            //foreach (DP_Key currKey in activatedKeys)
            {
                DP_Key currKey = activatedKeys[i];
                if (dspObj.desplayController == null || dspObj.gameObject==null) continue;

                if (!currKey.isCalld  )
                {
                    dspObj.desplayController.OnKeyChanged(currKey);//通知动画控制器，关键帧发生改变
                }

                switch (currKey.KeyType)
                {

                    case DPKeyType.MoveTo:
                        {
                            DPKey_MoveTo moveToKey = currKey as DPKey_MoveTo;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            dspObj.pos.x = Mathf.Lerp(moveToKey.m_fromx, moveToKey.m_tox, t);
                            dspObj.pos.z = Mathf.Lerp(moveToKey.m_fromz, moveToKey.m_toz, t);
                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.Wait:
                        {

                        }
                        break;
                    case DPKeyType.ToX:
                        {

                            DPKey_ToX moveToKey = currKey as DPKey_ToX;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.pos.x = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.pos.x = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                default:
                                    dspObj.pos.x = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                            }

                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.ToY:
                        {
                            DPKey_ToY moveToKey = currKey as DPKey_ToY;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.pos.y = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.pos.y = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                default:
                                    dspObj.pos.y = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                            } 

                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.ToZ:
                        {
                            DPKey_ToZ moveToKey = currKey as DPKey_ToZ;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.pos.z = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.pos.z = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                default:
                                    dspObj.pos.z = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                            }


                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.OffsetToX:
                        {
                            DPKey_OffsetToX moveToKey = currKey as DPKey_OffsetToX;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.offset.x = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.offset.x = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                default:
                                    dspObj.offset.x = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                            }
                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.OffsetToY:
                        {
                            DPKey_OffsetToY moveToKey = currKey as DPKey_OffsetToY;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len==0?1:lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.offset.y = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.offset.y = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                default:
                                    dspObj.offset.y = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                            }
                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.OffsetToZ:
                        {
                            DPKey_OffsetToZ moveToKey = currKey as DPKey_OffsetToZ;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.offset.z = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.offset.z = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                default:
                                    dspObj.offset.z = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                            }
                            needSetPos = true;
                        }
                        break;
                    case DPKeyType.SetParent:
                        {
                            DPKey_SetParent setPKey = currKey as DPKey_SetParent;
                            int parentID = setPKey.ParentID;
                            bool setok = false;
                            if (m_ActivityActors.ContainsKey(parentID))
                            {
                                var gameObj = m_ActivityActors[parentID].gameObject;
                                if (gameObj != null)
                                {
                                    setok = true;
                                    dspObj.gameObject.transform.parent = gameObj.transform;
                                }
                                else
                                    dspObj.gameObject.transform.parent = null;

                                needSetPos = true;
                            }else
                            {
                                dspObj.gameObject.transform.parent = null;
                                needSetPos = true;
                            }


                            var dspID = dspObj.actor.ID;
                            foreach (var pckv in m_ParentIDAndChildID)
                            {
                                var child = pckv.Value;
                                if (child == dspID)
                                {
                                    m_ParentIDAndChildID.Remove(pckv);
                                    break;
                                }
                            }

                            if(setok) m_ParentIDAndChildID.Add(new KeyValuePair<int, int>(parentID, dspID)); 
                        }
                        break;
                    
                        /*
                    case DPKeyType.ScaleX:
                        {

                            DPKey_ScaleX moveToKey = currKey as DPKey_ScaleX;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.scale.x = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.scale.x = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                                default:
                                    dspObj.scale.x = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromx, moveToKey.m_tox, t);
                                    break;
                            }

                            needSetScale = true;
                        }
                        break;
                    case DPKeyType.ScaleY:
                        {

                            DPKey_ScaleY moveToKey = currKey as DPKey_ScaleY;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.scale.y = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.scale.y = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                                default:
                                    dspObj.scale.y = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromy, moveToKey.m_toy, t);
                                    break;
                            }

                            needSetScale = true;
                        }
                        break;
                    case DPKeyType.ScaleZ:
                        {

                            DPKey_ScaleZ moveToKey = currKey as DPKey_ScaleZ;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len;


                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    dspObj.scale.z = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    dspObj.scale.z = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                                default:
                                    dspObj.scale.z = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromz, moveToKey.m_toz, t);
                                    break;
                            }

                            needSetScale = true;
                        }
                        break;
                        */
                    case DPKeyType.RotZ:
                        {
                            DPKey_RotZ nKey = currKey as DPKey_RotZ;
                            float lostTime = m_totalLostTime - nKey.StartTime;
                            float t = nKey.len == 0 ? 1 : lostTime / nKey.len;

                            switch (nKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    rotV = DP_TweenFuncs.Tween_Linear_Float(nKey.m_fromZ, nKey.m_toZ, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    rotV = DP_TweenFuncs.Tween_Accelerated_Float(nKey.m_fromZ, nKey.m_toZ, t);
                                    break;
                                default:
                                    rotV = DP_TweenFuncs.Tween_Deceleration_Float(nKey.m_fromZ, nKey.m_toZ, t);
                                    break;
                            } 
                            needRot = true;
                        }
                        break;
                    case DPKeyType.SetDir:
                        {
                            if (!currKey.isCalld)
                            {
                                var nKey = currKey as DPKey_SetDir;

                                var roty= -(180 / Mathf.PI * AI_Math.Dir2Radian(nKey.DirX, nKey.DirZ));
                                //var rot = ; //Dir2Rotation.Radian2ActRot( nKey.DirX,  nKey.DirZ);;
                                var oldEuler = dspObj.gameObject.transform.localEulerAngles;
                                dspObj.gameObject.transform.localRotation = Quaternion.Euler(oldEuler.x, roty, oldEuler.z);
                            }
                        }
                        break;

                    case DPKeyType.SetNeedPostMoveEvent:
                        {
                            if (!currKey.isCalld)
                            {
                                var nKey = currKey as DPKey_SetNeedPostMoveEvent;
                                dspObj.NeedPostMoveEvent = nKey.NeedPostMoveEvent;
                            }
                        }
                        break;
                    case DPKeyType.Alpha:
                        { 
                            DPKey_AlphaTo moveToKey = currKey as DPKey_AlphaTo;
                            float lostTime = m_totalLostTime - moveToKey.StartTime;
                            float t = moveToKey.len == 0 ? 1 : lostTime / moveToKey.len; 

                            switch (moveToKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    alphaV = DP_TweenFuncs.Tween_Linear_Float(moveToKey.m_fromAlpha, moveToKey.m_toAlpha, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    alphaV = DP_TweenFuncs.Tween_Accelerated_Float(moveToKey.m_fromAlpha, moveToKey.m_toAlpha, t);
                                    break;
                                default:
                                    alphaV = DP_TweenFuncs.Tween_Deceleration_Float(moveToKey.m_fromAlpha, moveToKey.m_toAlpha, t);
                                    break;
                            }

                            //设置透明度
                            needSetAlpha = true;
                        }
                        break;

                    case DPKeyType.Brightness:
                        {
                            DPKey_BrightnessTo nKey = currKey as DPKey_BrightnessTo;
                            float lostTime = m_totalLostTime - nKey.StartTime;
                            float t = nKey.len == 0 ? 1 : lostTime / nKey.len;

                            switch (nKey.makingUpFunc)
                            {
                                case MakingUpFunc.Linear:
                                    alphaV = DP_TweenFuncs.Tween_Linear_Float(nKey.m_from, nKey.m_to, t);
                                    break;
                                case MakingUpFunc.Acceleration:
                                    alphaV = DP_TweenFuncs.Tween_Accelerated_Float(nKey.m_from, nKey.m_to, t);
                                    break;
                                default:
                                    alphaV = DP_TweenFuncs.Tween_Deceleration_Float(nKey.m_from, nKey.m_to, t);
                                    break;
                            }

                            //设置透明度
                            needSetBrightness = true;
                        }
                        break; 
                    case DPKeyType.ActiveInstance://激活实例
                        {
                            if (!currKey.isCalld)
                            {
                                dspObj.gameObject.SetActive(true);
                                dspObj.desplayController.OnEnable();
                            }
                        }
                        break;
                    case DPKeyType.DisableInstance://禁用实例
                        {
                            if (!currKey.isCalld)
                            {

                                var nKey = currKey as DPKey_DisableInstance;
                                var aID = nKey.actorID;
                                if (!m_DisableActors.ContainsKey(aID) && m_ActivityActors.ContainsKey(aID))
                                {
                                    var a = m_ActivityActors[aID];
                                    m_DisableActors.Add(aID, a);
                                    if (a.gameObject != null) a.gameObject.SetActive(false);

                                    m_ActivityActors.Remove(aID);
                                    m_ActivityActorList.Remove(a);
                                }
                            }
                        }
                        break;
                    case DPKeyType.EnableInstance://启用实例
                        {
                            if (!currKey.isCalld)
                            {
                                var nKey = currKey as DPKey_EnableInstance;

                                var aID = nKey.actorID;
                                if (m_DisableActors.ContainsKey(aID))
                                {
                                    var a = m_DisableActors[aID];
                                    if (a.gameObject != null)
                                    {
                                        a.gameObject.SetActive(true);

                                        a.gameObject.transform.localPosition = AI_Single.Single.Battlefield.ISInBattle
                                            ? new Vector3(nKey.x, nKey.y, nKey.z)
                                            : Vector3.zero;
                                        a.desplayController.OnEnable();
                                        if (!AI_Single.Single.Battlefield.ISInBattle)
                                        {
                                            //a.gameObject.AddComponent<SinglePatrol>();
                                            //var sp = a.gameObject.GetComponent<SinglePatrol>();
                                            //sp.SetWaitTime(1.0f);
                                            //sp.SetRunTime(50f);
                                        }
                                        
                                    }

                                    m_ActivityActors.Add(aID,a);
                                    m_ActivityActorList.Add(a);
                                    m_DisableActors.Remove(aID);
                                } 
                            }
                        }
                        break;
                    case DPKeyType.DestroyInstance://销毁实例
                        {
                            if (!currKey.isCalld)
                            {
                                var dspID = dspObj.actor.ID;

                                //本实例的子物体自动解除父子关系
                                {
                                    bool changed;
                                    do
                                    {
                                        changed = false;
                                        foreach (var pckv in m_ParentIDAndChildID)
                                        {
                                            var pp = pckv.Key;
                                            if (pp == dspID)
                                            {
                                                if (m_ActivityActors.ContainsKey(pckv.Value)) m_ActivityActors[pckv.Value].gameObject.transform.parent = null;
                                                m_ParentIDAndChildID.Remove(pckv);
                                                changed = true;
                                                break;
                                            }
                                        }
                                    } while (changed);
                                }
                                 
                                dspObj.desplayController.Destroy();
                                GameObject.Destroy(dspObj.gameObject);
                                dspObj.gameObject = null;
                                dspObj.desplayController = null;

                                var aID = dspObj.actor.ID;
                                if (m_ActivityActors.ContainsKey(aID))
                                {
                                    m_ActivityActors.Remove(aID);
                                    m_ActivityActorList.Remove(dspObj);
                                }else
                                    m_DisableActors.Remove(aID);


                                m_DieActors.Add(dspObj.actor);
                                i1--;
                                break;

                            }
                        }
                        break;
                    case DPKeyType.CameraTrack://镜头追踪
                        {
                            if (!currKey.isCalld)
                            {
                                DPKey_CameraTrack nKey = currKey as DPKey_CameraTrack;
                                if(nKey.IsTrack)//追踪
                                {
                                    DP_Battlefield.Single.CameraFocusActorID(dspObj.actor.ActorType,dspObj.actor.ID,true);
                                    //DP_CameraTrackObjectManage.Single.SetTrackActor(dspObj.actor.ActorType, dspObj.actor.ID, true); 
                                    
                                }else//取消追踪
                                {
                                    DP_CameraTrackObjectManage.Single.UnLockOP( );
                                }
                            }
                        }
                        break;
                    case DPKeyType.CutKeys://剪裁活动关键帧
                        {
                            float endTime = currKey.StartTime;
                            foreach (DP_Key aKey in activatedKeys)
                            {
                                if(aKey.StartTime<endTime)//大于这个时间点的，在添加关键帧的时候就已经剪裁过了
                                    aKey.Cut(endTime);
                            }
                        }
                        break;
                };

                if (!currKey.isCalld) currKey.isCalld = true;
            }

           
            if (dspObj.gameObject != null)
            {
                //改变物体位置
                if (needSetPos || dspObj.IsUIActor)
                {
                    tmpV3.x = dspObj.pos.x + dspObj.offset.x;
                    tmpV3.y = dspObj.pos.y + dspObj.offset.y;
                    tmpV3.z = dspObj.pos.z + dspObj.offset.z;

                    if (dspObj.IsUIActor)//界面控件
                    {

                       dspObj.desplayController.OnUISet3DPos(tmpV3);
                      
                        /*
                       Vector3 vPos = eyeCamera.WorldToScreenPoint(tmpV3);
                       if (vPos.z > 0)//在屏幕内
                       {
                           vPos.z = 1f;
                           dspObj.gameObject.transform.position = uiCamera.ScreenToWorldPoint(vPos);
                       }
                       else//在屏幕外
                       {
                           tmpV3.x = tmpV3.y =99999; tmpV3.z = 0;
                           dspObj.gameObject.transform.localPosition = tmpV3;
                       }*/
                    }
                    else //3D物体
                    {
                        //dspObj.gameObject.transform.localPosition = tmpV3; 
                    }
                    if (dspObj.NeedPostMoveEvent) DP_FightEvent.PostActorMove(dspObj.actor.ID);

                }

                if (needRot)
                {
                    var el = dspObj.gameObject.transform.localRotation.eulerAngles;
                    dspObj.gameObject.transform.localRotation = Quaternion.Euler(el.x, el.y, rotV);//el.z
                }

                if (needSetAlpha) dspObj.desplayController.SetAlpha(alphaV);

                if (needSetBrightness) dspObj.desplayController.SetBrightness(alphaV);

                //缩放物体
                /*
                if (needSetScale)
                {
                    tmpV3.x = dspObj.scale.x * dspObj.originalScale.x;
                    tmpV3.y = dspObj.scale.y * dspObj.originalScale.y;
                    tmpV3.z = dspObj.scale.z * dspObj.originalScale.z;
                    dspObj.gameObject.transform.localScale = tmpV3;
                }*/

                dspObj.desplayController.Update(frameLostTime);//显示控制器更新 
                dspObj.actor.UpdateActiveKeys(m_totalLostTime);//动态激活和禁用关键帧 
            }
        }

    }

    void LateUpdate()
    {
        if (AI_Single.Single == null || AI_Single.Single.Battlefield.FightST < FightST.StartDone) return;

        if (eyeCamera == null)
        {
            eyeCamera = GameObject.Find("/PTZCamera/SceneryCamera").GetComponent<Camera>();

            var uiCameraObj = GameObject.Find("/UIRoot/Camera_UI");

            //m_PosTrack2DManage = uiCameraObj.GetComponent<PosTrack2DManage>();
            uiCamera = uiCameraObj.GetComponent<Camera>();
            //gongJianBatchRender = GameObject.Find("/PTZCamera/ArrowsCamera").GetComponent<YQ2BatchRender>();

            shakeManage = GameObject.Find("/ShakeManage").GetComponent<ShakeManage>();
        }


        float frameLostTime = Time.deltaTime;// *10;
        m_totalLostTime += frameLostTime;//演示层的当前时间

        lock (AI_Thread.Single.MutexLock)
        {
            //放入缓存的AI命令
            if (m_ActiveCmd.Count > 0)
            {
                foreach (var cmd in m_ActiveCmd) AI_Single.Single.Battlefield.PushAICmd(cmd);
                m_ActiveCmd.Clear();
            }

            //如果AI当前时间小于演示层当前时间，则AI步进到演示层当前时间点
            AI_Thread.Single.T_SetEndTime(m_totalLostTime);
            AI_Thread.Single.T_Do();

            /*
            double totalSeconds =  (DateTime.Now - n).TotalSeconds;
            Debug.Log("totalSeconds " + totalSeconds.ToString());
            */

            //演员出生
            DPActorBirth();

            //绘制活动的演员
            DrawActors(frameLostTime);


            //AI步进，让AI线程异步去算，与主线渲染同时进行
            AI_Thread.Single.T_SetEndTime(m_totalLostTime + 0.2f);
        }


        //每帧更新角色跟随面板位置 
        m_PosTrack2DManage.UpdatePos(); 
    }


    public void BindMainSceneEvent()
    {
        //YQ2CameraCtrl.Single.OnPoschanged += (v) => { m_PosTrack2DManage.UpdatePos(); };
    }

    public void Reset()
    {
        {
            foreach (var curr in m_ActivityActors)
            {
                var dsp = curr.Value;
                if (dsp.gameObject != null) GameObject.Destroy(dsp.gameObject);
            }
            m_ActivityActors.Clear();
            m_ActivityActorList.Clear();
        }
        
        {
            foreach (var curr in m_DisableActors)
            {
                var dsp = curr.Value;
                if (dsp.gameObject != null) GameObject.Destroy(dsp.gameObject);
            }
            m_DisableActors.Clear();
        }



        m_DieActors.Clear();  

        m_totalLostTime = 0;
        m_Random = new QKRandom(1);
        m_ParentIDAndChildID.Clear();
        m_ActiveCmd.Clear();
        m_UIDepthOffset = 0;
        m_EagleEyeDepthOffset = 0;


        //BuffsRoot = GameObject.Find("/SceneRoot/Buffs");
        //AvatarRoot = GameObject.Find("/SceneRoot/Avatar");
        //EffectsRoot = GameObject.Find("/SceneRoot/Effects");
    }

    public int RandomInt(int min, int max)
    {
        return m_Random.RangeI(min, max);
    }

    public void PushAICmd(AICmd cmd)    {        m_ActiveCmd.Add(cmd);    }

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
            dirX = actor.desplayController.DirX;
        } else
        {
            tr = null;
            dirX = 0;
        }
    }

    //总逝去时间
    public float TotalLostTime
    {
        get { return m_totalLostTime; }
    }
 
    /// <summary>
    /// 通过id获取到对应演员的显示组件
    /// </summary>
    /// <param name="actorID"></param>
    /// <returns></returns>
    public DPActor_Desplay GetActor_desplay(int actorID)
    {
        if (m_ActivityActors.ContainsKey(actorID))
        {
            return m_ActivityActors[actorID];
        }
        else
        {
            return null;
        }
    }

    public Camera EyeCamera { get { return eyeCamera; } }

    //父 子
    List<KeyValuePair<int, int>> m_ParentIDAndChildID = new List<KeyValuePair<int, int>>();
    //Dictionary<int, List<int>> m_ParentIDAndChildID = new Dictionary<int, List<int>>();
    Dictionary<int, DPActor_Desplay> m_ActivityActors = new Dictionary<int, DPActor_Desplay>();//活动的显示层演员       
    List<DPActor_Desplay> m_ActivityActorList = new List<DPActor_Desplay>();
    Dictionary<int, DPActor_Desplay> m_DisableActors = new Dictionary<int, DPActor_Desplay>();//禁用的显示层演员       

    List<DPActor_Base> m_DieActors = new List<DPActor_Base>();//已经失效的显示层演员
    List<AICmd> m_ActiveCmd = new List<AICmd>();
    
    QKRandom m_Random;
    float m_totalLostTime = 0;


    Vector3 tmpV3 = new Vector3();
    Color tmpColor = new Color();  
    //GameObject BuffsRoot;
    //GameObject AvatarRoot;
    //GameObject EffectsRoot;
    Camera eyeCamera = null;
    ShakeManage shakeManage = null;//震动管理器
    //YQ2BatchRender gongJianBatchRender = null;
    Camera uiCamera = null;
    PosTrack2DManage m_PosTrack2DManage = new PosTrack2DManage();
}



class DPActor_Desplay
{
    public DPActor_Base actor;//演员
    public GameObject gameObject;//游戏物体实例
    public Vector3 pos = Vector3.zero;//位置信息
    //public float retZ = 0;//绕z旋转值
    public Vector3 offset = Vector3.zero;//位置偏移量
    public bool IsUIActor = false;//是否是一个ui演员
    public bool NeedPostMoveEvent = false;//是否需要抛出移动事件
    //public Vector3 originalScale;//原始缩放值
    //public Vector3 scale;//逻辑缩放值

    //public Material Mat;//材料
    public I_DesplayController desplayController;//显示控制器
}
