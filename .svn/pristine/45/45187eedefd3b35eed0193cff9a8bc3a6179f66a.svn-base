using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class FightKeyValueMathInfo
{
    internal static short IID;
    internal static short INTiliBeishu;
    internal static short INnu;
    internal static short IHPHeroZhandouli;
    internal static short IWuliHeroZhandouli;
    internal static short ITiliHeroZhandouli;
    internal static short INuHeroZhandouli;
    internal static short IHPArmyZhandouli;
    internal static short IWuliArmyZhandouli;
    internal static short ITiliArmyZhandouli;

    internal static short[] IHeroGudingHP;
    internal static short[] IHeroGudingWuli;
    internal static short[] IHeroGudingTili;
    internal static short[] IHeroGudingNu;
    internal static short IHeroGrowHP;
    internal static short IHeroGrowWuli;
    internal static short IHeroGrowTili;
    internal static short IHeroGrowNu;

    internal static short[] IArmyGudingHP;
    internal static short[] IArmyGudingWuli;
    internal static short[] IArmyGudingTili;
    internal static short[] IArmyGudingNu;

   

    internal static short IArmyGrowHP;
    internal static short IArmyGrowWuli;
    internal static short IArmyGrowTili;
    internal static short IArmyGrowNu;

    internal static short[] IArmyGudingZhili;
    internal static short[] IArmyGudingJingshen;
    internal static short[] IHeroGudingZhili;
    internal static short[] IHeroGudingJingshen;
    internal static short INJingshenBeishu;
    internal static short IZhiliHeroZhandouli;
    internal static short IJingshenHeroZhandouli;
    internal static short IZhiliArmyZhandouli;
    internal static short IJingshenArmyZhandouli;
    internal static short  IHeroGrowZhili;
    internal static short IHeroGrowJingshen;
    internal static short IArmyGrowZhili;
    internal static short IArmyGrowJingshen;


     internal static short IArmyMonsterGrowHP;
     internal static short IArmyMonsterGrowWuli;
     internal static short IArmyMonsterGrowTili;
     internal static short IArmyMonsterGrowZhili;
     internal static short IArmyMonsterGrowJingshen;
     internal static short IArmyMonsterGrowNu;

  

    internal static short IMonsterGrowHP;
    internal static short IMonsterGrowWuli;
    internal static short IMonsterGrowTili;
    internal static short IMonsterGrowNu;
    internal static short IMonsterGrowZhili;
    internal static short IMonsterGrowJingshen;

    const int MaxXing = 7;//最大星级

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        INTiliBeishu = reader.ColumnName2Index("NTiliBeishu");
        INnu = reader.ColumnName2Index("Nnu");
        IHPHeroZhandouli = reader.ColumnName2Index("HPHeroZhandouli");
        IWuliHeroZhandouli = reader.ColumnName2Index("WuliHeroZhandouli");
        ITiliHeroZhandouli = reader.ColumnName2Index("TiliHeroZhandouli");
        INuHeroZhandouli = reader.ColumnName2Index("NuHeroZhandouli");
        IHPArmyZhandouli = reader.ColumnName2Index("HPArmyZhandouli");
        IWuliArmyZhandouli = reader.ColumnName2Index("WuliArmyZhandouli");
        ITiliArmyZhandouli = reader.ColumnName2Index("TiliArmyZhandouli");

        IHeroGudingHP = new short[MaxXing];
        IHeroGudingWuli = new short[MaxXing];
        IHeroGudingTili = new short[MaxXing];
        IHeroGudingNu = new short[MaxXing];
        IHeroGudingZhili = new short[MaxXing];
        IHeroGudingJingshen = new short[MaxXing];

        IArmyGudingHP = new short[MaxXing];
        IArmyGudingWuli = new short[MaxXing];
        IArmyGudingTili = new short[MaxXing];
        IArmyGudingNu = new short[MaxXing];
        IArmyGudingZhili= new short[MaxXing];
        IArmyGudingJingshen = new short[MaxXing];
        for (int i = 1; i <= MaxXing; i++)
        {
            int idx = i - 1;

            var istr = i.ToString();
            IHeroGudingHP[idx] = reader.ColumnName2Index("HeroGudingHP" + istr);
            IHeroGudingWuli[idx] = reader.ColumnName2Index("HeroGudingWuli" + istr);
            IHeroGudingTili[idx] = reader.ColumnName2Index("HeroGudingTili" + istr);
            IHeroGudingNu[idx] = reader.ColumnName2Index("HeroGudingNu" + istr);
            IHeroGudingZhili[idx] = reader.ColumnName2Index("HeroGudingZhili" + istr);
            IHeroGudingJingshen[idx] = reader.ColumnName2Index("HeroGudingJingshen" + istr);

            IArmyGudingHP[idx] = reader.ColumnName2Index("ArmyGudingHP" + istr);
            IArmyGudingWuli[idx] = reader.ColumnName2Index("ArmyGudingWuli" + istr);
            IArmyGudingTili[idx] = reader.ColumnName2Index("ArmyGudingTili" + istr);
            IArmyGudingNu[idx] = reader.ColumnName2Index("ArmyGudingNu" + istr);
            IArmyGudingZhili[idx] = reader.ColumnName2Index("ArmyGudingZhili" + istr);
            IArmyGudingJingshen[idx] = reader.ColumnName2Index("ArmyGudingJingshen" + istr);
        }

        IHeroGrowHP = reader.ColumnName2Index("HeroGrowHP");
        IHeroGrowWuli = reader.ColumnName2Index("HeroGrowWuli");
        IHeroGrowTili = reader.ColumnName2Index("HeroGrowTili");
        IHeroGrowNu = reader.ColumnName2Index("HeroGrowNu");

        IArmyGrowHP = reader.ColumnName2Index("ArmyGrowHP");
        IArmyGrowWuli = reader.ColumnName2Index("ArmyGrowWuli");
        IArmyGrowTili = reader.ColumnName2Index("ArmyGrowTili");
        IArmyGrowNu = reader.ColumnName2Index("ArmyGrowNu");
      


        IMonsterGrowHP = reader.ColumnName2Index("MonsterGrowHP");
        IMonsterGrowWuli = reader.ColumnName2Index("MonsterGrowWuli");
        IMonsterGrowTili = reader.ColumnName2Index("MonsterGrowTili");
        IMonsterGrowNu = reader.ColumnName2Index("MonsterGrowNu");




        INJingshenBeishu = reader.ColumnName2Index("NJingshenBeishu");
        IZhiliHeroZhandouli = reader.ColumnName2Index("ZhiliHeroZhandouli");
        IJingshenHeroZhandouli = reader.ColumnName2Index("JingshenHeroZhandouli");
        IZhiliArmyZhandouli = reader.ColumnName2Index("ZhiliArmyZhandouli");
        IJingshenArmyZhandouli = reader.ColumnName2Index("JingshenArmyZhandouli");
        IHeroGrowZhili = reader.ColumnName2Index("HeroGrowZhili");
        IHeroGrowJingshen = reader.ColumnName2Index("HeroGrowJingshen");
        IArmyGrowZhili = reader.ColumnName2Index("ArmyGrowZhili");
        IArmyGrowJingshen = reader.ColumnName2Index("ArmyGrowJingshen");


        IArmyMonsterGrowHP = reader.ColumnName2Index("ArmyMonsterGrowHP");
        IArmyMonsterGrowWuli = reader.ColumnName2Index("ArmyMonsterGrowWuli");
        IArmyMonsterGrowTili = reader.ColumnName2Index("ArmyMonsterGrowTili");
        IArmyMonsterGrowZhili = reader.ColumnName2Index("ArmyMonsterGrowZhili");
        IArmyMonsterGrowJingshen = reader.ColumnName2Index("ArmyMonsterGrowJingshen");
        IArmyMonsterGrowNu = reader.ColumnName2Index("ArmyMonsterGrowNu");
    }

    public FightKeyValueMathInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        NTiliBeishu = reader.GetI16(INTiliBeishu, row);
        Nnu = reader.GetI16(INnu, row);
        HPHeroZhandouli = reader.GetF(IHPHeroZhandouli, row);
        WuliHeroZhandouli = reader.GetF(IWuliHeroZhandouli, row);
        TiliHeroZhandouli = reader.GetF(ITiliHeroZhandouli, row);
        NuHeroZhandouli = reader.GetF(INuHeroZhandouli, row);
        HPArmyZhandouli = reader.GetF(IHPArmyZhandouli, row);
        WuliArmyZhandouli = reader.GetF(IWuliArmyZhandouli, row);
        TiliArmyZhandouli = reader.GetF(ITiliArmyZhandouli, row);

        HeroGudingHP = new int[MaxXing];
        HeroGudingWuli = new int[MaxXing];
        HeroGudingTili = new int[MaxXing];
        HeroGudingNu = new int[MaxXing];
        HeroGudingZhili= new int[MaxXing];
        HeroGudingJingshen= new int[MaxXing];

        ArmyGudingHP = new int[MaxXing];
        ArmyGudingWuli = new int[MaxXing];
        ArmyGudingTili = new int[MaxXing];
        ArmyGudingNu = new int[MaxXing];
        ArmyGudingZhili= new int[MaxXing];
        ArmyGudingJingshen = new int[MaxXing];

        for (int i = 0; i < MaxXing; i++)
        {
            HeroGudingHP[i] = reader.GetI32(IHeroGudingHP[i], row);
            HeroGudingWuli[i] = reader.GetI32(IHeroGudingWuli[i], row);
            HeroGudingTili[i] = reader.GetI32(IHeroGudingTili[i], row);
            HeroGudingNu[i] = reader.GetI32(IHeroGudingNu[i], row);
            HeroGudingZhili[i]= reader.GetI32(IHeroGudingZhili[i], row);
            HeroGudingJingshen[i] = reader.GetI32(IHeroGudingJingshen[i], row);

            ArmyGudingHP[i] = reader.GetI32(IArmyGudingHP[i], row);
            ArmyGudingWuli[i] = reader.GetI32(IArmyGudingWuli[i], row);
            ArmyGudingTili[i] = reader.GetI32(IArmyGudingTili[i], row);
            ArmyGudingNu[i] = reader.GetI32(IArmyGudingNu[i], row);
            ArmyGudingZhili[i] = reader.GetI32(IArmyGudingZhili[i], row);
            ArmyGudingJingshen[i] = reader.GetI32(IArmyGudingJingshen[i], row);
        }
        HeroGrowHP = reader.GetI32(IHeroGrowHP, row);
        HeroGrowWuli = reader.GetI32(IHeroGrowWuli, row);
        HeroGrowTili = reader.GetI32(IHeroGrowTili, row);
        HeroGrowNu = reader.GetI32(IHeroGrowNu, row);

        ArmyGrowHP = reader.GetI32(IArmyGrowHP, row);
        ArmyGrowWuli = reader.GetI32(IArmyGrowWuli, row);
        ArmyGrowTili = reader.GetI32(IArmyGrowTili, row);
        ArmyGrowNu = reader.GetI32(IArmyGrowNu, row);
       
        

        MonsterGrowHP = reader.GetI32(IMonsterGrowHP, row);
        MonsterGrowWuli = reader.GetI32(IMonsterGrowWuli, row);
        MonsterGrowTili = reader.GetI32(IMonsterGrowTili, row);
        MonsterGrowNu = reader.GetI32(IMonsterGrowNu, row);
        MonsterGrowZhili = reader.GetI32(IMonsterGrowZhili, row);
        MonsterGrowJingshen = reader.GetI32(IMonsterGrowJingshen, row);
      

         NJingshenBeishu= reader.GetI16(INJingshenBeishu, row);
        ZhiliHeroZhandouli= reader.GetF(IZhiliHeroZhandouli, row);
        JingshenHeroZhandouli= reader.GetF(IJingshenHeroZhandouli, row);
        ZhiliArmyZhandouli= reader.GetF(IZhiliArmyZhandouli, row);
        JingshenArmyZhandouli= reader.GetF(IJingshenArmyZhandouli, row);

        HeroGrowZhili = reader.GetI32(IHeroGrowZhili, row);
        HeroGrowJingshen = reader.GetI32(IHeroGrowJingshen, row);
        ArmyGrowZhili = reader.GetI32(IArmyGrowZhili, row);
        ArmyGrowJingshen = reader.GetI32(IArmyGrowJingshen, row);

        ArmyMonsterGrowHP = reader.GetI32(IArmyMonsterGrowHP, row);
        ArmyMonsterGrowWuli = reader.GetI32( IArmyMonsterGrowWuli, row);
        ArmyMonsterGrowTili =  reader.GetI32( IArmyMonsterGrowTili, row);
        ArmyMonsterGrowZhili = reader.GetI32( IArmyMonsterGrowZhili, row);
        ArmyMonsterGrowJingshen =  reader.GetI32( IArmyMonsterGrowJingshen, row);
        ArmyMonsterGrowNu = reader.GetI32(IArmyMonsterGrowNu, row);
    }

    public readonly short ID;
    public readonly short NTiliBeishu;
    public readonly short Nnu;
    public readonly float HPHeroZhandouli;
    public readonly float WuliHeroZhandouli;
    public readonly float TiliHeroZhandouli;
    public readonly float NuHeroZhandouli;
    public readonly float HPArmyZhandouli;
    public readonly float WuliArmyZhandouli;
    public readonly float TiliArmyZhandouli;
    
    public readonly int[] HeroGudingHP;
    public readonly int[] HeroGudingWuli;
    public readonly int[] HeroGudingTili;
    public readonly int[] HeroGudingNu;
    public readonly int[] HeroGudingZhili;
    public readonly int[] HeroGudingJingshen;

    public readonly int HeroGrowHP;
    public readonly int HeroGrowWuli;
    public readonly int HeroGrowTili;
    public readonly int HeroGrowNu;

    public readonly short NJingshenBeishu;
    public readonly float ZhiliHeroZhandouli;
    public readonly float JingshenHeroZhandouli;
    public readonly float ZhiliArmyZhandouli;
    public readonly float JingshenArmyZhandouli;
    public readonly int HeroGrowZhili;
    public readonly int HeroGrowJingshen;
    public readonly int ArmyGrowZhili;
    public readonly int ArmyGrowJingshen;


    public readonly int ArmyMonsterGrowHP;
    public readonly int ArmyMonsterGrowWuli;
    public readonly int ArmyMonsterGrowTili;
    public readonly int ArmyMonsterGrowZhili;
    public readonly int ArmyMonsterGrowJingshen;
    public readonly int ArmyMonsterGrowNu;




    public readonly int[] ArmyGudingHP;
    public readonly int[] ArmyGudingWuli;
    public readonly int[] ArmyGudingTili;
    public readonly int[] ArmyGudingNu;
    public readonly int[] ArmyGudingJingshen;
    public readonly int[] ArmyGudingZhili;

    public readonly int ArmyGrowHP;
    public readonly int ArmyGrowWuli;
    public readonly int ArmyGrowTili;
    public readonly int ArmyGrowNu;
   

    public readonly int MonsterGrowHP;
    public readonly int MonsterGrowWuli;
    public readonly int MonsterGrowTili;
    public readonly int MonsterGrowNu;
    public readonly int MonsterGrowZhili;
    public readonly int MonsterGrowJingshen;
}
public class SData_FightKeyValueMath : MonoEX.Singleton<SData_FightKeyValueMath>
{
    public SData_FightKeyValueMath()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 FightKeyValueMath");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "FightKeyValueMath");
            FightKeyValueMathInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                var sa = new FightKeyValueMathInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }
    }

    public FightKeyValueMathInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }

    Dictionary<int, FightKeyValueMathInfo> Data = new Dictionary<int, FightKeyValueMathInfo>();
}
