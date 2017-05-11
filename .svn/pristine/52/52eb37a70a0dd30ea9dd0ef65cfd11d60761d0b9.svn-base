using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
 using MonoEX;
public class AI_AudioFXCache  
{
    public void Cache(RuningAudioFXInfo fx)
    {
        var audioFXID = fx.effectActor.Res.AudioFxID;
        if (!CacheEffects.ContainsKey(audioFXID))
            CacheEffects.Add(audioFXID, new List<RuningAudioFXInfo>());

        CacheEffects[audioFXID].Add(fx);

        //禁用效果
        OwnerBattlefield.WorldActor.AddKey_Disable(OwnerBattlefield.TotalLostTime, fx.effectActor.ID);
    }

    public RuningAudioFXInfo New(int audioFXID, float activeTime, float x, float z, bool needPostMoveEvent, float dirx, float dirz)
    {
        RuningAudioFXInfo re;
        if (CacheEffects.ContainsKey(audioFXID))
        {
            var list = CacheEffects[audioFXID];
            re = list[0];
            if (list.Count > 1)
                list.RemoveAt(0);
            else
                CacheEffects.Remove(audioFXID);

            //启用演员
            OwnerBattlefield.WorldActor.AddKey_Enable(
                activeTime+0.001f, 
                re.effectActor.ID,
                x,0, z
                ); 

            if (needPostMoveEvent!=re.needPostMoveEvent)
                re.effectActor.AddKey_SetNeedPostMoveEvent(activeTime + 0.001f, needPostMoveEvent);

            if(dirx!=re.dirx||dirz!=re.dirz)
                re.effectActor.AddKey_SetDir(activeTime + 0.001f, dirx, dirz);

        }
        else
        {
            re = new RuningAudioFXInfo();
            //创建一个新的演员
            re.effectActor = AI_CreateDP.CreateDP(
               OwnerBattlefield,
               audioFXID,//效果ID
               0,//生命
               needPostMoveEvent,
               x, 0,z,
               dirx, dirz,
               activeTime
               );

            re.effectActor.AddKey_Active(activeTime);//激活演员 
        }

        re.x = x; 
        re.z = z;
        re.dirx = dirx;
        re.dirz = dirz;
        re.needPostMoveEvent = needPostMoveEvent;

        return re;
    }

    public void Reset(AI_Battlefield OwnerBattlefield)
    {
        this.OwnerBattlefield = OwnerBattlefield;
        CacheEffects.Clear();
    }

    AI_Battlefield OwnerBattlefield;
    Dictionary<int, List<RuningAudioFXInfo> > CacheEffects = new Dictionary<int, List<RuningAudioFXInfo> >(); 
}

public class RuningAudioFXInfo
{
    public float x,  z;
    public bool needPostMoveEvent;
    public float dirx, dirz;
    public DPActor_Effect effectActor;
}
