using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 固定时间点伤害效果
/// </summary>
public class AI_EffectTrack_Hit : AI_EffectTrack
{ 
    public float HitTime = -1;//打击点时间
    float m_BirthTime;
    //float dirX;
    //float dirZ;
    float posx;
    float posz;

    public override void Update(float lostTime)
    {
        base.AddTime(lostTime);
        ReduceAllTime();
        if (!Valid)
        {
            if (Attack.OwnerBattlefield.FightST < FightST.FightEnd)
            {
                foreach (var defender in DefenderList)
                {
                    if (defender.IsDie) continue;
                    var dirX = defender.ownerGrid.WorldX - posx;
                    var dirZ = defender.ownerGrid.WorldZ - posz;

                    SkillEffectDo.DoSkillEffect(this.CurrTime, Attack, defender, skill, skillLevel, IsGrazes, dirX, dirZ, dieEffect);
                }
            }
        }
    }

    public override void OnJoin(AI_Battlefield battlefield, float joinTime)
    {
        base.OnJoin(battlefield, joinTime);
        m_BirthTime = CurrTime;

         
        if (HitTime<0)//自动计算伤害时间点
            HitTime = SkillEffectDo.ArriveInfo==null?0:SkillEffectDo.ArriveInfo.ArriveTime;//飘血延迟
  
        DefenderList.Add(Defender);//首个防御者加入队列

        posx = Attack.ownerGrid.WorldX;//当前位置x
        posz = Attack.ownerGrid.WorldZ;//当前位置z 
    }

    public void AddDefender(AI_FightUnit unit)
    {
        DefenderList.Add(unit);
    }

    public override bool Valid { get { return CurrTime - m_BirthTime < HitTime; } }

    HashSet<AI_FightUnit> DefenderList = new HashSet<AI_FightUnit>();//防御者队列
}

