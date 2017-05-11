using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SData_FightKeyValue : MonoEX.Singleton<SData_FightKeyValue>
{
    public SData_FightKeyValue()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 FightKeyValue");

        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "FightKeyValue");
            short ICTili = reader.ColumnName2Index("CTili");
            short IArmyToArmyDis = reader.ColumnName2Index("ArmyToArmyDis");
            short IDaobingTonghang = reader.ColumnName2Index("DaobingTonghang");
            short IQiangbingTonghang = reader.ColumnName2Index("QiangbingTonghang");
            short IQibingTonghang = reader.ColumnName2Index("QibingTonghang");
            short IGongbingTonghang = reader.ColumnName2Index("GongbingTonghang");




           // short ISkillPutongNengliang = reader.ColumnName2Index("SkillPutongNengliang");
           // short ISkillOtherNengliang = reader.ColumnName2Index("SkillOtherNengliang");
            short IHeroToHeroNengliang = reader.ColumnName2Index("HeroToHeroNengliang");
            short IHeroToArmyNengliang = reader.ColumnName2Index("HeroToArmyNengliang");
            short IArmyToHeroNengliang = reader.ColumnName2Index("ArmyToHeroNengliang");
            short IArmyToArmyNengliang = reader.ColumnName2Index("ArmyToArmyNengliang");
            short ILianzhanNumNengliang = reader.ColumnName2Index("LianzhanNumNengliang");
            short ILianzhanNengliang = reader.ColumnName2Index("LianzhanNengliang");
            short IHpLostNengliang = reader.ColumnName2Index("HpLostNengliang");


            short IHeroWaitTime = reader.ColumnName2Index("HeroWaitTime");
            short IArmyWaitTime = reader.ColumnName2Index("ArmyWaitTime");
            short IZhanqianCameraStop = reader.ColumnName2Index("ZhanqianCameraStop");

            short ICjingshen = reader.ColumnName2Index("Cjingshen");

            short IHeroToHeroDis = reader.ColumnName2Index("HeroToHeroDis");
            short IMengjiangTonghang = reader.ColumnName2Index("MengjiangTonghang");
            short IYongjiangTonghang = reader.ColumnName2Index("YongjiangTonghang");
            short IGongjiangTonghang = reader.ColumnName2Index("GongjiangTonghang");

            short ICnu = reader.ColumnName2Index("Cnu");
            short INnu = reader.ColumnName2Index("Nnu");

            short INengliangMax = reader.ColumnName2Index("NengliangMax");

            short IBloodSpan = reader.ColumnName2Index("BloodSpan");

            short ILianzhanTime = reader.ColumnName2Index("LianzhanTime");
            short IHeroLianzhanNo = reader.ColumnName2Index("HeroLianzhanNo");

            short IBattleTime = reader.ColumnName2Index("BattleTime");
            short IBattleTimeXianshi = reader.ColumnName2Index("BattleTimeXianshi");

            short IZhanqianAllAudioFx = reader.ColumnName2Index("ZhanqianAllAudioFx"); 
            short IZhanqianRoleAudioFx = reader.ColumnName2Index("ZhanqianRoleAudioFx");
            short IZhanhouAudioFx = reader.ColumnName2Index("ZhanhouAudioFx");
            short IQixiTime = reader.ColumnName2Index("QixiTime");
            short IJiesanYanchi = reader.ColumnName2Index("JiesanYanchi");

            //short IHeroSelfAudioFx = reader.ColumnName2Index("HeroSelfAudioFx");
            //short IHeroOtherAudioFx = reader.ColumnName2Index("HeroOtherAudioFx"); 


            short[] ILianzhanNO = new short[5];
            short[] ILianzhanAudioFx = new short[5]; 
            for(int i=0;i<5;i++)
            {
                var istr = (i+1).ToString();
                ILianzhanNO[i] =  reader.ColumnName2Index("LianzhanNO"+istr); 
                ILianzhanAudioFx[i] = reader.ColumnName2Index("LianzhanAudioFx"+istr);  
            }


            short[] IShadiAudioFx = new short[4];
            for(int i=0;i<4;i++)
            {
                var istr = (i + 1).ToString();
                IShadiAudioFx[i] = reader.ColumnName2Index("ShadiAudioFx" + istr); 
            }


            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {

                CTili = reader.GetF(ICTili, row);
                ArmyToArmyDis = reader.GetF(IArmyToArmyDis, row)/10f;
                DaobingTonghang = (float)reader.GetI16(IDaobingTonghang, row) / 10f;
                QiangbingTonghang = (float)reader.GetI16(IQiangbingTonghang, row) / 10f;
                QibingTonghang = (float)reader.GetI16(IQibingTonghang, row) / 10f;
                GongbingTonghang = (float)reader.GetI16(IGongbingTonghang, row) / 10f;

                HeroToHeroDis = reader.GetF(IHeroToHeroDis, row)/10f;
                MengjiangTonghang = (float)reader.GetI16(IMengjiangTonghang, row) / 10f;
                YongjiangTonghang = (float)reader.GetI16(IYongjiangTonghang, row) / 10f;
                GongjiangTonghang = (float)reader.GetI16(IGongjiangTonghang, row) / 10f;

                Cnu = reader.GetF(ICnu, row);
                Nnu = reader.GetI16(INnu, row);

                //SkillPutongNengliang = reader.GetI16(ISkillPutongNengliang, row);
                //SkillOtherNengliang = reader.GetI16(ISkillOtherNengliang, row);
                HeroToHeroNengliang = reader.GetI16(IHeroToHeroNengliang, row);
                HeroToArmyNengliang = reader.GetI16(IHeroToArmyNengliang, row);
                ArmyToHeroNengliang = reader.GetI16(IArmyToHeroNengliang, row);
                ArmyToArmyNengliang = reader.GetI16(IArmyToArmyNengliang, row);
                LianzhanNumNengliang = reader.GetI16(ILianzhanNumNengliang, row);
                LianzhanNengliang = reader.GetI16(ILianzhanNengliang, row);
                HpLostNengliang = reader.GetF(IHpLostNengliang, row);


                NengliangMax = reader.GetI16(INengliangMax, row);

                HeroWaitTime = (float)reader.GetI16(IHeroWaitTime, row) / 1000f;
                ArmyWaitTime = (float)reader.GetI16(IArmyWaitTime, row) / 1000f;

                ZhanqianCameraStop = (float)reader.GetI16(IZhanqianCameraStop, row) / 1000f; 

                LianzhanTime = (float)reader.GetI16(ILianzhanTime, row) / 1000f;
                BloodSpan = (float)reader.GetI16(IBloodSpan, row) / 1000f;
                
                HeroLianzhanNo = reader.GetI16(IHeroLianzhanNo, row);

                BattleTime = (float)reader.GetI16(IBattleTime, row);
                BattleTimeXianshi = (float)reader.GetI16(IBattleTimeXianshi, row);

                ZhanhouAudioFx = reader.GetI32(IZhanhouAudioFx, row);
                ZhanqianAllAudioFx = reader.GetI32(IZhanqianAllAudioFx, row);
                ZhanqianRoleAudioFx = reader.GetI32(IZhanqianRoleAudioFx, row);

                QixiTime = (float)reader.GetI16(IQixiTime, row) / 1000f;
                JiesanYanchi = (float)reader.GetI16(IJiesanYanchi, row) / 1000f;
                


                Cjingshen = reader.GetF(ICjingshen, row);
                
                //HeroSelfAudioFx = reader.GetI32(IHeroSelfAudioFx, row);
                //HeroOtherAudioFx = reader.GetI32(IHeroOtherAudioFx, row);


                List<int> tmpShadiAudioFx = new List<int>();
                for (int i = 0; i < 4; i++)
                {
                    var shadiFxID = reader.GetI32(IShadiAudioFx[i], row);
                    if (shadiFxID > 0) tmpShadiAudioFx.Add(shadiFxID);
                }
                ShadiAudioFx = tmpShadiAudioFx.ToArray();

                List<short> tmpLianzhanNO = new List<short>();
                var tmpLianzhanAudioFx = new List<int>();

                for(int i=0;i<5;i++)
                {
                    var no = reader.GetI16(ILianzhanNO[i], row);
                    var fxid =  reader.GetI32(ILianzhanAudioFx[i], row);

                    if(no>0&&fxid>0)
                    {
                        tmpLianzhanNO.Add(no);
                        tmpLianzhanAudioFx.Add(fxid);
                    }
                }

                LianzhanNO = tmpLianzhanNO.ToArray();
                LianzhanAudioFx = tmpLianzhanAudioFx.ToArray();

                //从小到大排序
                int len = LianzhanNO.Length;
                for(int i=0;i<len-1;i++)
                {
                    var pos = i;
                    for(int i2 = i+1;i2<len;i2++)
                    {
                        if (LianzhanNO[i2] < LianzhanNO[pos])
                            pos = i2;
                    }

                    if(i!=pos)
                    {
                        {
                            var z = tmpLianzhanNO[pos];
                            tmpLianzhanNO[pos] = tmpLianzhanNO[i];
                            tmpLianzhanNO[i] = z;
                        }

                        {
                            var z = LianzhanAudioFx[pos];
                            LianzhanAudioFx[pos] = LianzhanAudioFx[i];
                            LianzhanAudioFx[i] = z;
                        }
                    }
                }
            }
        }
    }
    /// <summary>
    /// 根据角色动画模板，和攻击动作号，获取动画时长
    /// </summary>
    /// <param name="mb"></param>
    /// <param name="actNum"></param>
    /// <returns></returns>
    public float AvatarMB2HitTime(string mb, int actNum)
    {
        try
        {
            return _AvatarMB2HitTime[mb][actNum - 1];
        }
        catch (Exception)
        {
            throw new Exception(string.Format("AvatarMB2HitTime interrupt mb:{0} actNum:{1}", mb, actNum));

        }
    }

    public float GetHeroTonghangByType(HeroType tp)
    {
        switch (tp)
        {
            case HeroType.Yong:
                return YongjiangTonghang;
            case HeroType.Gong:
                return GongjiangTonghang;
            default:
                return MengjiangTonghang;
        };
    }

    public float GetArmyTonghangByType(SoldierType tp)
    {
        switch (tp)
        {
            case SoldierType.Gong:
                return GongbingTonghang;
            case SoldierType.Qi:
                return QibingTonghang;
            case SoldierType.Qiang:
                return QiangbingTonghang;
            default:
                return DaobingTonghang;
        }
    }

    public void BuildLinks()
    {
        if (ZhanqianRoleAudioFx > 0) ZhanqianRoleAudioFxObj = SData_AudioFx.Single.Get(ZhanqianRoleAudioFx);
        if (ZhanqianAllAudioFx > 0) ZhanqianAllAudioFxObj = SData_AudioFx.Single.Get(ZhanqianAllAudioFx);
        if (ZhanhouAudioFx > 0) ZhanhouAudioFxObj = SData_AudioFx.Single.Get(ZhanhouAudioFx);

        //if (HeroSelfAudioFx > 0) HeroSelfAudioFxObj = SData_AudioFx.Single.Get(HeroSelfAudioFx);
        //if (HeroOtherAudioFx > 0) HeroOtherAudioFxObj = SData_AudioFx.Single.Get(HeroOtherAudioFx);
         
        
        {
            int len = LianzhanAudioFx.Length;
            LianzhanAudioFxObj = new AudioFxInfo[len];
            for (int i = 0; i < len; i++)
            {
                LianzhanAudioFxObj[i] = SData_AudioFx.Single.Get(LianzhanAudioFx[i]);
                if (LianzhanAudioFxObj[i] == null)
                    throw new Exception("LianzhanAudioFx 无效的效果ID：" + LianzhanAudioFx[i]);
            }
        }


        {
            int len = ShadiAudioFx.Length;
            ShadiAudioFxObj = new AudioFxInfo[len];
            for (int i = 0; i < len; i++)
            {
                ShadiAudioFxObj[i] = SData_AudioFx.Single.Get(ShadiAudioFx[i]);
                if (ShadiAudioFxObj[i] == null)
                    throw new Exception("ShadiAudioFx 无效的效果ID：" + ShadiAudioFx[i]);
            }
        }
        
    }

    /*
      public AudioFxInfo ZhanqianRoleAudioFxObj;
    public AudioFxInfo ZhanqianAllAudioFxObj;

     */

    //角色模板转攻击时间
    Dictionary<string, float[]> _AvatarMB2HitTime = new Dictionary<string, float[]>();

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

    public AudioFxInfo ZhanqianRoleAudioFxObj = null;
    public AudioFxInfo ZhanqianAllAudioFxObj = null;
    public AudioFxInfo ZhanhouAudioFxObj = null;
    //public AudioFxInfo HeroSelfAudioFxObj = null;
    //public AudioFxInfo HeroOtherAudioFxObj = null;

    public short[] LianzhanNO;
    public AudioFxInfo[] LianzhanAudioFxObj;

    public int[] LianzhanAudioFx;
    public int[] ShadiAudioFx;

    public AudioFxInfo[] ShadiAudioFxObj;

    public readonly float BattleTime;
    public readonly float BattleTimeXianshi;
}