using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public enum ModleMaskColor
{
    R = 1,//红色
    G = 2,//绿色
    B = 3,//蓝色
    N = 0,//无过滤色
}

/// <summary>
/// 组成角色的零件
/// </summary>
public enum AvatarCM
{
    Infantry_R = 0,//步兵
    InfantryHero_R=1,//步兵英雄
    Cavalry_R = 2,//骑兵死亡人物
    Cavalry_RH = 3,//骑兵人马合体
    CavalryHero_R = 4,//骑将死亡人物
    CavalryHero_RH = 5,//骑将人马合体
    Horse_H = 6,//马死亡
    Cavalry_Fenshi = 7,//骑兵分尸
    Infantry_Fenshi = 8,//步兵分尸
    Max = 9
}

/*
public struct YQ2Color3
{
    public byte R;
    public byte G;
    public byte B;
}*/
 
/// <summary>
/// 角色模型资源
/// </summary>
public struct AvatarResources
{
    public string MeshPackName;//网格所在包
    public string TexturePackName;//纹理所在包
    //public ModleMaskColor MaskColor;//掩码颜色
    public byte FlogColorIndex;//标志色索引
    public AvatarCM cmType;//组件类型
    public bool IsHero;//是否为一个英雄
    public int DataID;//数据ID
    public bool colorMat;//是否需要带半透的材质
    public bool NeedPostMoveEvent;
}

/// <summary>
/// 旗帜模型资源
/// </summary>
public struct SquareFlagResources
{ 
    public byte FlogColorIndex;//标志色索引  
}




/// <summary>
/// 3D物体资源
/// </summary>
public struct Obj3DResources
{
    /// <summary>
    /// 资源名
    /// </summary>
    public string ResName;
}


/// <summary>
/// 头顶面板资源
/// </summary>
public struct OverheadPanelResources
{
    //头顶面板坐标位置
    public float x,z;

    public int DataID;//英雄数据ID
    public byte Fid;//战场上阵位对应的id
    public bool IsAttack;//是否为进攻方
    public int HeroActorID;//英雄的精灵ID
    public short xj;//武将星级
}


/// <summary>
/// 脚下面板资源
/// </summary>
public struct BelowPanelResources
{
    public int DataID;//英雄数据ID
    public byte Fid;//战场上阵位对应的id
    public bool IsAttack;//是否为进攻方
    public int HeroActorID;//跟随的英雄ID
}



public struct EffectResources
{
    public bool NeedPostMoveEvent;
    public float dirx;
    public float dirz;
    public float x;
    public float y;
    public float z;
    public int AudioFxID;//效果ID
    public float LiveTime;//用新的生存时间替代配置的生存时间，大于0生效
   
}


public struct GongJianResources
{
    public int GongJianID;//弓箭id
    public bool IsDirRight;//是否朝向右边
    public float x, y,z;//出生坐标
}

/// <summary>
/// 帧动画资源
/// </summary>
public struct FrameAnimationResources
{
    public string mbName;//模板前缀名
    public string templatePackName;//模板所在包
    public string templateName;//模板预置资源名
    public string texturePackName;//纹理所在包
    public string textureName;//纹理名
 
}

public enum DPActorType
{
    World,//世界演员
    Avatar,//角色
    Effect,//特效 
    OverheadPanel,//头顶面板
    BelowPanel,//脚下面板
    //GongJian,//箭雨
    Obj3D,//3D物体
    SquareFlag,//阵旗帜
}

/// <summary>
/// 演示层 演员接口
/// </summary>
public class DPActor_Base
{
    public float BirthTime;//诞生时间
    public List<DP_Key> ActivatedKeys = new List<DP_Key>();//激活的帧

    public LinkList<DP_Key> m_IterationKeys = new LinkList<DP_Key>();//迭代帧队列 
    public LinkList<DP_Key>.Node m_ActivatedBack = null;//最后一个激活帧，用于方便后续检查更多的活动帧
     
    public float offset_x = 0;//偏移x
    public float offset_y = 0;//偏移y
    public float offset_z = 0;//偏移z
    public float scale = 1;//缩放
    public readonly int ID;

   public DPActor_Base(int id)
    {
        this.ID = id;
    }
    
    

    public float AddKey_Active(float startTime)
    {
        /*
         LinkList<DP_Key>.Node back = m_IterationKeys.Back;
         if (back != null && back.v.KeyType == DPKeyType.ActiveInstance)
         {
             throw new Exception("重复激活实例");
         }*/

        DPKey_ActiveInstance activeKey = new DPKey_ActiveInstance();
        activeKey.StartTime = startTime;
        AddKey(activeKey);
        return 0;
    }


    public float AddKey_Disable(float startTime, int actorID)
    {
        DPKey_DisableInstance nKey = new DPKey_DisableInstance();
        nKey.StartTime = startTime;
        nKey.actorID = actorID;
        AddKey(nKey);
        return 0;
    }


    public float AddKey_Enable(float startTime,int actorID,float x,float y,float z)
    {
        DPKey_EnableInstance nKey = new DPKey_EnableInstance();
        nKey.StartTime = startTime;
        nKey.actorID = actorID;
        nKey.x = x;
        nKey.y = y;
        nKey.z = z;
        AddKey(nKey);
        return 0;
    }


    
    

    public float AddKey_LianzhanChange(float startTime,int v)
    {
        DPKey_LianzhanChange nKey = new DPKey_LianzhanChange(startTime,v);
        AddKey(nKey);
        return 0;
    } 

    public float AddKey_PlayAct(float startTime, string clipName, bool loop, float waitTime, float dirx, float dirz,float speedScale = 1.0f)
    {
        DPKey_PlayAct Key = new DPKey_PlayAct(startTime, clipName, loop, waitTime, dirx, dirz, speedScale);
        AddKey(Key);
        return Key.len;
    }

    
    public float AddKey_CameraTrack(float startTime,bool isTrack)
    {
        DPKey_CameraTrack nKey = new DPKey_CameraTrack(startTime, isTrack);
        AddKey(nKey);
        return 0;
    }

    public float AddKey_SwapJinYuan(float startTime, bool isYuan)
    {
        var nKey = new DPKey_JinYuanSwap(startTime, isYuan);
        AddKey(nKey);
        return 0;
    }


    public float AddKey_SetFlag(float startTime, ArmyFlag flag)
    {
        var nKey = new DPKey_SetFlag(startTime, flag);
        AddKey(nKey);
        return 0;
    }

    
     
    public float AddKey_DestroyInstance(float startTime)
    {
        DPKey_DestroyInstance destroyKey = new DPKey_DestroyInstance();
        destroyKey.StartTime = startTime;
        AddKey(destroyKey);
        return 0;
    }


    public float AddKey_BuffIcon(float startTime,int bid,string icon)
    {
        DPKey_BuffIcon nKey = new DPKey_BuffIcon(startTime,bid,icon);
        AddKey(nKey);
        return 0;
    }
     
     
    public float AddKey_ScaleX(MakingUpFunc makingUpFunc, float startTime, float fromX, float toX, float time)
    {
        DPKey_ScaleX toXKey = new DPKey_ScaleX();
        toXKey.StartTime = startTime;
        toXKey.m_fromx = fromX;
        toXKey.m_tox = toX;
        toXKey.len = time;
        toXKey.makingUpFunc = makingUpFunc;
        AddKey(toXKey);
        return time;
    }

    public float AddKey_ScaleY(MakingUpFunc makingUpFunc, float startTime, float fromY, float toY, float time)
    {
        DPKey_ScaleY toXKey = new DPKey_ScaleY();
        toXKey.StartTime = startTime;
        toXKey.m_fromy = fromY;
        toXKey.m_toy = toY;
        toXKey.len = time;
        toXKey.makingUpFunc = makingUpFunc;
        AddKey(toXKey);
        return time;
    }

    public float AddKey_ScaleZ(MakingUpFunc makingUpFunc, float startTime, float fromZ, float toZ, float time)
    {
        DPKey_ScaleZ toXKey = new DPKey_ScaleZ();
        toXKey.StartTime = startTime;
        toXKey.m_fromz = fromZ;
        toXKey.m_toz = toZ;
        toXKey.len = time;
        toXKey.makingUpFunc = makingUpFunc;
        AddKey(toXKey);
        return time;
    }

    public float AddKey_OffsetToX(MakingUpFunc makingUpFunc, float startTime, float fromX, float toX, float time)
    {
        DPKey_OffsetToX toXKey = new DPKey_OffsetToX();
        toXKey.StartTime = startTime;
        toXKey.m_fromx = fromX;
        toXKey.m_tox = toX;
        toXKey.len = time;
        toXKey.makingUpFunc = makingUpFunc;
        AddKey(toXKey);
        return time;
    }

    public float AddKey_OffsetToY(MakingUpFunc makingUpFunc, float startTime, float fromY, float toY, float time)
    {
        DPKey_OffsetToY toYKey = new DPKey_OffsetToY();
        toYKey.StartTime = startTime;
        toYKey.m_fromy = fromY;
        toYKey.m_toy = toY;
        toYKey.len = time;
        toYKey.makingUpFunc = makingUpFunc;
        AddKey(toYKey);
        return time;
    }


    public float AddKey_OffsetToZ(MakingUpFunc makingUpFunc, float startTime, float fromZ, float toZ, float time)
    {
        DPKey_OffsetToZ toZKey = new DPKey_OffsetToZ();
        toZKey.StartTime = startTime;
        toZKey.m_fromz = fromZ;
        toZKey.m_toz = toZ;
        toZKey.len = time;
        toZKey.makingUpFunc = makingUpFunc;
        AddKey(toZKey);
        return time;
    }











    public float AddKey_ToX(MakingUpFunc makingUpFunc, float startTime, float fromX, float toX, float time)
    {
        DPKey_ToX toXKey = new DPKey_ToX();
        toXKey.StartTime = startTime;
        toXKey.m_fromx = fromX;
        toXKey.m_tox = toX;
        toXKey.len = time;
        toXKey.makingUpFunc = makingUpFunc;
        AddKey(toXKey);
        return time;
    }

    public float AddKey_ToY(MakingUpFunc makingUpFunc, float startTime, float fromY, float toY, float time)
    {
        DPKey_ToY toYKey = new DPKey_ToY();
        toYKey.StartTime = startTime;
        toYKey.m_fromy = fromY;
        toYKey.m_toy = toY;
        toYKey.len = time;
        toYKey.makingUpFunc = makingUpFunc;
        AddKey(toYKey);
        return time;
    }


    public float AddKey_ToZ(MakingUpFunc makingUpFunc, float startTime, float fromZ, float toZ, float time)
    {
        DPKey_ToZ toZKey = new DPKey_ToZ();
        toZKey.StartTime = startTime;
        toZKey.m_fromz = fromZ;
        toZKey.m_toz = toZ;
        toZKey.len = time;
        toZKey.makingUpFunc = makingUpFunc;
        AddKey(toZKey);
        return time;
    }



    public float AddKey_Reset(float startTime)
    {
        DPKey_Reset Key = new DPKey_Reset();
        Key.StartTime = startTime;
        Key.len = 0;
        AddKey(Key);
        return 0;
    }

    public float AddKey_RotZ(MakingUpFunc makingUpFunc, float startTime, float fromV, float toV, float time)
    {
        DPKey_RotZ Key = new DPKey_RotZ();
        Key.StartTime = startTime;
        Key.m_fromZ = fromV;
        Key.m_toZ = toV;
        Key.len = time;
        Key.makingUpFunc = makingUpFunc;
        AddKey(Key);
        return time;
    }

    public float AddKey_SetDir(float startTime,float dirX,float dirZ)
    {
        DPKey_SetDir Key = new DPKey_SetDir();
        Key.StartTime = startTime;
        Key.len = 0;
        Key.DirX = dirX;
        Key.DirZ = dirZ;
        AddKey(Key);
        return 0;
    }


    public float AddKey_SetNeedPostMoveEvent(float startTime, bool needPostMoveEvent)
    {
        var Key = new DPKey_SetNeedPostMoveEvent();
        Key.StartTime = startTime;
        Key.len = 0;
        Key.NeedPostMoveEvent = needPostMoveEvent; 
        AddKey(Key);
        return 0;
    }

    


    public float AddKey_BrightnessTo(MakingUpFunc makingUpFunc, float startTime, float fromV, float toV, float time)
    {
        DPKey_BrightnessTo Key = new DPKey_BrightnessTo();
        Key.StartTime = startTime;
        Key.m_from  = fromV;
        Key.m_to  = toV;
        Key.len = time;
        Key.makingUpFunc = makingUpFunc;
        AddKey(Key);
        return time;
    }

    public float AddKey_Alpha(MakingUpFunc makingUpFunc, float startTime, float fromV, float toV, float time)
    {
        DPKey_AlphaTo Key = new DPKey_AlphaTo();
        Key.StartTime = startTime;
        Key.m_fromAlpha = fromV;
        Key.m_toAlpha = toV;
        Key.len = time;
        Key.makingUpFunc = makingUpFunc;
        AddKey(Key);
        return time;
    }

    public float AddKey_CD(float startTime,float startBfb, float fullTime)
    {
        DPKey_CD key = new DPKey_CD(startTime, startBfb, fullTime);
        AddKey(key);
        return key.len;
    }

    public float AddKey_Yinchang(float startTime, float fullTime)
    {
        DPKey_Yinchang key = new DPKey_Yinchang(startTime, fullTime);
        AddKey(key);
        return key.len;
    }

       float AddKey_CutKeys(float startTime)
    {
        var key = new DPKey_CutKeys(startTime);
        AddKey(key);
        return key.len;
    }

    public float AddKey_PopupText(float startTime, string text, DPKey_PopupText.textType tp)
    {
        var key = new DPKey_PopupText(startTime, text, tp);
        AddKey(key);
        return key.len;
    }
    

    public float AddKey_ShoudongIcon(float startTime)
    {
        DPKey_ShoudongIcon key = new DPKey_ShoudongIcon(startTime);
        AddKey(key);
        return key.len;
    }

    public float AddKey_Wait(float startTime, float waitTime)
    {
        //尝试合并
        LinkList<DP_Key>.Node back = m_IterationKeys.Back;
        if (back != null && back.v.KeyType == DPKeyType.Wait)//上一帧是等待帧
        {
            DPKey_Wait key = back.v as DPKey_Wait;
            key.len += waitTime;
            return waitTime;
        }

        DPKey_Wait moveKey = new DPKey_Wait(startTime, waitTime);
        AddKey(moveKey);
        return moveKey.len;
    }

    public float AddKey_HPChange(float startTime, int hp,float hpBfb,bool isHeroHit)
    {
        DPKey_HPChange newKey = new DPKey_HPChange(startTime, hp, hpBfb, isHeroHit);
        AddKey(newKey);
        return newKey.len;
    }


    public float AddKey_ShowFightCountDown(float startTime, float durationTime, bool isRed)
    {
        var newKey = new DPKey_ShowFightCountDown(startTime, durationTime, isRed);
        AddKey(newKey);
        return newKey.len;
    }

    public float AddKey_FightEnd(float startTime, FightResult result)
    {
        var newKey = new DPKey_FightEnd(startTime, result);
        AddKey(newKey);
        return newKey.len;
    }

    public float AddKey_FightAIEnd(float startTime )
    {
        var newKey = new DPKey_FightAIEnd(startTime );
        AddKey(newKey);
        return newKey.len;
    }

    


    public float AddKey_SoldiersCountChange(float startTime, int num)
    {
        DPKey_SoldiersCountChange newKey = new DPKey_SoldiersCountChange(startTime, num);
        AddKey(newKey);
        return newKey.len;
    }

    public float AddKey_SetParent(float startTime, int parentID)
    {
        DPKey_SetParent newKey = new DPKey_SetParent(startTime, parentID);
        AddKey(newKey);
        return newKey.len;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="fromX"></param>
    /// <param name="fromY"></param>
    /// <param name="toX"></param>
    /// <param name="toY"></param>
    /// <returns>移动耗时</returns>
    public float AddKey_MoveTo(float startTime, float fromX, float fromZ, float toX, float toZ, float speed,out  float dirx,out float dirz)
    {
        //应用位置偏移属性
        fromX += offset_x;
        toX += offset_x;
        fromZ += offset_z;
        toZ += offset_z;

        dirx = toX - fromX;
        dirz = toZ - fromZ;

       
        AI_Math.NormaliseV2(ref dirx, ref dirz);

        //if (dirx == dirz && dirz == 0)
        //    dirz = 0;//QKDEBUG


        //尝试合并  
        LinkList<DP_Key>.Node back = m_IterationKeys.Back;
        if (back != null && back.v.KeyType == DPKeyType.MoveTo)//上一帧是移动帧
        {
            DPKey_MoveTo key = back.v as DPKey_MoveTo;
            if (key.m_speed == speed)//速度一致
            {
                //方向一致 
                if (Math.Equals(dirx, key.DirX) && Math.Equals(dirz, key.DirZ))
                {
                    key.m_tox = toX;
                    key.m_toz = toZ;
                    float oldLen = key.len;
                    key.len = key.CountLen();

                    return key.len - oldLen;
                }
            }
        } 

        DPKey_MoveTo moveKey = new DPKey_MoveTo(
                                                startTime,
                                                speed,
                                                fromX, fromZ,
                                                toX, toZ,
                                                dirx, dirz
                                                );
        AddKey(moveKey);
        return moveKey.len;
    }


    public void UpdateActiveKeys(float totalLostTime)
    {
        //指向帧迭代器
        if (m_ActivatedBack == null && m_IterationKeys.Front != null)
            m_ActivatedBack = m_IterationKeys.Front;

        //清除已经过期的
        while (ActivatedKeys.Count > 1)
        {
            List<DP_Key>.Enumerator it = ActivatedKeys.GetEnumerator();
            it.MoveNext();
            DP_Key currKey = it.Current;
            //&&currKey.CanDestroy 
            if (currKey.isCalld&& currKey.StartTime + currKey.len + 0.0001 < totalLostTime)
                ActivatedKeys.RemoveAt(0);
            else
                break;
        }

        //激活帧
        {
            LinkList<DP_Key>.Node pit = m_ActivatedBack;

            if (pit != m_IterationKeys.Front) pit = pit.next;

            while (pit != null)
            {
                if (pit.v.StartTime > totalLostTime) break;

                ActivatedKeys.Add(pit.v);//加入到活动队列
                m_ActivatedBack = pit;

                pit = pit.next;//指针移动
            }
         
        }
    }

    /// <summary>
    /// 移除启动时间超过指定时间的关键帧
    /// </summary>
    public void CutKyes(float EndTime)
    {
        //指向帧迭代器
        if (m_ActivatedBack == null && m_IterationKeys.Front != null)
            m_ActivatedBack = m_IterationKeys.Front;
 
         
        LinkList<DP_Key>.Node pit = m_ActivatedBack;

        if (pit != m_IterationKeys.Front) pit = pit.next;

        while (pit != null)
        {
            if (pit.v.StartTime >= EndTime)//关键帧启动时间超过了指定时间 
                pit = m_IterationKeys.RemoveNode(pit);//移除关键帧
            else
                pit = pit.next;//指针移动
        }

        //剪裁活动关键帧
        AddKey_CutKeys(EndTime);
    }

    public void AddKey(DP_Key nKey)
    { 
        var startTime = nKey.StartTime;
        var it = m_IterationKeys.Back;
        if(
            it != null&&
            startTime<it.v.StartTime
            )
        { 
            while(
                it.before!=null&&
                startTime<it.v.StartTime
                ) 
                it = it.before;

            if (startTime < it.v.StartTime)
                m_IterationKeys.Insert(it, nKey);
            else
                m_IterationKeys.Insert(it.next, nKey);
        }


        m_IterationKeys.PushBack(nKey); 
    }

    public DPActorType ActorType { get { return _ActorType; } }

    protected DPActorType _ActorType;
   
}

/// <summary>
/// 演示层 角色类型的演员
/// </summary>
public class DPActor_Avatar : DPActor_Base
{
    public DPActor_Avatar(
        AIDirection dir,bool IsHero,int DataID,
        bool NeedPostMoveEvent,
        int id):base(id)
    {
        _ActorType = DPActorType.Avatar;
        Res.IsHero = IsHero;
        Res.DataID = DataID;
        Res.NeedPostMoveEvent = NeedPostMoveEvent;
    }
    public AvatarResources Res = new AvatarResources();//资源  
}


/// <summary>
/// 演示层 阵旗帜类型的演员
/// </summary>
public class DPActor_SquareFlag : DPActor_Base
{
    public DPActor_SquareFlag(byte clolrIndex,  int id):base(id)
    {
        _ActorType = DPActorType.SquareFlag;
        Res.FlogColorIndex = clolrIndex;
    }
    public SquareFlagResources Res = new SquareFlagResources();//资源  
} 



/// <summary>
/// 演示层 角色类型的演员
/// </summary>
public class DPActor_Obj3D : DPActor_Base
{
    public DPActor_Obj3D(string resName,int id):base(id)
    {
        _ActorType = DPActorType.Obj3D;
        Res.ResName = resName;
    }
    public Obj3DResources Res = new Obj3DResources();//资源  
}
 

/// <summary>
/// 演示层 世界演员
/// </summary>
public class DPActor_World : DPActor_Base
{
    public DPActor_World(int id)
        : base(id)
    {
        _ActorType = DPActorType.World;
        
    }
}


/// <summary>
/// 演示层 头顶面板类型的演员
/// </summary>
public class DPActor_OverheadPanel : DPActor_Base
{
    public DPActor_OverheadPanel(float x,  float z,int DataID,short xj,  byte Fid,int heroActorID,  bool IsAttack,int id)
        : base(id)
    {
        _ActorType = DPActorType.OverheadPanel;
        Res.x = x; 
        Res.z = z;
        Res.DataID = DataID;
        Res.Fid = Fid;
        Res.IsAttack = IsAttack;
        Res.HeroActorID = heroActorID;
        Res.xj = xj;
    }
    public OverheadPanelResources Res = new OverheadPanelResources();//资源  
}

/// <summary>
/// 演示层 脚下面板类型的演员
/// </summary>
public class DPActor_BelowPanel: DPActor_Base
{
    public DPActor_BelowPanel(int DataID, byte Fid, int heroActorID, bool IsAttack, int id)
        : base(id)
    {
        _ActorType = DPActorType.BelowPanel; 
        Res.DataID = DataID;
        Res.Fid = Fid;
        Res.IsAttack = IsAttack;
        Res.HeroActorID = heroActorID;
    }
    public BelowPanelResources Res = new BelowPanelResources();//资源  
}

/// <summary>
/// 演示层 特效类型的演员
/// </summary>
public class DPActor_Effect : DPActor_Base
{
    public DPActor_Effect( 
        int AudioFxID,//效果ID
        float LiveTime,//生命
        bool NeedPostMoveEvent,
        float dirx,
        float dirz,
        float x, float y, float z//初始位置
        , int id)
        : base(id)
    {    
        _ActorType = DPActorType.Effect;
        Res.dirx = dirx;
        Res.dirz = dirz;
        Res.x = x;
        Res.y = y;
        Res.z = z;
        Res.AudioFxID = AudioFxID;
        Res.LiveTime = LiveTime;
        Res.NeedPostMoveEvent = NeedPostMoveEvent;
    }
    public EffectResources Res = new EffectResources();//资源  
}

/*
public class DPActor_GongJian : DPActor_Base
{
    public DPActor_GongJian(
        int id,
        bool IsDirRight,
        int gongJianID,//弓箭id
        float x, float y, float z//初始位置
        )
        : base(id)
    {
        _ActorType = DPActorType.GongJian;
        Res.IsDirRight = IsDirRight;
        Res.x = x;
        Res.y = y;
        Res.z = z;
        Res.GongJianID = gongJianID;
    }
    public GongJianResources Res = new GongJianResources();//资源  
}
*/

/*

/// <summary>
/// 演示层 特效类型的演员
/// </summary>
public class DPActor_Texiao : DPActor_Avatar
{
    public DPActor_Texiao(
        AIDirection dir, //朝向
        bool scaleAnimation,//是否缩放动画帧
        float liveTime,//生命
        bool IsChuizhipian,//是否垂直片
        TexiaoBlend blend//混色模式
        ):base(dir)
    {
        _ActorType = DPActorType.Texiao; 
        this.scaleAnimation = scaleAnimation;
        this.liveTime = liveTime;
        this.IsChuizhipian = IsChuizhipian;
        this.blend = blend;
    } 
    public bool scaleAnimation;//是否缩放动画帧
    public float liveTime;//特效生存时间，用于计算动画帧缩放用
    public bool IsChuizhipian;//是否垂直片
    public TexiaoBlend blend;//混色模式
}

/// <summary>
/// 演示层 Buff类型的演员
/// </summary>
public class DPActor_Buff : DPActor_Texiao
{
    public DPActor_Buff(
        AIDirection dir, //朝向
        bool scaleAnimation,//是否缩放动画帧
        float liveTime,//生命
        bool IsChuizhipian,//是否垂直片
        TexiaoBlend blend//混色模式
        )  : base( dir,//朝向
         scaleAnimation,//是否缩放动画帧
         liveTime,//生命
         IsChuizhipian,//是否垂直片
         blend//混色模式
        )
    {
        _ActorType = DPActorType.Buff; 
    } 
}


*/
   

