using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public enum DPKeyType
{
    ActiveInstance = 1,//激活实例
    DestroyInstance = 2,//销毁实例
    Wait = 3,//原地等待
    HPChange = 4,//生命改变
    MoveTo = 5,
    OffsetToX =6,
    OffsetToY=7,
    OffsetToZ=8,
    SetParent=9,//设置父物体
    SoldiersCountChange=10,//士兵数量改变
    ToX=11,
    ToY=12,
    ToZ=13,
    PlayAct=14,//播放动画剪辑
    ScaleX=15,
    ScaleY=16,
    ScaleZ=17,
    Alpha=18,
    RotZ=19,//绕Z旋转
    CD=20,//cd增长
    ShoudongIcon=21,//手动技能激活
    Yinchang=22,//吟唱条增长
    BuffIcon=23,
    CameraTrack = 24,
    JinYuanSwap = 25,
    CutKeys = 26,//对活动关键帧进行剪裁
    ShowFightCountDown = 27,//显示战斗倒计时
    FightEnd = 28,//战斗结束
    SetFlag = 29,//设置阵营
    LianzhanChange= 30,//连斩变化
    //SceneBrightnessTo = 31,//场景亮度
    Brightness = 32,//演员亮度
    DisableInstance = 33,//禁用实例
    EnableInstance = 34,//启用实例
    PopupText = 35,//弹出文本
    SetDir = 36,//设定朝向
    SetNeedPostMoveEvent = 37,//设置是否需要抛出移动事件
    FightAIEnd = 38,//战斗AI已经结束工作
    Reset = 39,//重置
}

public abstract class DP_Key
{
    public float len = 0;
    public float StartTime;
    
    public bool isCalld = false;

    public abstract DPKeyType KeyType { get; }

    /// <summary>
    /// 对关键帧进行剪裁
    /// </summary>
    /// <param name="endTime">剪裁到该时间</param>
    public abstract void Cut(float endTime);


    public static void Cut(float endTime, float StartTime, ref float len, MakingUpFunc makingUpFunc, float fromV, ref float toV)
    { 
        float newLen = endTime - StartTime;
        if (newLen < 0)
            newLen = 0;//新的结束时间小于了起始时间，保留起点位置
        else if (newLen > len)
            return;//新的结束时间比原本结束时间还要长，无需剪裁

        if (newLen == 0)
            toV = fromV;
        else
        {
            float t = newLen / len;
            switch (makingUpFunc)
            {
                case MakingUpFunc.Linear:
                    toV = DP_TweenFuncs.Tween_Linear_Float(fromV, toV, t);
                    break;
                case MakingUpFunc.Acceleration:
                    toV = DP_TweenFuncs.Tween_Accelerated_Float(fromV, toV, t);
                    break;
                default:
                    toV = DP_TweenFuncs.Tween_Deceleration_Float(fromV, toV, t);
                    break;
            }
        }

        len = newLen; 

    }
} 

/// <summary>
/// 激活实例
/// </summary>
public class DPKey_ActiveInstance : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ActiveInstance; } }

    public override void Cut(float endTime) { }
}



/// <summary>
/// 禁用实例
/// </summary>
public class DPKey_DisableInstance : DP_Key
{
    public int actorID;

    public override DPKeyType KeyType { get { return DPKeyType.DisableInstance; } }

    public override void Cut(float endTime) { }
}



/// <summary>
/// 启用实例 由世界对象执行
/// </summary>
public class DPKey_EnableInstance : DP_Key
{
    public int actorID;
    public override DPKeyType KeyType { get { return DPKeyType.EnableInstance; } }

    public override void Cut(float endTime) { }

    public float x;
    public float y;
    public float z;
}


public class DPKey_CutKeys : DP_Key
{
    public DPKey_CutKeys(float startTime)
    {
        this.StartTime = startTime;
    }
    public override DPKeyType KeyType { get { return DPKeyType.CutKeys; } }

    public override void Cut(float endTime) { }
}


public class DPKey_PopupText:DP_Key
{
    public enum textType
    {
        None = 0,
        Shoudong = 1,
        Texing = 2,
        Bisha = 3,
    }
    public DPKey_PopupText(float startTime,string text,textType tp)
    {
        this.StartTime = startTime;
        this.text = text;
        this.txtType = tp;
    }

    public override DPKeyType KeyType { get { return DPKeyType.PopupText; } }

    public override void Cut(float endTime) { }

    public string text;
    public textType txtType;
}

/// <summary>
/// 战斗结果
/// </summary>
public class FightResult
{
    public bool IsWin;//左军是否胜利
    public float FightTime;//战斗时间
    public List<HeroFightResult> LeftHeros = new List<HeroFightResult>();//左军信息
    public List<HeroFightResult> RightHeros = new List<HeroFightResult>();//右军信息
}

public class HeroFightResult
{ 
    public short fid;//阵位编号
    public int staticDataID;//英雄静态数据ID
    public int HitCount;//总伤害
    public int NursedCount;//总治疗
    public int KillSoldiersCount;//总杀兵数
    public int currHP;//当前血量
    public int heroLevel;//英雄等级
    public int heroXJ;//英雄星级
    public int MaxHP;//最大血量
    public int AliveSoldiers;//剩余士兵数
}
 

public class DPKey_FightEnd : DP_Key
{
    public DPKey_FightEnd(float startTime, FightResult result)
    {
        this.StartTime = startTime;
        this.Result = result;
    }
    public override DPKeyType KeyType { get { return DPKeyType.FightEnd; } }

    public override void Cut(float endTime) { }

    public readonly FightResult Result;
}


public class DPKey_FightAIEnd : DP_Key
{
    public DPKey_FightAIEnd(float startTime )
    {
        this.StartTime = startTime; 
    }
    public override DPKeyType KeyType { get { return DPKeyType.FightAIEnd; } }

    public override void Cut(float endTime) { }
}



public class DPKey_ShowFightCountDown : DP_Key
{
    public DPKey_ShowFightCountDown(float startTime, float durationTime, bool isRed)
    {
        this.StartTime = startTime;
        DurationTime = durationTime;
        IsRed = isRed;
    }
    public override DPKeyType KeyType { get { return DPKeyType.ShowFightCountDown; } }

    public override void Cut(float endTime) { }

    public readonly float DurationTime;
    public readonly bool IsRed;
}


public class DPKey_SetParent : DP_Key
{
    public DPKey_SetParent(float startTime, int parentID)
    {
        StartTime = startTime;
        this.ParentID = parentID; 
    }
    public override DPKeyType KeyType { get { return DPKeyType.SetParent; } }
     
    public readonly int ParentID;//父物体id

    public override void Cut(float endTime) { }
} 


public class DPKey_Wait : DP_Key
{
    public DPKey_Wait(float startTime,float waitTime)
    {
        StartTime = startTime;
        len = waitTime;
    }
     
    public override DPKeyType KeyType { get { return DPKeyType.Wait; } }
    public override void Cut(float endTime) { }
     
}


public class DPKey_CD : DP_Key
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="startTime"></param>
    /// <param name="startBfb">开始百分比</param>
    /// <param name="fullTime">CD满还需要多少秒</param>
    public DPKey_CD(float startTime,float startBfb, float fullTime)
    {
        StartTime = startTime;
        len = fullTime;
        StartBfb = startBfb;
    }

    public override DPKeyType KeyType { get { return DPKeyType.CD; } }

    public override void Cut(float endTime) { }
 
    public float StartBfb;
}




public class DPKey_Yinchang : DP_Key
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="startTime"></param> 
    /// <param name="fullTime">吟唱满还需要多少秒，如果小于等于0表示立即隐藏吟唱条 </param>
    public DPKey_Yinchang(float startTime,  float fullTime)
    {
        StartTime = startTime;
        len = fullTime; 
    }

    public override DPKeyType KeyType { get { return DPKeyType.Yinchang; } }

    public override void Cut(float endTime) { }
}



public class DPKey_ShoudongIcon : DP_Key
{ 
    public DPKey_ShoudongIcon(float startTime)
    {
        StartTime = startTime;
        len = 0.1f;
    }
     
    public override DPKeyType KeyType { get { return DPKeyType.ShoudongIcon; } }

    public override void Cut(float endTime) { }
     
}



/// <summary>
/// buff图标显隐，icon为空串表示隐藏
/// </summary>
public class DPKey_BuffIcon : DP_Key
{
    public DPKey_BuffIcon(float startTime,int bid, string icon)
    {
        StartTime = startTime;
        len = 0.1f;
        this.bid = bid;
        this.icon = icon;
    }
     
    public override DPKeyType KeyType { get { return DPKeyType.BuffIcon; } }

 

    public readonly int bid;//图标编号
    public readonly string icon;//图标 
    public override void Cut(float endTime) { }
}


public class DPKey_CameraTrack: DP_Key
{
    public DPKey_CameraTrack(float startTime,bool isTrack)
    {
        StartTime = startTime;
        len = 0.1f;
        this.IsTrack = isTrack;
    }

    public override DPKeyType KeyType { get { return DPKeyType.CameraTrack; } }
     
    public bool IsTrack;
    public override void Cut(float endTime) { }
}



public class DPKey_JinYuanSwap : DP_Key
{
    public DPKey_JinYuanSwap(float startTime, bool isYuan)
    {
        StartTime = startTime;
        len = 0.1f;
        this.IsYuan = isYuan;
    }


    public override DPKeyType KeyType { get { return DPKeyType.JinYuanSwap; } }

 
    public bool IsYuan;
    public override void Cut(float endTime) { }
}


/// <summary>
/// 设置阵营
/// </summary>
public class DPKey_SetFlag:DP_Key
{
    public DPKey_SetFlag(float startTime, ArmyFlag flag)
    {
        StartTime = startTime;
        len = 0.1f;
        this.Flag = flag;
    }


    public override DPKeyType KeyType { get { return DPKeyType.SetFlag; } }


    public ArmyFlag Flag;
    public override void Cut(float endTime) { }
}

public class DPKey_HPChange : DP_Key
{
    public DPKey_HPChange(float startTime, int hp, float hpBfb, bool isHeroHit)
    {
        StartTime = startTime;
        len = 0.1f;
        this.lostHP = hp;
        this.hpBfb = hpBfb;
        this.isHeroHit = isHeroHit;
    }

    public override DPKeyType KeyType { get { return DPKeyType.HPChange; } } 

    public readonly int lostHP;//血增量
    public readonly float hpBfb;//剩余血量百分比 
    public readonly bool isHeroHit;//是否为英雄发出的攻击
    public override void Cut(float endTime) { }
}


public class DPKey_LianzhanChange : DP_Key
{
    public DPKey_LianzhanChange(float startTime, int lianzhanCount)
    {
        StartTime = startTime;
        len = 0.1f;
        this.lianzhanCount = lianzhanCount; 
    }

    public override DPKeyType KeyType { get { return DPKeyType.LianzhanChange; } }

    public readonly int lianzhanCount;//连斩数
    public override void Cut(float endTime) { }
}



public class DPKey_SoldiersCountChange : DP_Key
{
    public DPKey_SoldiersCountChange(float startTime, int num)
    {
        StartTime = startTime;
        len = 0.1f;
        this.num = num; 
    }

    public override DPKeyType KeyType { get { return DPKeyType.SoldiersCountChange; } } 
    public readonly int num;//新的士兵数量   
    public override void Cut(float endTime) { }
}

 

/// <summary>
/// 播放动画剪辑
/// </summary>
public class DPKey_PlayAct : DP_Key
{
    public DPKey_PlayAct(float startTime, string clipName, bool loop, float waitTime, float dirx, float dirz, float speedScale = 1)
    {
        StartTime = startTime;
        len = waitTime;
        this.clipName = clipName;
        this.loop = loop;
        this.dirx = dirx;
        this.dirz = dirz;
        this.speedScale = speedScale;
    }

    public override DPKeyType KeyType { get { return DPKeyType.PlayAct; } }

  
    public readonly string clipName;
    public readonly bool loop;

    //朝向
    public readonly float dirx;
    public readonly float dirz;

    public readonly float speedScale;//速度缩放
    public override void Cut(float endTime) { }
}

public class DPKey_DestroyInstance : DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.DestroyInstance; } }
    public override void Cut(float endTime) { }
}


/// <summary>
/// 移动到,速度优先
/// </summary>
public class DPKey_MoveTo : DP_Key
{

    public DPKey_MoveTo(float startTime,float speed,float fromX,float fromZ,float toX,float toZ,float dirX,float dirZ)
    {
        StartTime = startTime;
        m_speed = speed;
        m_tox = toX;
        m_toz = toZ;
        m_fromx = fromX;
        m_fromz = fromZ;
        this.len = CountLen();

        DirX = dirX;
        DirZ = dirZ; 
    } 
    public float CountLen()
    { 
            float czx = m_fromx - m_tox;
            float czz = m_fromz - m_toz;
            return (float)Math.Sqrt(czx * czx + czz * czz) / m_speed; 
    }

    public override void Cut(float endTime)
    {
        float newLen = endTime - StartTime;
        if (newLen < 0)
            newLen = 0;//新的结束时间小于了起始时间，保留起点位置
        else if (newLen > len)
            return;//新的结束时间比原本结束时间还要长，无需剪裁

        //应用新的终点位置和新的移动耗时
        m_tox = m_fromx + DirX * newLen;
        m_toz = m_fromz + DirZ * newLen;
        len = newLen;
    }

    public override DPKeyType KeyType { get { return DPKeyType.MoveTo; } }

    public float m_speed;//移动速度 
    public float m_tox;//目的位置x
    public float m_toz;//目的位置y
    public float m_fromx;//起始位置x
    public float m_fromz;//起始位置z
   
    public readonly float DirX;//归一化后的朝向x
    public readonly float DirZ;//归一化后的朝向z
}


/// <summary>
/// x移动到，时间优先
/// </summary>
public class DPKey_OffsetToX : DP_Key
{  
    public override DPKeyType KeyType { get { return DPKeyType.OffsetToX; } }

    public override void Cut(float endTime)
    { 

        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromx, ref   m_tox);
    }
     
    public float m_tox;//目的位置x 
    public float m_fromx;//起始位置x 
 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}

/// <summary>
/// y移动到，时间优先
/// </summary>
public class DPKey_OffsetToY : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.OffsetToY; } }

    public override void Cut(float endTime)
    { 

        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromy, ref   m_toy);
    }
    public float m_toy;//目的位置 
    public float m_fromy;//起始位置  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}

/// <summary>
/// z移动到，时间优先
/// </summary>
public class DPKey_OffsetToZ : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.OffsetToZ; } }

    public override void Cut(float endTime)
    { 

        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromz, ref   m_toz);
    }

    public float m_toz;//目的位置
    public float m_fromz;//起始位置  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
} 



/// <summary>
/// x缩放到，时间优先
/// </summary>
public class DPKey_ScaleX : DP_Key
{

    public override DPKeyType KeyType { get { return DPKeyType.ScaleX; } }

    public override void Cut(float endTime)
    { 

        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromx, ref   m_tox);
    }
     
    public float m_tox;//目的位置x 
    public float m_fromx;//起始位置x  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}



/// <summary>
/// x缩放到，时间优先
/// </summary>
public class DPKey_ScaleY : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ScaleY; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromy, ref   m_toy);
         
    }
     
     
    public float m_toy;
    public float m_fromy; 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}



/// <summary>
/// x缩放到，时间优先
/// </summary>
public class DPKey_ScaleZ : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ScaleZ; } }

    public override void Cut(float endTime)
    { 

        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromz, ref   m_toz);
    }
     
    public float m_toz; 
    public float m_fromz;  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}



/// <summary>
/// 透明度，时间优先
/// </summary>
public class DPKey_AlphaTo : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.Alpha; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromAlpha, ref   m_toAlpha);
    }

    public float m_fromAlpha;
    public float m_toAlpha;//目的 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}

 
public class DPKey_BrightnessTo : DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.Brightness; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_from, ref   m_to);
    }

    public float m_from ;
    public float m_to ;//目的 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}



/*
public class DPKey_SceneBrightnessTo : DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.SceneBrightnessTo; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_from, ref   m_to);
    }

    public float m_from;
    public float m_to;//目的 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}*/

public class DPKey_Reset:DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.Reset; } }

    public override void Cut(float endTime)  {  } 
}

public class DPKey_RotZ : DP_Key
{

    public override DPKeyType KeyType { get { return DPKeyType.RotZ; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromZ, ref   m_toZ);
    }


    public float m_fromZ;
    public float m_toZ;//目的 
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}


public class DPKey_SetDir:DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.SetDir; } }

    public override void Cut(float endTime)
    { 
    }


    public float DirX;
    public float DirZ;
}

public class DPKey_SetNeedPostMoveEvent:DP_Key
{
    public override DPKeyType KeyType { get { return DPKeyType.SetNeedPostMoveEvent; } }

    public override void Cut(float endTime)
    {
    }


    public bool NeedPostMoveEvent; 
}



/// <summary>
/// x移动到，时间优先
/// </summary>
public class DPKey_ToX : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ToX; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromx, ref   m_tox);
    }


    public float m_tox;//目的位置x 
    public float m_fromx;//起始位置x  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}

/// <summary>
/// y移动到，时间优先
/// </summary>
public class DPKey_ToY : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ToY; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromy, ref   m_toy);
    }


    public float m_toy;//目的位置 
    public float m_fromy;//起始位置  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}

public class DPKey_ToZ : DP_Key
{ 
    public override DPKeyType KeyType { get { return DPKeyType.ToZ; } }

    public override void Cut(float endTime)
    {
        Cut(endTime, StartTime, ref   len, makingUpFunc, m_fromz, ref   m_toz);
    }


    public float m_toz;//目的位置
    public float m_fromz;//起始位置  
    public MakingUpFunc makingUpFunc = MakingUpFunc.Linear;
}
