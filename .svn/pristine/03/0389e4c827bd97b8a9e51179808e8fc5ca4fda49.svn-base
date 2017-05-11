using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
public class AI_EffectBuff
{
    public float time;//时间 CD类专用
    public AI_FightUnit attacker;//进攻者
    public Skill skill;
    public SkillEffect effect;//技能效果 
    public short skillLevel;//技能等级
    public DPActor_Base fxActor;//特效
    public int buffIconID;//界面显示图标ID 
} 


 
public class AI_EffectBuffManage
{
    public AI_EffectBuffManage(AI_FightUnit owner)
    {
        m_Owner = owner;
    }

    /// <summary>
    /// 获取可免疫本负面状态的 免疫状态
    /// </summary> 
    SkillEffectBOOLST GetMianyiST(SkillEffectBOOLST st)
    {
        switch (st)
        {
            case SkillEffectBOOLST.Fengji://封技 
                return SkillEffectBOOLST.Mianyi_Fengji;
            case SkillEffectBOOLST.Dingshen://	定身状态 
                return SkillEffectBOOLST.Mianyi_Dingshen;
            case SkillEffectBOOLST.Yun://晕眩 
                return SkillEffectBOOLST.Mianyi_Yun;
            case SkillEffectBOOLST.Zhongdu:
                return SkillEffectBOOLST.Mianyi_Zhongdu;
            case SkillEffectBOOLST.Bianxing://变形
                return SkillEffectBOOLST.Mianyi_Bianxing;
            case SkillEffectBOOLST.Jiaoxie://缴械
                return SkillEffectBOOLST.Mianyi_Jiaoxie; 
        }
        return SkillEffectBOOLST.None;
    }

    /// <summary>
    /// 获取本状态可免疫的负面状态
    /// </summary>
    SkillEffectBOOLST GetFumianST(SkillEffectBOOLST st)
    {
        switch (st)
        {
            case SkillEffectBOOLST.Mianyi_Fengji://封技 
                return SkillEffectBOOLST.Fengji;
            case SkillEffectBOOLST.Mianyi_Dingshen://	定身状态 
                return SkillEffectBOOLST.Dingshen;
            case SkillEffectBOOLST.Mianyi_Yun://晕眩 
                return SkillEffectBOOLST.Yun;
            case SkillEffectBOOLST.Mianyi_Zhongdu :
                return SkillEffectBOOLST.Zhongdu;
            case SkillEffectBOOLST.Mianyi_Bianxing://变形
                return SkillEffectBOOLST.Bianxing;
            case SkillEffectBOOLST.Mianyi_Jiaoxie://缴械
                return SkillEffectBOOLST.Jiaoxie;
        }
        return SkillEffectBOOLST.None;
    }

    public void Add(
            float CurrTime,
            AI_FightUnit attacker, 
            Skill skill,
            SkillEffect effect,//技能效果
            short skillLevel//技能等级   
            )
    {
        var myst = GetMianyiST(effect.Zhuangtai);
        if (myst != SkillEffectBOOLST.None)//这是一个可以被免疫的负面效果
        {
            if (HasStateM(myst, SkillEffectBOOLST.Mianyi_All))
                return;//被免疫了
        }

        //处理叠加规则
        if (!effect.IsDiejia)//不是一个可叠加的技能
        {
            var diejiaType = effect.DiejiaType;
             
            ForeachBuffs((currbuff) =>
            {
                if (currbuff.effect.DiejiaType == diejiaType)
                    m_RemoveBuff.Add(currbuff);
            });
            ClearRemove(); 
        }

        AI_EffectBuff buff = new AI_EffectBuff();
        buff.skill = skill;
        buff.effect = effect;
        buff.skillLevel = skillLevel;
        buff.attacker = attacker;

        var endTrigger = buff.effect.EndSkillTriggerObj;
        if (endTrigger == null)
        {
            buff.time = 999999;
            m_TimeBuff.Add(buff);
        }
        else
        {
            if (endTrigger.TriggerEnd == ConditionTriggerEnum.CD)
            {
                buff.time = endTrigger.Float3rdTriggerEnd_Lv(skillLevel);
                m_TimeBuff.Add(buff);
            }
            else
                m_TexingBuff.Add(buff);
        }
        //处理技能效果 
        AI_SkillHit.ApplySkillEffect(attacker, m_Owner,buff. skill,buff.effect, buff.skillLevel, true, DieEffect.Putong );


        //处理显示效果 
        if (buff.effect.ShengcunAudioFxObj != null)
        {
            buff.fxActor = AI_CreateDP.CreateDP(
                m_Owner.OwnerBattlefield,
                buff.effect.ShengcunAudioFxObj.ID,//效果ID
                0,//生命
                false,
                0, 0, 0,
                1, 0,//正前方
                CurrTime
                );
            buff.fxActor.AddKey_Active(CurrTime);//激活特效 

            //显示效果挂接到战斗单位上
            m_Owner.MountActor(buff.fxActor);
        }

        //界面显示技能图标 
        if (!string.IsNullOrEmpty( buff.effect.Icon))
        {
            buff.buffIconID = m_Owner.OwnerBattlefield.NewDPID;
            m_Owner.OwnerArmySquare.OverheadPanel.AddKey_BuffIcon(CurrTime, buff.buffIconID, buff.effect.Icon);
        }

        //免疫已经挂上的buff
        {
            if (
                effect.Zhuangtai == SkillEffectBOOLST.Mianyi_All
                )//免疫全部
            {
                RemoveBuffM(
                    SkillEffectBOOLST.Fengji,
                    SkillEffectBOOLST.Dingshen,
                    SkillEffectBOOLST.Yun,
                    SkillEffectBOOLST.Zhongdu,
                    SkillEffectBOOLST.Bianxing,
                    SkillEffectBOOLST.Jiaoxie
                    );
            }
            else //免疫单个
            {
                var fmST = GetFumianST(effect.Zhuangtai);
                if (fmST != SkillEffectBOOLST.None)//当前buff是一个免疫类的
                {
                    RemoveBuff(fmST);//移除所有被免疫的
                }
            }
        }

        //无敌的时候，去掉所有负面修改器
        if (
            effect.Zhuangtai == SkillEffectBOOLST.ArmyWudi ||
            effect.Zhuangtai == SkillEffectBOOLST.HeroWudi
            )
        {
            ForeachBuffs((currbuff) =>
            {
                if (
                    currbuff.effect.SkillRange.SelfOrEnemy == SelfOrEnemyEnum.Enemy&&
                    !m_Owner.ActionsLimit.CanInjured(currbuff.attacker)
                    )
                {
                    m_RemoveBuff.Add(currbuff);
                }
            });
            ClearRemove();
        }

        //手动技能打断判定
        if (m_Owner.UnitType == UnitType.Hero)
        {
            switch (effect.Zhuangtai)
            {
                case SkillEffectBOOLST.Yun:
                case SkillEffectBOOLST.Jiaoxie:
                case SkillEffectBOOLST.Bianxing:
                case SkillEffectBOOLST.Fengji:
                case SkillEffectBOOLST.DaduanShoudong:
                    {
                        //打断手动技
                        (m_Owner as AI_Hero).InterruptShoudong(CurrTime);
                    }
                    break;
            }
        }

        if(effect.Zhuangtai== SkillEffectBOOLST.Yun)
        {
            if (m_Owner.UnitType == UnitType.Hero)
                m_Owner.OwnerBattlefield.Event.PostYun(m_Owner as AI_Hero);
        }
    }

    public void ForeachBuffs(Action<AI_EffectBuff> callBack)
    {
        if (m_TimeBuff.Count > 0)
        {
            var count = m_TimeBuff.Count;
            for (int i = 0; i < count; i++)
            {
                callBack( m_TimeBuff[i]); 
            }
        }

        if (m_TexingBuff.Count > 0)
        {
            var count = m_TexingBuff.Count;
            for (int i = 0; i < count; i++)
            {
                callBack( m_TexingBuff[i]); 
            }
        }
    }

    void RemoveBuffM(params SkillEffectBOOLST[] sts )
    {
        int stcount = sts.Length;

        ForeachBuffs((curr) =>
        { 
            for (int i2 = 0; i2 < stcount; i2++)
                if (curr.effect.Zhuangtai == sts[i2])
                { m_RemoveBuff.Add(curr); break; }
        }); 

        ClearRemove();
    }

    void RemoveBuff(SkillEffectBOOLST st)
    {
        ForeachBuffs((curr) =>
        {
            if (curr.effect.Zhuangtai == st)
                m_RemoveBuff.Add(curr);
        });  

        ClearRemove();
    }
    
    /// <summary>
    /// 逝去时间，自动判断buff过期
    /// </summary>
    public void AddTime(float time)
    {
        foreach (var curr in m_TimeBuff) 
            curr.time -= time;  
    }

    public void Update()
    {
        foreach (var curr in m_TimeBuff)
        { 
            if (curr.time <= 0) //buff已经过期了
            {
                m_RemoveBuff.Add(curr);
            }
        }

        ClearRemove();
    }

    void ClearRemove()
    {
        if (m_RemoveBuff.Count > 0)
        {
            foreach (AI_EffectBuff buff in m_RemoveBuff)
                RemoveBuff(buff);

            m_RemoveBuff.Clear();
        }
    }

    public void RemoveBuff(AI_EffectBuff buff)
    {
        m_TexingBuff.Remove(buff);
        m_TimeBuff.Remove(buff); 

        //处理技能效果 
        AI_SkillHit.ApplySkillEffect(buff.attacker, m_Owner, buff.skill, buff.effect, buff.skillLevel, false, DieEffect.Putong );

        //处理特效
        if (buff.fxActor!=null) buff.fxActor.AddKey_DestroyInstance(m_Owner.CurrTime);

        //处理界面显示buff图标 
        RemoveBuffIcon(buff);
    }

    /// <summary>
    /// 仅移除buff图标
    /// </summary>
    public void RemoveBuffIcon(AI_EffectBuff buff)
    {
        if (buff.buffIconID >= 0)
        {
            m_Owner.OwnerArmySquare.OverheadPanel.AddKey_BuffIcon(m_Owner.CurrTime, buff.buffIconID, "");
            buff.buffIconID = -1;
        }
    }


    /// <summary>
    /// 检查当前是否中了某效果
    /// </summary>
    public bool HasState(SkillEffectBOOLST st)
    {
        if (m_TimeBuff.Count > 0) 
        {
            var count = m_TimeBuff.Count;
            for (int i = 0; i < count; i++) if (m_TimeBuff[i].effect.Zhuangtai == st) return true;
        }

        if (m_TexingBuff.Count > 0)
        {
            var count = m_TexingBuff.Count;
            for (int i = 0; i < count; i++) if (m_TexingBuff[i].effect.Zhuangtai == st) return true;
        }

        return false;
    }


    /// <summary>
    /// 获取指定状态的buff
    /// </summary>
    public void GetBuffs(SkillEffectBOOLST st,List<AI_EffectBuff> outBufs)
    {
        if (m_TimeBuff.Count > 0)
        {
            var count = m_TimeBuff.Count;
            for (int i = 0; i < count; i++) if (m_TimeBuff[i].effect.Zhuangtai == st) outBufs.Add( m_TimeBuff[i]);
        }

        if (m_TexingBuff.Count > 0)
        {
            var count = m_TexingBuff.Count;
            for (int i = 0; i < count; i++) if (m_TexingBuff[i].effect.Zhuangtai == st) outBufs.Add( m_TexingBuff[i]);
        }
    }

    /// <summary>
    /// 检查当前是否中了某效果,同时检查多个
    /// </summary>
    public bool HasStateM(params SkillEffectBOOLST[] sts)
    {
        int arraylen = sts.Length;
        if (m_TimeBuff.Count > 0)
        {
            var count = m_TimeBuff.Count;
            for (int i = 0; i < count; i++)
                for (int i2 = 0; i2 < arraylen;i2++ )
                    if (m_TimeBuff[i].effect.Zhuangtai == sts[i2]) return true;
        }

        if (m_TexingBuff.Count > 0)
        {
            var count = m_TexingBuff.Count;
            for (int i = 0; i < count; i++)
                for (int i2 = 0; i2 < arraylen; i2++)
                    if (m_TexingBuff[i].effect.Zhuangtai == sts[i2]) return true;
        }

        return false;
    }

    List<AI_EffectBuff> m_RemoveBuff = new List<AI_EffectBuff>();
    List<AI_EffectBuff> m_TimeBuff = new List<AI_EffectBuff>();
    List<AI_EffectBuff> m_TexingBuff = new List<AI_EffectBuff>();
    public void ForeachTexingBuff(Action<AI_EffectBuff> buff)
    {
        foreach (var curr in m_TexingBuff) buff(curr);
    }

    AI_FightUnit m_Owner;
   
}