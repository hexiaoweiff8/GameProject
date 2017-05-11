using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; 
using System.Xml;
 
public class ArmyRestraintOnce
{
    public SoldierType type;
    public float Modulus;
}
 

public class ArmyInfo
{
    const int SkillCount = 2;
    internal static short IID;
    internal static short IName;
    internal static short IType;
    internal static short[] ISkillIDs;
    internal static short[] ISkillAtk;
    internal static short IIsZhaomu;   
    internal static short IMorenXing;
    internal static short ISpeed;
    internal static short ISoldierBanshen;
    internal static short IAtkHeroXueruo;
    internal static short IDefProportion; 
    internal static short IAtkRange;  
    internal static short IIcon; 
     internal static short IZiyuanBaoming;
     internal static short IZiyuanBaomingZuoqi;

    internal static short IMoxingRange;
    

     internal static short IDasuiAudioFxID;

    internal static short IJinshenSkill;
    //internal static short IGongbingSkillID;

    internal static short IDeadAudioFxID;

    internal static short ITongYongSuiPian;
    internal static short INote;

    internal static short IHeroOrMonsterArmy;

    internal static short IBiliHP;
    internal static short IBiliWuli;
    internal static short IBiliTili;
    internal static short IBiliNu;
    internal static short IBiliZhili;
    internal static short IBiliJingshen;
    //internal static short IGrowWithLvID;

    internal static short[] ISoldierType= new short[1];
    internal static short[] IModulus = new short[1];
    const int ModulusCount = 1;

     internal static void FillFieldIndex(ITabReader reader)
     {
         IID = reader.ColumnName2Index("ID");
         IName = reader.ColumnName2Index("Name");
         IType = reader.ColumnName2Index("Type");
         ISkillIDs = new short[SkillCount];
         ISkillIDs[0] = reader.ColumnName2Index("SkillID1");
         ISkillIDs[1] = reader.ColumnName2Index("SkillID2");

         ISkillAtk = new short[SkillCount];
         ISkillAtk[0] = reader.ColumnName2Index("Skill1Atk");
         ISkillAtk[1] = reader.ColumnName2Index("Skill2Atk");

         IIsZhaomu = reader.ColumnName2Index("IsZhaomu");
         IDefProportion = reader.ColumnName2Index("DefProportion");
         IMorenXing = reader.ColumnName2Index("MorenXing");
         ISpeed = reader.ColumnName2Index("Speed");
         ISoldierBanshen = reader.ColumnName2Index("SoldierBanshen");
         IAtkRange = reader.ColumnName2Index("AtkRange"); 
         ISoldierType[0] = reader.ColumnName2Index("SoldierType1");
         IModulus[0] = reader.ColumnName2Index("Modulus1");
         IIcon = reader.ColumnName2Index("Icon");  


         IJinshenSkill = reader.ColumnName2Index("JinshenSkill");
       // IGongbingSkillID = reader.ColumnName2Index("GongbingSkillID");
        IDeadAudioFxID = reader.ColumnName2Index("DeadAudioFxID");

         IBiliHP = reader.ColumnName2Index("BiliHP");
         IHeroOrMonsterArmy = reader.ColumnName2Index("HeroOrMonsterArmy");
         IBiliWuli = reader.ColumnName2Index("BiliWuli");
         IBiliTili = reader.ColumnName2Index("BiliTili");
         IBiliNu = reader.ColumnName2Index("BiliNu");
         IBiliZhili = reader.ColumnName2Index("BiliZhili");
         IBiliJingshen = reader.ColumnName2Index("BiliJingshen");
         
         IAtkHeroXueruo = reader.ColumnName2Index("AtkHeroXueruo");
         IZiyuanBaoming = reader.ColumnName2Index("ZiyuanBaoming"); 
         IZiyuanBaomingZuoqi = reader.ColumnName2Index("ZiyuanBaomingZuoqi");
         IMoxingRange = reader.ColumnName2Index("MoxingRange");

         IDasuiAudioFxID = reader.ColumnName2Index("DasuiAudioFxID");

         ITongYongSuiPian = reader.ColumnName2Index("TongYongSuiPian");
         INote = reader.ColumnName2Index("Note");
     }


     List<int> tmpSkillIDList = new List<int>();
     List<string> tmpSkillAtkList = new List<string>();
     public ArmyInfo(ITabReader reader, int row)
     {
         m_id = reader.GetI32(IID, row);
         Name = reader.GetS(IName, row);
         m_type = (SoldierType)reader.GetI16(IType, row);

         //SkillID = new int[2];
         tmpSkillIDList.Clear();
         tmpSkillAtkList.Clear();
         for(int i=0;i<SkillCount;i++)
         {
             var skid = reader.GetI32(ISkillIDs[i], row);
             if (skid > 0)
             {
                 tmpSkillIDList.Add(skid);
                 tmpSkillAtkList.Add(reader.GetS(ISkillAtk[i], row));
             }
         }


         SkillID = tmpSkillIDList.ToArray();
         SkillAtks = tmpSkillAtkList.ToArray();
          
         _IsZhaomu = reader.GetI16(IIsZhaomu, row) == 1;

         DasuiAudioFxID = reader.GetI32(IDasuiAudioFxID, row);

         BiliHP = reader.GetF(IBiliHP, row);
         BiliWuli = reader.GetF(IBiliWuli, row);
         BiliTili = reader.GetF(IBiliTili, row);
         BiliNu = reader.GetF(IBiliNu, row);


         HeroOrMonsterArmy =  reader.GetI16(IHeroOrMonsterArmy, row) == 1;
         
         
         BiliZhili = reader.GetF(IBiliZhili, row);
         BiliJingshen = reader.GetF(IBiliJingshen, row);
         //GrowWithLvID = reader.GetI16(IGrowWithLvID, row);

         MorenXing = reader.GetI16(IMorenXing, row);

         m_speed = reader.GetI16(ISpeed, row);
         DefProportion = reader.GetF(IDefProportion, row); 

         AtkRange = reader.GetI16(IAtkRange, row); 
         List<ArmyRestraintOnce> tmpList = new List<ArmyRestraintOnce>();
         for (int j = 0; j < ModulusCount; j++)
         {
             short tp = reader.GetI16(ISoldierType[j], row);
             float ms = reader.GetF(IModulus[j], row);
             if (tp <= 0 || ms <= 0) continue;
             ArmyRestraintOnce nd = new ArmyRestraintOnce();
             nd.type = (SoldierType)tp;
             nd.Modulus = ms;
             tmpList.Add(nd);
         }
         RestraintSoldier = tmpList.ToArray();

         Icon = reader.GetS(IIcon, row);
         SoldierBanshen = reader.GetS(ISoldierBanshen,row);
         AtkHeroXueruo = reader.GetF(IAtkHeroXueruo, row);


        //GongbingSkillID = reader.GetI32(IGongbingSkillID, row);
        JinshenSkill = reader.GetI32(IJinshenSkill, row);
         DeadAudioFxID = reader.GetI32(IDeadAudioFxID, row);
         
          
         ZiyuanBaoming = reader.GetS(IZiyuanBaoming, row);
         ZiyuanBaomingZuoqi = reader.GetS(IZiyuanBaomingZuoqi, row);

         MoxingRange = reader.GetI16(IMoxingRange, row);
         

         TongYongSuiPian = reader.GetI32(ITongYongSuiPian, row);
         Note = reader.GetS(INote, row); 

         switch(this.Type)
         {
             case SoldierType.Dao:
                 DirectionGuideType = DirectionGuideSchemeType.Daobing;
                 break;
             case SoldierType.Gong:
                 DirectionGuideType = DirectionGuideSchemeType.Gongbing;
                 break;
             case SoldierType.Qi:
                 DirectionGuideType = DirectionGuideSchemeType.Qibing;
                 break;
             default:
                 DirectionGuideType = DirectionGuideSchemeType.Qiangbing;
                 break;
         };
     }

    ArmyRestraintOnce[] RestraintSoldier;//克制关系 

    public ArmyRestraintOnce GetRestraintAttr(SoldierType tp)
    {
        int len = RestraintSoldier.Length;
        for (int j = 0; j < len; j++)
        {
            ArmyRestraintOnce curr = RestraintSoldier[j];
            if (curr.type == tp)
                return curr;
        }

        return null;
    }
    public int GetRestraintSoldierLength()
    {
        if (RestraintSoldier != null)
            return RestraintSoldier.Length;
        return 0;
    }

    public ArmyRestraintOnce GetRestraintSoldierInfo(int id)
    {
        if (id >= 0 && id < RestraintSoldier.Length)
            return RestraintSoldier[id];
        return null;
    }
    public int CalculationHP(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingHP[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowHP;
            return (int)(jichu * this.BiliHP);
        } else
            return (int)(this.BiliHP * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowHP);
        

    }

    public int CalculationWuli(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingWuli[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowWuli;
            return (int)(jichu * this.BiliWuli);
        }
        else
            return (int)(this.BiliWuli * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowWuli);
    }

    public int CalculationTili(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingTili[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowTili;
            return (int)(jichu * this.BiliTili);
        }else
            return (int)(this.BiliTili * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowTili);
    }

    public int CalculationNu(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingNu[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowNu;
            return (int)(jichu * this.BiliNu);
        }else
            return (int)(this.BiliNu * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowNu);
    }


    public int CalculationZhili(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingZhili[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowZhili;

            return (int)(jichu * this.BiliZhili);
        } else
            return (int)(this.BiliZhili * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowZhili);
    }

    public int CalculationJingshen(int level, short xj)
    {
        if (HeroOrMonsterArmy)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).ArmyGudingJingshen[xj - 1] +
                SData_FightKeyValueMath.Single.Get(level).ArmyGrowJingshen;
            return (int)(jichu * this.BiliJingshen);
        }else
            return (int)(this.BiliJingshen * (float)SData_FightKeyValueMath.Single.Get(level).ArmyMonsterGrowJingshen);
    }
      

    public void BuildLinks()
    {
        int len = SkillID.Length;
        SkillObjs = new Skill[len];
        List<Skill> tmpBisha = new List<Skill>();
        SuperSkillCountWeight =0;
        for (int i = 0; i < len; i++)
        {
            var sk =  SkillObjs[i] = SData_Skill.Single.Get(SkillID[i]);
            if (sk.SkillType == SkillType.Unique) { tmpBisha.Add(sk); SuperSkillCountWeight += sk.SuperSkillWeight; }
        }
        BishaSkills = tmpBisha.ToArray();

        if (JinshenSkill>0) JinshenSkillObj = SData_Skill.Single.Get(JinshenSkill);
        if (DeadAudioFxID > 0) DeadAudioFxObj = SData_AudioFx.Single.Get(DeadAudioFxID);
        //if(GongbingSkillID>0) GongbingSkillObj = SData_Skill.Single.Get(GongbingSkillID);
    }
     

    //public readonly short GrowID;
    public readonly int MorenXing;
    public readonly int AtkRange;
    public readonly DirectionGuideSchemeType DirectionGuideType;//方向导航类型
     
    //public readonly short GrowHP ;
    //public readonly short GrowWuli ;
    //public readonly short GrowTili;
    //public readonly short GrowNu;

    public readonly float BiliHP;
    public readonly float BiliWuli;
    public readonly float BiliTili;
    public readonly float BiliNu;
    public readonly bool HeroOrMonsterArmy;
    public readonly float BiliZhili;
        public readonly float BiliJingshen;

    //public AudioFxInfo DasuiAudioFx;
    public readonly int DasuiAudioFxID;

    public readonly int JinshenSkill;
    public  Skill JinshenSkillObj;

    //public readonly int GongbingSkillID;
   // public Skill GongbingSkillObj;

    public readonly int DeadAudioFxID;
    public AudioFxInfo DeadAudioFxObj;

    public readonly int TongYongSuiPian;
    public readonly string Note;

    public short ModelRange
    {
        get
        {
            if (MoxingRange == 2 || MoxingRange == 3) return 1;
            return (short)((MoxingRange - 1) / 6);
        }
    }

    //public readonly short GrowWithLvID; 


   // readonly XingAttr xingGuding  ; 

    public bool IsZhaomu { get { return _IsZhaomu; } }

  //  public float HeroProportion { get { return m_HeroProportion; } }

    //public float DefProportion { get { return m_DefProportion; } }

   // public float ArmyProportion { get { return _ArmyProportion; } }

    //public float TwoObj { get { return m_TwoObj; } }

    public int Speed { get { return m_speed; } }
     
  

    //士兵ID
    public int ID { get { return m_id; } }
    public SoldierType Type { get { return m_type; } }
    public readonly String Name;//士兵名称

    public readonly String Icon;    // 头像 Sprite
    public readonly String SoldierBanshen;
    public readonly float AtkHeroXueruo;
     

    int m_id;
        
    SoldierType m_type;//Type 士兵兵种
    public readonly int[] SkillID;//技能ID
    public readonly string[] SkillAtks;//技能动作
    public Skill[] BishaSkills;
    public short SuperSkillCountWeight ;
    public Skill[] SkillObjs;


    bool _IsZhaomu;//是否允许招募

   public readonly  string ZiyuanBaoming;
   public readonly string ZiyuanBaomingZuoqi;
   public readonly float DefProportion;
   public readonly short MoxingRange;
   //public readonly ModleMaskColor YanmaYanse;
 

    int m_speed;//Speed 移动速度加成
    //DefProportion 分担伤害比列
    //float m_HeroProportion;//HeroProportion 武将分配伤害比列
    //float m_TwoObj;//TwoObj 多目标衰减系数
    //float _ArmyProportion;

       
}
 

public class SData_Army : MonoEX.Singleton<SData_Army>
{
    const int MaxSoldierLevel = 10;

    public SData_Army()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 ArmyData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "ArmyData");
            ArmyInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                ArmyInfo sa = new ArmyInfo(reader, row);
                Data.Add(sa.ID, sa);
                if (sa.IsZhaomu) ZhaomuArmys.Add(sa);
            }
        }
    }
    public List<int> GetALLNormalArmy()
    {
        List<int> _List = new List<int>();
        foreach (ArmyInfo _temp in ZhaomuArmys)
        {
            if (_temp.ID < 2000)
                _List.Add(_temp.ID);
        }
        return _List;
    }
    public ArmyInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

     public void BuildLinks()
    {
        foreach (var kv in Data) kv.Value.BuildLinks();
    }

    public List<ArmyInfo> ZhaomuArmys = new List<ArmyInfo>();//允许招募的士兵 
    Dictionary<int, ArmyInfo> Data = new Dictionary<int, ArmyInfo>();
}