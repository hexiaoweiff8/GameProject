using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SData_FightKeyValue : MonoEX.Singleton<SData_FightKeyValue>
{

    public readonly short HeroLianzhanNo;
    public readonly float LianzhanTime;
    public readonly float BloodSpan;
    public readonly float Cnu;
    public readonly short Nnu;
    public readonly short NengliangMax;
    public readonly float CTili;
    public readonly float ArmyToArmyDis;
    public readonly float DaobingTonghang;
    public readonly float QiangbingTonghang;
    public readonly float QibingTonghang;
    public readonly float GongbingTonghang;


   // public readonly short SkillPutongNengliang;
   // public readonly short SkillOtherNengliang;
    public readonly short HeroToHeroNengliang;
    public readonly short HeroToArmyNengliang;
    public readonly short ArmyToHeroNengliang;
    public readonly short ArmyToArmyNengliang;
    public readonly float HpLostNengliang;
    public readonly short LianzhanNumNengliang;
    public readonly short LianzhanNengliang;



    public readonly float HeroToHeroDis;
    public readonly float MengjiangTonghang;
    public readonly float YongjiangTonghang;
    public readonly float GongjiangTonghang;
    public readonly float HeroWaitTime;
    public readonly float ArmyWaitTime;
    public readonly float ZhanqianCameraStop;

    public readonly int ZhanqianRoleAudioFx;
    public readonly int ZhanqianAllAudioFx;
    public readonly int ZhanhouAudioFx;
    public readonly float QixiTime;
    public readonly float JiesanYanchi;

    public readonly float Cjingshen;

    //public readonly int HeroSelfAudioFx;
    //public readonly int HeroOtherAudioFx;


    public short[] LianzhanNO;

    public int[] LianzhanAudioFx;
    public int[] ShadiAudioFx;

    public readonly float BattleTime;
    public readonly float BattleTimeXianshi;
}