﻿using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 战斗预置管理
/// </summary>
public class DP_FightPrefabManage
{
    public static void Init()
    {
        GameObject Prefabs = GameObject.Find("/Prefabs");
        //Infantry 步兵 Cavalry 骑兵
        Avatar_Prefabs = new GameObject[(int)AvatarCM.Max];
        Avatar_Prefabs[(int)AvatarCM.Cavalry_R] = Prefabs.transform.FindChild("Cavalry_R").gameObject;
        Avatar_Prefabs[(int)AvatarCM.Cavalry_RH] = Prefabs.transform.FindChild("Cavalry_RH").gameObject;
        Avatar_Prefabs[(int)AvatarCM.InfantryHero_R] = Prefabs.transform.FindChild("InfantryHero_R").gameObject;
        Avatar_Prefabs[(int)AvatarCM.Infantry_R] = Prefabs.transform.FindChild("Infantry_R").gameObject; 
        Avatar_Prefabs[(int)AvatarCM.CavalryHero_R] = Prefabs.transform.FindChild("CavalryHero_R").gameObject; 
        Avatar_Prefabs[(int)AvatarCM.CavalryHero_RH] = Prefabs.transform.FindChild("CavalryHero_RH").gameObject; 
        Avatar_Prefabs[(int)AvatarCM.Horse_H] = Prefabs.transform.FindChild("Horse_H").gameObject;
        Avatar_Prefabs[(int)AvatarCM.Cavalry_Fenshi] = Prefabs.transform.FindChild("Cavalry_Fenshi").gameObject; 
        Avatar_Prefabs[(int)AvatarCM.Infantry_Fenshi] = Prefabs.transform.FindChild("Infantry_Fenshi").gameObject;

        //var scene_mainPacket = PacketManage.Single.GetPacket("scene_main");
        //scene_mainPacket.Load("spotlight") as GameObject
        Object3D_Prefabs.Add("spotlight",
            null
            
            );



        PacketRouting pk = PacketManage.Single.GetPacket("core");
        /*
        Avatar_Mats = new Material[4];//角色渲染材质
        Avatar_Mats[(int)ModleMaskColor.B] = pk.Load("Avatar_B.mat") as Material;
        Avatar_Mats[(int)ModleMaskColor.G] = pk.Load("Avatar_G.mat") as Material;
        Avatar_Mats[(int)ModleMaskColor.R] = pk.Load("Avatar_R.mat") as Material;
        Avatar_Mats[(int)ModleMaskColor.N] = pk.Load("Avatar_N.mat") as Material;


        Avatar_ColorMats = new Material[4];//角色渲染材质
        Avatar_ColorMats[(int)ModleMaskColor.B] = pk.Load("Avatar_B_Color.mat") as Material;
        Avatar_ColorMats[(int)ModleMaskColor.G] = pk.Load("Avatar_G_Color.mat") as Material;
        Avatar_ColorMats[(int)ModleMaskColor.R] = pk.Load("Avatar_R_Color.mat") as Material;
        Avatar_ColorMats[(int)ModleMaskColor.N] = pk.Load("Avatar_N_Color.mat") as Material;
        */
        Avatar_ColorMat_N = pk.Load("Avatar_N_Color.mat") as Material;
        Avatar_Mats_N = pk.Load("Avatar_N.mat") as Material;
        
        m_AvatarLayer = LayerMask.NameToLayer("Avatar");

        //绑定主场景事件
        DP_BattlefieldDraw.Single.BindMainSceneEvent();
    }


    
    /// <summary>
    /// 实例化3D游戏物体
    /// </summary>
    public static GameObject InstantiateObject3D(string name)
    {
        return GameObject.Instantiate(Object3D_Prefabs[name]);
    }

    public static void ReLoad3DObjects()
    {
        //var scene_mainPacket = PacketManage.Single.GetPacket("scene_main");
        //scene_mainPacket.Load("spotlight") as GameObject
        Object3D_Prefabs["spotlight"] = PacketManage.Single.GetPacket("spotlight").Load("spotlight") as GameObject;

    }

    /// <summary>
    /// 实例化角色对象
    /// </summary>
    /// <param name="cmType"></param>
    /// <param name="maskColor"></param>
    /// <param name="flagColorIdx"></param>
    /// <returns></returns>
    public static GameObject InstantiateAvatar(
        CreateActorParam param
        )
    {
        //实例化游戏物体 
        GameObject preObj = Avatar_Prefabs[(int)param.CmType]; 
        GameObject reObj = GameObject.Instantiate(preObj);

        //设置材质
        Material preMat = param.ColorMat ? Avatar_ColorMat_N : Avatar_Mats_N;//ColorMat?Avatar_ColorMats[(int)maskColor]:Avatar_Mats[(int)maskColor];
        reObj.GetComponent<Renderer>().material = preMat;

        //设置模型渲染组件
        var modelRender = reObj.GetComponent<MFAModelRender>();
        modelRender.MeshPackName = param.MeshPackName;//包名
        modelRender.TexturePackName = param.TexturePackName;
        //modelRender.flagColor = ColorTab[FlagColorIdx];//标志色

        //检查512级别的纹理是否存在，如果不存在则替换成256
        /*
        PacketRouting pack = PacketManage.Single.GetPacket(packName);
        Object t512 = pack.Load("t512");
        if(t512==null)
        {
            YQ2LodMesh[] lods = reObj.GetComponents<YQ2LodMesh>();
            int len = lods.Length;
            for(int i=0;i<len;i++)
            {
                if (lods[i].TextureName == "t512")
                    lods[i].TextureName = "t256";
            }
        }*/
        if (param.CmType == AvatarCM.Horse_H)
        {
            if(param.IsHero)//英雄的马纹理
                SetModelTexture(reObj, "t1024");
            else
                if(param.FlagColorIdx ==1)
                       SetModelTexture(reObj,"t512_r");
        } else  if(!param.IsHero && param.FlagColorIdx ==1) 
            SetModelTexture(reObj,"t512_r");
        return reObj;
    }


    //
    static void SetModelTexture(GameObject obj,string textureName)
    {
        MFALodMesh[] lods = obj.GetComponents<MFALodMesh>();
        int len = lods.Length;
        for (int i = 0; i < len; i++)
        {
            lods[i].TextureName = textureName;
        }
    }

    public static Material CreateMat(
        //ModleMaskColor maskColor,
        bool colorMat)
    {
        //Material preMat = 
         // return  ColorMat?Avatar_ColorMats[(int)maskColor]:Avatar_Mats[(int)maskColor];
        return colorMat ? Avatar_ColorMat_N  : Avatar_Mats_N ;
       // return Material.Instantiate(preMat);
    }

    

    public static Color32[] ColorTab = new Color32[]{
        new Color32(0,255,0,255),//进攻方
        new Color32(255,0,0,255),//防御方
    };

    static int m_AvatarLayer;

    static GameObject[] Avatar_Prefabs;
    static Dictionary<string,GameObject> Object3D_Prefabs = new Dictionary<string,GameObject>();//3D物体预置
    //static Material[] Avatar_Mats;//角色渲染材质
    //static Material[] Avatar_ColorMats;//角色渲染材质 带透明和颜色
    static Material Avatar_ColorMat_N;//角色渲染材质 带透明和颜色
    static Material Avatar_Mats_N;//角色渲染材质
} 
