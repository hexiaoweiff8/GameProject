﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class AI_CreateDP
{
    public static DPActor_Avatar CreateDP(
        AI_Battlefield battlefield, AIDirection dir, float birthTime,
        bool NeedPostMoveEvent,
        string meshPackName,
        //ModleMaskColor MaskColor,
        string texturePackName,
        byte FlogColorIndex, AvatarCM cmType,bool colorMat,
        bool IsHero,
        int DataID
        )
    {
        DPActor_Avatar tmpActor = new DPActor_Avatar(dir, IsHero, DataID,NeedPostMoveEvent,battlefield.NewDPID);

        tmpActor.BirthTime = birthTime;
        tmpActor.Res.MeshPackName = meshPackName;
        tmpActor.Res.TexturePackName = texturePackName;
        //tmpActor.Res.MaskColor = MaskColor;
        tmpActor.Res.FlogColorIndex = FlogColorIndex;
        tmpActor.Res.cmType = cmType;
        tmpActor.Res.colorMat = colorMat;
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);

        return tmpActor;
    }

    public static DPActor_SquareFlag CreateDP(AI_Battlefield battlefield,float birthTime,  byte FlogColorIndex)
    {
        var tmpActor = new DPActor_SquareFlag(FlogColorIndex, battlefield.NewDPID);

        tmpActor.BirthTime = birthTime; 
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);

        return tmpActor;
    }

    

    public static DPActor_Obj3D CreateDP(AI_Battlefield battlefield, float birthTime,string resName)
    {
        var tmpActor = new DPActor_Obj3D(resName, battlefield.NewDPID);
        tmpActor.BirthTime = birthTime;
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);
        return tmpActor;
    }

    

    public static DPActor_Effect CreateDP(
        AI_Battlefield battlefield,
        int AudioFxID,//效果ID
        float LiveTime,//生命
        bool NeedPostMoveEvent,
        float x,float y,float z,
        float dirx,float dirz, 
        float birthTime 
       )
    {
        if (dirx == dirz && dirx == 0)
            dirz = 0;

        DPActor_Effect tmpActor = new DPActor_Effect(AudioFxID, LiveTime, NeedPostMoveEvent, dirx, dirz, x, y, z, battlefield.NewDPID);

        tmpActor.BirthTime = birthTime; 
        battlefield.DPTimeLine.AddNotbornActor(tmpActor); 

        return tmpActor;
    }


    /*

    public static DPActor_GongJian CreateDP(
        AI_Battlefield battlefield,
        float x, float y, float z,
        bool IsDirRight,
        float birthTime,
        int gongJianID
       )
    {
        DPActor_GongJian tmpActor = new DPActor_GongJian(battlefield.NewDPID, IsDirRight, gongJianID, x, y, z ); 
        tmpActor.BirthTime = birthTime; 
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);

        return tmpActor;
    }*/

    /*
    class DPActor_GongJian : DPActor_Base
{
    public DPActor_GongJian(
        int id,
        bool IsDirRight,
        int gongJianID,//弓箭id
        float x, float y, float z//初始位置
        )
     */


    /// <summary>
    /// 创建头顶面板类型的演员
    /// </summary>
    public static DPActor_OverheadPanel CreateDP(
        AI_Battlefield battlefield, 
        float birthTime,
        float x,   float z, int DataID,short xj, byte Fid, int heroActorID, bool IsAttack
       )
    {
        DPActor_OverheadPanel tmpActor = new DPActor_OverheadPanel(x,   z, DataID,xj,Fid, heroActorID,IsAttack, battlefield.NewDPID);

        tmpActor.BirthTime = birthTime;
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);

        return tmpActor;
    }
     
    public static DPActor_World CreateDP( AI_Battlefield battlefield, float birthTime)
    {
        DPActor_World tmpActor = new DPActor_World( battlefield.NewDPID); 
        tmpActor.BirthTime = birthTime;
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);
        return tmpActor;
    }

    

    /// <summary>
    /// 创建脚下面板类型的演员
    /// </summary>
    public static DPActor_BelowPanel CreateDP(
        AI_Battlefield battlefield,
        float birthTime,
        int DataID, byte Fid, int heroActorID, bool IsAttack
       )
    {
        DPActor_BelowPanel tmpActor = new DPActor_BelowPanel(DataID, Fid,heroActorID, IsAttack, battlefield.NewDPID);

        tmpActor.BirthTime = birthTime;
        battlefield.DPTimeLine.AddNotbornActor(tmpActor);

        return tmpActor;
    }
    //
    /*
    /// <summary>
    /// 根据buff外观创建
    /// </summary>
    /// <param name="birthTime"></param>
    /// <param name="dir"></param>
    /// <param name="tx"></param>
    /// <param name="liveTime"></param>
    /// <returns></returns>
    public static DPActor_Buff CreateDP(float birthTime, AIDirection dir, BuffMathInfo tx, float liveTime)
    {
        DPActor_Buff tmpActor = new DPActor_Buff(
           dir,
           tx.AnimMode == TexiaoAnimMode.Scale,
           liveTime,
           tx.IsChuizhipian,
           tx.Blend
       );

        tmpActor.BirthTime = birthTime;
        tmpActor.Res = new FrameAnimationResources();
        tmpActor.Res.templatePackName = "scene_common";//模板所在包
        tmpActor.Res.templateName = "Animation_" + tx.AtcMB;//模板预置资源名
        tmpActor.Res.mbName = tx.AtcMB;
        tmpActor.Res.TexturePackName =//纹理所在包
        tmpActor.Res.textureName = string.Format("{0}{1:D3}", tx.AtcMB, tx.AtcID);//纹理名 

        tmpActor.offset_x = 0;
        tmpActor.offset_y = 0;
        tmpActor.offset_z = -tx.sort;
        tmpActor.scale = 1;

        DP_TimeLine.Single.AddNotbornActor(tmpActor);

        return tmpActor;
    }
    
    /// <summary>
    /// 根据Texiao数据创建
    /// </summary>
    /// <param name="birthTime"></param>
    /// <param name="dir"></param>
    /// <param name="tx"></param>
    /// <returns></returns>
    public static DPActor_Texiao CreateDP(float birthTime,AIDirection dir, TexiaoInfo tx)
    { 
        DPActor_Texiao tmpActor = new DPActor_Texiao(
            dir,
            tx.AnimMode== TexiaoAnimMode.Scale,
            tx.LiveTime,
            tx.IsChuizhipian,
            tx.Blend
        );    

        tmpActor.BirthTime = birthTime;
        tmpActor.Res = new FrameAnimationResources();
        tmpActor.Res.templatePackName = "scene_common";//模板所在包
        tmpActor.Res.templateName = "Animation_" + tx.AtcMB;//模板预置资源名
        tmpActor.Res.mbName = tx.AtcMB;
        tmpActor.Res.TexturePackName =//纹理所在包
        tmpActor.Res.textureName = string.Format("{0}{1:D3}", tx.AtcMB, tx.AtcID);//纹理名 

        tmpActor.offset_x = 0;
        tmpActor.offset_y = 0;
        tmpActor.offset_z = -tx.sort;
        tmpActor.scale = 1;

        DP_TimeLine.Single.AddNotbornActor(tmpActor);

        return tmpActor;
    } 
    */
}