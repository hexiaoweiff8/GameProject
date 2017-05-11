using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; 


public enum SoldierType
{
    None = 1,//其它
    Dao = 2,//刀
    Qiang = 3,//枪
    Qi = 4,//骑兵
    Gong = 5,//弓兵
    Fa = 6//法术兵
}

public enum HeroType
{
    None = 1,//未定义，表示通用
    Meng = 2,//猛将
    Yong = 3,//勇将
    Gong = 4,//弓将
    Moushi = 5,//谋士
    All = 6,//全部
}


public enum HeroZhenYing
{
    None = 0,//未定义，表示通用
    Wei = 1,//魏国
    Shu = 2,//蜀国
    Wu = 3,//吴国
    QunXiong = 4,//群雄
    All = 5,//全部
}

 

    public enum SkillType
    {
        General = 1,//普通
        Unique = 2,//必杀技
        Texing = 3,//特性技能
        Shoudong = 4,//手动技能
        //BeiDongAttr = 5,//被动给自己加属性的技能
        BeiDongChiXu = 6,//被动持续
    }

    public enum AtkDirection
    {
        Front = 1,//前方
    }



    public enum SkillObjectType
    {
        Zengyi = 1,//增益技能
        Jianyi = 2//减益技能
    }

    /// <summary>
    /// 必杀技限制
    /// </summary>
    public enum SuperSkillTerm
    {
        None= 1,//无限制
        BeiHou = 2//背后攻击时
    }


    public enum SkillEffectType
    {
        None = -1,//什么也不是
        Hit = 1,//攻击类       （读F$HitPercent字段）
        EditAttr = 2,//修改属性类   （读I16$HitType字段）
        State = 3,//状态类       （读I16$Zhuangtai字段）
        Zhili = 4,//智力攻击
        ZhiliEditAttr = 5,//智力治疗
    }
    
    public enum SkillHitType
    {
        Node = 0,//无效
        Jia = 1,//加数值 
        JiaBfb = 2,//加百分比  
        Jian = 3,//减数值
        JianBfb = 4//减百分比
    }
     
    public enum SkillDVType
    {
        none=-1,//什么也不是
        hpmap=1,//HP  
        currhp = 2,//当前HP
        wl = 3,//武力
        tl = 4,//体力
        fyl = 5,//防御率
        nu = 6,//怒
        bsjgl = 7,//必杀技使用几率 
        speed = 8,//移动速度        
    }



    public enum SkillEffectBOOLST
    {
        None = 0,
        Shuaxin = 1,//立即刷新状态 
        Fengji = 2,//封技 ok
        Dingshen = 3,//	定身状态 ok
        Yun = 4,//晕眩 ok
        Zhongdu = 5,//中毒 ok 
        Bianxing = 6,//变形
        Jiaoxie = 7,//缴械 ok
        WujiangFendan = 8, //武将间分担伤害
        DaduanShoudong = 9,//打断手动
        Xixue = 10,//吸血
        HeroWudi = 11,//武将无敌 ok
        ArmyWudi = 12,//士兵无敌 ok
        Fantan = 13,//	反弹伤害
        Meihuo = 14,//	魅惑
        ShanghaiJilei = 15,//伤害积累效果（延后做）
        ZhiliaoLeiji = 16,//治疗积累效果（延后做）
        Taopao = 18,//	逃跑效果	 
        Mianyi_Fengji = 42,//免疫封技 ok
        Mianyi_Dingshen = 43,//	免疫定身 ok
        Mianyi_Yun = 44,//	免疫晕眩 ok
        Mianyi_Zhongdu = 45,//免疫中毒 ok
        Mianyi_Bianxing = 46,//免疫变形
        Mianyi_Jiaoxie = 47,//免疫缴械 ok
        Mianyi_Meihuo = 54,//免疫魅惑
        Mianyi_Taopao = 58,//免疫逃跑效果
        Mianyi_All = 70, //免疫多个负面效果 ok
        CDEditor = 71,//主动技能CD增加or减少
        AddBisha = 72,//必杀技能权重提高 ok
        Fubing = 74,//伏兵
        Qixi = 75,//奇袭
        MAX =  76//上限
    }

    public class SkillEffect
    {
        internal static short IEffectID;
        internal static short IHitNo;
        //internal static short IHitTypeGrow;

        internal static short ISkillArriveID;
        
        internal static short IShengcunAudioFx; 
        internal static short IBeijiAudioFx;
       
        
        internal static short IEndSkillTrigger;

        internal static short IIsDiejia;
        internal static short IDiejiaType;
        internal static short IIcon;
        
       
        internal static short IIsLvUp; 
        internal static short IGrowWithLvID;
        internal static short IGrowWithLvPercentID;
        
        internal static short IEffectType;
        internal static short IHitPercent; 
        internal static short ISkillHit;
        internal static short IHitType;
        internal static short ISkillRangeID; 
       // internal static short IHitGrowHero; 
        //internal static short IHitGrowSkillHit;  
        internal static short IShuxingType; 
        internal static short  IZhuangtai;
        internal static short I2ndZhuangtai;
        internal static short I3rdZhuangtai;

        internal static void FillFieldIndex(ITabReader reader)
        {
            IEffectID = reader.ColumnName2Index("EffectID"); 
            IEffectType = reader.ColumnName2Index("EffectType");
            IHitPercent = reader.ColumnName2Index("HitPercent");
            ISkillHit = reader.ColumnName2Index("SkillHit");
            IHitType = reader.ColumnName2Index("HitType");
            ISkillRangeID = reader.ColumnName2Index("SkillRangeID");

           // IHitGrowHero = reader.ColumnName2Index("HitGrowHero");

            //IHitGrowSkillHit = reader.ColumnName2Index("HitGrowSkillHit"); 
            IShuxingType = reader.ColumnName2Index("ShuxingType");

            IZhuangtai = reader.ColumnName2Index("Zhuangtai");
            I2ndZhuangtai = reader.ColumnName2Index("2ndZhuangtai");
            I3rdZhuangtai = reader.ColumnName2Index("3rdZhuangtai");
            IHitNo = reader.ColumnName2Index("HitNo");
            //IHitTypeGrow = reader.ColumnName2Index("HitTypeGrow");
            IGrowWithLvID = reader.ColumnName2Index("GrowWithLvID");
            IGrowWithLvPercentID = reader.ColumnName2Index("GrowWithLvPercentID"); 

            ISkillArriveID = reader.ColumnName2Index("SkillArriveID");
           
            IShengcunAudioFx = reader.ColumnName2Index("ShengcunAudioFx");
            IBeijiAudioFx = reader.ColumnName2Index("BeijiAudioFx");
           
           
            IEndSkillTrigger = reader.ColumnName2Index("EndSkillTrigger");
            IIsDiejia = reader.ColumnName2Index("IsDiejia");
            IDiejiaType = reader.ColumnName2Index("DiejiaType");
            IIcon = reader.ColumnName2Index("Icon");
            
        }
        public SkillEffect(ITabReader reader,int row)
        {
            //i32
            _EffectID = (int)reader.GetI32(IEffectID,row);//	效果ID  
            _SkillHit = reader.GetI16(ISkillHit,row);
            _HitType = (SkillHitType)reader.GetI16(IHitType,row);
            _EffectType = (SkillEffectType)reader.GetI16(IEffectType,row);
            SkillRangeID = reader.GetI32(ISkillRangeID, row);
            short _Zhuangtai = reader.GetI16(IZhuangtai,row);
            _2ndZhuangtai = reader.GetI32(I2ndZhuangtai, row);
            _3rdZhuangtai = reader.GetF(I3rdZhuangtai, row);
            Icon = reader.GetS(IIcon, row);
            Zhuangtai = (_Zhuangtai > 0 && _Zhuangtai < (short)SkillEffectBOOLST.MAX) ? (SkillEffectBOOLST)_Zhuangtai : SkillEffectBOOLST.None;
            _ShuxingType = (SkillDVType)reader.GetI16(IShuxingType,row);

            //F
            _HitPercent = reader.GetF(IHitPercent,row);//	发挥攻击力比例（对武将） 
            //_HitGrowHero = reader.GetF(IHitGrowHero,row);
            //_HitGrowSkillHit = (int)reader.GetF(IHitGrowSkillHit, row);
            HitNo = reader.GetF(IHitNo, row);
            //HitTypeGrow = reader.GetF(IHitTypeGrow, row);
            GrowWithLvID = reader.GetI16(IGrowWithLvID, row);
            GrowWithLvPercentID = reader.GetI16(IGrowWithLvPercentID, row);
            
            EndSkillTrigger = reader.GetI32(IEndSkillTrigger, row);
            ShengcunAudioFx = reader.GetI32(IShengcunAudioFx, row);
            BeijiAudioFx = reader.GetI32(IBeijiAudioFx, row);
            SkillArriveID = reader.GetI32(ISkillArriveID, row);
            IsDiejia = reader.GetI16(IIsDiejia, row) == 1;
            DiejiaType = reader.GetI16(IDiejiaType, row);
        }


        public void BuildLinks()
        {
            SkillRange = SData_SkillRange.Single.Get(SkillRangeID);//技能范围id 

            if (SkillArriveID>0) SkillArriveObj = SData_SkillArrive.Single.Get(SkillArriveID);
            
            if(ShengcunAudioFx>0)ShengcunAudioFxObj = SData_AudioFx.Single.Get(ShengcunAudioFx);
            if(BeijiAudioFx>0)BeijiAudioFxObj = SData_AudioFx.Single.Get(BeijiAudioFx);

            if (EndSkillTrigger > 0) EndSkillTriggerObj = SData_SkillTrigger.Single.Get(EndSkillTrigger);
        }

     

       
        readonly int ShengcunAudioFx; 
        readonly int BeijiAudioFx;
        readonly int SkillArriveID;
        public SkillArriveInfo SkillArriveObj;
        readonly int EndSkillTrigger;

        public readonly bool IsDiejia;
        public readonly short DiejiaType;

        public SkillTriggerInfo EndSkillTriggerObj;
       

        public AudioFxInfo ShengcunAudioFxObj;
        public AudioFxInfo BeijiAudioFxObj;
    

        public readonly short GrowWithLvID;
        public readonly short GrowWithLvPercentID;
        
     
        XGICO SelectIcoByHitType(XGICO jia,XGICO jian,XGICO jiaBfb,XGICO jianBfb)
        {
            switch(HitType)
            {
                case SkillHitType.Jia:
                    return jia;
                case SkillHitType.JiaBfb:
                    return jiaBfb;
                case SkillHitType.Jian:
                    return jian;
                case SkillHitType.JianBfb:
                    return jianBfb;
                default:
                    return XGICO.NONE;
            }
        }

     
        public SkillEffectBOOLST Zhuangtai;//状态
        public readonly int _2ndZhuangtai;
        public readonly float _3rdZhuangtai;
        public readonly string Icon;
      
        //public readonly float Float_3rdZhuangtai;
        //I32BoolValue _BoolST1 = new I32BoolValue(0);//布尔类型状态 
        //I32BoolValue _BoolST2 = new I32BoolValue(0);//布尔类型状态 

        public float BuffHitPercentArmy;
        public int EffectID { get { return _EffectID; } }//	效果ID  
        //public int ColumnRange { get { return _ColumnRange; } }//	列攻击范围
         public float ActiveTime { get { return _ActiveTime; } }//	作用时间
        public SkillEffectType EffectType { get { return _EffectType; } }//	"效果类型

         
        
        public SkillHitType HitType { get { return _HitType; } }//	修改方式


        //	发挥攻击力比例（对武将）
        public float GetHitPercent( int sklv)
        { 
            //return _HitPercent + _HitGrowHero * (sklv - 1) * SData_GrowWithLv.Single.Get(GrowWithLvID, sklv) ;
            return (float)_HitPercent * SData_GrowWithLv.Single.Get(GrowWithLvPercentID, sklv);
        }

        //	技能伤害
        public float GetSkillHit(  int sklv)
        {
            //return _SkillHit + _HitGrowHero * (sklv - 1) * SData_GrowWithLv.Single.Get(GrowWithLvID, sklv);
            return (float)_SkillHit * SData_GrowWithLv.Single.Get(GrowWithLvID, sklv);
        }

        /// <summary>
        /// 编辑属性效果
        /// </summary>
        public float GetEditAttrV(int sklv)
        {
            //return HitNo + (sklv - 1) * HitTypeGrow * SData_GrowWithLv.Single.Get(GrowWithLvID, sklv); 
            return HitNo * SData_GrowWithLv.Single.Get(GrowWithLvID, sklv); 
        }


        public float GetBuffHitPercent(bool isUpSk, int skilllv)
        {
			return isUpSk?BuffHitPercent + BUFFHitGrowHero * (skilllv-1):BuffHitPercent;
		}

        public float GetBUFFSkillHit(bool isUpSk, int skilllv)
        {
			return isUpSk?BUFFSkillHit + BUFFHitGrowSkillHit * (skilllv-1):BUFFSkillHit;
		} 

         
        public SkillDVType ShuxingType { get { return _ShuxingType; } }//属性类型
         
        int _EffectID;//	效果ID 
        float _ActiveTime;//	作用时间
        public readonly float HitPoint;//数值结算点

        public readonly float   BuffHitPercent  ;
        public readonly float    BUFFSkillHit  ;
        public readonly float  BUFFHitGrowHero ;
        public readonly float BUFFHitGrowSkillHit  ;

        
       public readonly float HitNo;
       //public readonly float HitTypeGrow;
       public SkillRangeInfo SkillRange;

       int SkillRangeID;//技能范围id
        SkillEffectType _EffectType;//	"效果类型
        float _HitPercent;//	发挥攻击力比例（对武将） 
        int _SkillHit;//	技能伤害
        SkillHitType _HitType;//	修改方式

        //bool _Yun;//晕眩

        //float _HitGrowHero;
      
        //int _HitGrowSkillHit;

        SkillDVType _ShuxingType;//属性类型

    }


    //手动技能释放条件    
    public enum ShouDongSkillTJ
    {
        NONE = -1,//什么也不是
        TJ1 = 1,//时间积累初始为0,   
        TJ2 = 2,//时间积累初始为满 
        TS = 3,//特殊条件
    };


    public class Skill
    {
        internal static short IID;
        internal static short IIsLvUp;
        internal static short ISkillName;
        internal static short ISkillNote;
        internal static short ISkillNoteMin;
        internal static short ISkillType;
        internal static short[] ITakeEffect = new short[5];
        internal static short[] IAddTakeEffect= new short[2];
        internal static short[] ITakeBox = new short[3];
        internal static short IAddTakeBox1;
        internal static short IAtkTime;
        internal static short ISuperSkillWeight;
        internal static short IZhandouli;
        internal static short IZhandouliAdd;
        internal static short IIcon;
        internal static short IYinchangTime;
        internal static short ISkillTriggerID;
        internal static short INengliangzhi;
       
        internal static short IShifaAudioFx;
        internal static short IChufaAudioFx;
        internal static short IAddSkillTriggerID;

        //internal static short IAddSkillID;
        //internal static short[] IAddEffectID = new short[2];
    

        internal static void FillFieldIndex(ITabReader reader)
        {
            IID = reader.ColumnName2Index("ID");
            ISkillName = reader.ColumnName2Index("SkillName");
            ISkillType = reader.ColumnName2Index("SkillType");
            IIcon = reader.ColumnName2Index("Icon");
            IIsLvUp = reader.ColumnName2Index("IsLvUp");
            IZhandouliAdd = reader.ColumnName2Index("ZhandouliAdd");
            IZhandouli = reader.ColumnName2Index("Zhandouli");
            IAtkTime = reader.ColumnName2Index("AtkTime");
            ISuperSkillWeight = reader.ColumnName2Index("SuperSkillWeight");
            ISkillNote = reader.ColumnName2Index("SkillNote");
            ISkillNoteMin = reader.ColumnName2Index("SkillNoteMin");
            IYinchangTime = reader.ColumnName2Index("YinchangTime");
            ISkillTriggerID = reader.ColumnName2Index("SkillTriggerID");
            INengliangzhi = reader.ColumnName2Index("Nengliangzhi");
            IAddSkillTriggerID = reader.ColumnName2Index("AddSkillTriggerID");
            for (int i = 0; i < ITakeEffect.Length; i++)
            {
                string istr = (i + 1).ToString();
                ITakeEffect[i] = reader.ColumnName2Index("TakeEffect" + istr);
            }

            for (int i = 0; i < IAddTakeEffect.Length; i++)
            {
                string istr = (i + 1).ToString();
                IAddTakeEffect[i] = reader.ColumnName2Index("AddTakeEffect" + istr);
            }
            

            for (int i = 0; i < ITakeBox.Length; i++)
            {
                string istr = (i + 1).ToString();
                ITakeBox[i] = reader.ColumnName2Index("TakeBox" + istr);
            }

            IAddTakeBox1 = reader.ColumnName2Index("AddTakeBox1" );

            IShifaAudioFx = reader.ColumnName2Index("ShifaAudioFx");
            IChufaAudioFx = reader.ColumnName2Index("ChufaAudioFx");


            /*
            for (int i = 0; i < IAddEffectID.Length; i++)
            {
                string istr = (i + 1).ToString();
                IAddEffectID[i] = reader.ColumnName2Index("AddEffectID" + istr);
            }
                
            IAddSkillID = reader.ColumnName2Index("AddSkillID");*/
        }
        public Skill(SData_Skill sdataSkill, ITabReader reader, int row)
        {
            m_id = (int)reader.GetI32(IID, row);

            _name = reader.GetS(ISkillName, row);
            m_Icon = reader.GetS(IIcon, row);
            //if (m_Icon == "0") m_Icon = "";

            ZhandouliAdd = reader.GetI32(IZhandouliAdd, row);
            m_SuperSkillWeight = reader.GetI16(ISuperSkillWeight, row);
            m_Zhandouli = (int)reader.GetI32(IZhandouli, row);

           
            ShifaAudioFx = reader.GetI32(IShifaAudioFx, row);
            ChufaAudioFx = reader.GetI32(IChufaAudioFx, row);

            m_SkillType = (SkillType)reader.GetI16(ISkillType, row);
            IsLvUp = reader.GetI16(IIsLvUp, row) == 1;
            m_AtkTime = (float)(reader.GetI16(IAtkTime, row)) / 1000.0f;

            SkillNote = reader.GetS(ISkillNote, row);
            SkillNoteMin = reader.GetS(ISkillNoteMin, row);
            
            YinchangTime = (float)reader.GetI16(IYinchangTime, row) / 1000f;


            Nengliangzhi = reader.GetI16(INengliangzhi, row);
            SkillTriggerID = reader.GetI32(ISkillTriggerID, row);
            AddSkillTriggerID = reader.GetI32(IAddSkillTriggerID, row);

            List<SkillEffect> skeffectList = new List<SkillEffect>();
            for (int j = 1; j <= 5; j++)
            {
                int tid = (int)reader.GetI32(ITakeEffect[j - 1], row);
                if (tid > 0) skeffectList.Add(sdataSkill.GetEffect(tid));
            }
            TakeEffects = skeffectList.ToArray();

            skeffectList.Clear();
            for (int j = 1; j <= 2; j++)
            {
                int tid = (int)reader.GetI32(IAddTakeEffect[j - 1], row);
                if (tid > 0) skeffectList.Add(sdataSkill.GetEffect(tid));
            }
            AddTakeEffects = skeffectList.ToArray();


            tmpTakeBoxs.Clear();
            for (int j = 1; j <= 3; j++)
            {
                int tid =  reader.GetI32(ITakeBox[j - 1], row);

                if (tid > 0) tmpTakeBoxs.Add(tid);
            }
            TakeBoxIDs = tmpTakeBoxs.ToArray();

            AddTakeBoxID = reader.GetI32(IAddTakeBox1, row);

            /*
            AddEffectID = new int[2];
            for (int i = 0; i < 2; i++)
            {
                AddEffectID[i] = reader.GetI32(IAddEffectID[i], row);
            }

            IAddSkillID = reader.ColumnName2Index("AddSkillID");*/
            
        }
        List<int> tmpTakeBoxs = new List<int>();

      //  readonly int[] AddEffectID;
        readonly int[] TakeBoxIDs = null;
        readonly int AddTakeBoxID = -1;


        public SkillBoxInfo[] TakeBoxObjs = null;
        public SkillBoxInfo AddTakeBoxObj = null;

        public int id { get { return m_id; } }
        public SkillType SkillType { get { return m_SkillType; } }
        public string Icon { get { return m_Icon; } }
        public readonly bool IsLvUp = false;
        public readonly float ZhandouliAdd = 0.0f;
        public String Name { get { return _name; } }

        public void BuildLinks()
        {
            //if (SkillType != SkillType.BeiDongAttr && SkillType != SkillType.BeiDongChiXu && SkillType != SkillType.General)
            
            if(SkillTriggerID>0) _SkillTrigger = SData_SkillTrigger.Single.Get(SkillTriggerID);

            if (AddSkillTriggerID > 0) AddSkillTrigger = SData_SkillTrigger.Single.Get(AddSkillTriggerID);

           
            if (ShifaAudioFx > 0) ShifaAudioFxObj = SData_AudioFx.Single.Get(ShifaAudioFx);
            if (ChufaAudioFx > 0) ChufaAudioFxObj = SData_AudioFx.Single.Get(ChufaAudioFx);


            if(AddTakeBoxID>0)   AddTakeBoxObj = SData_SkillBox.Single.Get(AddTakeBoxID);

            int len = TakeBoxIDs.Length;
            TakeBoxObjs = new SkillBoxInfo[len]; 
            for(int i=0;i<len;i++) TakeBoxObjs[i] = SData_SkillBox.Single.Get(TakeBoxIDs[i]); 
        }

        int m_id;
        SkillType m_SkillType;
        string m_Icon;
        String _name;

        public int MaxLv { get { return _MaxLv; } }


        int _MaxLv = 0;



        /// <summary>
        /// 必杀技权重
        /// </summary>
        public short SuperSkillWeight { get { return m_SuperSkillWeight; } }

        public float AtkTime { get { return m_AtkTime; } }
        public int Zhandouli { get { return m_Zhandouli; } }

      
       public AudioFxInfo ShifaAudioFxObj;
       public AudioFxInfo ChufaAudioFxObj;
        
        int ShifaAudioFx;
        int ChufaAudioFx;


        float m_AtkTime;
        int m_Zhandouli;
        short m_SuperSkillWeight;

        public readonly string SkillNoteMin;
        public readonly string SkillNote;
        public readonly float YinchangTime;

        public readonly short Nengliangzhi;
        readonly int SkillTriggerID;
        readonly int AddSkillTriggerID;
        public SkillTriggerInfo SkillTrigger { get { return _SkillTrigger; } }
        SkillTriggerInfo _SkillTrigger;
        public SkillTriggerInfo AddSkillTrigger;

        public readonly SkillEffect[] TakeEffects = null;//技能效果 
        public readonly SkillEffect[] AddTakeEffects = null;//必杀技能效果
    }


    public class SData_Skill : MonoEX.Singleton<SData_Skill>
    {
        public SData_Skill()
        {
            
            //读取技能效果


            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillEffect");

                reader.Load("bsv", "SkillEffect");//
                SkillEffect.FillFieldIndex(reader);
                int rowCount = reader.GetRowCount(); 
                for (int row = 0; row < rowCount; row++)
                {
                    SkillEffect sa = new SkillEffect(reader, row);

                    try
                    {
                        EffectData.Add(sa.EffectID, sa);
                    }catch(Exception )
                    {
                        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_DEBUG, "重复的效果EffectID " + sa.EffectID.ToString());
                    }
                }
            }
             
            //读取技能信息
            
          
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SkillData");

                reader.Load("bsv", "SkillData");
                Skill.FillFieldIndex(reader);
                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    Skill sa = new Skill(this,reader, row);
                    if (Data.ContainsKey(sa.id))
                        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + sa.id.ToString());
                    Data.Add(sa.id, sa);
                }
            } 
        }

        //构建对象之间的联系
        public void BuildLinks()
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "SkillData 开始建立对象关联");
            foreach (var skill in Data) skill.Value.BuildLinks();

            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "SkillEffect 开始建立对象关联");
            foreach (var kv in EffectData) kv.Value.BuildLinks();
        }

        public Skill Get(int skillid)
        {
            try
            {
                return Data[skillid];
            }
            catch (Exception )
            {
                throw new Exception(String.Format("SData_Skill Get ID:{0}", skillid)); 
            }
        }

        public SkillEffect GetEffect(int id)
        {
            if (!EffectData.ContainsKey(id))
            {
                throw new Exception(String.Format("错误的效果ID {0}", id));
                throw new Exception();
            }
            return EffectData[id];
        }

        Dictionary<int, Skill> Data = new Dictionary<int, Skill>();
        Dictionary<int, SkillEffect> EffectData = new Dictionary<int, SkillEffect>(); 
    } 
