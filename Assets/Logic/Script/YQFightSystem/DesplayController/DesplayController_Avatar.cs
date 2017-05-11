﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;

/// <summary>
/// 角色显示控制器
/// </summary>
class DesplayController_Avatar : I_DesplayController
{
    const int EagleEyeMapHeroW = 480;
    const float EagleEyeMapHeroYOffset = EagleEyeMapHeroW / 1.3f;
    const int EagleEyeMapArmyW = 20;
    const int EagleEyeMapArmyH = 30;
    static int heroIconDepth = 2;
    public DesplayController_Avatar(GameObject gameObject,
        //AvatarCM CmType,         bool isColorMat, int colorIndex, 
        AvatarResources res,
        string eagleEyeIcon, 
        bool isHero,
        int actorID,
        int cardId
        )
    {
        m_res = res;
        this.gameObject = gameObject;
        modelRender = gameObject.GetComponent<MFAModelRender>();
        
        var shadowObj = gameObject.transform.FindChild("Shadow");
        if(shadowObj!=null) ShadowRenderer = shadowObj.GetComponent<Renderer>();
        
       // this.maskColor = maskColor;
        this.isColorMat =  m_res.colorMat;
        this.isHero = isHero;
        m_actorID = actorID;
        //this.CmType = CmType;
       
        //colorIndex 0 进攻方  "army"
        var pos = this.gameObject.transform.position;
        m_DirX = res.FlogColorIndex == 0 ? 1 : -1;
        var cmType = m_res.cmType;

        if (cmType == AvatarCM.Cavalry_RH || cmType == AvatarCM.Infantry_R || cmType == AvatarCM.CavalryHero_RH || cmType == AvatarCM.InfantryHero_R)
        {
            if (isHero)
            {

                EagleEyeObj = wnd_fight.Single.EagleEyeMap.AddObj(
                    pos.x, pos.z + EagleEyeMapHeroYOffset,
                    wnd_fight.Single.RadarHeroHeadMB,
                    heroIconDepth++
                    );

                //设置英雄头像图标
                {
                    //var img = EagleEyeObj.widget.gameObject.transform.FindChild("img");
                    //var headSprite = img.GetComponent<UISprite>();
                    //LuaHeroInfoLibs.SetHeroIconCirclemask(headSprite, SData_Hero.Get(m_res.DataID));
                }

                EagleEyeLight = EagleEyeObj.widget.gameObject.transform.FindChild("light").gameObject;
                /*
                EagleEyeObjID = wnd_fight.Single.EagleEyeMap.AddActor(pos.x, pos.z + EagleEyeMapHeroYOffset, EagleEyeMapHeroW, EagleEyeMapHeroW, eagleEyeIcon, Color.white, false, heroIconDepth++);
                EagleEyeArrowID = wnd_fight.Single.EagleEyeMap.AddActor(
                    pos.x, pos.z, EagleEyeMapHeroW, EagleEyeMapHeroW / 0.7021276595744681f, colorIndex == 0 ? "QL" : "QR",
                    Color.white, true,
                    heroIconDepth++
                    );

               */
                DepthOffset = DP_BattlefieldDraw.Single.m_EagleEyeDepthOffset;
                DP_BattlefieldDraw.Single.m_EagleEyeDepthOffset += 2;
            }
            else
                EagleEyeObjID = wnd_fight.Single.EagleEyeMap.AddActor(pos.x, pos.z, EagleEyeMapArmyW, EagleEyeMapArmyH, eagleEyeIcon, DP_FightPrefabManage.ColorTab[m_res.FlogColorIndex], false, 1);
        }

        if(cmType == AvatarCM.CavalryHero_RH || cmType == AvatarCM.InfantryHero_R)//活着的武将
        {
            //动态挂载烟雾拖尾组件
            var pack = PacketManage.Single.GetPacket("yanwu_tuowei");
            var tuowei = pack.Load("yanwu_tuowei") as GameObject;
            var cloneTuoWei = GameObject.Instantiate(tuowei);
            cloneTuoWei.transform.parent = gameObject.transform;
            cloneTuoWei.transform.localPosition = Vector3.zero;
            cloneTuoWei.SetActive(false);
            var cmParticleTrailing = gameObject.AddComponent<YQ2ParticleTrailing>();
            cmParticleTrailing.Particle = cloneTuoWei;

            //设置脚下圈的材质
            if(res.FlogColorIndex==1)//敌方
            {
                var corepack = PacketManage.Single.GetPacket("core");
                var quan = gameObject.transform.FindChild("Quan");
                var render = quan.GetComponent<Renderer>();
                render.material = corepack.Load("Shadow02") as Material;
            }
        }
    }
    public void OnEnable() { }
    public void OnUISet3DPos(Vector3 pos3d) { }

    public void Destroy()
    {
        RemoveFromEagleEyeMap();
    }

    void RemoveFromEagleEyeMap()
    {
        if (EagleEyeObjID >= 0) { 
            wnd_fight.Single.EagleEyeMap.RemoveActor(EagleEyeObjID); EagleEyeObjID = -1; 
        }
        if (EagleEyeArrowID >= 0) {
            wnd_fight.Single.EagleEyeMap.RemoveActor(EagleEyeArrowID); EagleEyeArrowID = -1;
        }
        if (EagleEyeObj != null) { 
            wnd_fight.Single.EagleEyeMap.RemoveObj(EagleEyeObj.id); EagleEyeObj = null; 
        }
    }

    public void Update(float lostTime)
    {
        m_LostTotalTime += lostTime;
        if (m_LostTotalTime - m_LastUpdateTime > 0.1f)
        {
            m_LastUpdateTime = m_LostTotalTime;

            var pos = this.gameObject.transform.position;
            var cmType = m_res.cmType;
            if (cmType == AvatarCM.Cavalry_RH || cmType == AvatarCM.Infantry_R || cmType == AvatarCM.CavalryHero_RH || cmType == AvatarCM.InfantryHero_R)
            {
                if (isHero)
                {
                    /*
                   
                    wnd_fight.Single.EagleEyeMap.MoveActor(EagleEyeObjID, pos.x, pos.z + EagleEyeMapHeroYOffset, depth);
                    wnd_fight.Single.EagleEyeMap.MoveActor(EagleEyeArrowID, pos.x, pos.z, depth + 1);
                    */
                    int depth = 1000000 - (int)pos.z * 100 + DepthOffset;
                    wnd_fight.Single.EagleEyeMap.MoveObj(EagleEyeObj.id,pos.x, pos.z, depth);
                }
                else
                    wnd_fight.Single.EagleEyeMap.MoveActor(EagleEyeObjID, pos.x, pos.z);
            }
        }
    }



    public void OnKeyChanged(DP_Key newKey)
    {

        switch (newKey.KeyType)
        {
            case DPKeyType.MoveTo://移动到
                {
                    DPKey_MoveTo hKey = newKey as DPKey_MoveTo;
                    modelRender.SetClip("run".GetHashCode());
                    modelRender.IsLoop = true;
                    gameObject.transform.localRotation = Dir2Rotation.Radian2ActRot(hKey.DirX, hKey.DirZ);
                    m_DirX = hKey.DirX;

                }
                break;
            case DPKeyType.PlayAct://播放动画
                {
                    DPKey_PlayAct playKey = newKey as DPKey_PlayAct;
                    modelRender.SetLostTime(0);
                    modelRender.SetClip(playKey.clipName.GetHashCode());
                    modelRender.IsLoop = playKey.loop;
                    modelRender.speedScale = playKey.speedScale;
                    gameObject.transform.localRotation = Dir2Rotation.Radian2ActRot(playKey.dirx, playKey.dirz);
                    m_DirX = playKey.dirx;

                    if (m_res.NeedPostMoveEvent) DP_FightEvent.PostActorMove(m_actorID);
                }
                break;
            case DPKeyType.Wait://等待
                {
                    modelRender.SetLostTime(0);
                    modelRender.SetClip("wait2".GetHashCode());
                    modelRender.IsLoop = true;
                    modelRender.speedScale = 1;
                }
                break;
            case DPKeyType.Alpha://半透
                {
                    if (!isColorMat) //当前使用的是不支持半透的材质，则自动换成支持半透的材质
                    {
                        isColorMat = true;
                        modelRender.SetMat(
                            DP_FightPrefabManage.CreateMat(
                            //maskColor, 
                            true)
                        );
                    }
                    YQ2BathQuad shadow = modelRender.GetComponent<YQ2BathQuad>();
                    if (shadow != null) shadow.enabled = false;//禁用阴影组件
                }
                break;
            case DPKeyType.JinYuanSwap://近远模型切换
                {
                    var nKey = newKey as DPKey_JinYuanSwap;
                    float lodCount = modelRender.LodCount;
                    if (nKey.IsYuan)
                    {
                        for (int i = 0; i < lodCount; i++)
                        {
                            string meshName = modelRender.GetLodMesh(i);
                            if (meshName[meshName.Length - 1] == 'B')//当前是近身模型
                                modelRender.SetLodMesh(i, meshName.Substring(0, meshName.Length - 1));
                        }
                    }
                    else
                    {
                        for (int i = 0; i < lodCount; i++)
                        {
                            string meshName = modelRender.GetLodMesh(i);
                            if (meshName[meshName.Length - 1] != 'B')//当前是远战模型
                                modelRender.SetLodMesh(i, meshName + "B");
                        }
                    }
                }
                break;
            case DPKeyType.SetFlag://阵营改变
                {
                    var nKey = newKey as DPKey_SetFlag;
                    modelRender.SetTexture(0, nKey.Flag == ArmyFlag.Attacker ? "t512_l" : "t512_r"); 
                }
                break;
        };

    }
    public float DirX { get { return m_DirX; } }

    public void SetAlpha(float v)//设置透明度
    {
        modelRender.SetAlpha(v);
        if(ShadowRenderer!=null) 
        {
            var color = ShadowRenderer.material.color;
            color.a = v;
            ShadowRenderer.material.color = color;
        }
    }

    public void SetBrightness(float v) { 
        modelRender.SetShaderParam("_Brightness", v); 
        if(EagleEyeLight!=null)
        {
            EagleEyeLight.SetActive(v>1);
        }
    }

    GameObject gameObject = null;
    MFAModelRender modelRender = null;
    Renderer ShadowRenderer = null;
    //ModleMaskColor maskColor;
    bool isColorMat;
    bool isHero;
    int m_actorID;
    int EagleEyeObjID = -1;//雷达中的对象ID
    GameObject EagleEyeLight = null;
    UIEagleEyeMap.ObjInfo EagleEyeObj = null;//雷达中的对象
    int EagleEyeArrowID = -1;//雷达中的箭头对象ID
    float m_LostTotalTime = 0;
    float m_LastUpdateTime = 0;
    int DepthOffset;
    float m_DirX = 0;
    //AvatarCM CmType;
    AvatarResources m_res;
}