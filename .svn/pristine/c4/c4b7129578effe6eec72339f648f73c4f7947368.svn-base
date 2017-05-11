using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 
/// <summary>
/// 效果追踪管理器
/// </summary>
public class AI_EffectTrackManage //: MonoEX.Singleton<AI_EffectTrackManage>
{ 
    public AI_EffectTrackManage(AI_Battlefield ownerBattlefield)
    {
        this.OwnerBattlefield = ownerBattlefield;
    }

    public void Reset()
    { 
        m_EffectList.Clear();
    }
 
    //加入一个飞行效果追踪器
    public void AddEffectTrack(AI_Battlefield battlefield, AI_EffectTrack effectTrack)
    {
        effectTrack.OnJoin(battlefield, battlefield.TotalLostTime);
        m_EffectList.PushBack(effectTrack);

        if (
            effectTrack.Attack.Flag== ArmyFlag.Attacker&&//进攻方释放的效果
            (effectTrack.SkillEffectDo.ArriveInfo!=null&& effectTrack.SkillEffectDo.ArriveInfo.Gensui) &&//该效果需要相机跟随 
             effectTrack.Actor!=null//存在演员
            ) 
        {
            effectTrack.Actor.AddKey_CameraTrack(effectTrack.CurrTime, true);
            CameraTrackEffect = effectTrack;
            UnLockCameraOPTime = -1;
        }
    }



    public void Update(float lostTime
        //,bool isFightEnd
        )
    {
        //if (!isFightEnd)
        {
            //LinkList<AI_EffectTrack>.Node endNode = m_EffectList.Back;//记录一下结尾节点，遍历过程中新增节点，本次不进行遍历
            LinkList<AI_EffectTrack>.Node currNode = m_EffectList.Front;
            while (currNode != null)
            {
                var curr = currNode.v;
                curr.Update(lostTime);
                if (!curr.Valid)//已无效 
                {
                    currNode = m_EffectList.RemoveNode(currNode);//清除
                    if (curr == CameraTrackEffect)//一个当前相机追踪的效果死亡
                    {
                        CameraTrackEffect = null;
                        UnLockCameraOPTime = curr.SkillEffectDo.ArriveInfo.HuiguiYanchi;
                    }
                }
                else
                    currNode = currNode.next;
            }
        } 
        /*else
        {
            if (UnLockCameraOPTime > 0)
            {
                UnLockCameraOPTime = 0f;
                AutoUnlock();
            }
        }*/

        if(UnLockCameraOPTime>0)
        {
            UnLockCameraOPTime -= lostTime;
            if (UnLockCameraOPTime <= 0)
                AutoUnlock(); 
        }

        if(AttachingUnlockTime>0)
        {
            AttachingUnlockTime -= lostTime;
            if(AttachingUnlockTime<=0) 
                AutoUnlock(); 
        }
    }

    public bool HasTrackEffect { get { return CameraTrackEffect != null; } }

    /// <summary>
    /// 设定附带解锁时间，只有附带时间到点并且当前无技能处于追踪状态，才解锁相机
    /// </summary>
    /// <param name="time"></param>
    public void SetAttachingUnlockTime(float time)
    {
        if (time > AttachingUnlockTime)
            AttachingUnlockTime = time;
    }

    void AutoUnlock()
    {
        if (UnLockCameraOPTime <= 0 && AttachingUnlockTime <= 0 && CameraTrackEffect == null)
        {
            //恢复场景亮度
            OwnerBattlefield.WorldActor.AddKey_BrightnessTo(MakingUpFunc.SlowDown, OwnerBattlefield.TotalLostTime,   0, 1,0.3f);


            //解锁
            OwnerBattlefield.WorldActor.AddKey_CameraTrack(OwnerBattlefield.TotalLostTime, false);
        }
    }

    float AttachingUnlockTime = -1;
    float UnLockCameraOPTime = -1;
    AI_EffectTrack CameraTrackEffect = null;//相机当前追踪的效果
    LinkList<AI_EffectTrack> m_EffectList = new LinkList<AI_EffectTrack>();//效果列表
    AI_Battlefield OwnerBattlefield;
}
      