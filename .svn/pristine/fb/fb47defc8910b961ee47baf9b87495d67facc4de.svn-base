using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public partial class AI_Soldiers : AI_FightUnit
{
    //public float m_BirthTime;//诞生时间  
    //public readonly AI_ArmySquare OwnerArmySquare;//归属哪个方阵   
    public AI_AvatarShape Shape = null;//外型  
  
    public override AI_Battlefield OwnerBattlefield { get { return OwnerArmySquare.OwnerBattlefield; } }
     
    public override ArmyFlag Flag { get { return OwnerArmySquare.flag; } }

    public override Skill[] SkillObjs { get { return Data.SkillObjs; } } ///技能列表
    public override short ModelRange { get { return Data.ModelRange; } }
    public override UnitType UnitType { get { return UnitType.Soldiers; } } 

    public override int FinalBishaGL { get { return OwnerArmySquare.FnBishaGL; } } //必杀释放概率

    public override int FinalMaxHP { get { return (int)OwnerArmySquare.FnMaxHP; } }

    public override float FinalNu { get { return OwnerArmySquare.FnNu; } }

    public override AI_Limit ActionsLimit { get { return OwnerArmySquare.ActionsLimit; } }

    public override short SuperSkillCountWeight { get { return Data.SuperSkillCountWeight; } }//必杀技总权重
    public override float FinalSpeed { get { return OwnerArmySquare.FnSpeed; } }
    public override AAttr Speed { get { return OwnerArmySquare._Speed; } }//移动速度
    public override AAttr MaxHP { get { return OwnerArmySquare._MaxHP; } }//生命上限

    public override AAttr WuLi { get { return OwnerArmySquare._WuLi; } }//武力
    public override AAttr Zhili { get { return OwnerArmySquare._Zhili; } }
    public override AAttr Nu { get { return OwnerArmySquare._Nu; } }//怒
    public override AAttr TiLi { get { return OwnerArmySquare._TiLi; } }//体力
    public override AAttrLight AddFYL { get { return OwnerArmySquare._AddFYL; } }//增加防御率
    public override AAttrLight AddBSGL { get { return OwnerArmySquare._AddBSGL; } }

    public override AI_EffectBuffManage EffectBuffManage { get { return OwnerArmySquare.EffectBuffManage; } }//buff管理器

    public override string[] SkillAtks { get { return Data.SkillAtks; } }//获取技能动作

    public override void OnAttrChanged() {
        base.OnAttrChanged();
        OwnerArmySquare.UpdateDyAttrs();
    }

    public override void Wait(float t)
    {
        ReduceTime(Shape.RH.AddKey_Wait(CurrTime, t));
    }

    public override void MountActor(DPActor_Base actor)
    {
        actor.AddKey_SetParent(CurrTime, Shape.RH.ID);
    }

    public AI_Soldiers(
        //float birthTime, 
        AI_ArmySquare ownerArmySquare, float dirx,float dirz,bool indent)
    {
        //m_BirthTime = birthTime; 
        OwnerArmySquare = ownerArmySquare; 
        this.dirx = dirx;
        this.dirz = dirz;
        IndentPos = indent;
        InitAttrs();
    }

    void InitAttrs()
    {
        WaitTime = SData_FightKeyValue.Single.ArmyWaitTime;
        CurrHP = (int)OwnerArmySquare.FnMaxHP;
        _Data = OwnerArmySquare.ArmyData;
    }

   
    AI_FightUnit tmpEnemy = null;


    public override void PlayHitAction(string atk, float dirx, float dirz)
    {
        Shape.RH.AddKey_PlayAct(CurrTime, atk, false, 0.1f, dirx, dirz);
    }

    public override Skill JinshenSkill { get { return _Data.JinshenSkillObj; } }//近身技

    public override void SwapJinYuan(bool isYuan)
    {
        Shape.RH.AddKey_SwapJinYuan(CurrTime, isYuan);
    }

    static short[] _skLevels = new short[5]{1,1,1,1,1};
    public override short[] SkillLevels   {  get { return _skLevels; }  }//技能等级



    protected void DoMoveing()
    {

        AI_FightUnit currEnemy = Enemy;
   
        if (!MoveingCheckEnemy(Shape, null))
        {
            if (tmpEnemy == null || tmpEnemy.IsDie) //寻找一个临时敌人
            {
                tmpEnemy = FindEnemy(false);
            }

            currEnemy = tmpEnemy;
        }
        else
        {
            currEnemy = Enemy;
            tmpEnemy = null;//临时敌人失效

            //检查是否需要切换为战斗状态 
            if (AI_Math.WithinShot(this, currEnemy, Data.AtkRange))//进入射程
            {
                st = HeroST.Fighting;//切换为战斗状态
                ReduceTime(Shape.RH.AddKey_Wait(CurrTime, WaitTime));
                return;
            }
        }


        if (!ActionsLimit.CanMove || currEnemy==null)//当前被限制行进
        {
            ReduceTime(Shape.RH.AddKey_Wait(CurrTime, WaitTime));
            return;
        } 

        var ownerBattlefield = OwnerBattlefield;

        //  DiamondGrid tGrid = ownerBattlefield.GridMap.GetGrid(ownerGrid.GredX + (OwnerArmySquare.flag == ArmyFlag.Attacker ? 1 : -1), ownerGrid.GredZ);//Enemy.ownerGrid;
        DiamondGrid tGrid = currEnemy.ownerGrid;

        if (tGrid != null)
        {
            bool isRound;//是否绕行了
            AI_FightUnit blockEnemy, blockFriend;

            DiamondGrid newGrid = ownerBattlefield.GridMap.MoveOneStep( ModelRange,Data.DirectionGuideType, ownerGrid, lastGrid, tGrid, out isRound, out blockEnemy, out blockFriend);


            
            if (newGrid != null)
            {
                MoveSwapGrid(
                    newGrid, Shape,
                    OwnerArmySquare.QizhiOwner==this?OwnerArmySquare.QizhiActor:null  
                    );
 
                /*
                if(
                    isRound&&//产生了绕行
                    blockFriend!=null&&//存在挡路的友军
                    blockFriend.st== HeroST.Moveing&&//挡路友军处于移动状态
                    gz == blockFriend.ownerGrid.GredZ//挡路的友军在同行
                    )
                {
                    //禁止绕过移动状态的友军， 等待片刻，打断移动帧
                    ReduceTime(Shape.RH.AddKay_Wait(CurrTime, 0.2f));
                    return;
                }
                */


                 
                return;
            } 
            else
            {
                if (blockEnemy != null)
                {
                    Enemy = blockEnemy;//改变攻击目标并进入战斗
                    st = HeroST.Fighting;
                     
                    ReduceTime(Shape.RH.AddKey_Wait(CurrTime, 0.1f));//稍微等待一下再开战 

                    return;
                }
            } 
        }

        //通路被堵死了  
        st = HeroST.Wait;
        ReduceTime(Shape.RH.AddKey_Wait(CurrTime, WaitTime));
    }


    /// <summary>
    /// 常规死亡效果
    /// </summary>
    protected override void PlayCommonDieEffect(AI_FightUnit attacker)
    {
        //播放死亡特效
        if (Data.DeadAudioFxObj != null)
        {
            AI_CreateFX.CreateFX(OwnerBattlefield.TotalLostTime, Data.DeadAudioFxObj, this, dirx, dirz);
        }

        Shape.PlayCommonDieEffect(attacker, this);
        //Shape.PlayExplodedDieEffect(attacker, this);
    }


    public override int ID { get { return Shape.RH.ID; } }

    public ArmyInfo Data { get { return _Data; } }
    ArmyInfo _Data;

    //创建演示层角色
    public void CreateDPActors(float time)
    {
        Shape = new AI_AvatarShape(
            OwnerArmySquare.OwnerBattlefield, time,
            Data.ZiyuanBaoming,
            Data.ZiyuanBaomingZuoqi,
            ModleMaskColor.N, //Data.YanmaYanse,
            (byte)(OwnerArmySquare.flag== ArmyFlag.Attacker? 0:1),
             !string.IsNullOrEmpty(Data.ZiyuanBaomingZuoqi),
            false,
            Data.ID
            );
    }

    /// <summary>
    /// 播放攻击动画
    /// </summary>
    /// <param name="hitAtkTime">攻击动作时间</param>
    /*
    public void PlayHitAnimation(float skillAtkTime,float hitAtkTime,AIDirection dir)
    {
        if (
            st != HeroST.Fighting||//当前不在战斗状态
            !CanInsertAction
            ) 
            return;//忽略本次播放

        float waitTime = skillAtkTime - hitAtkTime;//可以用于打乱攻击的时间差
        float bfb = (float)AI_Battlefield.Single.RandomInt(0, 100)/100.0f;
        float startWait = Math.Min(waitTime,0.3f)* bfb;
       
        ReduceTime(startWait);//随机一个发招时间

        ReduceTime(Shape.AddKay_PlayAct(CurrTime, "hit1", false, hitAtkTime, dir));

        float endWait = waitTime - startWait;
        if (endWait>0) ReduceTime(Shape.AddKay_Wait(CurrTime, endWait));//创建延迟帧
    }*/

    /*
    public void CorrectDir()
    {
        if (dir != OwnerArmySquare.Dir)
        {
            dir = OwnerArmySquare.Dir;
            Shape.AddKay_PlayAct(CurrTime, "run", true, 0.1f, dir); //设定朝向 
        }
    }*/
    protected override void PlayExplodedDieEffect(AI_FightUnit attacker)
    {
        //播放死亡特效
        if (Data.DeadAudioFxObj != null)
        {
            AI_CreateFX.CreateFX(OwnerBattlefield.TotalLostTime, Data.DeadAudioFxObj, this, dirx, dirz);
        }

        Shape.PlayExplodedDieEffect(attacker, this);
    }

    protected override void PlayEscapeEffect()
    {
        Shape.PlayEscapeEffect(this);
    }

    protected override void OnDie(AI_FightUnit attacker,float time)
    {

        //统计杀兵总数
        if (attacker != null && attacker.UnitType== UnitType.Hero)
        {
            (attacker as AI_Hero).AddKillSoldiersCount(1);
        }

        OwnerArmySquare.SoldiersCount--;

        //抛出士兵为0事件
        if (OwnerArmySquare.SoldiersCount == 0)
            OwnerBattlefield.Event.PostArmyZero(OwnerArmySquare);

        //士兵数首次小于事件
        if(OwnerArmySquare.triggerMinSoldiersNum.CheckValue(OwnerArmySquare.SoldiersCount))
            OwnerBattlefield.Event.PostSoldiersFirstLower(OwnerArmySquare);

        //自己是抗旗的兵
        if(OwnerArmySquare.QizhiOwner==this)
        {
            //重新找抗旗的人
            OwnerArmySquare.FindQizhiOwner(ownerGrid.WorldX, ownerGrid.WorldZ);

            if(OwnerArmySquare.QizhiOwner!=null)//找到了抗旗的人
            {
                var og = OwnerArmySquare.QizhiOwner.ownerGrid;
               // OwnerArmySquare.QizhiActor.AddKey_SetParent(time, OwnerArmySquare.QizhiOwner.Shape.RH.ID);
                float tmp; OwnerArmySquare.QizhiActor.AddKey_MoveTo(time, og.WorldX, og.WorldZ, og.WorldX, og.WorldZ, 1000, out tmp, out tmp);
            }else //没有人可以扛旗子了
            {
                OwnerArmySquare.QizhiActor.AddKey_DestroyInstance(time);
            }
        } 
    }

    public override int Level { get { return OwnerArmySquare.BaseAttr.soldiersLevel; } }//等级


    //被魅惑后的处理
    public void MeiHuo(float time, AI_FightUnit Attacker)
    {
        if (IsDie) return;

        //改变阵营
        OwnerArmySquare.SoldiersCount--;
        OwnerArmySquare.soldiers.Remove(this);
        OwnerArmySquare.ChargeKeyUnits.Remove(this);
        OwnerArmySquare.FindEnemyKeyUnits.Remove(this);

        Attacker.OwnerArmySquare.SoldiersCount++;
        OwnerArmySquare.soldiers.Add(this);

        //创建改变阵营关键帧
        Shape.RH.AddKey_SetFlag(time, Attacker.Flag);

        //丢失寻敌目标
        this.Enemy = null;

        OwnerArmySquare = Attacker.OwnerArmySquare;//改变所属阵营
        var newFlag = this.Flag;

        //所有当前以我为目标的角色丢失寻敌目标
        var it = OwnerBattlefield.ArmySquareListEnumerator;
        while(it.MoveNext())
        {
            var square = it.Current;
            if (square.flag != newFlag) continue;//现在不是同阵营的
            if (square.hero.Enemy == this) square.hero.Enemy = null;

            foreach(var sb in square.soldiers) if (sb.Enemy == this) sb.Enemy = null;
        }
    }

    public override void HitMe(AI_FightUnit enemy)
    {
        //处理反击逻辑
        if (
            enemy.IsMelee &&//敌人是近战单位
            st != HeroST.Fighting//当前不处于战斗状态
            )
        {
            Enemy = enemy;//以攻击我的人作为目标
            st = HeroST.Fighting;//立即进入战斗状态
            return;
        }

        if (m_HitMeEnemy == null || m_HitMeEnemy.IsDie || m_HitMeEnemy.UnitType != UnitType.Soldiers)
            m_HitMeEnemy = enemy;
    }
    /*
    public void Die(AIDirection dieDir)
    { 
        float mapPosX, mapPosZ;
        AI_Math.BlockToMap(posx, posz, out mapPosX, out  mapPosZ);

        //马的死亡动作播放
        if (Shape.horse!=null)
        {
          
            float moveOffset = (float)AI_Battlefield.Single.RandomInt(400,800)/100.0f   ;
            float mt = moveOffset /5.0f; //取得移动时间

             if(dieDir== AIDirection.Left)  moveOffset = -moveOffset;
             moveOffset *= AI_Math.MapScale;

            float t = CurrTime;

            

            //马的位移
            float moveTime = Shape.horse.AddKey_ToX( 
                MakingUpFunc.SlowDown,
                t,
                mapPosX,  
                mapPosX + moveOffset,
                mt
                );

            Shape.horse.AddKay_PlayAct(t, "run", true, moveTime, dieDir);

            //马的渐隐
            Shape.horse.AddKey_Alpha(MakingUpFunc.Linear, t, 1, 0, moveTime);

            t += moveTime;

            //马的销毁
            Shape.horse.AddKey_DestroyInstance(t);
        }

        {
            float t = CurrTime;



            //float trowHeight = (float)AI_Battlefield.Single.RandomInt(20, 50) / 100.0f;
            float trowHeight = (float)AI_Battlefield.Single.RandomInt(50, 100) / 100.0f;

            float trowTime = trowHeight * 0.9f;//抛射总时间
            
            trowHeight*= AI_Math.MapScale;

            //人物x方向位移
            {
                float offsetX = trowHeight * 3f;
                if (dieDir == AIDirection.Left) offsetX = -offsetX;
                Shape.role.AddKey_ToX(
                     MakingUpFunc.SlowDown,
                    t,
                    mapPosX,
                    mapPosX + offsetX,
                    trowTime
                    );
            }

            //人物死亡动作播放
            Shape.role.AddKay_PlayAct(t, "die", false, trowTime, AI_Math.ReverseDir(dieDir));

            float hxs1 =  5.0f;//高度弹跳衰减系数
            float hxs2 = 5.0f;//高度弹跳衰减系数

            float th1 = trowHeight / hxs1;
            float th2 = th1 / hxs2;

            float sumH = trowHeight + th1 + th2;

            float t1 = trowTime * (trowHeight / sumH) / 2;
            float t2 = trowTime * (th1 / sumH) / 2;
            float t3 = trowTime * (th2 / sumH) / 2;

            //人物y方向1
            t += Shape.role.AddKey_ToY(MakingUpFunc.SlowDown, t, 0, trowHeight, t1); 
            t += Shape.role.AddKey_ToY(MakingUpFunc.Acceleration, t, trowHeight, 0, t1); 
          
            //人物y方向2
            t += Shape.role.AddKey_ToY(MakingUpFunc.SlowDown, t, 0, th1, t2); 
            t += Shape.role.AddKey_ToY(MakingUpFunc.Acceleration, t, th1, 0, t2); 

            //人物y方向3
            t += Shape.role.AddKey_ToY(MakingUpFunc.SlowDown, t, 0, th2, t3); 
            t += Shape.role.AddKey_ToY(MakingUpFunc.Acceleration, t, th2, 0, t3);  

            //尸体渐隐
            t += Shape.role.AddKey_Alpha(MakingUpFunc.Linear, t, 1, 0.0f, 1.0f);
           
            //尸体销毁
            Shape.role.AddKey_DestroyInstance(t);
        }
    }

    */
    public override void OnJoin(AI_Battlefield battlefield, float joinTime)
    {
        base.OnJoin(battlefield,joinTime);

        st = HeroST.Moveing;

        //如果是缩进单位，则立即移动半格，对齐到标准格子
        if(IndentPos)
        {
            var toX = ownerGrid.WorldX;
            var toZ = ownerGrid.WorldZ;
            var IndentX = AI_Math.IndentOffset(Flag);
            var t = Shape.RH.AddKey_MoveTo(joinTime, toX + IndentX, toZ, toX, toZ, this.FinalSpeed * DiamondGridMap.WidthSpacingFactor, out dirx, out dirz);
            this.ReduceTime(t);
        }
    }

    public override int AtkRange { get { return Data.AtkRange; } }

    public override Skill[] BishaSkills { get { return Data.BishaSkills; } }


    public override void LostHP(int v, AI_FightUnit attacker, DieEffect dieEffect, bool addLianzhan)
    {
        base.LostHP(v, attacker, dieEffect, addLianzhan);

        if (IsDie) //已经被杀死
        {
            AI_Hero attacker_hero = attacker as AI_Hero;

            //抛出英雄杀死士兵事件
            if (attacker_hero != null) 
                OwnerBattlefield.Event.PostHeroKillSoldiers(attacker_hero, this);

            OwnerBattlefield.Event.PostSoldiersDie(this, attacker);
        }
    }

    public override int JinshenSkillID { get { return Data.JinshenSkill; } }


    public override void DoAI()
    { 

        //自动切换状态
        while (HasNotUsedTime&&!IsDie)
        {  
            if (DoCacheSkill()) continue; 
            switch (st)
            {
                case HeroST.Moveing://移动中 
                    DoMoveing( ); 
                    break; 
                case HeroST.None:
                    { 
                        ReduceAllTime();
                    }
                    break;
                case HeroST.Wait:
                    {
                        st = HeroST.Moveing;//立即切换为移动状态
                        /*
                        //waitd = true;
                        if (IsEnemyValid) //当前存在有效的目标
                            st = HeroST.Moveing;//立即切换为移动状态
                        else if (
                                !ContextFindEnemying &&//当前没有处于联想寻敌状态
                                !IsInFindEnemyQueue//当前也没有在精准寻敌队列
                                )
                        {
                            DoFindEnemyFast();//快速寻敌
                            if (IsEnemyValid)//已经找到了有效目标
                                st = HeroST.Moveing;//立即切换为移动状态
                        }
                        else
                            ReduceTime(WaitTime);//继续保持等待
                        */
                    }
                    break;
                case HeroST.Fighting:
                    {
                        DoFighting(Shape);
                    }
                    break;    
                
            }
        }
    }
    /*
    float AddKay_MoveTo(float startTime, float fromX, float fromZ, float toX, float toZ, float speed)
    {
        if (toX > fromX)
            dir = AIDirection.Right;
        else
            if (toX < fromX) 
                dir = AIDirection.Left;


        return Shape.AddKay_MoveTo(startTime,
                                fromX, fromZ,
                                toX, toZ,
                                speed
                                );
    }
    */
    /*
    /// <summary>
    /// 计算当前应该位移到的目的位置
    /// </summary>
    /// <param name="dk_x"></param>
    /// <param name="dk_z"></param>
    void CountToPos(out float dk_x, out float dk_z)
    {
        dk_x = OwnerArmySquare.Dir == AIDirection.Left ? OwnerArmySquare.hero.posx + row : OwnerArmySquare.hero.posx - row;
        dk_z = OwnerArmySquare.hero.posz + column - 5;
    }
    */
 /*

    void AddStartDelay()
    {
        float waitTime = (float)AI_Battlefield.Single.RandomInt(100, 500) / 1000.0f;
        ReduceTime(Shape.AddKay_Wait(CurrTime, waitTime)); 

    }
    */
    /*
    /// <summary>
    /// 自动转换为战斗状态
    /// </summary>
    /// <returns></returns>
    bool AutoToFightST()
    {
        if (
          OwnerArmySquare.hero.st != HeroST.Fighting//英雄不在战斗状态
            ) return false;

        float dk_x,dk_z;
        CountToPos(out   dk_x, out   dk_z);

        if ( 
           (posx != dk_x || posz!=dk_z) //还没有走到目的地 
            ) return false;

        st = HeroST.Fighting;//设置状态
        return true;
    }*/


}
