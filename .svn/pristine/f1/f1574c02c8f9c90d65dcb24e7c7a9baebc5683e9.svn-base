using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class AI_AvatarShape
{
    public AI_AvatarShape(
        AI_Battlefield battlefield,
        float birthTime,
        string packName,
        string HorsePackName, 
        ModleMaskColor MaskColor, 
        byte FlogColorIndex,
        bool IsCavalry,
         bool IsHero,
        int DataID
        )
    { 
        if (IsHero)
        {
            //骑将
            if (IsCavalry)
            {
                RH = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, true, packName, packName, FlogColorIndex, AvatarCM.CavalryHero_RH, false, IsHero, DataID);
                R = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, packName, packName, FlogColorIndex, AvatarCM.CavalryHero_R, true, IsHero, DataID);
                H = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, HorsePackName, packName, FlogColorIndex, AvatarCM.Horse_H, true, IsHero, DataID);
                battlefield.WorldActor.AddKey_Disable(birthTime, RH.ID);
                battlefield.WorldActor.AddKey_Disable(birthTime, R.ID);
                battlefield.WorldActor.AddKey_Disable(birthTime, H.ID);
            }
            else//步将
            {
                RH = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, true, packName, packName, FlogColorIndex, AvatarCM.InfantryHero_R, false, IsHero, DataID);
                battlefield.WorldActor.AddKey_Disable(birthTime, RH.ID);
            }
        } else
        {
            //骑兵
            if (IsCavalry)
            {
                RH = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, packName, packName, FlogColorIndex, AvatarCM.Cavalry_RH, false, IsHero, DataID);
                R = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, packName, packName, FlogColorIndex, AvatarCM.Cavalry_R, true, IsHero, DataID);
                H = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, HorsePackName, packName, FlogColorIndex, AvatarCM.Horse_H, true, IsHero, DataID);
                Fenshi = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, "fenshi", "fenshi", FlogColorIndex, AvatarCM.Cavalry_Fenshi, true, IsHero, DataID);

                battlefield.WorldActor.AddKey_Disable(birthTime, RH.ID);
                battlefield.WorldActor.AddKey_Disable(birthTime, R.ID);
                battlefield.WorldActor.AddKey_Disable(birthTime, H.ID);
                battlefield.WorldActor.AddKey_Disable(birthTime, Fenshi.ID);
            }
            else//步兵
            {
                RH = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, packName, packName, FlogColorIndex, AvatarCM.Infantry_R, false, IsHero, DataID);
                Fenshi = AI_CreateDP.CreateDP(battlefield, AIDirection.Right, birthTime, false, "fenshi", "fenshi", FlogColorIndex, AvatarCM.Infantry_Fenshi,true, IsHero, DataID);

                battlefield.WorldActor.AddKey_Disable(birthTime, RH.ID); 
                battlefield.WorldActor.AddKey_Disable(birthTime, Fenshi.ID);
            }
        }
    }

    //播放逃离效果
    public void PlayEscapeEffect(AI_FightUnit defender)
    {
        var time = defender.OwnerBattlefield.TotalLostTime;
        RH.CutKyes(time);

        //人马合体外型向大方向渐隐
        float wx = defender.ownerGrid.WorldX;
        float wz = defender.ownerGrid.WorldZ;

        float dic = DiamondGridMap.WidthSpacingFactor * 1.5f; //距离
        if(defender.Flag== ArmyFlag.Attacker) dic = -dic; 

        float tmpdirx, tmpdirz;
        float mvTime = RH.AddKey_MoveTo(time, wx, wz, wx + dic, wz, DiamondGridMap.WidthSpacingFactor * 1.5f, out tmpdirx, out tmpdirz);
        RH.AddKey_Alpha(MakingUpFunc.Linear, time, 1, 0, mvTime); 

        time += mvTime;


        this.RH.AddKey_DestroyInstance(time);//销毁实例 
        if (this.R != null) this.R.AddKey_DestroyInstance(time);//销毁实例
        if (this.H != null) this.H.AddKey_DestroyInstance(time);//销毁实例 
        if (this.Fenshi != null) Fenshi.AddKey_DestroyInstance(time);//销毁分尸实例  
    }

    //播放正常死亡效果
    public void PlayCommonDieEffect(AI_FightUnit attacker, AI_FightUnit defender)
    {
        var Battlefield = attacker.OwnerBattlefield;
        var time = Battlefield.TotalLostTime;
         float tmpdirx, tmpdirz;
        
        float wx = defender.ownerGrid.WorldX;
        float wz = defender.ownerGrid.WorldZ;

        DPActor_Avatar dieR;//死亡的人物演员
        if (this.R != null)
        {
            this.RH.AddKey_DestroyInstance(time);//人马合体外形销毁
            Battlefield.WorldActor.AddKey_Enable(time, this.R.ID, wx,0, wz);//激活分体的人  
            dieR = this.R;
        }
        else
        {
            this.RH.CutKyes(time);//剪裁关键帧
            dieR = this.RH;
        }


        const float actTime = 1.5f;//动画播放时间
        const float alphaTime = 0.3f;//渐隐时间

        //人物播放死亡动作
        dieR.AddKey_PlayAct(time, "die", false, 0f, defender.dirx, defender.dirz);//播放死亡动画

        //渐隐分体的人
        dieR.AddKey_Alpha(MakingUpFunc.Acceleration, time + actTime, 1, 0, alphaTime);
        dieR.AddKey_DestroyInstance(time + actTime + alphaTime);//销毁实例 

         
        if (this.H != null)
        {
            Battlefield.WorldActor.AddKey_Enable(time, this.H.ID, wx, 0, wz);//激活分体的马匹外形 

            //马向后跑
            float dic = DiamondGridMap.WidthSpacingFactor * 1.5f; //距离
            
            if (defender.dirx > 0) dic = -dic;
            var moveTime = this.H.AddKey_MoveTo(time, wx, wz, wx + dic, wz,Math.Abs(dic) , out tmpdirx, out tmpdirz);

            this.H.AddKey_Alpha(MakingUpFunc.Acceleration, time, 1, 0, moveTime);//渐隐分体的马
            this.H.AddKey_DestroyInstance(time + moveTime);//销毁实例 
        }

        if (this.Fenshi != null) Fenshi.AddKey_DestroyInstance(time);//销毁分尸实例 
    }


    //播放爆炸死亡效果
    public void PlayExplodedDieEffect(AI_FightUnit attacker, AI_FightUnit defender)
    {
        var Battlefield = attacker.OwnerBattlefield;
        var time = Battlefield.TotalLostTime;

        if (this.R != null) this.R.AddKey_DestroyInstance(time);//销毁分体的人
        this.RH.AddKey_DestroyInstance(time);//立即销毁人物模型
        

        float wx = defender.ownerGrid.WorldX;
        float wz = defender.ownerGrid.WorldZ;

        //创建爆炸特效 
        var DasuiAudioFxID = defender.OwnerArmySquare.ArmyData.DasuiAudioFxID;
        if (DasuiAudioFxID>0)
        {
            var bzeffect = AI_CreateDP.CreateDP(defender.OwnerBattlefield, DasuiAudioFxID, 0, false,
                wx, 0, wz, defender.dirx, defender.dirz, time);
            bzeffect.AddKey_Active(time);
            bzeffect.AddKey_DestroyInstance(time + 2);//两秒后销毁
        } 

        //向后跑
        float moveDirx, moveDirz;
        if (attacker != null)
        {
            //计算渐隐方向
            AI_Math.V2Dir(attacker.ownerGrid.WorldX, attacker.ownerGrid.WorldZ, wx, wz, out moveDirx, out moveDirz);
        }
        else
        {
            //当前方向的反方向
            moveDirx = -defender.dirx;
            moveDirz = -defender.dirz;
        }

        float tmpdirx, tmpdirz;

        if (this.Fenshi != null)//分尸Avatar
        {
            var rx = (float)defender.OwnerBattlefield.RandomInt(0,(int)(DiamondGridMap.WidthSpacingFactor))/100f;
            var rz = (float)defender.OwnerBattlefield.RandomInt(0, (int)(DiamondGridMap.WidthSpacingFactor * 30)) / 100f;
            
            if (moveDirx<0)//爆炸飞行方向和马一致
                rx = -rx;
            
            if (defender.OwnerBattlefield.RandomInt(0, 1) == 0)
                rz = -rz;

            Battlefield.WorldActor.AddKey_Enable(time, Fenshi.ID, wx,0,wz);//激活分尸Avatar
            Fenshi.AddKey_ToX(MakingUpFunc.SlowDown, time, wx, wx + rx, 0.6f);
            Fenshi.AddKey_ToZ(MakingUpFunc.SlowDown, time, wz, wz + rz, 0.6f);
                /*
                AddKey_MoveTo(time, wx, wz, 
                wx +rx, wz + rz,//位置随机一下，避免完全重合
                AI_Math.V2Distance(wx, wz, wx + rx, wz + rz)/0.6f,
                out tmpdirx, out tmpdirz
                );*/
 
            Fenshi.AddKey_PlayAct(time, "die", false, 0, -moveDirx, -moveDirz);//播放动画
            Fenshi.AddKey_Alpha(MakingUpFunc.Linear, time + 2, 1, 0,0.5f);//渐隐
            Fenshi.AddKey_DestroyInstance(time + 2.5f);//销毁
        }


        if (this.H != null)
        {
           

            

            //归一化向量
            AI_Math.NormaliseV2(ref moveDirx, ref  moveDirz);

            //计算渐隐距离
            float dic = DiamondGridMap.WidthSpacingFactor * 1.5f; //距离
            float tox = wx + dic * moveDirx;
            float toz = wz + dic * moveDirz;
            //this.H.AddKey_PlayAct(time, "die", true, 0, moveDirx, moveDirz);
            Battlefield.WorldActor.AddKey_Enable(time, this.H.ID, wx, 0, wz);//激活分体的马匹外形
            float moveTime = this.H.AddKey_MoveTo(time, wx, wz, tox, toz, DiamondGridMap.WidthSpacingFactor * 1.5f, out tmpdirx, out tmpdirz); 

            //渐隐分体的马
            this.H.AddKey_Alpha(MakingUpFunc.Acceleration, time, 1, 0, moveTime);
            this.H.AddKey_DestroyInstance(time + moveTime);//销毁实例 
        }
    }

    public DPActor_Avatar RH = null;//演示层 人马合体 或 步兵
    public DPActor_Avatar R = null;//骑兵死亡时的人物
    public DPActor_Avatar H = null;//骑兵死亡时的马
    public DPActor_Avatar Fenshi = null;//分尸Avatar
} 
