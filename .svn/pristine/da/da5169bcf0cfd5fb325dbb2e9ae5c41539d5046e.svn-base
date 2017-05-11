using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 飞行到格子
/// </summary>
public class AI_EffectTrack_FlyToGrid : AI_EffectTrack
{

    public override void Update(float lostTime)
    {
        float lastCurrTime = CurrTime;//记录增加时间前的当前时间
        base.AddTime(lostTime);
        ReduceAllTime();

        //飞行过程中造成伤害
        if (m_FlyTrackHit != null && CurrTime - m_BirthTime >= StartYanchi)
        {
            float t = CurrTime - m_BirthTime - StartYanchi;

            var posx = DP_TweenFuncs.Tween_Linear_Float(fromWorldX, toWorldX, t);
            var posz = DP_TweenFuncs.Tween_Linear_Float(fromWorldZ, toWorldZ, t);

            m_FlyTrackHit.MoveTo(posx, posz, (unit) => Hit(unit, true));
        }


        if (NeedHit)
        {
            DoHitEnd = true;

            //检查目标格是否有防御者
            Defender = DefenderGrid.Obj;

            if (Defender != null &&
                !(m_FlyTrackHit != null && m_FlyTrackHit.InHitList(Defender)
                )
                )
            {
                m_LiveTime = m_HitTime; //打中了，调整生命时间
                Hit(Defender, false);
            } 
        }


        if (!Valid)
        {
            //缓存效果对象
            if (FlyObj != null)
            {
                this.Attack.OwnerBattlefield.AudioFXCache.Cache(FlyObj);
                FlyObj = null;
            }
           
        }
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="unit"></param>
    /// <param name="dx"></param>
    /// <param name="dz"></param>
    /// <param name="isFlyTrackHit">是否是被飞行轨迹所伤</param>
    void Hit(AI_FightUnit unit, bool isFlyTrackHit)
    {
        if (unit.IsDie) return;

        if (
            Attack.OwnerBattlefield.FightST >= FightST.FightEnd||
            (isFlyTrackHit && unit.Flag == this.Attack.Flag)//不伤害自己方的
            ) return;

        SkillEffectDo.DoSkillEffect(this.CurrTime, Attack, unit, skill, skillLevel, isFlyTrackHit ? true : IsGrazes, dirX, dirZ, dieEffect);
    }

    public bool NeedHit { get { return CurrTime - m_BirthTime >= m_HitTime&&!DoHitEnd; } }
    public override bool Valid { get { return CurrTime - m_BirthTime < m_LiveTime; } }

    public override void OnJoin(AI_Battlefield battlefield, float joinTime)
    {
        base.OnJoin(battlefield, joinTime);
        m_BirthTime = CurrTime;

        var ArriveInfo = SkillEffectDo.ArriveInfo;
        var fxInfo = ArriveInfo.FeixingwuAudioFxObj;
        var m_MainTexiao = fxInfo != null && fxInfo.Texiaos.Length > 1 ? fxInfo.Texiaos[0] : null;

        fromWorldX = Attack.ownerGrid.WorldX;//当前位置x
        fromWorldZ = Attack.ownerGrid.WorldZ;//当前位置z 

        DefenderGrid = Defender.ownerGrid;
        toWorldX = DefenderGrid.WorldX - (m_MainTexiao == null ? 0f : (m_MainTexiao.OffSetX - m_MainTexiao.OffSetXEnd));
        toWorldZ = DefenderGrid.WorldZ;//目标世界坐标 

        var toWorldY = m_MainTexiao == null ? 0f : m_MainTexiao.OffSetYEnd - m_MainTexiao.OffSetY;
        

        var distance = AI_Math.V2Distance(fromWorldX, fromWorldZ, toWorldX, toWorldZ);

        //计算飞行方向
        AI_Math.V2Dir(fromWorldX, fromWorldZ, toWorldX, toWorldZ, out dirX, out dirZ);
        AI_Math.NormaliseV2(ref dirX, ref dirZ);

        var FlySpeed = ArriveInfo.FlySpeed * DiamondGridMap.WidthSpacingFactor;
        //计算飞行总时间
        var HitTime = distance / FlySpeed;
        

        StartYanchi = ArriveInfo.FeichuYanchi;
        m_HitTime = StartYanchi + HitTime;

    
        m_LiveTime = m_HitTime; 

        //创建飞行演员 
        if (fxInfo != null)
        {
            var gtime = HitTime + 0.5f/ArriveInfo.FlySpeed;
            var harf_gtime = gtime / 2.0f;

            FlyObj = battlefield.AudioFXCache.New(fxInfo.ID, CurrTime + StartYanchi, fromWorldX, fromWorldZ, ArriveInfo.Gensui, dirX, dirZ);
            Actor = FlyObj.effectActor;

            var activeTime = CurrTime + StartYanchi; 
            if (ArriveInfo.FlyArc > 0)//抛物线飞行
            {
                m_LiveTime = m_LiveTime + 0.5f / ArriveInfo.FlySpeed  //增加半个格子的飞行距离
                         + 0.3f;//箭延迟一段时间后才被销毁

                //避免短距离内飞太高
                var bl = distance / (12f * DiamondGridMap.WidthSpacingFactor);//5格达到最大弧度
                if (bl > 1) bl = 1; 
                float flyArc = ArriveInfo.FlyArc * bl;//飞行距离越近高度越低

                //增加xz移动关键帧 
                Actor.AddKey_ToX(MakingUpFunc.Linear, activeTime, fromWorldX, toWorldX, gtime);//Flag == ArmyFlag.Attacker ?
                Actor.AddKey_ToZ(MakingUpFunc.Linear, activeTime, fromWorldZ, toWorldZ, gtime);

                float jd = (float)ArriveInfo.FlyAngle * bl;//旋转角度，飞行距离越近旋转角度越小 

                //增加上行Y移动关键帧 和 z旋转关键帧
                Actor.AddKey_ToY(MakingUpFunc.SlowDown, activeTime, 0, flyArc, harf_gtime);
                Actor.AddKey_RotZ(MakingUpFunc.Linear, activeTime,  jd,0, harf_gtime);

                //清轨迹
                Actor.AddKey_Reset(activeTime);

                //增加下行Y移动关键帧 和 z旋转关键帧
                Actor.AddKey_ToY(MakingUpFunc.Acceleration, activeTime + harf_gtime, flyArc, toWorldY, harf_gtime);
                Actor.AddKey_RotZ(MakingUpFunc.Linear, activeTime + harf_gtime, 0,-jd,harf_gtime); 
            }
            else //直线飞
            {
                Actor.AddKey_ToX(MakingUpFunc.Linear, activeTime, fromWorldX, toWorldX, HitTime);
                Actor.AddKey_ToZ(MakingUpFunc.Linear, activeTime, fromWorldZ, toWorldZ, HitTime);
            }
        }

        if (SkillEffectDo.SkillRange.RangeType == RangeTypeEnum.GridFlyHit)
            m_FlyTrackHit = new TrackHitCheck(fromWorldX, fromWorldZ, this.Attack.OwnerBattlefield.GridMap, null);
    }

    RuningAudioFXInfo FlyObj = null;
    float StartYanchi;
    float m_BirthTime;
    float dirX, dirZ;
    float m_HitTime;
    float m_LiveTime;
    bool DoHitEnd = false;
    DiamondGrid DefenderGrid;
    TrackHitCheck m_FlyTrackHit = null;

    float fromWorldX;
    float fromWorldZ;
    float toWorldX;
    float toWorldZ;
}