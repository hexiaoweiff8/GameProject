using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public interface IHeroInfo
{
    HeroType Type { get; }
    short MorenXing { get; }

    string ZiyuanBaoming { get; }

    string ZiyuanBaomingZuoqi { get; }
    

    short AtkRange { get; }
    short Speed { get; }

    /// <summary>
    /// 释放技能应该偏移的格子数
    /// </summary>
    short ModelRange { get; }

    string[] SkillAtks { get; }
    int[] Skills { get; }

    Skill[] SkillObjs { get; }

    int ID { get; }
    short MingziID { get; }

    short TypeIcon { get; }

    string Name { get; }
    string Special { get; }
    string HeroFace { get; }
    int HeroFaceID { get; }

    string Hanhua { get; }
    ArmyInfo Army { get; }

    //short ShowNPCZuoqi { get; }
    //short NPCZuoqiID { get; }

    AudioFxInfo YinchangAudioFxObj { get; }
    AudioFxInfo HeroDeadAudioFxObj { get; } 

    int CalculationHP(int level, short xj);
        
}

public class MonsterDataInfo : IHeroInfo
{
    internal static short IAtkRange;
    internal static short ISpeed; 
    internal static short[] ISkillAtks;
    internal static short IMingziID;
    internal static short ISex;
    internal static short IHeroZhenying; 
    internal static short IType;
    internal static short IMorenXing;
    internal static short IID;
    internal static short IName;
    internal static short ISpecial;
    internal static short IZiyuanBaomingZuoqi;
    internal static short IYinchangAudioFx;
    internal static short IArmy;
    internal static short IMoxingRange;
    internal static short IArmyTaopao;
    internal static short[] ISkills;
    internal static short IHeroFace; 
     internal static short IHeroBanshen;
    internal static short IZiyuanBaoming;

    internal static short IBiliHP;
    internal static short IBiliWuli;
    internal static short IBiliTili;
    internal static short IBiliNu;
    internal static short IBiliZhili;
    internal static short IBiliJingshen;

    internal static short IHeroDeadAudioFx;
    internal static short ITypeIcon;

    internal static short IStartNengliang; 

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        ISex = reader.ColumnName2Index("Sex");
        IMingziID = reader.ColumnName2Index("MingziID");
        ISpecial = reader.ColumnName2Index("Special");
        IArmyTaopao = reader.ColumnName2Index("ArmyTaopao");

        IType = reader.ColumnName2Index("Type");
        IMorenXing = reader.ColumnName2Index("MorenXing");
        IArmy = reader.ColumnName2Index("Army");
        IHeroZhenying = reader.ColumnName2Index("HeroZhenying");

        IHeroDeadAudioFx = reader.ColumnName2Index("HeroDeadAudioFx");
        IMoxingRange = reader.ColumnName2Index("MoxingRange");
 
        IAtkRange = reader.ColumnName2Index("AtkRange");
        ISpeed = reader.ColumnName2Index("Speed");
        IHeroFace = reader.ColumnName2Index("HeroFace");
        IZiyuanBaoming = reader.ColumnName2Index("ZiyuanBaoming");
        IZiyuanBaomingZuoqi = reader.ColumnName2Index("ZiyuanBaomingZuoqi");
         IHeroBanshen = reader.ColumnName2Index("HeroBanshen"); 
        ISkillAtks = new short[SData_HeroData.MaxSkillCount];
        ISkills = new short[SData_HeroData.MaxSkillCount];
        for (int i = 0; i < SData_HeroData.MaxSkillCount; i++)
        {
            var istr = (i + 1).ToString();
            ISkillAtks[i] = reader.ColumnName2Index("Skill" + istr + "Atk");
            ISkills[i] = reader.ColumnName2Index("Skill" + istr);
        }

        IBiliHP = reader.ColumnName2Index("BiliHP");
        IBiliWuli = reader.ColumnName2Index("BiliWuli");
        IBiliTili = reader.ColumnName2Index("BiliTili");
        IBiliNu = reader.ColumnName2Index("BiliNu");

        IBiliZhili = reader.ColumnName2Index("BiliZhili");
        IBiliJingshen = reader.ColumnName2Index("BiliJingshen");


        IYinchangAudioFx = reader.ColumnName2Index("YinchangAudioFx");

        ITypeIcon = reader.ColumnName2Index("TypeIcon");
        IStartNengliang = reader.ColumnName2Index("StartNengliang");
    }

    internal MonsterDataInfo(ITabReader reader, int row)
    {
        _ID = reader.GetI32(IID, row);
        _Sex = (Sex)reader.GetI16(ISex, row);
        _MingziID = reader.GetI16(IMingziID, row);
        _Type = (HeroType)reader.GetI16(IType, row);
        _MorenXing = reader.GetI16(IMorenXing, row);

        _HeroZhenying = (HeroZhenyingEnum)reader.GetI16(IHeroZhenying, row);
  
        _AtkRange = reader.GetI16(IAtkRange, row);
        _Speed = reader.GetI16(ISpeed, row);
        _ZiyuanBaomingZuoqi = reader.GetS(IZiyuanBaomingZuoqi, row);
        _HeroBanshen = reader.GetS(IHeroBanshen, row); 
        
        _SkillAtks = new string[SData_HeroData.MaxSkillCount];
        _Skills = new Int32[SData_HeroData.MaxSkillCount];
        for (int i = 0; i < SData_HeroData.MaxSkillCount; i++)
        {
            _SkillAtks[i] = reader.GetS(ISkillAtks[i], row);
            _Skills[i] = reader.GetI32(ISkills[i], row);
        }

        _Army = reader.GetI32(IArmy, row);
        _ArmyTaopao = (float)reader.GetI16(IArmyTaopao, row)/100f ;

        _TypeIcon = reader.GetI16(ITypeIcon, row);
        _StartNengliang = reader.GetI16(IStartNengliang,row);

        _BiliHP = reader.GetF(IBiliHP, row);
        _BiliWuli = reader.GetF(IBiliWuli, row);
        _BiliTili = reader.GetF(IBiliTili, row);
        _BiliNu = reader.GetF(IBiliNu, row);

        BiliZhili = reader.GetF(IBiliZhili, row);
        BiliJingshen = reader.GetF(IBiliJingshen, row);

        _MoxingRange = reader.GetI16(IMoxingRange, row);

        _Name = reader.GetS(IName, row);
        _Special = reader.GetS(ISpecial, row);
        _HeroFace = reader.GetS(IHeroFace, row);
        _HeroFaceID = int.Parse(_HeroFace.Substring(1, _HeroFace.Length - 1));

        _ZiyuanBaoming = reader.GetS(IZiyuanBaoming, row);

        _HeroDeadAudioFx = reader.GetI32(IHeroDeadAudioFx, row);

        YinchangAudioFx = reader.GetI32(IYinchangAudioFx, row);
    }

    public void BuildLinks()
    {
        int len = _Skills.Length;
        _SkillObjs = new Skill[len];
        for (int i = 0; i < len; i++)
        {
            var skid = _Skills[i];
            _SkillObjs[i] = skid<=0?null:SData_Skill.Single.Get(skid);
        }

        ArmyObj = SData_Army.Single.Get(_Army);
        if (ArmyObj == null) throw new Exception("英雄表引用了不存在的士兵ID:" + _Army.ToString());


        if (YinchangAudioFx > 0) _YinchangAudioFxObj = SData_AudioFx.Single.Get(YinchangAudioFx);
        if (_HeroDeadAudioFx > 0) _HeroDeadAudioFxObj = SData_AudioFx.Single.Get(_HeroDeadAudioFx);
    }

    public Skill[] SkillObjs { get { return _SkillObjs; } }
    Skill[] _SkillObjs;


    public readonly int _HeroFaceID;
    public readonly HeroType _Type;
    public readonly short _MorenXing;
    public readonly string _ZiyuanBaoming;
    public readonly HeroZhenyingEnum _HeroZhenying;
    public readonly int _HeroDeadAudioFx;
    public AudioFxInfo HeroDeadAudioFxObj { get { return _HeroDeadAudioFxObj; } } 

    AudioFxInfo _HeroDeadAudioFxObj = null;


    public readonly float _BiliHP;
    public readonly float _BiliWuli;
    public readonly float _BiliTili;
    public readonly float _BiliNu;

    public readonly short _MoxingRange;
    public short ModelRange
    {
        get
        {
            if (_MoxingRange == 2 || _MoxingRange == 3) return 1;
            return (short)((_MoxingRange - 1) / 6);
        }
    }

    public float BiliHP { get { return _BiliHP; } }
    public float BiliWuli { get { return _BiliWuli; } }
    public float BiliTili { get { return _BiliTili; } }
    public float BiliNu { get { return _BiliNu; } }
    public short StartNengliang{get{return _StartNengliang;}}

    public readonly float BiliZhili;
    public readonly float BiliJingshen;

    public readonly short _TypeIcon;
    public readonly short _StartNengliang;
    public short TypeIcon { get { return _TypeIcon; } }

    public readonly short _AtkRange;
    public readonly short _Speed;
    public readonly string _ZiyuanBaomingZuoqi;
    public readonly string _HeroBanshen; 

    public readonly string[] _SkillAtks;
    public readonly int[] _Skills;
    public readonly int _ID;
    public readonly Sex _Sex;
    public readonly short _MingziID;
    public readonly string _Name;
    public readonly string _Special;
    public readonly string _HeroFace;
   
    public readonly int _Army;
    public readonly float _ArmyTaopao; 

    public int HeroFaceID { get { return _HeroFaceID;} } 
    public float ArmyTaopao { get { return _ArmyTaopao; } }

    public string ZiyuanBaoming { get { return _ZiyuanBaoming; } }
    public HeroType Type { get { return _Type; } }
    public short MorenXing { get { return _MorenXing; } }
    public string ZiyuanBaomingZuoqi { get { return _ZiyuanBaomingZuoqi; } }
    public HeroZhenyingEnum HeroZhenying { get { return _HeroZhenying; } }
  
    public short AtkRange { get { return _AtkRange; } }
    public short Speed { get { return _Speed; } }
    public string HeroBanshen { get { return _HeroBanshen; } }
  //  public short ActID { get { return _ActID; } }
    public string[] SkillAtks { get { return _SkillAtks; } }


  //  public short ShowNPCZuoqi { get { return _ShowNPCZuoqi; } }
   // public short NPCZuoqiID { get { return _NPCZuoqiID; } }
    public int[] Skills { get { return _Skills; } }
    public int ID { get { return _ID; } }
    public Sex Sex { get { return _Sex; } }
    public short MingziID { get { return _MingziID; } }
    public string Name { get { return _Name; } }

    public string Hanhua { get { return ""; } }
    public string Special { get { return _Special; } }
    public string HeroFace { get { return _HeroFace; } }



    public int CalculationHP( int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowHP;
        return (int)(jichu * BiliHP);
    }
    public int CalculationWuli( int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowWuli;
        return (int)(jichu * BiliWuli);
    }

    public int CalculationTili( int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowTili;
        return (int)(jichu * BiliTili);
    }

    public int CalculationNu( int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowNu;
        return (int)(jichu * BiliNu);
    }

    public int CalculationZhili(int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowZhili;
        return (int)(jichu * BiliZhili);
    }

    public int CalculationJingshen(int level, short xj)
    {
        var jichu = SData_FightKeyValueMath.Single.Get(level).MonsterGrowJingshen;
        return (int)(jichu * BiliJingshen);
    }

    

    public AudioFxInfo YinchangAudioFxObj { get { return _YinchangAudioFxObj; } }

    int YinchangAudioFx;
    public AudioFxInfo _YinchangAudioFxObj;



    public ArmyInfo Army { get { return ArmyObj; } }
    ArmyInfo ArmyObj;
}

public class SData_MonsterData : MonoEX.Singleton<SData_MonsterData>
{
    public SData_MonsterData()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 MonsterData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "MonsterData");

            MonsterDataInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                MonsterDataInfo sa = new MonsterDataInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }

    }

    public void BuildLinks()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "MonsterData 开始建立对象关联");
        foreach (var kv in Data) kv.Value.BuildLinks();
    }


    public MonsterDataInfo Get(int heroId)
    {
        try
        {
            if (!Data.ContainsKey(heroId)) return null;
            return Data[heroId];
        }
        catch (Exception)
        {
            throw new Exception(String.Format("SData_MonsterData::Get() not found data  heroId:{0}", heroId));
        }
    }

    Dictionary<int, MonsterDataInfo> Data = new Dictionary<int, MonsterDataInfo>();
}