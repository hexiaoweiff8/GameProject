﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

public class AI_Object
{
    public const float NormalBrightness = 0.8f;
    public const float HightBrightness = 1.2f;

    /// <summary>
    /// 正式进入战场，参与AI运算
    /// </summary>
    public virtual void OnJoin(AI_Battlefield battlefield,float joinTime)
    {
        ResetTime(joinTime, 0);
    }

    public void ResetTime(float joinTime, float notUsedTime)
    {
        m_UsedTime = joinTime;
        m_NotUsedTime = 0;
    }

    /// <summary>
    /// 减少一个时间量
    /// </summary>
    /// <param name="time"></param>
    public void ReduceTime(float time)
    {
        m_UsedTime += time;//增加已经使用的时间参数
        m_NotUsedTime -= time;
    }

    /// <summary>
    /// 时间轴上增加一个时间量
    /// </summary>
    public virtual void AddTime(float time)
    {
        m_NotUsedTime += time;
        //m_LastAdd = time;
    }

    //public float LastAdd { get { return m_LastAdd; } }

    /// <summary>
    /// 减少全部未应用的时间
    /// </summary>
    public void ReduceAllTime()
    {
        if (m_NotUsedTime < 0) return;

        m_UsedTime += m_NotUsedTime;
        m_NotUsedTime = 0;
    }

    /// <summary>
    /// 无条件立即获得行动时间
    /// </summary>
    public void ObtainActionTime(float currTime)
    {
        if (m_NotUsedTime <= 0)
        {
            m_UsedTime = currTime;
            m_NotUsedTime = 0.001f;
        }
    }

    public float CurrTime { get { return m_UsedTime; } }
    public bool HasNotUsedTime { get { return m_NotUsedTime > 0; } }

    //是否允许第三方插入行为
    public virtual bool CanInsertAction { get { return m_NotUsedTime > -0.1f; } }

    public float NotUsedTime { get { return m_NotUsedTime; } }

    
    //由于ai运算在帧上有过载应用时间的情况，所以每个ai物体一根时间轴
    private float m_NotUsedTime = 0;//还没有应用的逝去时间
    private float m_UsedTime = 0;//执行行为已经使用的总时间
    //private float m_LastAdd = 0;//上次执行AddTime增加的时间量

}

/// <summary>
/// 单位类型
/// </summary>
public enum UnitType
{
    Hero,//英雄
    Soldiers,//士兵
    Square,//方阵
}

/// <summary>
/// 死亡效果
/// </summary>
public enum DieEffect
{
    Putong,//普通
    Taopao,//逃跑
    Baozha,//爆炸
}

public abstract class AI_FightUnit : AI_Object 
{

    protected static List<AI_EffectBuff> tmpEffectBuff = new List<AI_EffectBuff>();

    public virtual void LostHP(int v, AI_FightUnit attacker,DieEffect dieEffect, bool addLianzhant)
    {
        if (IsDie) return;//已经死了

        if (attacker!=null&&attacker.UnitType == UnitType.Hero) (attacker as AI_Hero).AddHitCount(v);

        CurrHP -= v;

        if (IsDie)//被打死
        {
            var currTime = attacker.OwnerBattlefield.TotalLostTime;
            _OnDie(attacker,currTime);
        
            switch(dieEffect)
            {
                case DieEffect.Putong://播放普通死效果
                    PlayCommonDieEffect(attacker);
                    break;
                case DieEffect.Taopao: //播放逃跑效果
                    PlayEscapeEffect();
                    break;
                case DieEffect.Baozha: //播放爆炸死效果
                    PlayExplodedDieEffect(attacker);
                    break; 
            } 

            //通知战场，角色死亡
            OwnerBattlefield.OnUnityDie(this);
        }
    }

    public virtual void AddHP(AI_FightUnit attacker, int v)
    {
        if (IsDie) return;//已经死了

        if (attacker!=null&& attacker.UnitType == UnitType.Hero) (attacker as AI_Hero).AddNursedCount(v);

        CurrHP += v;
        int mhp = FinalMaxHP;
        if (CurrHP > mhp) CurrHP = mhp;
    }

    //逃跑
    public void DoEscape(  AI_FightUnit attacker,float time)
    {
        if (IsDie) return;//已经死了

        if (UnitType == global::UnitType.Hero)
        {
            OwnerArmySquare.OverheadPanel.AddKey_HPChange(time, CurrHP, 0, attacker==null|| attacker.UnitType == UnitType.Hero);//掉血关键帧
        }


        //生命无条件减为0
        CurrHP = 0;

        _OnDie(attacker, time);

        //播放逃跑效果
        PlayEscapeEffect();

        //通知战场，角色死亡
        OwnerBattlefield.OnUnityDie(this); 
    }

    public bool CheckEnemy(AI_AvatarShape Shape)
    {
        if (!IsEnemyValid)//目标已阵亡
        {
            st = HeroST.Moveing;//进入移动状态
            //ReduceTime(Shape.RH.AddKey_Wait(CurrTime, WaitTime));//演员进入等待状态 
            return false;
        }

        return true;
    }



    protected void MoveSwapGrid(DiamondGrid newGrid, AI_AvatarShape Shape, DPActor_Base OverheadPanel)
    {
        int gz = ownerGrid.GredZ;
        int gx = ownerGrid.GredX;


        var tSpeed = FinalSpeed;//使用自身的移动速度

        //继承前方友军移动速度
        {
            if (newGrid.GredZ == gz)
            {
                if (newGrid.GredX > gx)//朝右走
                {
                    var grid = OwnerBattlefield.GridMap.GetGrid(gx + 2, gz);
                    if (grid != null && grid.IsObstacle && grid.Obj.Flag == Flag)//继承友军移动速度
                        tSpeed = grid.Obj.FinalSpeed;
                }
                else //朝左走
                {
                    var grid = OwnerBattlefield.GridMap.GetGrid(gx - 2, gz);
                    if (grid != null && grid.IsObstacle && grid.Obj.Flag == Flag)//继承友军移动速度
                        tSpeed = grid.Obj.FinalSpeed;
                }
            }
        }

        float mvspeed = tSpeed * DiamondGridMap.WidthSpacingFactor;
        float t = Shape.RH.AddKey_MoveTo(
            CurrTime,
            ownerGrid.WorldX, ownerGrid.WorldZ,
            newGrid.WorldX, newGrid.WorldZ,
            mvspeed,
            out dirx, out dirz
            );

        if (OverheadPanel!=null)
            OverheadPanel.AddKey_MoveTo(
            CurrTime,
            ownerGrid.WorldX, ownerGrid.WorldZ,
            newGrid.WorldX, newGrid.WorldZ,
            mvspeed,
            out dirx, out dirz
            );


        ReduceTime(t);


        //处理格子地图
        SetGridObjFast(null);//身下的格子置为空，快速模式

        lastGrid = ownerGrid;

        ownerGrid = newGrid;

        SetGridObjFast(this);//身下的格子置为自己，快速模式
    }

    public void SetGridObjFast(AI_FightUnit obj)
    {
        if (ModelRange > 0)
        {
            {
                var offsets = SData_DamoxingYindao.Single.GetBody(ModelRange, 1 - (ownerGrid.GredZ % 2));//只设置最外圈
                int len = offsets.Length;
                for (int i = 0; i < len; i++)
                {
                    var tmp = offsets[i];
                    var g = OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX + tmp.offsetX, ownerGrid.GredZ + tmp.offsetZ);
                    if (g != null) g.Obj = obj;
                }
            }

            if (obj != null)
            {
                var offsets = SData_DamoxingYindao.Single.GetBody(ModelRange-1, 1 - (ownerGrid.GredZ % 2));//设置最外第二圈
                int len = offsets.Length;
                for (int i = 0; i < len; i++)
                {
                    var tmp = offsets[i];
                    var g = OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX + tmp.offsetX, ownerGrid.GredZ + tmp.offsetZ);
                    if (g != null) g.Obj = obj;
                }

            }
        }
        else
        { 
            ownerGrid.Obj = obj;
        }
    }


    public bool SetGridObj(AI_FightUnit obj,bool qiangZhi)
    {
        if (ModelRange > 0)
        {
            for (int range = ModelRange; range >= 0; range--)//设置每一圈
            {
                var offsets = SData_DamoxingYindao.Single.GetBody(range, 1 - (ownerGrid.GredZ % 2));
                int len = offsets.Length;
                for (int i = 0; i < len; i++)
                {
                    var tmp = offsets[i];
                    var g = OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX + tmp.offsetX, ownerGrid.GredZ + tmp.offsetZ);
                    //if (g != null) g.Obj = obj;

                    if (
                       obj != null &&//设置
                       g != null&&
                       g.Obj != null//已经有人占了这个格子
                       )
                    {
                        if (!qiangZhi)//强制占上去 
                            return false; //返回失败
                    }
                }
            }

            for (int range = ModelRange; range >= 0; range--)//设置每一圈
            {
                var offsets = SData_DamoxingYindao.Single.GetBody(range, 1 - (ownerGrid.GredZ % 2));
                int len = offsets.Length;
                for (int i = 0; i < len; i++)
                {
                    var tmp = offsets[i];
                    var g = OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX + tmp.offsetX, ownerGrid.GredZ + tmp.offsetZ);
                    if (g != null)
                    {
                        if (g.Obj != null&&obj!=null) { g.Obj.SetGridObj(null, true); g.Obj.ownerGrid = null; }
                        g.Obj = obj;
                    }
                }
            }
        }
        else
        {
            if (
                obj!=null&&//设置
                ownerGrid.Obj != null//已经有人占了这个格子
                )
            {
                if(qiangZhi)//强制占上去
                {
                    ownerGrid.Obj.SetGridObj(null,true);
                    ownerGrid.Obj.ownerGrid = null;
                } else 
                    return false; //返回失败
            }
            ownerGrid.Obj = obj;
        }
        return true;
    }

    /// <summary>
    /// 切换为寻敌状态
    /// </summary>
    public void AddToFindEnemy()
    {   
        OwnerBattlefield.AddToFindEnemyCache(this);//把自己放进寻敌缓冲池 
    }

    public bool IsInFindEnemyQueue = false;//是否在寻敌队列中

    public virtual void DoReadyEnter(float time, AI_AvatarShape Shape, bool IsQixi)
    {     
        float toX = ownerGrid.WorldX;
        float toZ = ownerGrid.WorldZ;
        float tmpdirx, tmpdirz;
      
        if (IndentPos)//需要缩进位置  
            toX += AI_Math.IndentOffset(Flag);  

        float startX = toX + (Flag == ArmyFlag.Attacker ? -0.1f : 0.1f);

        //增加激活角色关键帧
        OwnerBattlefield.WorldActor.AddKey_Enable(time, Shape.RH.ID, toX, 0, toZ);

        //增加关键帧
        if (IsQixi)
        {
            startX = 999999;
            toZ = 0;
            toX = 999999;


            Shape.RH.AddKey_MoveTo(
                      time,
                      startX, toZ,
                      toX, toZ,
                      10000,
                      out  tmpdirx, out  tmpdirz
                      );

        }
        else
        {

            Shape.RH.AddKey_MoveTo(
                      time,
                      startX, toZ,
                      toX, toZ,
                      10000,
                      out  tmpdirx, out  tmpdirz
                      );

            //播放等待动作
            Shape.RH.AddKey_Wait(time, 0f);
        }

        
        //var sb = this as AI_Soldiers;
        //if (sb!=null&&OwnerArmySquare.QizhiOwner == sb)//抗旗的兵
        //{   
        //    var qztime = time;
        //    //创建旗子
        //    var QizhiActor = AI_CreateDP.CreateDP(OwnerBattlefield, qztime, (byte)(Flag == ArmyFlag.Attacker ? 0 : 1));
        //    QizhiActor.AddKey_Active(qztime);
        //    //QizhiActor.AddKey_SetParent(qztime, Shape.RH.ID);
        //    float tmp; QizhiActor.AddKey_MoveTo(qztime, startX, toZ, toX, toZ, 1000, out tmp, out tmp);
        //    OwnerArmySquare.QizhiActor = QizhiActor;
        //}
    }
     

    /// <summary>
    /// 快速寻敌
    /// </summary>
    protected void DoFindEnemyFast()
    {
        var eFlag = AI_Math.ReverseFlag(Flag);//敌人标志
        var map = OwnerBattlefield.GridMap;
        int gx = ownerGrid.GredX;
        int gz = ownerGrid.GredZ;

        //优先找正在打我的人
        if(m_HitMeEnemy!=null&&!m_HitMeEnemy.IsDie)
        {
            Enemy = m_HitMeEnemy;
            st = HeroST.Fighting;//切换为战斗状态
            this.ReduceTime(0.1f);
            return;
        }

        if (IsMelee)//近战
        {
            //var Adjacent = ownerGrid.Adjacent; 
            //int len = Adjacent.Length;
            //在相邻格子中查询敌人
            for (int i = 3; i < 9; i++)
            {
                var pnode = map.GetDirectionGuideGrid(gx, gz, i);
                //var pnode = Adjacent[i];
                if (pnode == null || !pnode.IsObstacle) continue;

                var grid = pnode as DiamondGrid;
                if (!grid.Obj.IsDie && grid.Obj.Flag == eFlag)
                {
                    Enemy = grid.Obj;
                    st = HeroST.Fighting;//切换为战斗状态
                    this.ReduceTime(0.1f);
                    return;
                }
            }
        }
        else//远战
        {
            //在同行前方射程范围内查询敌人 
            int range = AtkRange;
            for (int i = range; i > 0; i--)
            {
                var g1 = map.GetGrid(gx + i, gz);

                if (g1 != null && g1.IsObstacle && g1.Obj.Flag == eFlag && !g1.Obj.IsDie)
                {
                    Enemy = g1.Obj;
                    st = HeroST.Fighting;//切换为战斗状态
                    this.ReduceTime(0.1f);
                    return;
                }


                var g2 = map.GetGrid(gx - i, gz);
                if (g2 != null && g2.IsObstacle && g2.Obj.Flag == eFlag && !g2.Obj.IsDie)
                {
                    Enemy = g2.Obj;
                    st = HeroST.Fighting;//切换为战斗状态
                    this.ReduceTime(0.1f);
                    return;
                }
            }
        }


        //使用联想寻敌 
        if (
            ContextFindEnemyOne(OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX +  1, ownerGrid.GredZ))|| //右格
            ContextFindEnemyOne(OwnerBattlefield.GridMap.GetGrid(ownerGrid.GredX - 1, ownerGrid.GredZ))//左格
            ) return; 
         
        AddToFindEnemy();//快速寻敌无果，加入到精准寻敌队列
    }

    /// <summary>
    /// 联想寻敌，检查一个格子，如果找到友军则返回true
    /// </summary>
    /// <param name="gd"></param>
    /// <returns></returns>
    bool ContextFindEnemyOne(DiamondGrid gd)
    {
        if (gd == null) return false;
        
        var friend = gd.Obj;
        if (
            friend == null||
            friend.Flag != Flag || friend.IsDie
            ) return false;

        if (friend.IsEnemyValid)//友军的敌人是有效目标
        {
            //使用这个敌人作为目标
            Enemy = friend.Enemy;
            SwapToMoveing();
            return true;
        }
             
        if (IsInContextFindEnemy(friend)) //不在我的联想寻敌列表中 （防止循环联想导致谁都不去寻敌）
        {
            friend.SetContextFindEnemyUnit(this);//联想寻敌
            ContextFindEnemying = true;//设置联想寻敌中标记
            return true;
        }
        

        return false;
    }

    /// <summary>
    /// 敌人发生变化时被调用
    /// </summary>
    void OnEnemyChanged()
    {
        if (ContextFindEnemyUnit1 != null) { ContextFindEnemyUnit1.Enemy = Enemy; ContextFindEnemyUnit1 = null; }
        if (ContextFindEnemyUnit2 != null) { ContextFindEnemyUnit2.Enemy = Enemy; ContextFindEnemyUnit2 = null; }

        ContextFindEnemying = false;//取消联想寻敌中标记
    }

    protected bool ContextFindEnemying = false;

    public void AddCacheSkill(Skill skill,  bool isTexing )
    {
        var info = new CacheSkillInfo() { skill = skill, isTexing = isTexing };

        if (skill.SkillType == SkillType.Shoudong)
            m_CacheSkills.Insert(0, info);//手动插队
        else
            m_CacheSkills.Add(info);//其它技能顺序排在后面
    }

    class CacheSkillInfo
    {
        public Skill skill;
        public bool isTexing; 
    }

    //缓存的技能释放队列 <技能，是否为特性触发>
    List<CacheSkillInfo> m_CacheSkills = new List<CacheSkillInfo>();

    void SwapToMoveing( )
    {
        st = HeroST.Moveing;//切换为移动状态
        ReduceTime(0.1f);

        if (IsJinshenModel) //当前使用的是近身模型
        {
            SwapJinYuan(true);//切换为远模型
            IsJinshenModel = false;
        }
    }

    protected void DoFighting(AI_AvatarShape Shape)
    {
        if (!CheckEnemy(Shape)) return;

        //检查是否需要切换为移动状态
        if (!AI_Math.WithinShot(this, Enemy, AtkRange))//进入射程
        {
            SwapToMoveing();
            return;
        }


        Enemy.HitMe(this);


        Skill SelSkill = null;

        //选择攻击技能 
        int bsCount = BishaSkills.Length;//必杀技总数  
        if (
            bsCount > 0 &&
            OwnerBattlefield.RandomInt(0, 99) < FinalBishaGL && //满足必杀技能释放概率
            ActionsLimit.CanReleaseBishaSkill//当前没有限制必杀技释放
            )
        {
            if (bsCount == 1)
                SelSkill = BishaSkills[0];
            else
            {
                var SkillCountWeight = SuperSkillCountWeight;
                skill_weight.Clear();
                EffectBuffManage.ForeachBuffs(
                    (buff) =>
                    {
                        if (buff.effect.Zhuangtai == SkillEffectBOOLST.AddBisha)
                        {
                            var skillid = buff.effect._2ndZhuangtai;
                            short addweight = (short)buff.effect._3rdZhuangtai;
                            if (SkillID2Index(SkillObjs, JinshenSkillID, skillid) >= 0)
                            {
                                skill_weight.Add(new KeyValuePair<int, short>(skillid, addweight));
                                SkillCountWeight += addweight;
                            }
                        }
                    }
                    );
                var addWeightCount = skill_weight.Count;
                var w = OwnerBattlefield.RandomInt(0, SkillCountWeight - 1);//随机一个总权重范围内的数
                short currw = 0;
                for (int i = 0; i < bsCount; i++)
                {
                    var sk = BishaSkills[i];
                    currw += sk.SuperSkillWeight;

                    if (addWeightCount > 0)//buff增加权重生效中
                        for (int i2 = 0; i2 < addWeightCount; i2++)
                        {
                            var addkv = skill_weight[i2];
                            if (addkv.Key == sk.id)
                            {
                                currw += addkv.Value;//增加权重
                                break;
                            }
                        }

                    if (w < currw) { SelSkill = sk; break; }//权重和随机数匹配，选择该技能
                }
            }

            if (SelSkill != null)
            {
                var trigger = SelSkill.SkillTrigger;
                if (trigger != null && !CheckBishaTrigger(trigger))
                {
                    SelSkill = null;//不满足必杀条件筛选时，选择的技能无效
                }
            }
        }


        if (SelSkill == null)//当前尚未选择必杀技
        {
            if (!ActionsLimit.CanReleasePutongSkill)//普通技能被限制释放
            {
                ReduceTime(WaitTime);
                return;
            }

            if (
                JinshenSkill != null && //配置了近身技
                AI_Math.IsAdjacentGird(ownerGrid.GredX, ownerGrid.GredZ, Enemy.ownerGrid.GredX, Enemy.ownerGrid.GredZ) //敌人相邻
                )
                SelSkill = JinshenSkill;//选择近身技 
            else
            {
                /*
                if (UnitType == UnitType.Soldiers)
                {
                    var sb = this as AI_Soldiers;
                    if (sb.Data.Type == SoldierType.Gong && AI_Math.GridDistance(this, Enemy) <= 6)
                        SelSkill = sb.Data.GongbingSkillObj;
                }

                if (SelSkill == null) */
                    SelSkill = SkillObjs[0];//选择主技能
            }
        }

        //技能加入缓存
        AddCacheSkill(SelSkill, false);
    }

    //获取侧后格子
    public void GetCehouGrids(out DiamondGrid g1, out  DiamondGrid g2, out  DiamondGrid g3)
    {
        var map = OwnerBattlefield.GridMap;

        //目标身后是否有空位
        DiamondGrid tGrid = Enemy.ownerGrid;
        var gid = map.GetDirectionGuideGridID(-dirx, -dirz);//获取屁股后面的格子ID
        var leftGID = gid - 1;
        var rightGID = gid + 1;
        if (leftGID < 3) leftGID = 8;
        if (rightGID > 8) rightGID = 3;

        g1 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, gid);
        g2 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, leftGID);
        g3 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, rightGID);

        if (map.IsInSide(g1)) g1 = null;//边区域不允许饶后
        if (map.IsInSide(g2)) g2 = null;//边区域不允许饶后
        if (map.IsInSide(g3)) g3 = null;//边区域不允许饶后
    }

    bool CheckBishaTrigger(SkillTriggerInfo trigger)
    {
        switch (trigger.BishaTrigger)
        {
            case ObjectTriggerEnum.None://无限制条件
                return true;
            case ObjectTriggerEnum.Cehou://侧后方攻击时
                {
                    DiamondGrid g1, g2, g3;
                    Enemy.GetCehouGrids(out g1, out g2, out g3);
                    var selfgrid = ownerGrid;

                    return selfgrid == g1 || selfgrid == g2 || selfgrid == g3;
                }
            case ObjectTriggerEnum.Gailv://概率调用
                return OwnerBattlefield.RandomInt(0, 99) < trigger.Int_SubBishaTrigger;
            case ObjectTriggerEnum.Hero://仅对英雄有效
                return Enemy.UnitType == UnitType.Hero;
            case ObjectTriggerEnum.Soldiers://仅对士兵有效
                return Enemy.UnitType == UnitType.Soldiers;
            default:
                {
                   return AI_TriggerChecker.RangeTriggerCheckOne(
                        this,
                        Enemy,
                        false,//是否为我方
                        trigger.BishaRangeTrigger,
                        false,//是否包含自己
                        trigger.IntArray_SubBishaTrigger,
                        trigger.Float_SubBishaTrigger,
                        HeroOrArmyEnum.HeroAndSoldiers
                        );
                }
        }
    }

    List<KeyValuePair<int, short>> skill_weight = new List<KeyValuePair<int, short>>();


    public void CreateShifaFX(AudioFxInfo fx)
    { 
        AI_CreateFX.CreateFX(CurrTime,fx,OwnerBattlefield, ownerGrid.WorldX, 0, ownerGrid.WorldZ, dirx, dirz); 
    }


    protected void SelectSkillTargets(Skill SelSkill, List<EffectHit> targetList, List<BoxHit> boxList,ref bool hasXingZhuangHit)
    {
        AI_SkillHit.DoSkill(SelSkill, this, targetList, boxList, out hasXingZhuangHit);

        if (
             SelSkill.AddSkillTrigger != null &&//存在附加触发条件
             CheckBishaTrigger(SelSkill.AddSkillTrigger)//检查副释放条件
            ) //执行副技能效果
        {
            foreach (var effect in SelSkill.AddTakeEffects)
                AI_SkillHit.BuildHitEffectList(
                    this, effect,
                    targetList,
                    ref hasXingZhuangHit
                );
        }

    }

    protected void LookAtTarget(List<EffectHit> targetList, List<BoxHit> boxList,bool hasXingZhuangHit)
    {
        AI_FightUnit lookUnit = Enemy;

        if (!hasXingZhuangHit)
        {
            if (targetList.Count > 0)
                lookUnit = targetList[0].unit;
            else if (boxList.Count > 0)
                lookUnit = boxList[0].unit;
        }
        //计算角色朝向
        if (lookUnit != this)
        {
            AI_Math.V2Dir(ownerGrid.WorldX, ownerGrid.WorldZ, lookUnit.ownerGrid.WorldX, lookUnit.ownerGrid.WorldZ, out dirx, out dirz);
            AI_Math.NormaliseV2(ref dirx, ref dirz);//归一化朝向
        }
    }

    
    /// <summary>
    /// 执行技能释放流程
    /// </summary>
    /// <param name="SelSkill">技能</param>
    /// <param name="isTexingchufa">是否为特性触发的该技能</param>
    protected void DoSkill(Skill SelSkill, bool isTexingchufa)
    {
        int skillidx = SkillID2Index(SkillObjs, JinshenSkillID, SelSkill.id); 
        var skillLevel = SkillLevels[skillidx];
        if (skillLevel < 1)
        {
            Wait(WaitTime);
            OwnerBattlefield.EffectTrackManage.SetAttachingUnlockTime(0.0001f);//解锁相机跟踪
            return;
        }


         List<EffectHit> targetList;
         List<BoxHit> boxList;
         bool hasXingZhuangHit;

        if (SelSkill.SkillType == SkillType.Shoudong)
        {
            var heroObj = this as AI_Hero;
            targetList = heroObj.ShoudongTargetList;
            boxList = heroObj.ShoudongBoxList;
            hasXingZhuangHit = heroObj.ShoudongXingZhuangHit;
        }
        else //需要选择目标
        {
            targetList = new List<EffectHit>();
            boxList = new List<BoxHit>();
            hasXingZhuangHit = false;//是否包含形状类的伤害

            SelectSkillTargets(SelSkill, targetList, boxList, ref   hasXingZhuangHit);
        }

        bool isBeidong = SelSkill.SkillType == SkillType.BeiDongChiXu;//是否是被动技

        if (targetList.Count < 1 && SelSkill.SkillType != SkillType.Shoudong)//没有适合的攻击目标
        {
            if (!isBeidong)
            {
                Wait(0.3f);
                OwnerBattlefield.EffectTrackManage.SetAttachingUnlockTime(0.0001f);//解锁相机跟踪
            }

            return;
        }

        AI_Hero hero = (this as AI_Hero);

        if (!isBeidong)
        {
            LookAtTarget(targetList, boxList, hasXingZhuangHit);

            //检查当前技能动作是否和模型匹配
            if (SelSkill == JinshenSkill)//使用的是近身技能
            {
                if (!IsJinshenModel) //当前使用的是远程模型
                {
                    SwapJinYuan(false);//切换为远模型
                    IsJinshenModel = true;
                }
            }
            else//使用的是远技
            {
                if (IsJinshenModel) //当前使用的是近身模型
                {
                    SwapJinYuan(true);//切换为远模型
                    IsJinshenModel = false;
                }
            }

            //播放攻击动作
            PlayHitAction(SkillAtks[skillidx], dirx, dirz);

            //播放触发特效
            if (isTexingchufa)
            {
                var fx = SelSkill.ChufaAudioFxObj;
                CreateShifaFX(fx);
            }

            //播放施法特效
            {
                var fx = SelSkill.ShifaAudioFxObj;
                CreateShifaFX(fx);
            }

            //头顶飘技能名
            if (hero != null)
            {
                DPKey_PopupText.textType tp = DPKey_PopupText.textType.None;
                if (SelSkill.SkillType == SkillType.Unique)
                    tp = DPKey_PopupText.textType.Bisha;
                else if (SelSkill.SkillType == SkillType.Texing)
                    tp = DPKey_PopupText.textType.Texing;
                else if (SelSkill.SkillType == SkillType.Shoudong)
                    tp = DPKey_PopupText.textType.Shoudong;

                if (tp != DPKey_PopupText.textType.None)
                    hero.OwnerArmySquare.OverheadPanel.AddKey_PopupText(CurrTime, SelSkill.Name, tp);
            }
        }

        //创建效果追踪器
        CreateEffectTrack(SelSkill, skillLevel, targetList);
        CreateBoxTrack(SelSkill, skillLevel, boxList);


        if (
            SelSkill.SkillType == SkillType.Shoudong &&//技能是手动类型
            this.Flag == ArmyFlag.Attacker //左军释放的技能 
            )
        {
            //恢复角色亮度
            hero.Shape.RH.AddKey_BrightnessTo(MakingUpFunc.SlowDown, CurrTime, HightBrightness, NormalBrightness, 0.3f);

            //隐藏聚光
            //hero.Spotlight.AddKey_Alpha(MakingUpFunc.SlowDown, CurrTime, 1, 0, 0.3f);
            //float tmpDirX, tmpDirZ;
            // hero.Spotlight.AddKey_MoveTo(CurrTime, 999999, 0, 999999, 0, 10000, out tmpDirX, out tmpDirZ);
            OwnerBattlefield.WorldActor.AddKey_Disable(CurrTime, hero.Spotlight.ID); 

            //设置附带解锁相机时间
            OwnerBattlefield.EffectTrackManage.SetAttachingUnlockTime(SelSkill.AtkTime);
        }


        if (hero != null)
        {
            switch (SelSkill.SkillType)
            {
                case SkillType.Shoudong:
                    OwnerBattlefield.Event.PostShoudongRelease(hero,SelSkill);
                    break;
                case SkillType.Texing:
                    OwnerBattlefield.Event.PostTexingRelease(hero,SelSkill);
                    break;
                case SkillType.Unique:
                    OwnerBattlefield.Event.PostBishaRelease(hero,SelSkill);
                    break;
                case SkillType.General:
                    OwnerBattlefield.Event.PostGeneralRelease(hero,SelSkill);
                    break; 
            }
        }

        if (!isBeidong)
        {
            //AI冷却
            ReduceTime(SelSkill.AtkTime);

            //冲锋阶段的阵停止移动，直到技能释放完
            OwnerArmySquare.SetHeroWait2MoveTime(CurrTime);
        }
    }


    void CreateBoxTrack(Skill SelSkill, short skillLevel, List<BoxHit> boxList)
    {
        //非飞行物的效果追踪器，多目标共用一个
        Dictionary<int, AI_EffectTrack_Hit> HitTracks = new Dictionary<int, AI_EffectTrack_Hit>();

        //创建伤害效果追踪器  

        foreach (var hit in boxList)
        {
            var box = hit.boxInfo;
            var target = hit.unit;
            AI_EffectTrack effectTrack = null;
            if (
                (box.SkillArriveObj != null && box.SkillArriveObj.ArriveType == SkillArriveInfo.ArriveTypeEnum.Fly) &&//是一个飞行物
                !target.IsDie//目标活着
                )
            {
                switch (box.SkillRange.RangeType)
                {
                    case RangeTypeEnum.Grid:
                    case RangeTypeEnum.GridFlyHit://指向格子 
                        effectTrack = new AI_EffectTrack_FlyToGrid();
                        break;
                    default://指向目标
                        effectTrack = new AI_EffectTrack_FlyToObj();
                        break;
                }
            }
            else//不是飞行物 
            {
                if (
                (box.SkillArriveObj != null && box.SkillArriveObj.ArriveType == SkillArriveInfo.ArriveTypeEnum.Angle) &&//是一个角延迟伤害
                !target.IsDie//目标活着
                )//角速度伤害
                { 
                    var angleHit =  new AI_EffectTrack_Hit();//创建效果追踪器
                    effectTrack =angleHit;
                    angleHit.HitTime = box.SkillArriveObj.FeichuYanchi + (float)hit.angleOrder * box.SkillArriveObj.ArriveTime;
                }
                else //常规的延迟伤害
                {
                    if (HitTracks.ContainsKey(box.SkillBoxID))
                    {
                        HitTracks[box.SkillBoxID].AddDefender(target);//加入防御者
                    }
                    else
                    {
                        effectTrack = new AI_EffectTrack_Hit();//创建效果追踪器
                        HitTracks.Add(box.SkillBoxID, effectTrack as AI_EffectTrack_Hit);
                    }
                }
            }
            if (effectTrack != null)
            {
                effectTrack.Attack = this;
                effectTrack.Defender = target;
                effectTrack.skill = SelSkill;
                effectTrack.SkillEffectDo = new SkillBoxDo(box);
                effectTrack.skillLevel = skillLevel;//技能等级
                effectTrack.IsGrazes = false;

                //图形类的算擦伤
                if (box.SkillRange.RangeType == RangeTypeEnum.Shape)
                    effectTrack.IsGrazes = true;

                if (box.SkillRange.RangeType == RangeTypeEnum.GridFlyHit || //朝格子飞行且飞行过程中造成伤害的
                    box.SkillRange.RangeType == RangeTypeEnum.Grid //指向格子的 
                    )
                    effectTrack.IsGrazes = true;//算擦伤 

                //死亡效果
                if (SelSkill.SkillType == SkillType.Texing || SelSkill.SkillType == SkillType.Unique || SelSkill.SkillType == SkillType.Shoudong)
                    effectTrack.dieEffect = DieEffect.Baozha;
                else
                    effectTrack.dieEffect = DieEffect.Putong;


                OwnerBattlefield.EffectTrackManage.AddEffectTrack(OwnerBattlefield, effectTrack);
            }
        }
    }


    public void CreateEffectTrack(Skill SelSkill, short skillLevel, List<EffectHit> targetList)
    {
        //非飞行物的效果追踪器，多目标共用一个
        Dictionary<int, AI_EffectTrack_Hit> HitTracks = new Dictionary<int, AI_EffectTrack_Hit>();

        //创建伤害效果追踪器 
        foreach (var hit in targetList)
        {
            var target = hit.unit;
            //var effectList = targetList[target];

            if (target.IsDie) continue;//目标活着

            var effect = hit.effectInfo;
            AI_EffectTrack effectTrack = null;
            if (
                (effect.SkillArriveObj != null && effect.SkillArriveObj.ArriveType == SkillArriveInfo.ArriveTypeEnum.Fly) //是一个飞行物
                )
            {
                switch (effect.SkillRange.RangeType)
                {
                    case RangeTypeEnum.Grid:
                    case RangeTypeEnum.GridFlyHit://指向格子 
                        effectTrack = new AI_EffectTrack_FlyToGrid();
                        break;
                    default://指向目标
                        effectTrack = new AI_EffectTrack_FlyToObj();
                        break;
                }
            }
            else//不是飞行物 
            {
                if (
                  (effect.SkillArriveObj != null && effect.SkillArriveObj.ArriveType == SkillArriveInfo.ArriveTypeEnum.Angle)  //是一个角延迟伤害
                 
                  )//角速度伤害
                {
                   
                    var angleHit = new AI_EffectTrack_Hit();//创建效果追踪器
                    effectTrack = angleHit;
                    angleHit.HitTime = effect.SkillArriveObj.FeichuYanchi + (float)hit.angleOrder * effect.SkillArriveObj.ArriveTime;
                  
                }
                else
                {
                    if (HitTracks.ContainsKey(effect.EffectID))
                    {
                        HitTracks[effect.EffectID].AddDefender(target);//加入防御者
                    }
                    else
                    {
                        effectTrack = new AI_EffectTrack_Hit();//创建效果追踪器
                        HitTracks.Add(effect.EffectID, effectTrack as AI_EffectTrack_Hit);
                    }
                }
            }
            if (effectTrack != null)
            {
                effectTrack.Attack = this;
                effectTrack.Defender = target;
                effectTrack.skill = SelSkill;
                effectTrack.SkillEffectDo = new SkillEffectDo(effect);
                effectTrack.skillLevel = skillLevel;//技能等级
                effectTrack.IsGrazes = false;

                //图形类的算擦伤
                //if (effect.SkillRange.RangeType == RangeTypeEnum.Shape)
                //    effectTrack.IsGrazes = true;

                if (
                    //effect.SkillRange.RangeType == RangeTypeEnum.GridFlyHit || //朝格子飞行且飞行过程中造成伤害的
                    effect.SkillRange.RangeType == RangeTypeEnum.Grid //指向格子的 
                    )
                    effectTrack.IsGrazes = true;//算擦伤 

                //死亡效果
                if (SelSkill.SkillType == SkillType.Texing || SelSkill.SkillType == SkillType.Unique || SelSkill.SkillType == SkillType.Shoudong)
                    effectTrack.dieEffect = DieEffect.Baozha;
                else
                    effectTrack.dieEffect = DieEffect.Putong;


                OwnerBattlefield.EffectTrackManage.AddEffectTrack(OwnerBattlefield, effectTrack);
            }
        }
    }

    /// <summary>
    /// 立即移动到相邻格，一般是用于和某单位交换格子
    /// </summary>
    public void MoveTo(DiamondGrid grid, AI_AvatarShape Shape, DPActor_Base OverheadPanel)
    { 
        if (IsJinshenModel)//当前使用的是近身模型
        {
            SwapJinYuan(true);//切换为远模型
            IsJinshenModel = false;
        }

        st = HeroST.Moveing;//状态强行变为移动中

        if (UnitType == UnitType.Soldiers)
            m_CacheSkills.Clear();//士兵强行清除当前缓存未释放的技能，让位后缓存技能的目标可能不正确，影响视觉效果

        //处理关键帧以及时间损耗
        var tSpeed = FinalSpeed;//使用自身的移动速度 
        float mvspeed = tSpeed * DiamondGridMap.WidthSpacingFactor;
        float t = Shape.RH.AddKey_MoveTo(
            CurrTime,
            ownerGrid.WorldX, ownerGrid.WorldZ,
            grid.WorldX, grid.WorldZ,
            mvspeed,
            out dirx, out dirz
            );

        if (OverheadPanel != null)
            OverheadPanel.AddKey_MoveTo(
                CurrTime,
                ownerGrid.WorldX, ownerGrid.WorldZ,
                grid.WorldX, grid.WorldZ,
                mvspeed,
                out dirx, out dirz
                );

        ReduceTime(t);

        //处理格子地图 
        lastGrid = ownerGrid;
        ownerGrid = grid;
        grid.Obj = this;
    }

    protected bool DoCacheSkill()
    {
        if (m_CacheSkills.Count < 1) return false;
        var info = m_CacheSkills[0];
        DoSkill(
            info.skill, 
            info.isTexing
            );
        m_CacheSkills.RemoveAt(0);
        return true;
    }

    /// <summary>
    /// 是否为近战部队
    /// </summary>
    public bool IsMelee { get { return AtkRange <= 3; } } 
    public  virtual  bool IsDie { get { return CurrHP <= 0; } }

    /// <summary>
    /// 敌人是否有效
    /// </summary>
    public bool IsEnemyValid
    {
        get
        {
            return Enemy != null && !Enemy.IsDie;
        }
    }

    public HeroST _st = HeroST.None;//状态 
    public HeroST st {
        get { return _st; }
        set { _st = value; }
    } 
    public float dirx;//当前朝向x
    public float dirz;//当前朝向z 

    public virtual DiamondGrid ownerGrid {
        get { return _ownerGrid; }
        set { _ownerGrid = value; }
    }
      DiamondGrid _ownerGrid;//所属地块

      public virtual AI_FightUnit Enemy
    {
        get { return m_Enemy; }
        set { m_Enemy = value; OnEnemyChanged(); }
    }
      AI_FightUnit m_Enemy = null;
   
    public float WaitTime;//卡死时的等待时间

    

    /// <summary>
    /// 属性值已变更，主要指那些受装备，技能影响的属性
    /// </summary>
    public virtual void OnAttrChanged(){}

    
    /// <summary>
    /// 根据技能id,计算技能索引号
    /// </summary>
    public static int SkillID2Index(Skill[] SkillObjs,int jinShenID, int skillID)
    {
        int len = SkillObjs.Length;
        for(int i=0;i<len;i++)
        {
            var obj = SkillObjs[i];
            if (obj!=null&& obj.id == skillID) return i;
        }

        if (skillID == jinShenID) return 0;

        return -1;
    }


    /// <summary>
    /// 根据技能id获取技能动作名
    /// </summary>
    public string GetSkillAtk(int skillID)
    {
        var idx = SkillID2Index(SkillObjs,JinshenSkillID, skillID);
        if (idx < 0) return null;
        return SkillAtks[idx];
    }

    public AI_ArmySquare OwnerArmySquare;//归属哪个方阵 

    /// <summary>
    /// 设置借助本单位联想寻敌的单位
    /// </summary>
    public void SetContextFindEnemyUnit(AI_FightUnit unit)
    {
        if (ContextFindEnemyUnit1 == null) { ContextFindEnemyUnit1 = unit; return; }
        if (ContextFindEnemyUnit2 == null) { ContextFindEnemyUnit2 = unit; return; }
        throw new Exception("SetContextFindEnemyUnit 没有联想空位！");
    }


    /// <summary>
    /// 检查某单位是否在联想队列中
    /// </summary>
    public bool IsInContextFindEnemy(AI_FightUnit unit)
    {
        return ContextFindEnemyUnit1 == unit || ContextFindEnemyUnit2 == unit;
    }

    AI_FightUnit ContextFindEnemyUnit1 = null;//联想寻敌
    AI_FightUnit ContextFindEnemyUnit2 = null;//联想寻敌


    protected abstract void OnDie(AI_FightUnit attacker,float time);


    void _OnDie(AI_FightUnit attacker, float time)
    {
        //结束冲锋
        OwnerArmySquare.ToIndependentAI();

        //取消关联寻敌
        cancelContextFindEnemy(ref ContextFindEnemyUnit1);
        cancelContextFindEnemy(ref ContextFindEnemyUnit2);

        OnDie(attacker,time);

        //抛出阵杀敌事件
        if (attacker!=null)
            OwnerBattlefield.Event.PostSquareKill(attacker.OwnerArmySquare, this);
    }


    //取消关联寻敌
    void cancelContextFindEnemy(ref AI_FightUnit unit)
    {
        if (unit == null||unit.IsDie) return;
        unit.DoFindEnemyFast();
        unit = null;
    }


    protected bool MoveingCheckEnemy(AI_AvatarShape Shape, DPActor_OverheadPanel OverheadPanel)
    {
        if (IsEnemyValid) //当前存在有效的目标
            return true;

        if (
            !ContextFindEnemying &&//当前没有处于联想寻敌状态
            !IsInFindEnemyQueue//当前也没有在精准寻敌队列
            )
        {
            DoFindEnemyFast();//快速寻敌
            if (IsEnemyValid) return true;//已经找到了有效的目标
        }

        /*
        if (waitd)//已经等待过了
        {
            st = HeroST.Wait;
            Wait(WaitTime);
        }
        else//没有等待过
        {
            //朝当前行进方向移动
            var grid = OwnerBattlefield.GridMap.GetDirectionGuideGrid(ownerGrid.GredX, ownerGrid.GredZ, dirx, dirz);
            if (grid == null || grid.IsObstacle)//被堵死
            {
                st = HeroST.Wait;
                Wait(WaitTime);
            }
            else //移动进新格
            {
                MoveSwapGrid(grid, Shape, OverheadPanel);
            }
        }*/


        return false;
    }


    /// <summary>
    /// 行为限制器
    /// </summary>
    public abstract AI_Limit ActionsLimit { get; }

    protected abstract void PlayExplodedDieEffect(AI_FightUnit attacker);

    protected abstract void PlayEscapeEffect();

    protected abstract void PlayCommonDieEffect(AI_FightUnit attacker);

    public abstract AI_FightUnit FindEnemy(bool findSoldiers);
    public abstract AI_Battlefield OwnerBattlefield { get; }


    /// <summary>
    /// 执行AI
    /// </summary>
    public abstract void DoAI();

    

    public abstract void Wait(float t);
    public abstract ArmyFlag Flag { get; }
    public abstract UnitType UnitType { get; }

    /// <summary>
    /// 攻击范围
    /// </summary>
    public abstract int AtkRange { get; }

    public abstract float FinalSpeed { get; }
    public abstract int FinalMaxHP { get; }
    public abstract int FinalBishaGL { get; }//必杀释放概率

    public abstract float FinalNu { get; }

    public abstract void HitMe(AI_FightUnit enemy);

    /// <summary>
    /// 播放攻击动作
    /// </summary>
    public abstract void PlayHitAction(string atk, float dirx, float dirz);

    public abstract void SwapJinYuan(bool isYuan);
    /*
    public abstract float FinalMaxHP { get; }//最终生命上限
    public abstract float FinalWuLi { get; }//最终武力
    public abstract float FinalNu { get; }//最终怒
    public abstract float FinalTiLi { get; }//最终体力
    public abstract float FinalAddFYL { get; }//最终增加防御率 
    public abstract float FinalAddBSGL { get; }//最终增加必杀概率
    */

    public abstract Skill[] BishaSkills { get; }///获取必杀技队列
    public abstract Skill[] SkillObjs { get; } ///技能列表

    public abstract Skill JinshenSkill { get; }//近身技

    public abstract short ModelRange { get; }
    
    public abstract string[] SkillAtks { get; }//获取技能动作
    public abstract short[] SkillLevels { get; }//技能等级

    public abstract void MountActor(DPActor_Base actor);

    public abstract short SuperSkillCountWeight { get; }//必杀技总权重
    public abstract int Level { get; }//等级
    public abstract AAttr Speed { get; }//移动速度
    public abstract AAttr MaxHP { get; }//生命上限
    public abstract AAttr WuLi { get; }//武力
    public abstract AAttr Zhili { get; }
    public abstract AAttr Nu { get; }//怒
    public abstract AAttr TiLi { get; }//体力
    public abstract AAttrLight AddFYL { get; }//增加防御率 
    public abstract AAttrLight AddBSGL { get; }//增加必杀概率

    public abstract int ID{get;}

    public abstract int JinshenSkillID { get; }


    public abstract AI_EffectBuffManage EffectBuffManage { get; }//buff管理器
     
    public int CurrHP=100;//当前生命值

    public bool IsJinshenModel = false;//当前是否用了近身模型
    protected DiamondGrid lastGrid = null;//上一步经过的格子
    public bool IndentPos = false;//开场时是否向前缩进位置

    protected AI_FightUnit m_HitMeEnemy = null;//当前正在打我的敌人

    //protected bool waitd = false;
}


/*
 private static int SortTestObj2Compare(SortTestObj2 obj1, SortTestObj2 obj2)
        {
            int res = 0;
            if ((obj1 == null) && (obj2 == null))
            {
                return 0;
            }
            else if ((obj1 != null) && (obj2 == null))
            {
                return 1;
            }
            else if ((obj1 == null) && (obj2 != null))
            {
                return -1;
            }
            if (obj1.Code > obj2.Code)
            {
                res = 1;
            }
            else if (obj1.Code < obj2.Code)
            {
                res = -1;
            }
            return res;
        }
 */