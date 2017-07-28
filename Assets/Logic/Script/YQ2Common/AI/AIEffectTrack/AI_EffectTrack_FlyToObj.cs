using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// 飞行的效果
/// </summary>
public class AI_EffectTrack_FlyToObj : AI_EffectTrack
{
    public override void Update(float lostTime)
    {
        base.AddTime(lostTime); 
       if (moveEnd) return;

        if(this.m_CurrState== State.TimerStart)//定时开始阶段
        {
            if (CurrTime - m_BirthTime < TexiaoYanchi) return;//定时未达到设定时间
            this.m_CurrState = State.Flying;
        }

       
       //记录移动前的位置
       float oldposx = posx;
       float oldposz = posz;

       float targetX , targetZ ;

       if (!Defender.IsDie)
       {
           oldTargetX = targetX = Defender.ownerGrid.WorldX;
           oldTargetZ = targetZ = Defender.ownerGrid.WorldZ;

       }else//已经死亡了，用最近一次的防御者位置作为飞行目的地
       {
           targetX = oldTargetX;
           targetZ = oldTargetZ;
       }

       //计算飞行方向向量
       float dx = targetX - oldposx;
       float dz = targetZ - oldposz;

       //归一化方向向量
       AI_Math.NormaliseV2(ref dx, ref dz);

       if (dx>0)
           targetX += m_FlyEndOffset;
       else
           targetX -= m_FlyEndOffset; 

       //位移
       posx += dx * FlySpeed * lostTime;
       posz += dz * FlySpeed * lostTime;

       //对新的当前位置进行纠错
       if (dx > 0) //向右飞
       {
           if (posx > targetX)//纠错
           {
               posx = targetX;
               posz = targetZ;
               moveEnd = true;
           }
       }
       else if (dx < 0)//向左飞
       {
           if (posx < targetX)
           {
               posx = targetX;
               posz = targetZ;
               moveEnd = true;
           }
       } else
       {
           posx = targetX;
           posz = targetZ;
           moveEnd = true;
       }

       //生成移动关键帧 
       if (Actor != null)
       {
           Actor.AddKey_ToX(MakingUpFunc.Linear, CurrTime, oldposx, posx, lostTime);
           Actor.AddKey_ToZ(MakingUpFunc.Linear, CurrTime, oldposz, posz, lostTime);
       }
       ReduceTime(lostTime);

       

       //飞行过程中造成伤害
       if (m_FlyTrackHit!=null)
           m_FlyTrackHit.MoveTo(posx, posz, (unit) => Hit(unit,dx,dz,true));

       //移动已经结束
       if (moveEnd)
       {
           //创建销毁关键帧
           if (Actor != null)
            Actor.AddKey_DestroyInstance(CurrTime + lostTime);
            
           Hit(Defender, dx, dz,false);  
       } 
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="unit"></param>
    /// <param name="dx"></param>
    /// <param name="dz"></param>
    /// <param name="isFlyTrackHit">是否是被飞行轨迹所伤</param>
    void Hit(AI_FightUnit unit, float dx, float dz, bool isFlyTrackHit)
    {
        if (
            unit.IsDie||
            Attack.OwnerBattlefield.FightST >= FightST.FightEnd
            ) return;

        //if (isFlyTrackHit && unit.Flag == this.Attack.Flag) return;//不伤害自己方的

        var range = SkillEffectDo.SkillRange;
        
        //子筛选条件
        if (isFlyTrackHit && //擦伤
            !AI_TriggerChecker.RangeTriggerCheckOne(
            Attack,
            unit,
            false,//是否为我方
            range.SubRange,
            range.IsSelf,//是否包含自己
            range._2rdSubRangeIntArray,
            range._2rdSubRangeFloat,
            range.HeroOrArmy
            )//不满足子条件
         )
            return;

        SkillEffectDo.DoSkillEffect(this.CurrTime,Attack,unit,skill,skillLevel,
            isFlyTrackHit ? true : IsGrazes,
            dx,dz,
            dieEffect
            ) ;
    }

    float TexiaoYanchi;

    public override bool Valid { get { return !moveEnd; } }

    
    public override void OnJoin(AI_Battlefield battlefield, float joinTime)
    {
        base.OnJoin(battlefield, joinTime);

        m_BirthTime = CurrTime; 

        oldTargetX = Defender.ownerGrid.WorldX;
        oldTargetZ = Defender.ownerGrid.WorldZ;


        posx = Attack.ownerGrid.WorldX;//当前位置x
        posz = Attack.ownerGrid.WorldZ;//当前位置z 

        var  ArriveInfo = SkillEffectDo.ArriveInfo;
        m_FxInfo = ArriveInfo.FeixingwuAudioFxObj;

        if (m_FxInfo == null || m_FxInfo.Texiaos[0] == null)
            m_FlyEndOffset = 0;
        else
            m_FlyEndOffset = m_FxInfo.Texiaos[0].OffSetXEnd;

        TexiaoYanchi = ArriveInfo.FeichuYanchi;
        
         
        FlySpeed = ArriveInfo.FlySpeed * DiamondGridMap.WidthSpacingFactor; 

        float targetX = Defender.ownerGrid.WorldX, targetZ = Defender.ownerGrid.WorldZ;

        //计算飞行方向向量
        float dx = targetX - posx;
        float dz = targetZ - posz;
        AI_Math.NormaliseV2(ref dx, ref dz);

        if (dx == dz && dx == 0)
        {
            dx = Attack.dirx;
            dz = Attack.dirz;
        }

        if (m_FxInfo != null)
        {
            //创建飞行演员 
            Actor = AI_CreateDP.CreateDP(
                Attack.OwnerBattlefield,
                m_FxInfo.ID,//效果ID
                0,//生命
                ArriveInfo.Gensui,
                posx, 0, posz,
                dx, dz,
                CurrTime
                );
            Actor.AddKey_Active(CurrTime);//激活飞行特效  
        }

        //飞向目标过程中造成伤害
        if (SkillEffectDo.SkillRange.RangeType == RangeTypeEnum.ObjFlyHit)
        {
            m_FlyTrackHit = new TrackHitCheck(posx, posz, this.Attack.OwnerBattlefield.GridMap, Defender);
        }
    }

    AudioFxInfo m_FxInfo;
    //TexiaoInfo m_MainTexiao;
    float m_FlyEndOffset;
    float FlySpeed;

    float posx;//当前位置x
    float posz;//当前位置z   
    bool moveEnd = false;
    TrackHitCheck m_FlyTrackHit = null;
    float oldTargetX, oldTargetZ;
    float m_BirthTime;

    enum State
    {
        TimerStart,//定时开始
        Flying,//飞行中
    }
    State m_CurrState = State.TimerStart;
}

//采样点采样到的格子中心点离采样点距离<对角线/2,则伤害


/// <summary>
/// 飞行轨迹伤害检查
/// </summary>
class TrackHitCheck
{
    //目标对象，不会被轨迹伤害
    public TrackHitCheck(float startX, float startZ, DiamondGridMap map, AI_FightUnit target)
    {
        if (target != null) m_HitList.Add(target);

        m_X = startX;
        m_Z = startZ;
        m_map = map;
    }


    /// <summary>
    /// 移动到指定位置
    /// </summary>
    /// <param name="x">新的世界坐标x</param>
    /// <param name="z">新的世界坐标z</param>
    /// <param name="hitRecall">伤害回调</param>
    public void MoveTo(float x,float z,Action<AI_FightUnit> hitRecall)
    {
        var distance = AI_Math.V2Distance(m_X, m_Z, x, z);
        var harfW = SData_mapdata.Single.GetDataOfID(1).terrain_cell_bianchang * DiamondGridMap.harf_wxs;//六边形格子宽度的一半
        if (distance < harfW) return;//移动没超过半个格子宽度

        int cs = (int)(distance / harfW);//伤害检查迭代次数

        //移动朝向
        var dirx = x - m_X;
        var dirz = z - m_Z;

        AI_Math.NormaliseV2(ref dirx, ref dirz);//归一化朝向
        
        for(int i=0;i<cs;i++)
        {
            m_X += dirx;
            m_Z += dirz;
            //检查新位置是否被撞
            int gridX,gridZ;
            m_map.World2Grid(m_X, m_Z, out gridX, out gridZ);
            var grid = m_map.GetGrid(gridX, gridZ);
            if (grid == null || grid.Obj == null || m_HitList.Contains(grid.Obj)) continue;

            m_HitList.Add(grid.Obj);//加入到已经撞击过队列
            hitRecall(grid.Obj);//回调
        }
    }


    public bool InHitList(AI_FightUnit unit)
    {
        return m_HitList.Contains(unit);
    }

    HashSet<AI_FightUnit> m_HitList = new HashSet<AI_FightUnit>();
    float m_X;
    float m_Z;
    DiamondGridMap m_map;
}