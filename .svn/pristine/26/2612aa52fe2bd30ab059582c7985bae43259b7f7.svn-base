using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
    public class AI_CreateFX
    {
        /// <summary>
        /// 创建被击特效
        /// </summary>
        public static void CreateBeijiFX(
            float time, SkillEffect skillEffect,   AI_FightUnit Defender, float dirX, float dirZ,
            bool autoDestroy = true
            )
        {
            var fx = skillEffect.BeijiAudioFxObj;
            if (fx == null) return;//不需要被击效果


            DPActor_Base actor = AI_CreateDP.CreateDP(
                Defender.OwnerBattlefield,
                fx.ID,//效果ID
                0,//生命
                false,
                Defender.ownerGrid.WorldX, 0, Defender.ownerGrid.WorldZ,
                dirX, dirZ,
                time
                );
            actor.AddKey_Active(time);//激活演员
            Defender.MountActor(actor);//作为子物体

            float dtime = fx.LiveTime;

            if (autoDestroy && dtime > 20)
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_WARNING, "AudioFX生命时间过长，强制设置为3秒 ID:"+fx.ID);
                dtime = 3.0f;
                actor.AddKey_DestroyInstance(time + dtime);//间隔一段时间后销毁实例 
            }

           
        }

        public static void CreateFX(
            float time, AudioFxInfo fx, 
            AI_FightUnit Defender,
            float dirX, float dirZ,
            bool autoDestroy = true
            )
        {
            if (fx == null) return;//不需要效果


            DPActor_Base actor = AI_CreateDP.CreateDP(
                Defender.OwnerBattlefield,
                fx.ID,//效果ID
                0,//生命
                false,
                Defender.ownerGrid.WorldX, 0, Defender.ownerGrid.WorldZ,
                dirX, dirZ,
                time
                );
            actor.AddKey_Active(time);//激活演员


            float dtime = fx.LiveTime;
            if (autoDestroy && dtime > 20)
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_WARNING, "AudioFX生命时间过长，强制设置为3秒 ID:" + fx.ID);
                dtime = 3.0f;
                actor.AddKey_DestroyInstance(time + dtime);//间隔一段时间后销毁实例
            }
             
        }

        public static DPActor_Base CreateFX(
           float time, AudioFxInfo fx,
           AI_Battlefield battlefield,
            float x,float y,float z,
           float dirX, float dirZ,
            bool autoDestroy = true
           )
        {
            if (fx == null) return null;//不需要效果


            DPActor_Base actor = AI_CreateDP.CreateDP(
                battlefield,
                fx.ID,//效果ID
                0,//生命
                false,
                x, y,z,
                dirX, dirZ,
                time
                );
            actor.AddKey_Active(time);//激活演员

            float dtime = fx.LiveTime;
            if (autoDestroy && dtime > 20)
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_WARNING, "AudioFX生命时间过长，强制设置为3秒 ID:" + fx.ID);
                dtime = 3.0f; 
                actor.AddKey_DestroyInstance(time + dtime);//间隔一段时间后销毁实例 

            }
          
            return actor;
        } 
    } 