using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 战斗预置管理
/// </summary>
public class DP_FightPrefabManage
{

    static int m_AvatarLayer;

    static Dictionary<string, GameObject> Object3D_Prefabs = new Dictionary<string, GameObject>();//3D物体预置
    static Material Avatar_ColorMat_N;//角色渲染材质 带透明和颜色
    static Material Avatar_Mats_N;//角色渲染材质

    public static void Init()
    {
        GameObject Prefabs = GameObject.Find("/Prefabs");
        //Infantry 步兵 Cavalry 骑兵
        //var scene_mainPacket = PacketManage.Single.GetPacket("scene_main");
        //scene_mainPacket.Load("spotlight") as GameObject
        Object3D_Prefabs.Add("spotlight", null);



        PacketRouting pk = PacketManage.Single.GetPacket("core");
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
    ///// <summary>
    ///// 创建模型 沿用重构以前的名字 为了兼容lua里现成的调用
    ///// </summary>
    ///// <param name="param"></param>
    ///// <returns></returns>
    //public static GameObject InstantiateAvatar(CreateActorParam param)
    //{
        
    //    var config = SData_armybase_c.Single.GetDataOfID(param.SoldierID);
    //    var modelname = config.Prefab + "@model";
    //    GameObject obj = GameObjectExtension.InstantiateFromPacket(config.Pack, modelname, null);
    //    //var render = obj.AddComponent<MFAModelRender>();
    //    //render.MeshPackName = param.MeshPackName;//包名
    //    //render.TexturePackName = config.Texture;

    //    //GameObject head = new GameObject();
    //    //head.transform.parent = obj.transform;
    //    //head.name = "head";
    //    //head.transform.position = new Vector3(0,22,0);
    //    //head.transform.localScale = Vector3.one;

    //    //modelRender.flagColor = ColorTab[FlagColorIdx];//标志色
    //    //GameObject obj = GameObjectExtension.InstantiateFromPacket("jidi", "zhujidi_model", null);
 
    //    return obj;
    //}

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

} 
