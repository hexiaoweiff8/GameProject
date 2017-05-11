using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


 
public class AI_SkillBoxManage
{
    public AI_SkillBoxManage(AI_Battlefield ownerBattlefield)
    {
        m_OwnerBattlefield = ownerBattlefield;

        //绑定英雄死亡事件
        ownerBattlefield.Event.OnHeroDie += OnHeroDie;
    }

    void OnHeroDie(AI_Hero hero,AI_FightUnit attacker)
    {
        if (!m_BoxIndexByHero.ContainsKey(hero)) return;
        var list = m_BoxIndexByHero[hero]; 
        foreach (var curr in list) m_NeedRemove.Add(curr); 
    }
   
    public void AddTime(float lostTime)
    {
        foreach (var box in m_Boxs)
        {
            //以CD作为起始条件
            {
                var trigger = box.boxInfo.StartSkillTrigger;
                if (
                    trigger != null &&
                    (trigger.TriggerStart == ConditionTriggerEnum.CD || trigger.TriggerStart == ConditionTriggerEnum.CD_StartFull)
                    )
                {
                    box.CDTime += lostTime; 
                }
            }

            //以CD作为结束条件
            {
                var trigger = box.boxInfo.EndSkillTrigger;
                if (
                    trigger != null &&
                    trigger.TriggerEnd == ConditionTriggerEnum.CD
                    )
                {
                    box.LostTime += lostTime; 
                }
            }
        } 
    }

    

    public void Update()
    {
        var time = m_OwnerBattlefield.TotalLostTime;
        foreach (var box in m_Boxs)
        {
            {
                var trigger = box.boxInfo.StartSkillTrigger;
                if (
                    trigger != null &&
                    (trigger.TriggerStart == ConditionTriggerEnum.CD || trigger.TriggerStart == ConditionTriggerEnum.CD_StartFull)
                    )
                { 
                    while (box.CDTime >= trigger.Float_3rdTriggerStart)
                    {
                        var t = time - (box.CDTime - trigger.Float_3rdTriggerStart);

                        if (m_OwnerBattlefield.FightST < FightST.FightEnd)//当战斗未结束时，才执行效果
                            DoBoxEffects(t, box);//触发效果 

                        box.CDTime -= trigger.Float_3rdTriggerStart;
                    }
                }
            }

            {
                var trigger = box.boxInfo.EndSkillTrigger;
                if (
                    trigger != null &&
                    trigger.TriggerEnd == ConditionTriggerEnum.CD
                    )
                { 
                    if (box.LostTime >= trigger.Float_3rdTriggerEnd)//满足结束条件
                        m_NeedRemove.Add(box);
                }
            }
        }
        DoRemove(time);
    }
     

     public void MountBox(  float time,    AI_SkillBox box )
    {
        var trigger = box.boxInfo.StartSkillTrigger;
        if (trigger != null)
        {
            if (trigger.TriggerStart == ConditionTriggerEnum.CD_StartFull) //初始cd满
                DoBoxEffects(time, box);//触发效果 
        }



        m_Boxs.Add(box);

        if (box.boxInfo.BoxDanwei == BoxDanweiEnum.Grid)
        {
            var ownerGridZ = box.ownerGridZ;
            var ownerGridX = box.ownerGridX;
            //索引box
            {
                if (!m_BoxIndexByGrid.ContainsKey(ownerGridZ))
                    m_BoxIndexByGrid.Add(ownerGridZ, new Dictionary<byte, List<AI_SkillBox>>());

                var list = m_BoxIndexByGrid[ownerGridZ];
                if (!list.ContainsKey(ownerGridX))
                    list.Add(ownerGridX, new List<AI_SkillBox>());

                list[ownerGridX].Add(box);
            }

            //创建生存特效
            box.shengcunFX = CreateBoxFX(time,box,box.boxInfo.ShengcunAudioFxObj);
        } else
        {
            var ownerUnit = box.ownerUnit;
            if (!m_BoxIndexByHero.ContainsKey(ownerUnit)) m_BoxIndexByHero.Add(ownerUnit, new List<AI_SkillBox>());
            m_BoxIndexByHero[ownerUnit].Add(box);

            if (box.boxInfo.ShengcunAudioFxObj != null)
            {
                box.shengcunFX = AI_CreateFX.CreateFX(time, box.boxInfo.ShengcunAudioFxObj, m_OwnerBattlefield, 0, 0, 0, box.ownerUnit.dirx, box.ownerUnit.dirz, false);
                ownerUnit.MountActor(box.shengcunFX);
            }
        }
        
    }


    /// <summary>
    /// 触发盒子效果
    /// </summary>
    public void DoBoxEffects(float time,AI_SkillBox box)
    { 
        //播放调用效果
        CreateBoxFX(time, box, box.boxInfo.DiaoyongAudioFxObj);

        bool hasXingZhuangHit = false;
        var out_targetList = new List<EffectHit>();
        foreach (var effect in box.boxInfo.TakeEffectObjs) AI_SkillHit.BuildHitEffectList(box, effect, out_targetList,ref hasXingZhuangHit);
        if (out_targetList.Count!=0)  box.CreateEffectTrack(box.skill, box.skillLevel, out_targetList);  
    }

    public DPActor_Base CreateBoxFX(float time, AI_SkillBox box, AudioFxInfo fx)
    {
        if (fx == null) return null;

        float dirx = 1, dirz = 0; 
        if (box.boxInfo.BoxDanwei == BoxDanweiEnum.Hero)
        {
            var target = box.ownerUnit;
            if (target == null || target.IsDie) return null;

            dirx = target.dirx; dirz = target.dirz; 
        }

        var grid = box.ownerGrid;

        //在格子上播放效果
        return AI_CreateFX.CreateFX(time, fx, m_OwnerBattlefield, grid.GredX, 0, grid.GredZ, dirx, dirz);
    }

    public void Reset()
    { 
        m_NeedRemove.Clear();
        m_Boxs.Clear();
        m_BoxIndexByGrid.Clear();
        m_BoxIndexByHero.Clear();
    }


    //移除无效的盒子
    internal void DoRemove(float time)
    {
        foreach(var box in m_NeedRemove)
        {
            if (!m_Boxs.Contains(box)) continue;

            //播放死亡特效
            CreateBoxFX(time, box, box.boxInfo.SiwangAudioFxObj);

            //销毁生存特效
            if (box.shengcunFX != null) box.shengcunFX.AddKey_DestroyInstance(time);

            m_Boxs.Remove(box);

            if (box.boxInfo.BoxDanwei == BoxDanweiEnum.Grid)
            {
                var list = m_BoxIndexByGrid[box.ownerGridZ][box.ownerGridX];
                list.Remove(box);
                if (list.Count == 0)
                {
                    var l2 = m_BoxIndexByGrid[box.ownerGridZ];
                    l2.Remove(box.ownerGridX);
                    if (l2.Count == 0) m_BoxIndexByGrid.Remove(box.ownerGridZ);
                }
            } else
            {
                var list = m_BoxIndexByHero[box.ownerUnit];
                list.Remove(box);
                if (list.Count == 0) m_BoxIndexByHero.Remove(box.ownerUnit);
            }
        }
        m_NeedRemove.Clear();
    }

    public void ForeachTexingBox(Action< AI_SkillBox> callBack)
    {
        foreach(var box in m_Boxs)
        {
             var trigger = box.boxInfo.EndSkillTrigger;
             if (
                 trigger == null||
                 trigger.TriggerStart == ConditionTriggerEnum.CD
                 //||
                 //trigger.TriggerEnd == ConditionTriggerEnum.CD
                 ) continue;

             callBack(box);
        }
    }

    public void CacheRemove(AI_SkillBox box)
    {
        m_NeedRemove.Add(box);
    }

    //Dictionary<z, Dictionary<x,  List< AI_SkillBox> >> 根据各自位置索引的盒子
    Dictionary<byte, Dictionary<byte, List< AI_SkillBox>>> m_BoxIndexByGrid = new Dictionary<byte, Dictionary<byte, List<AI_SkillBox>>>();

    Dictionary<AI_FightUnit, List<AI_SkillBox>> m_BoxIndexByHero = new Dictionary<AI_FightUnit, List<AI_SkillBox>>();

     List<AI_SkillBox> m_NeedRemove = new List<AI_SkillBox>();

    //活动的盒子
    HashSet<AI_SkillBox> m_Boxs = new HashSet<AI_SkillBox>();

    AI_Battlefield m_OwnerBattlefield = null;
}

public class AI_SkillBox:AI_FightUnit
{
    public SkillBoxInfo boxInfo;//盒子静态信息
    public AI_FightUnit ownerUnit;//所属单位
    public AI_FightUnit attacker;//进攻者
    public byte ownerGridX;//所属格子X
    public byte ownerGridZ;//所属格子Z

    public Skill skill;//技能
    public short skillLevel;//技能等级
    public bool IsGrazes;//是否为擦伤
    public DieEffect dieEffect; 
    public float CDTime = 0;
    public float LostTime = 0;
    public DPActor_Base shengcunFX = null;


    /// <summary>
    /// 行为限制器
    /// </summary>
    public override AI_Limit ActionsLimit { get { return null; } }

    protected override void PlayExplodedDieEffect(AI_FightUnit attacker) { }

    protected override void PlayEscapeEffect() { }

    protected override void PlayCommonDieEffect(AI_FightUnit attacker) { }

    public override AI_FightUnit FindEnemy(bool findSoldiers) { return null; }
    public override AI_Battlefield OwnerBattlefield { get { return attacker.OwnerBattlefield; } }


    /// <summary>
    /// 执行AI
    /// </summary>
    public override void DoAI() { } 

    public override void Wait(float t) { }

    public override ArmyFlag Flag { get { return attacker.Flag; } }
    public override UnitType UnitType { get { return attacker.UnitType; } }

    public override short ModelRange { get { return attacker.ModelRange; } }

    /// <summary>
    /// 攻击范围
    /// </summary>
    public override int AtkRange { get { return attacker.AtkRange; } }

    public override float FinalSpeed { get { return attacker.FinalSpeed; } }
    public override int FinalMaxHP { get { return attacker.FinalMaxHP; } }
    public override int FinalBishaGL { get { return attacker.FinalBishaGL; } }//必杀释放概率

    public override float FinalNu { get { return attacker.FinalNu; } }

    public override void HitMe(AI_FightUnit enemy) { }

    protected override void OnDie(AI_FightUnit attacker, float time)
    {
         
    }

    /// <summary>
    /// 播放攻击动作
    /// </summary>
    public override void PlayHitAction(string atk, float dirx, float dirz){}

    public override void SwapJinYuan(bool isYuan) { }

    public override Skill[] BishaSkills { get { return attacker.BishaSkills; } }///获取必杀技队列
    public override Skill[] SkillObjs { get { return attacker.SkillObjs; } } ///技能列表

    public override Skill JinshenSkill { get { return null; } }//近身技

    public override string[] SkillAtks { get { return attacker.SkillAtks; } }//获取技能动作
    public override short[] SkillLevels { get { return attacker.SkillLevels; } }//技能等级

    public override void MountActor(DPActor_Base actor) { }

    public override short SuperSkillCountWeight { get { return attacker.SuperSkillCountWeight; } }//必杀技总权重
    public override int Level { get { return attacker.Level; } }//等级
    public override AAttr Speed { get { return attacker.Speed; } }//移动速度
    public override AAttr MaxHP { get { return attacker.MaxHP; } }//生命上限
    public override AAttr WuLi { get { return attacker.WuLi; } }//武力
    public override AAttr Nu { get { return attacker.Nu; } }//怒
    public override AAttr TiLi { get { return attacker.TiLi; } }//体力

    public override AAttr Zhili { get { return attacker.Zhili; } }

    public override AAttrLight AddFYL { get { return attacker.AddFYL; } }//增加防御率 
    public override AAttrLight AddBSGL { get { return attacker.AddBSGL; } }//增加必杀概率

    public override int ID { get { return -1; } }

    public override int JinshenSkillID { get { return -1; } }


    public override AI_EffectBuffManage EffectBuffManage { get { return null; } }//buff管理器

    public override DiamondGrid ownerGrid
    {
        get { return boxInfo.BoxDanwei== BoxDanweiEnum.Hero?ownerUnit.ownerGrid:OwnerBattlefield.GridMap.GetGrid(ownerGridX,ownerGridZ); }
        set {  
        }
    }

    public override AI_FightUnit Enemy
    {
        get {
            if (boxInfo.BoxDanwei == BoxDanweiEnum.Hero)
                return ownerUnit;

            var grid = OwnerBattlefield.GridMap.GetGrid(ownerGridX, ownerGridZ);
            var re = grid.Obj;
            return re.Flag == attacker.Flag ? null : re;
        }
        set {   }
    }
}