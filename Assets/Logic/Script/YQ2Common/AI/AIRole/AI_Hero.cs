using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public enum HeroST
{
    None,//什么也不是  
    Wait,//等待状态 一般在通路被堵死时发生
    Moveing,//移动中
    Fighting,//战斗中 
}



public partial class AI_Hero :AI_FightUnit
{
    public AI_Hero(byte Fid, int staticID, bool indent)
    {
      
        this.Fid = Fid;
        this.staticID = staticID;
        IndentPos = indent; 
        this._ActionsLimit = new AI_Limit(this);

        this.YinchangTimer.OnComplete += OnYinchangComplete;

        this._EffectBuffManage = new AI_EffectBuffManage(this);


        WaitTime = SData_FightKeyValue.Single.HeroWaitTime;
        Data = SData_Hero.Get(staticID);
    }

    public override short ModelRange { get { return Data.ModelRange; } }
    /// <summary>
    /// 遍历装备提供的技能
    /// </summary>
    public static void ForeachEquipSkill(Equip[]  Equips,Action<Skill> reCall )
    {   
        foreach(var currEquip in  Equips)
        {
            var skill = GetEquipSkill(currEquip);
            if (skill != null) reCall(skill);
        }
    }

    public static Skill GetEquipSkill(Equip equip)
    {
        if (equip.XilianST!= XilianST.X3) return null;//没洗练技能

        var equipInfo = SData_EquipData.Single.Get(equip.sid);
        if (equipInfo==null|| equipInfo.XilianSkill3 <= 0) return null;

        return SData_Skill.Single.Get(equipInfo.XilianSkill3);
    }

    void AddTexingSkill(Skill skill, List<Skill> skillList)
    {
        if (skill == null || skill.SkillType != SkillType.Texing || //不是特性
            SkillLevels[ SkillID2Index(SkillObjs,-1,skill.id ) ] < 1//没有等级
            ) return;//跳过
        skillList.Add(skill);
    }

    void AddBishaSkill(Skill skill, List<Skill> skillList, ref short weight)
    {
        if (skill == null || skill.SkillType != SkillType.Unique ||//不是必杀
            SkillLevels[ SkillID2Index(SkillObjs,-1,skill.id) ] < 1//没有等级
            ) return;//跳过
        skillList.Add(skill);
        weight += skill.SuperSkillWeight;
    }


    //吟唱完成事件
    void OnYinchangComplete()
    {
        AddCacheSkill(ShoudongSkill,false);
    }

    
    public override UnitType UnitType { get { return UnitType.Hero; } }

    public override void OnJoin(AI_Battlefield battlefield, float joinTime)
    {
        base.OnJoin(battlefield, joinTime);

        st = HeroST.Moveing;

        //英雄CD类手动开始记时
        StartCD();

        //执行持续被动技能
        foreach (var skill in _SkillObjs)
        {
            if (skill == null || skill.SkillType != SkillType.BeiDongChiXu) continue;

            DoSkill(skill, false);
        }
    }

    protected override void PlayExplodedDieEffect(AI_FightUnit attacker)
    {
        //播放死亡特效
        if (Data.HeroDeadAudioFxObj != null)
        {
            AI_CreateFX.CreateFX(OwnerBattlefield.TotalLostTime, Data.HeroDeadAudioFxObj, this, dirx, dirz);
        }

        Shape.PlayExplodedDieEffect(attacker, this);
    }

    protected override void  PlayEscapeEffect()
    {
        Shape.PlayEscapeEffect(this);
    }

    /// <summary>
    /// 常规死亡效果
    /// </summary>
    protected override void PlayCommonDieEffect(AI_FightUnit attacker)
    {
        //播放死亡特效
        if (Data.HeroDeadAudioFxObj != null)
        {
            AI_CreateFX.CreateFX(OwnerBattlefield.TotalLostTime, Data.HeroDeadAudioFxObj, this, dirx, dirz);
        }

        Shape.PlayCommonDieEffect(attacker, this);
    }

    public override int AtkRange { get { return Data.AtkRange; } }

    public override short[] SkillLevels { get { return _SkillLevels; } }//技能等级

    short[] _SkillLevels;


    public override void PlayHitAction(string atk, float dirx, float dirz)
    {
        Shape.RH.AddKey_PlayAct(CurrTime, atk, false, 0.1f, dirx, dirz);
    }

    /// <summary>
    /// 勇将饶后格子，如果无需绕后返回null
    /// </summary>
    DiamondGrid AroundGrid
    {
        get
        {
            if (Data.Type != HeroType.Yong) return null;//不是勇将

            if (Enemy.Enemy == this) return null;//目标的目标是自己

            //var map = OwnerBattlefield.GridMap;
            DiamondGrid g1, g2, g3;
            Enemy.GetCehouGrids(out g1, out g2, out g3);

            //目标身后是否有空位
            /*
            DiamondGrid tGrid = Enemy.ownerGrid;
            var gid = map.GetDirectionGuideGridID(-Enemy.dirx, -Enemy.dirz);//获取敌人屁股后面的格子ID
            var leftGID = gid - 1;
            var rightGID = gid + 1;
            if (leftGID < 3) leftGID = 8;
            if (rightGID > 8) rightGID = 3;

            var g1 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, gid);
            var g2 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, leftGID);
            var g3 = map.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, rightGID);
             */
            //if(!DiamondGrid.IsEmptyGrid(g1)&&! DiamondGrid.IsEmptyGrid(g2)&&!DiamondGrid.IsEmptyGrid(g3))
              //  return null;//可绕后的位置全部被填满
                
            //选择一个最靠谱的绕后格子 
            if (DiamondGrid.IsEmptyGrid(g1)||g1==ownerGrid)
            {
                return g1;
            }
            else
            {
                bool eg2 = DiamondGrid.IsEmptyGrid(g2) || g2 == ownerGrid;
                bool eg3 = DiamondGrid.IsEmptyGrid(g3) || g3 == ownerGrid;

                if (eg2 && eg3)//两个侧后都是空的
                {
                    var dg2 = AI_Math.V2Distance(g2.WorldX, g2.WorldZ, ownerGrid.WorldX, ownerGrid.WorldZ);
                    var dg3 = AI_Math.V2Distance(g3.WorldX, g3.WorldZ, ownerGrid.WorldX, ownerGrid.WorldZ);
                    return dg2 > dg3 ? g3 : g2;//选择距离最近的一个
                }

                if (eg2) return g2;
                if (eg3) return g3;
            }

            //所有可绕的位置被填满
            return null; 
        }
    } 

    protected void DoMoveing()
    {

        var OverheadPanel = OwnerArmySquare.OverheadPanel;
        if (!MoveingCheckEnemy(Shape, OverheadPanel))
        {
            Enemy = FindEnemy(true);//立即查询敌人

            if (!IsEnemyValid)//没有符合条件的敌人
            {
                st = HeroST.Wait;
                Wait(WaitTime);
                return;
            }
        }

        var aroundGrid = AroundGrid;
       
        //检查是否需要切换为战斗状态
        if (
            aroundGrid==null &&//当前不用执行绕行逻辑
            AI_Math.WithinShot(this, Enemy,Data.AtkRange)//进入射程
            )
        {
            st = HeroST.Fighting;//切换为战斗状态
            return;
        }


        if (!ActionsLimit.CanMove)//当前被限制行进
        {
            ReduceTime(WaitTime);
            return;
        }

        var ownerBattlefield = OwnerBattlefield;
        DiamondGrid tGrid = Enemy.ownerGrid;

        if (aroundGrid!=null)//需要饶到敌人后面
        {
            //var bkGrid = ownerBattlefield.GridMap.GetDirectionGuideGrid(tGrid.GredX, tGrid.GredZ, -Enemy.dirx, -Enemy.dirz);//获取敌人屁股后面的格子
            //if (bkGrid != null)
            {
                tGrid = aroundGrid;//敌人屁股后面的格子作为行进目标
                if(tGrid==ownerGrid)//已经饶到了相应位置
                {
                    st = HeroST.Fighting;//切换为战斗状态
                    return;
                }
            }
        }


        if (tGrid != null)
        {
            bool isRound;//是否绕行了
            AI_FightUnit blockEnemy, blockFriend;

            DiamondGrid newGrid = ownerBattlefield.GridMap.MoveOneStep(this.ModelRange,DirectionGuideType, ownerGrid, lastGrid, tGrid, out isRound, out blockEnemy, out blockFriend);


            if (
                Data.Type== HeroType.Meng&&//猛将
                blockFriend != null &&//存在挡路的士兵
                //blockFriend._st != HeroST.Moveing&&//士兵当前不在移动状态
                //blockFriend._st != HeroST.Fighting&&//士兵当前也不在战斗状态
                blockFriend.OwnerArmySquare.st == ArmySquareST.IndependentAI//士兵所属的阵已经进入独立AI阶段
                )//和士兵交换位置
            {
                //过程中所属格子可能变化，所以先读取出来
                var heroGrid = ownerGrid;
                var soldiersGrid = blockFriend.ownerGrid;

                var soldiers = blockFriend as AI_Soldiers; 
                blockFriend.MoveTo(heroGrid, soldiers.Shape,
                     soldiers.OwnerArmySquare.QizhiOwner == soldiers ? soldiers.OwnerArmySquare.QizhiActor : null
                    ); //士兵移动到英雄位置
                MoveTo(soldiersGrid,this.Shape,OwnerArmySquare.OverheadPanel); //英雄移动到士兵位置
                return;
            }

            if (newGrid != null)
            {
                MoveSwapGrid(newGrid, Shape, OverheadPanel);
                return;
            }
            else
            {
                if (
                    blockEnemy != null && //挡住我去路的是敌人
                    AI_Math.WithinShot(this, blockEnemy, AtkRange)//在我的射程范围内
                    )
                {
                    Enemy = blockEnemy;//改变攻击目标并进入战斗
                    st = HeroST.Fighting;

                    OverheadPanel.AddKey_Wait(CurrTime, 0.1f);
                    ReduceTime(Shape.RH.AddKey_Wait(CurrTime, 0.1f));//稍微等待一下再开战 

                    return;
                }
            }
        }

        //通路被堵死了

        //打断移动帧 
        st = HeroST.Wait;
        OverheadPanel.AddKey_Wait(CurrTime, WaitTime);
        ReduceTime(Shape.RH.AddKey_Wait(CurrTime, WaitTime));
    }

    DirectionGuideSchemeType DirectionGuideType
    {
        get
        {
            switch (Data.Type)
            {
                case HeroType.Moushi://谋士
                case HeroType.Gong:
                    return DirectionGuideSchemeType.GongJiang;
                case HeroType.Yong:
                    return DirectionGuideSchemeType.YongJiang;
                default:
                    return DirectionGuideSchemeType.MengJiang;
            }
        }
    }

    public override int ID { get { return Shape.RH.ID; } }

    public override AI_EffectBuffManage EffectBuffManage { get { return _EffectBuffManage; } }//buff管理器
    AI_EffectBuffManage _EffectBuffManage;

    public float FangyuLv {
        get { 
            float currTili = this.TiLi.ToFloat();
            return (SData_FightKeyValue.Single.CTili*currTili)/(currTili+SData_FightKeyValueMath.Single.Get(Level).NTiliBeishu);
        }
    }

    public float FashuFangyulv
    {
        get
        {
            float currJingshen = this.TiLi.ToFloat();
            return (SData_FightKeyValue.Single.Cjingshen * currJingshen) / (currJingshen + SData_FightKeyValueMath.Single.Get(Level).NJingshenBeishu);
        }
    }

    protected override void OnDie(AI_FightUnit attacker,float time)
    {
        //OwnerArmySquare.OverheadPanel.AddKey_SetParent(time, -1);//和武将对象解除关系
        OwnerArmySquare.OverheadPanel.AddKey_DestroyInstance(time + 3f);//3秒后销毁
        //子对象自动脱离

        InterruptShoudong(time);//打断手动吟唱

        //逃跑逻辑
        {
            bool taopaoAll = true;//是否全部逃跑

            //判断是否全部武将已经挂了
            var flag = this.Flag;
            {
                var it = OwnerBattlefield.ArmySquareListEnumerator;
                while (it.MoveNext())
                {
                    if (it.Current.flag == flag && !it.Current.hero.IsDie)
                    { taopaoAll = false; break; }
                }
            }

            if (taopaoAll)//全部逃跑
            {
                /*有战斗结束逻辑来处理逃跑
                var it = OwnerBattlefield.ArmySquareListEnumerator;
                while (it.MoveNext())
                {
                    var square = it.Current;
                    if (square.flag == flag)
                    {
                        foreach (var curr in square.soldiers)
                            curr.DoEscape(attacker, time);//执行逃跑逻辑 
                    }
                }*/
            }
            else//部分逃跑
            {
            }
        }

        //触发英雄死亡事件
        OwnerBattlefield.Event.PostHeroDie(this, attacker);

       
        

        //销毁聚光
        //Spotlight.AddKey_DestroyInstance(CurrTime);

    }



    /// <summary>
    /// 
    /// </summary>
    /// <param name="ownerArmySquare"></param>
    /// <param name="hp">由入口参数指定的生命值，-1表示满血</param>
    public void InitAttrs(AI_ArmySquare ownerArmySquare,int hp)
    {
        OwnerArmySquare = ownerArmySquare;

        //重组技能队列
        {
            List<Skill> skillList = new List<Skill>();//重组后的技能队列，因为有装备等系统会加入新技能
            List<short> SkillLevelList = new List<short>();//重组后的技能等级队列

            var skLen = Data.SkillObjs.Length;

            //加入静态数据提供的技能
            for (int i = 0; i < skLen; i++)
            {
                skillList.Add(Data.SkillObjs[i]);
                SkillLevelList.Add(OwnerArmySquare.BaseAttr.sklv[i]);
            }

            //加入装备提供的技能
            ForeachEquipSkill(OwnerArmySquare.BaseAttr.Equips, (skill) => { skillList.Add(skill); SkillLevelList.Add(1); });

            _SkillObjs = skillList.ToArray();
            _SkillLevels = SkillLevelList.ToArray();
        }

        //特殊技能提取，提高战斗运算效率
        {
            List<Skill> tmpSkillList = new List<Skill>();
            //统计必杀技
            {
                tmpSkillList.Clear();
                _SuperSkillCountWeight = 0;

                foreach (var skill in _SkillObjs) AddBishaSkill(skill, tmpSkillList, ref _SuperSkillCountWeight);

                _BishaSkill = tmpSkillList.ToArray();
            }

            //统计特性技
            {
                tmpSkillList.Clear();

                foreach (var skill in _SkillObjs) AddTexingSkill(skill, tmpSkillList);

                TexingSkill = tmpSkillList.ToArray();
            }
        }

        var hlevel = OwnerArmySquare.BaseAttr.heroLevel;
        var hxj = OwnerArmySquare.BaseAttr.hxj;

        //设置基础值
        _MaxHP.SetV( Data.CalculationHP(hlevel, hxj));

        //处理装备对属性的影响 
        CalculateEquipAttr(OwnerArmySquare.BaseAttr.Equips, _MaxHP, _WuLi, _TiLi, _Nu, _Speed);


        _Speed.SetV(Data.Speed);
        CurrHP = hp<=0?FinalMaxHP:hp;
    }

    /*
    //应用被动属性类技能
   void ApplyBeidongAttr()
    {
        foreach (var skill in _SkillObjs)
        {
            if (skill==null||skill.SkillType != SkillType.BeiDongAttr) continue;

            var sklevel = SkillLevels[SkillID2Index(skill.id)];

            foreach (var effect in skill.TakeEffects)
            {
                if (effect.SkillRange.HeroOrArmy != HeroOrArmyEnum.Soldiers)//对武将有效
                {
                    AI_SkillHit.DoBeidongAttr(effect, sklevel, MaxHP, WuLi, TiLi, AddFYL, Nu, AddBSGL, Speed);

                }

                if (effect.SkillRange.HeroOrArmy != HeroOrArmyEnum.Hero)//对士兵有效
                {
                    AI_SkillHit.DoBeidongAttr(effect, sklevel,
                        OwnerArmySquare.MaxHP, OwnerArmySquare.WuLi, OwnerArmySquare.TiLi,
                        OwnerArmySquare.AddFYL, OwnerArmySquare.Nu, OwnerArmySquare.AddBSGL, OwnerArmySquare.Speed
                        );
                }
            }
        }

        OnAttrChanged();
        OwnerArmySquare.OnAttrChanged();
    }
     */

    /// <summary>
    /// 计算装备对属性的影响
    /// </summary> 
    public static void CalculateEquipAttr(Equip[] Equips, I_AAttr MaxHP, I_AAttr WuLi, I_AAttr TiLi, I_AAttr Nu, I_AAttr Speed)
    {
        foreach (var currEquip in Equips)
        {
            CalculateEquipAttr(currEquip, MaxHP, WuLi, TiLi, Nu, Speed); 
        }
    }

    /// <summary>
    /// 计算装备对属性的影响
    /// </summary> 
    public static void CalculateEquipAttr(Equip equip, I_AAttr MaxHP, I_AAttr WuLi, I_AAttr TiLi, I_AAttr Nu, I_AAttr Speed)
    {
        var equipInfo = SData_EquipData.Single.Get(equip.sid);
        if (equipInfo == null)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_WARNING, "无效的装备 id:" + equip.sid.ToString());
            return;
        }


        MaxHP.JAddV(equipInfo.HP);
        WuLi.JAddV(equipInfo.Wuli);
        TiLi.JAddV(equipInfo.Tili);
        Nu.JAddV(equipInfo.Nu); 

        switch(equip.XilianST)
        {
            case XilianST.X1A:
                ApplyXilianAttr(MaxHP, WuLi, TiLi, Nu, Speed, equipInfo.XilianShuxing1, equipInfo.XilianShuxingNum1);
                break;
            case XilianST.X1B:
                ApplyXilianAttr(MaxHP, WuLi, TiLi, Nu, Speed, equipInfo.XilianShuxing1B, equipInfo.XilianShuxingNum1B);
                break;
            case XilianST.X2:
                ApplyXilianAttr(MaxHP, WuLi, TiLi, Nu, Speed, equipInfo.XilianShuxing2A, equipInfo.XilianShuxingNum2A);
                ApplyXilianAttr(MaxHP, WuLi, TiLi, Nu, Speed, equipInfo.XilianShuxing2B, equipInfo.XilianShuxingNum2B);
                break;
        };

        //装备提供的技能影响
        {
            var skill = GetEquipSkill(equip);
            AAttrLight AddFYL, AddBSGL;
            AddBSGL = AddFYL = new AAttrLight();
            AI_SkillHit.CalculateBeidongSkillAttr(skill, 1, HeroOrArmyEnum.Hero, MaxHP, WuLi, TiLi, AddFYL, Nu, AddBSGL, Speed);
        }
    }


    //计算被动技能对武将或士兵的影响
    public static void CalculateBeidongSkillAttr(
        IHeroInfo heroInfo,
        HeroOrArmyEnum heroOrArmy,
        short[] skillLeves,//技能等级
        I_AAttr MaxHP, I_AAttr WuLi, I_AAttr TiLi, I_AAttr Nu, I_AAttr Speed
        )
    {
        AAttrLight AddFYL, AddBSGL;
        AddBSGL = AddFYL = new AAttrLight();

        var skills = heroInfo.SkillObjs;

        foreach (var sk in skills)
        {
            if (sk != null)
            {
                var idx = SkillID2Index(skills,-1, sk.id);
                var sklevel = idx >= skillLeves.Length ? (short)0 : skillLeves[idx];
                if (sklevel < 1) continue;
                AI_SkillHit.CalculateBeidongSkillAttr(sk, sklevel, heroOrArmy, MaxHP, WuLi, TiLi, AddFYL, Nu, AddBSGL, Speed);
 
            }
        }
    }




    static void ApplyXilianAttr(I_AAttr MaxHP, I_AAttr WuLi, I_AAttr TiLi, I_AAttr Nu, I_AAttr Speed, short shuxing, int shuxingValue)
    { 
        switch(shuxing)
        {
            case 1://气血
                MaxHP.JAddV(shuxingValue);
                break;
            case 2://武力
                WuLi.JAddV(shuxingValue);
                break;
            case 3://体力
                TiLi.JAddV(shuxingValue);
                break;
            case 4://怒气
                Nu.JAddV(shuxingValue);
                break;
        }
    }

    public override int Level { get { return OwnerArmySquare.BaseAttr.heroLevel; } }//等级

    public override short SuperSkillCountWeight { get { return _SuperSkillCountWeight; } }//必杀技总权重
    public override Skill[] BishaSkills { get { return _BishaSkill; } }
    public override Skill[] SkillObjs { get { return _SkillObjs; } } ///技能列表
                                                                     ///
    public override int JinshenSkillID { get { return -1; } }
    Skill[] _SkillObjs;


    public override string[] SkillAtks { get { return Data.SkillAtks; } }//获取技能动作

    public Skill[] TexingSkill;//特性技
    Skill[] _BishaSkill;
    short _SuperSkillCountWeight;

    /// <summary>
    /// 开始CD类技能记时
    /// </summary>
    public void StartCD()
    {
        int len = Data.SkillObjs.Length;
        for (int i = 0; i < len; i++)
        {
            var skill = Data.SkillObjs[i];
            if (skill == null) continue;
            if (skill.SkillType == SkillType.Shoudong)
            {
                ShoudongSkill = skill;

                var skillTrigger = skill.SkillTrigger;
                if (
                    skillTrigger!=null&&
                    (skillTrigger.TriggerStart == ConditionTriggerEnum.CD || skillTrigger.TriggerStart == ConditionTriggerEnum.CD_StartFull)
                    )
                {
                    ShoudongIsCD = true;
                    if (skillTrigger.TriggerStart == ConditionTriggerEnum.CD)//cd类
                    {
                        ShoudongCDStartTime = CurrTime;
                        ShoudongCDFullTime = CurrTime + ShoudongCDTime;

                        OwnerArmySquare.OverheadPanel.AddKey_CD(CurrTime, 0, skillTrigger.Float_3rdTriggerStart);//CD进度关键帧
                    }
                    else //cd类 开始满
                    {
                        ShoudongCDStartTime = ShoudongCDFullTime = CurrTime;
                        OwnerArmySquare.OverheadPanel.AddKey_CD(CurrTime, 1, 0);//CD进度关键帧
                    }
                }

                break;
            }
        }
    }

    public override void SwapJinYuan(bool isYuan)
    {
        Shape.RH.AddKey_SwapJinYuan(CurrTime, isYuan);
    }

    public override Skill JinshenSkill { get { return null; } }//近身技

    /// <summary>
    /// 释放手动技能
    /// </summary>
    /// <param name="isTexingChufa">是否为特性触发</param>
    public void ReleaseShouDong()
    {
        if (!ShoudongIsActived ||//手动技能没有激活
            OwnerBattlefield.FightST >= FightST.FightEnd //战斗已经结束
            ) return;

        ShoudongIsActived = false;

        //手动技能是插队执行的，在OwnerBattlefield.TotalLostTime时间点可能已经有其它指令
        //为了防止指令逆序，让释放手动行为的时间点在这个时间之后
        if (CurrTime < OwnerBattlefield.TotalLostTime)
            ReduceTime(OwnerBattlefield.TotalLostTime - CurrTime+0.0001f);

        float time = CurrTime; 

        //重新开始cd
        if (ShoudongIsCD)
        {
            var skillTrigger = ShoudongSkill.SkillTrigger;

            ShoudongCDStartTime = time;
            ShoudongCDFullTime = time + ShoudongCDTime;

            //CD进度关键帧
            OwnerArmySquare.OverheadPanel.AddKey_CD(time, 0, skillTrigger.Float_3rdTriggerStart);
        }else
            OwnerArmySquare.OverheadPanel.AddKey_CD(time, 0, 99999999);


        //相机注视吟唱对象 
        if (Flag == ArmyFlag.Attacker) Shape.RH.AddKey_CameraTrack(time, true); 

        //开始吟唱
        { 
             
            //选择目标
            ShoudongTargetList.Clear();
            ShoudongBoxList.Clear();
            SelectSkillTargets(ShoudongSkill,ShoudongTargetList, ShoudongBoxList,ref ShoudongXingZhuangHit);

            //朝向目标
            LookAtTarget(ShoudongTargetList, ShoudongBoxList, ShoudongXingZhuangHit);

            YinchangTimer.Start(ShoudongSkill.YinchangTime);//启动定时器 
            Shape.RH.AddKey_PlayAct(time, "yinchang", false, 0.1f, dirx, dirz, 1.0f / ShoudongSkill.YinchangTime); //播放蓄力动作 

            if (Flag == ArmyFlag.Attacker)
            {
                //场景变暗
                OwnerBattlefield.WorldActor.AddKey_BrightnessTo(MakingUpFunc.SlowDown, time, 1, 0, 0.3f);

                //角色高亮
                Shape.RH.AddKey_BrightnessTo(MakingUpFunc.SlowDown, time, NormalBrightness, HightBrightness, 0.3f);


                //显示聚光效果
                OwnerBattlefield.WorldActor.AddKey_Enable(time, Spotlight.ID,0,0,0); 
            }


            //创建吟唱特效
            var fx = Data.YinchangAudioFxObj;
            if (fx != null&& Flag== ArmyFlag.Attacker)
            { 
                YinchangFXActor = AI_CreateFX.CreateFX(time, fx, OwnerBattlefield,
                     0,0,0,//ownerGrid.WorldX, 0, ownerGrid.WorldZ,
                     this.dirx, this.dirz
                    );
                MountActor(YinchangFXActor);
            }
            else
                YinchangFXActor = null;

            //面板移动到对应位置
            float tmpDirx, tmpDirz;
            OwnerArmySquare.BelowPanel.AddKey_MoveTo(
                time, ownerGrid.WorldX, ownerGrid.WorldZ, ownerGrid.WorldX, ownerGrid.WorldZ,
                999999, out  tmpDirx, out tmpDirz
                );

            OwnerArmySquare.BelowPanel.AddKey_Yinchang(time, ShoudongSkill.YinchangTime); //处理吟唱cd条  
            ReduceTime(ShoudongSkill.YinchangTime);//吟唱过程中停止AI思维


            //冲锋阶段的阵停止移动，直到吟唱完
            OwnerArmySquare.SetHeroWait2MoveTime(CurrTime+0.3f);
        }
    }

     
    public List<EffectHit> ShoudongTargetList = new List<EffectHit>();
    public List<BoxHit> ShoudongBoxList = new List<BoxHit>();
    public bool ShoudongXingZhuangHit;

    public override  void HitMe(AI_FightUnit enemy)
    {
        //处理反击逻辑
        /*
        if (
            enemy.IsMelee &&//敌人是近战单位
            st != HeroST.Fighting//当前不处于战斗状态
            )
        {
            Enemy = enemy;//以攻击我的人作为目标
            st = HeroST.Fighting;//立即进入战斗状态
            return;
        }*/

        if (m_HitMeEnemy == null || m_HitMeEnemy.IsDie||m_HitMeEnemy.UnitType != UnitType.Hero)
            m_HitMeEnemy = enemy; 
    }

    
    /// <summary>
    /// 打断手动播放
    /// </summary>
    public void InterruptShoudong(float time)
    {
        if (!YinchangTimer.IsRuning) return;//手动技能不在吟唱阶段 

        //停止相机追踪
        OwnerBattlefield.EffectTrackManage.SetAttachingUnlockTime(0.0001f);

        //停止播放吟唱特效
        if (YinchangFXActor != null)
        {
            YinchangFXActor.CutKyes(time);//剪裁帧
            YinchangFXActor.AddKey_DestroyInstance(time);//销毁实例
            YinchangFXActor = null;
        }
        //停止吟唱CD进度条
        OwnerArmySquare.BelowPanel.AddKey_Yinchang(time, 0);

        //恢复角色亮度
        Shape.RH.AddKey_BrightnessTo(MakingUpFunc.SlowDown, time, HightBrightness, NormalBrightness, 0.3f);

        //隐藏聚光
        OwnerBattlefield.WorldActor.AddKey_Disable(time, Spotlight.ID);


        //停止定时器
        YinchangTimer.Stop();

        //播放等待动作
        Shape.RH.AddKey_PlayAct(time, "wait2", true, 0.1f, dirx, dirz); 

        //抛出打断事件
        OwnerBattlefield.Event.PostYinchangInterrupt(this);
    }

    //获取手动技能的CD时间
    public float ShoudongCDTime {
        get
        {
            var re = ShoudongSkill.SkillTrigger.Float_3rdTriggerStart;

            //获取CD增减类buff
            tmpEffectBuff.Clear();
            this._EffectBuffManage.GetBuffs(SkillEffectBOOLST.CDEditor, tmpEffectBuff);
            if (tmpEffectBuff.Count>0)
            {
                foreach(var buff in tmpEffectBuff)
                {
                    re += (float)buff.effect._2ndZhuangtai / 1000f;
                }
            }

            return re; 
        }
    }

    DPActor_Base YinchangFXActor = null;//吟唱效果演员
    AI_Timer YinchangTimer = new AI_Timer(); //吟唱定时器
    public bool ShoudongIsActived = false;//手动技能是否处于激活状态
    public bool ShoudongIsCD = false;//手动技能是否是以cd方式触发
    public float ShoudongCDFullTime = 0;//手动cd满的时间点
    public float ShoudongCDStartTime = 0;//手动cd起始时间点
    public Skill ShoudongSkill = null;
    
    
    public int LostHPNum = 0;//掉血次数
    bool IsFirstHit = true;


    public override void AddHP(AI_FightUnit attacker, int v)
    {
        if (IsDie) return;//已经死了
        OwnerArmySquare.OverheadPanel.AddKey_HPChange(OwnerBattlefield.TotalLostTime, -v, (CurrHP + v) / MaxHP.ToFloat(), attacker.UnitType == UnitType.Hero);//加血关键帧
        base.AddHP(attacker,v );
    }



    bool isFantaning = false;//当前是否处于反弹血量中

    public override void LostHP(int _v, AI_FightUnit attacker, DieEffect dieEffect,bool addLianzhan)
    {
        if (IsDie) return;//已经死了

        var time = OwnerBattlefield.TotalLostTime;


        
        if (attacker!=null&& attacker.UnitType == UnitType.Hero && !attacker.IsDie)
        {
            //处理吸血
            {
                tmpEffectBuff.Clear();
                attacker.EffectBuffManage.GetBuffs(SkillEffectBOOLST.Xixue, tmpEffectBuff);

                //存在吸血buff
                if (tmpEffectBuff.Count > 0)
                {
                    foreach (var buff in tmpEffectBuff)
                    {
                        //检查是否可以吸血
                        var rangeEnum = (RangeTriggerEnum)buff.effect._2ndZhuangtai;
                        if (!AI_TriggerChecker.RangeTriggerCheckOne(attacker, this, false, rangeEnum, false, null, 0, HeroOrArmyEnum.HeroAndSoldiers))
                            continue;//不满足吸血条件

                        var xixuev = (int)((float)_v * buff.effect._3rdZhuangtai);//吸血量
                        attacker.AddHP(attacker,xixuev);//增加血量
                    }
                }
            }

            
        }

        //处理反弹
        if (attacker!=null&& !isFantaning)//当前没有处于反弹血量中，防止多个武将之间来回反弹
        {
            var buffList = new List<AI_EffectBuff>();
            EffectBuffManage.GetBuffs(SkillEffectBOOLST.Fantan, buffList);
            //存在反弹buff
            if (buffList.Count > 0)
            {
                using (
                        new MonoEX.SafeCall(
                            () => isFantaning = true,
                            () => isFantaning = false
                        )
                    )
                {
                    foreach (var buff in buffList)
                    {
                        //检查是否可以反弹
                        var rangeEnum = (RangeTriggerEnum)buff.effect._2ndZhuangtai;
                        if (!AI_TriggerChecker.RangeTriggerCheckOne(this, attacker, false, rangeEnum, false, null, 0, HeroOrArmyEnum.HeroAndSoldiers))
                            continue;//不满足反弹条件

                        var fantanv = (int)((float)_v * buff.effect._3rdZhuangtai);//反弹量
                        attacker.LostHP(fantanv, this, DieEffect.Putong,true);//减少血量
                    }
                }
            }
        }
   
        float bfb = 1.0f;//还有多少百分比可以被分担
        //检查分担效果
        tmpEffectBuff.Clear();
        _EffectBuffManage.GetBuffs(SkillEffectBOOLST.WujiangFendan, tmpEffectBuff);
        if (tmpEffectBuff.Count>0)
        {
            foreach(var buff in tmpEffectBuff)
            {
                if (buff.attacker.IsDie) continue;//人已经死了，不能再分担

                //检查是否可以分担  
                var rangeEnum = (RangeTriggerEnum)buff.effect._2ndZhuangtai;
                if (!AI_TriggerChecker.RangeTriggerCheckOne(this, attacker, false, rangeEnum, false, null, 0, HeroOrArmyEnum.HeroAndSoldiers))
                    continue;//不能分担这个攻击者的伤害

                var fd = Math.Min(buff.effect._3rdZhuangtai, bfb);//实际分担
                if (fd > 0)
                {
                    buff.attacker.LostHP((int)((float)_v * fd), attacker, DieEffect.Putong,true); //分担者掉血
                    bfb -= fd;//取消被分担掉的部分
                }
            }
        }

        var v = (int)((float)_v * bfb);

        OwnerArmySquare.OverheadPanel.AddKey_HPChange(time, v, (CurrHP - v) / MaxHP.ToFloat(), attacker==null||attacker.UnitType == UnitType.Hero);//掉血关键帧
        base.LostHP(v, attacker, dieEffect,addLianzhan);

        if(IsDie) //已经被杀死
        {
            AI_Hero attacker_hero = attacker as AI_Hero;

            //抛出英雄杀死英雄事件
            if (attacker_hero != null)
            {
                OwnerBattlefield.Event.PostHeroKillHero(attacker_hero, this);
            }
        }

        if (_v != 0)
        {
            //英雄掉血事件
            OwnerBattlefield.Event.PostHeroLostHP(this, ++LostHPNum);

            //抛出英雄生命首次小于事件
            if (triggerMinHP.CheckValue(CurrHP))
                OwnerBattlefield.Event.PostHPFirstLower(this);
        }
    }
    
    public int XJ { get { return OwnerArmySquare.BaseAttr.hxj; } }

    //检查英雄首次造成伤害
    public void CheckHeroFirstHit()
    {
        if (IsFirstHit)
        {
            IsFirstHit = false;
            OwnerBattlefield.Event.PostHeroHitFirst(this);
        }
    }
    
    
    //public readonly AI_Battlefield ownerBattlefield;//所属战场

    public AAttr _Speed = new AAttr();
    public AAttr _MaxHP = new AAttr();
    public AAttr _WuLi = new AAttr();//武力
    public AAttr _Nu = new AAttr();//怒
    public AAttr _Zhili = new AAttr();
    public AAttr _TiLi = new AAttr();//体力
    public AAttrLight _AddFYL = new AAttrLight();//增加防御率
    public AAttrLight _AddBSGL = new AAttrLight();//增加必杀概率

    //必杀释放概率
    public override int FinalBishaGL
    {
        get
        {
            float bsgl = (SData_FightKeyValue.Single.Cnu * FinalNu)/ (FinalNu + SData_FightKeyValueMath.Single.Get(Level).Nnu);
            var re = (int)((bsgl + _AddBSGL.addV) * (1.0f + _AddBSGL.addBFB) *100.0f);
            return re;
        }
    }
    public override float FinalNu { get { return  _Nu.ToFloat(); } }
    public override int FinalMaxHP { get { return (int)_MaxHP.ToFloat(); } }
    public override float FinalSpeed { get { return _Speed.ToFloat(); } }
    public override AAttr Speed { get { return _Speed; } }//移动速度
    public override AAttr MaxHP { get { return _MaxHP; } }//生命上限


    public override AAttr WuLi { get { return _WuLi; } }//武力

    public override AAttr Zhili { get { return _Zhili; } }

    public override AAttr Nu { get { return _Nu; } }//怒
    public override AAttr TiLi { get { return _TiLi; } }//体力
    public override AAttrLight AddFYL { get { return _AddFYL; } }//增加防御率
    public override AAttrLight AddBSGL { get { return _AddBSGL; } }

    /// <summary>
    /// 行为限制器
    /// </summary>
    public override AI_Limit ActionsLimit { get { return _ActionsLimit; } }

    AI_Limit _ActionsLimit;

    public IHeroInfo Data = null;

    public override AI_Battlefield OwnerBattlefield
    {
        get { return OwnerArmySquare.OwnerBattlefield; }
    }

    //public int dyID;//动态id
    public byte Fid;//阵位id
    public int staticID;//数据id
   // public float m_BirthTime;//诞生时间   
    public AI_AvatarShape Shape = null;//外型
    public DPActor_Obj3D Spotlight = null;//聚光
    //float m_CDStartTime = 0;//cd开始记时的时间点
    
    public override void Wait(float t)
    {
        OwnerArmySquare.OverheadPanel.AddKey_Wait(CurrTime, t);
        ReduceTime(Shape.RH.AddKey_Wait(CurrTime, t));
    }
    public override ArmyFlag Flag { get { return OwnerArmySquare.flag; } }
    /*
    public int GetSkillIndexBySkillID(int skillID)
    { 
        int len = StaticMonsterInfo.skills.Length;
        for(int i=0;i<len;i++)
        {
            if (StaticMonsterInfo.skills[i] == skillID)
                return i;
        }
        return -1;
    }

    public int GetSkillLevel(int skillID)
    {
        int index = GetSkillIndexBySkillID(skillID);
        if (index < 0) return 0;
        return OwnerArmySquare.BaseAttr.sklv[index];
    }
    */ 
    static string[] tx_pks = new string[]{
        "fengji",
        "xixue",
        "shibingwudi",
        "wujiangwudi",
        "xuanyun",
        "zhongdu",
    };

    public override void AddTime(float time)
    {
        base.AddTime(time);
        EffectBuffManage.AddTime(time);
        YinchangTimer.AddTime(time);
    }

    public bool UserReleaseShoudong = false;
    public override void DoAI( )
    {
       
        EffectBuffManage.Update();
        ShoudongCDTrack();
        YinchangTimer.Update();


        //用户操作释放手动技能
        if (UserReleaseShoudong && !IsDie)
        {
            //立即获得可行动时间,并设置CurrTime为战役当前时间
            ObtainActionTime(OwnerBattlefield.TotalLostTime);

            UserReleaseShoudong = false;
            ReleaseShouDong();
        }

        //自动切换状态
        while (HasNotUsedTime && !IsDie)
        {
            
            //执行缓存的技能
            if (DoCacheSkill()) continue;

       
            //阵没有进入独立状态，忽略其它AI行为
            if (OwnerArmySquare.st != ArmySquareST.IndependentAI || YinchangTimer.IsRuning)
            {
                ReduceAllTime();
                break; 
            }

            switch (st)
            {
              
                case HeroST.Moveing://移动中
                    DoMoveing( );
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
                case HeroST.Fighting://战斗状态
                    DoFighting(Shape);
                    break;  
                case HeroST.None:
                    ReduceAllTime();
                    break; 
            }
        }
    }


    public override void DoReadyEnter(float time, AI_AvatarShape Shape,bool IsQixi)
    {
        float toX = ownerGrid.WorldX;
        float toZ = ownerGrid.WorldZ;
        float tmpdirx, tmpdirz;
      
        if (IndentPos)//需要缩进位置 
            toX += AI_Math.IndentOffset(Flag);  

        float startX = toX + (Flag == ArmyFlag.Attacker ? -0.1f : 0.1f);

        var BelowPanel = OwnerArmySquare.BelowPanel;
         var OverheadPanel=   OwnerArmySquare.OverheadPanel;
        if (OverheadPanel != null)
        {
            OverheadPanel.AddKey_Active(time);
            /*
            OverheadPanel.AddKey_MoveTo(
                time,
                startX, toZ,
                toX, toZ,
                10000,
                out  tmpdirx, out  tmpdirz
                );*/
        }

        //激活脚底面板
        if (BelowPanel != null)
            BelowPanel.AddKey_Active(time);

        //AI_Object的进入
        base.DoReadyEnter(time,Shape, IsQixi);

        //通知界面显示英雄头像
        LostHP(0, null, DieEffect.Putong,false);

        //开始CD类技能记时
        //StartCD();
    }


    public override void MountActor(DPActor_Base actor) { 
        actor.AddKey_SetParent(CurrTime, Shape.RH.ID);
    }


    void ShoudongCDTrack()
    {
        //这里使用战役的当前时间，主要防止currtimer超载时提前释放手动
        if (ShoudongIsCD && !ShoudongIsActived && OwnerBattlefield.TotalLostTime >= ShoudongCDFullTime)//手动技能满足激活条件
        {
            ActiveShoudong(false);
        }
    }

    /// <summary>
    /// 激活手动技
    /// </summary>
    public void ActiveShoudong(bool isTexingChufa)
    {
        if (
            ShoudongIsActived||//已经被激活
            OwnerBattlefield.FightST >= FightST.FightEnd //战斗已经结束
            ) return;
        ShoudongIsActived = true;//激活手动

        //特性触发特效
        if (isTexingChufa)
        {
            var fx = this.ShoudongSkill.ChufaAudioFxObj;
            CreateShifaFX(fx); 
        }
        float time = OwnerBattlefield.TotalLostTime;
        OwnerArmySquare.OverheadPanel.AddKey_CD(time, 1, 0);

        //如果是进攻方，创建手动技能激活关键帧
        if (Flag == ArmyFlag.Attacker)
        {
            OwnerArmySquare.OverheadPanel.AddKey_ShoudongIcon(time);
        }
        else //防御方，自动释放
        {
            ReleaseShouDong();
        }
    }


   
    public int HitCount { get { return m_HitCount; } }
    public int NursedCount { get { return m_NursedCount; } }
    public int KillSoldiersCount { get { return m_KillSoldiersCount; } }

    public void AddHitCount(int v)   { m_HitCount += v; }

    public void AddNursedCount(int v)  { m_NursedCount += v;  }

    public void AddKillSoldiersCount(int v) {  m_KillSoldiersCount += v; }



    public Equip[] Equips  { get { return OwnerArmySquare.BaseAttr.Equips; }     }
    

    //创建演示层角色
    public void CreateDPActors(float time)
    {
        //创建英雄,应用不变化颜色
        Shape = new AI_AvatarShape(
            OwnerArmySquare.OwnerBattlefield, time, 
            Data.ZiyuanBaoming,
            Data.ZiyuanBaomingZuoqi,
            ModleMaskColor.N, 
            (byte)(OwnerArmySquare.flag== ArmyFlag.Attacker? 0:1),
            !string.IsNullOrEmpty(Data.ZiyuanBaomingZuoqi),
           true,
           Data.ID
           );

        Spotlight = AI_CreateDP.CreateDP(OwnerBattlefield, time, "spotlight");
        Spotlight.AddKey_SetParent(time + 0.1f, Shape.RH.ID);
        float tmpDirX, tmpDirZ;
        Spotlight.AddKey_MoveTo(time,
            -1, 0,// ownerGrid.WorldX, ownerGrid.WorldZ,
            0, 0,//ownerGrid.WorldX, ownerGrid.WorldZ,
            10000,
            out tmpDirX, out tmpDirZ
            );
        OwnerBattlefield.WorldActor.AddKey_Disable(time, Spotlight.ID);


       OwnerArmySquare.OverheadPanel = AI_CreateDP.CreateDP(
           OwnerBattlefield, time + 0.1f, ownerGrid.WorldX, ownerGrid.WorldZ, Data.ID, OwnerArmySquare.BaseAttr.hxj, Fid,
           Shape.RH.ID,
           Flag== ArmyFlag.Attacker
           );
       OwnerArmySquare.BelowPanel = AI_CreateDP.CreateDP(OwnerBattlefield, time + 0.1f, Data.ID, Fid, Shape.RH.ID, Flag == ArmyFlag.Attacker);

        //创建脚底的武将标识
        /*
        var fx = Flag== ArmyFlag.Attacker?SData_FightKeyValue.Single.HeroSelfAudioFxObj:SData_FightKeyValue.Single.HeroOtherAudioFxObj;
        var act = AI_CreateFX.CreateFX(time + 0.1f, fx, OwnerBattlefield, 0, 0, 0, Flag == ArmyFlag.Attacker ? 1 : -1, 0, false);
        this.MountActor(act);
        float tmpV; act.AddKey_MoveTo(time + 0.1f, -1, 0, 0, 0, 100000, out tmpV, out tmpV);
         */
    }
     
     
     
    
    
    //一个连斩ID失效的时候被触发
    public void OnLianzhanDestroy(int id)     { m_LianzhanSkill.Remove(id); }

    /// <summary>
    /// 一个连斩技能释放成功时触发
    /// </summary>
    public void OnLianzhanSkillRelease(int id,Skill skill)
    {
        if (!m_LianzhanSkill.ContainsKey(id))
            m_LianzhanSkill.Add(id, new Dictionary<int, int>());

        var k = m_LianzhanSkill[id];
        if (k.ContainsKey(skill.id))
            k[skill.id]++;
        else
            k.Add(skill.id,1);
    }

    /*
    //判定某个连斩ID的某个技能是否已经释放过了
    public bool IsLianzhanReleased(int id, Skill skill)
    {
        if (!m_LianzhanSkill.ContainsKey(id)) return false;
        return m_LianzhanSkill[id].Contains(skill.id);
    }*/


    //获取某个连斩ID触发的某个技能的次数
    public int GetLianzhanReleaseCount(int id, Skill skill)
    {
        if (!m_LianzhanSkill.ContainsKey(id)) return 0;
         var k = m_LianzhanSkill[id];
         return k.ContainsKey(skill.id) ? k[skill.id] : 0;
    }


    //Dictionary<连斩ID, Dictionary<技能ID,释放成功的次数(打断清0)>>
    Dictionary<int, Dictionary<int, int>> m_LianzhanSkill = new Dictionary<int, Dictionary<int, int>>();//记录连斩ID触发过的技能

    //bool IsYongNeedAround = true;//勇将当前是否需要执行饶后逻辑

    public TriggerMinOnce triggerMinHP = new TriggerMinOnce();//hp首次小于统计


    int m_HitCount = 0;//总伤害
    int m_NursedCount = 0;//总治疗
    int m_KillSoldiersCount = 0;//总杀兵数
}


public class TriggerMinOnce
{ 

    public void OnSkillReleased(Skill skill)
    {
        ReleasedSkills.Add(skill.id);
    }

    public bool IsReleasedSkill(Skill skill)
    {
        return ReleasedSkills.Contains(skill.id);
    }

    public bool CheckValue(int currValue)
    {
        if(currValue<value)
        {
            value = currValue;
            return true;
        }

        return false;
    }



   

    int value = 99999999;

    HashSet<int> ReleasedSkills = new HashSet<int>();//已经触发过的技能


 
}