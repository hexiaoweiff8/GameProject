﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; 
using System.Xml;


public enum Sex
{
    None = 0,
    Man = 1,
    Woman = 2,
    All = 3
}


public class HeroRestraintOnce
{
    public HeroType heroType;
    public float Modulus;
    public float DefModulus;
};

    public class XingAttr
    {
        public float HP;
        public float Wuli;
        public float Tili;
        public float Nu;
    }

    public class HeroDataInfo:IHeroInfo
    {
        internal static short IID;
        internal static short IName;
        internal static short IHanhua;
        internal static short IMingziID;
        internal static short IType; 
        internal static short IMorenXing;
        internal static short IArmy;
        internal static short ITypeIcon; 
        internal static short[] ISkills;
        internal static short IAtkRange;
        internal static short ISpeed;
        internal static short IHeroFace;
        internal static short ISurrenderCostID;
        internal static short[] ISkillAtks;
        internal static short IZiyuanBaoming;
        internal static short IZiyuanBaomingZuoqi;

        internal static short IMoxingRange;

        internal static void FillFieldIndex(ITabReader reader)
        {
            IID = reader.ColumnName2Index("ID");
            IName = reader.ColumnName2Index("Name");
            IHanhua = reader.ColumnName2Index("Hanhua");
            IMingziID = reader.ColumnName2Index("MingziID");
            IType = reader.ColumnName2Index("Type");
            IMorenXing = reader.ColumnName2Index("MorenXing");
            IArmy = reader.ColumnName2Index("Army");
            ITypeIcon = reader.ColumnName2Index("TypeIcon"); 
            IAtkRange = reader.ColumnName2Index("AtkRange");
            ISpeed = reader.ColumnName2Index("Speed");
            IHeroFace = reader.ColumnName2Index("HeroFace");
            IZiyuanBaoming = reader.ColumnName2Index("ZiyuanBaoming");
            ISurrenderCostID = reader.ColumnName2Index("SurrenderCostID");
            IZiyuanBaomingZuoqi = reader.ColumnName2Index("ZiyuanBaomingZuoqi");
            ISkillAtks = new short[SData_HeroData.MaxSkillCount];
            ISkills = new short[SData_HeroData.MaxSkillCount];
            for (int i = 0; i < SData_HeroData.MaxSkillCount; i++)
            {
                var istr = (i + 1).ToString();
                ISkillAtks[i] = reader.ColumnName2Index("Skill"+istr+"Atk"   );
                ISkills[i] = reader.ColumnName2Index("Skill" + istr);
            }
            IMoxingRange = reader.ColumnName2Index("MoxingRange");

        }

        internal HeroDataInfo(ITabReader reader, int row)
        {
            _ID = reader.GetI32(IID, row);
            _MingziID = reader.GetI16(IMingziID, row);
            _Type = (HeroType)reader.GetI16(IType, row);
            _MorenXing = reader.GetI16(IMorenXing, row);

            _TypeIcon = reader.GetI16(ITypeIcon, row);
            _AtkRange = reader.GetI16(IAtkRange, row);
            _Speed = reader.GetI16(ISpeed, row);
            SurrenderCostID = reader.GetI16(ISurrenderCostID, row);
            _ZiyuanBaomingZuoqi = reader.GetS(IZiyuanBaomingZuoqi, row);

            _MoxingRange = reader.GetI16(IMoxingRange, row);

            _SkillAtks = new string[SData_HeroData.MaxSkillCount];
            _Skills = new int[SData_HeroData.MaxSkillCount];
            for (int i = 0; i < SData_HeroData.MaxSkillCount; i++)
            {
                _SkillAtks[i] = reader.GetS(ISkillAtks[i], row);
                _Skills[i] = reader.GetI32(ISkills[i], row);
            }
            _Army = reader.GetI32(IArmy, row);

            _Name = reader.GetS(IName, row);
            _Hanhua = reader.GetS(IHanhua, row);
            _HeroFace = reader.GetS(IHeroFace, row);
            _ZiyuanBaoming = reader.GetS(IZiyuanBaoming, row);
            _HeroFaceID = int.Parse(_HeroFace.Substring(1, _HeroFace.Length - 1));

        }
        public readonly int _HeroFaceID;
        public readonly int _ID;
        public readonly string _ZiyuanBaoming;
        public readonly short SurrenderCostID;
        public readonly short _MingziID;
        public readonly HeroType _Type;
        public readonly short _MorenXing;
        public readonly short _TypeIcon;
        public readonly short _AtkRange;
        public readonly short _Speed;
        public readonly string HtitleHeroTitle;
        public readonly string[] _SkillAtks;
        public readonly int[] _Skills;
        public readonly int _Army;
        public readonly short _MoxingRange;

        public short ModelRange
        {
            get
            {
                if (_MoxingRange == 2||_MoxingRange ==3) return 1;
                return (short)((_MoxingRange - 1) / 6);
            }
        }


        public readonly short _StartNengliang;
        public short TypeIcon { get { return _TypeIcon; } }

        ArmyInfo ArmyObj;

        public readonly string _Name;
        public readonly string _Hanhua;
        public readonly string _Special;
        public readonly string History;
        public readonly string _HeroFace;
        public readonly string _ZiyuanBaomingZuoqi;


        public HeroType Type { get { return _Type; } }
        public short MorenXing { get { return _MorenXing; } }
        public int HeroFaceID { get { return _HeroFaceID; } }
     
        public short AtkRange { get { return _AtkRange; } }
        public short Speed { get { return _Speed; } }




        public readonly int _HeroDeadAudioFx;
        public AudioFxInfo HeroDeadAudioFxObj { get { return _HeroDeadAudioFxObj; } }

        AudioFxInfo _HeroDeadAudioFxObj = null;


        public string ZiyuanBaomingZuoqi { get { return _ZiyuanBaomingZuoqi; } }

        public string[] SkillAtks { get { return _SkillAtks; } }

        public string ZiyuanBaoming { get { return _ZiyuanBaoming; } }

        public int[] Skills { get { return _Skills; } }

        public int CalculationHP( int level, short xj)
        {
            var jichu = SData_FightKeyValueMath.Single.Get(level).HeroGudingHP[xj - 1] +
       SData_FightKeyValueMath.Single.Get(level).HeroGrowHP;
            return jichu;
        }
        public void BuildLinks()
        { 

            int len = _Skills.Length;
            _SkillObjs = new Skill[len];
            for (int i = 0; i < len; i++)
            {
                var skid = _Skills[i];
                _SkillObjs[i] = skid <= 0 ? null : SData_Skill.Single.Get(skid);
            }

            ArmyObj = SData_Army.Single.Get(_Army);
            if (ArmyObj == null) throw new Exception("英雄表引用了不存在的士兵ID:" + _Army.ToString());

            if (YinchangAudioFx > 0) _YinchangAudioFxObj = SData_AudioFx.Single.Get(YinchangAudioFx);
            if (_HeroDeadAudioFx > 0) _HeroDeadAudioFxObj = SData_AudioFx.Single.Get(_HeroDeadAudioFx);

        }

        public Skill[] SkillObjs { get { return _SkillObjs; } }
        Skill[] _SkillObjs;
        /// <summary>
        /// 获取技能索引号
        /// </summary>
        public short GetSkillIndex(int skillID)
        {
            short len = (short)_Skills.Length;
            for (short i = 0; i < len; i++) if (_Skills[i] == skillID) return i;

            return -1;
        }

        public int ID { get { return _ID; } }
        public short MingziID { get { return _MingziID; } }
        public string Name { get { return _Name; } }
        public string Hanhua { get { return _Hanhua; } }
        public string Special { get { return _Special; } }
        public string HeroFace { get { return _HeroFace; } }

        public ArmyInfo Army { get { return ArmyObj; } }

        public AudioFxInfo YinchangAudioFxObj { get { return _YinchangAudioFxObj; } }

        int YinchangAudioFx;
        public AudioFxInfo _YinchangAudioFxObj;
    }

    public class SData_HeroData : MonoEX.Singleton<SData_HeroData>
    {
        public const int MaxSkillCount = 6;

        public SData_HeroData()
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 HeroData");
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 HeroData");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "HeroData");

                HeroDataInfo.FillFieldIndex(reader);
                
                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    HeroDataInfo sa = new HeroDataInfo(reader, row);
                    if (Data.ContainsKey(sa.ID))
                        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + sa.ID.ToString());
                    Data.Add(sa.ID, sa); 
                }
            }
          
        }


        public void BuildLinks()
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "HeroData 开始建立对象关联");

            foreach (var kv in Data) kv.Value.BuildLinks();
        }

        public HeroDataInfo GetHeroData(int heroId)
        {
            try
            {
                if (!Data.ContainsKey(heroId)) return null;
                return Data[heroId];
            }
            catch (Exception)
            {
                throw new Exception(String.Format("SData_Hero::Get() not found data  heroId:{0}", heroId)); 
            }
        } 
              
        internal Dictionary<int, HeroDataInfo> Data = new Dictionary<int, HeroDataInfo>();  
    }

    //1星固定 * 4星固定加成 + (等级-1)*1星成长*4星加成
    


    public class SData_Hero
    {
        public static IHeroInfo Get(int id)
        {
           IHeroInfo re = SData_HeroData.Single.GetHeroData(id);
           if (re != null) return re;
           return SData_MonsterData.Single.Get(id);
        }
    }
