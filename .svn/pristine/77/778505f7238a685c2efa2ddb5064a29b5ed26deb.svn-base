using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


public struct RefreshTime
{
    public int hour;
    public int minute;
    public int second;
}

public class SData_KeyValue : MonoEX.Singleton<SData_KeyValue>
{
    public SData_KeyValue()
    {
        Single = this;

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 KeyValue");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "KeyValue");
                FillFieldIndex(reader);
                {
                    CopperFreeTimes = reader.GetI16(ICopperFreeTimes, 0);
                    CopperPrice = reader.GetI16(ICopperPrice, 0);
                    Copper10LianPrice = reader.GetI32(ICopper10LianPrice, 0);
                    GoldPrice = reader.GetI16(IGoldPrice, 0);
                    Gold10LianPrice = reader.GetI16(IGold10LianPrice, 0);
                    Minyuan = reader.GetI16(IMinyuan, 0);
                    CopperFree = reader.GetI16(ICopperFree, 0);
                    GoldFree = reader.GetI32(IGoldFree, 0);
                    Copper10LianDiscountKeep = reader.GetI16(ICopper10LianDiscountKeep, 0);
                    Gold10LianDiscountKeep = reader.GetI16(IGold10LianDiscountKeep, 0);
                    GoldDiscountKeep = reader.GetI16(IGoldDiscountKeep, 0);
                    GoldControllableTimes = reader.GetI16(IGoldControllableTimes, 0);
                    Gold10LianControllableTimes = reader.GetI16(IGold10LianControllableTimes, 0);
                    SaodangCost = reader.GetI16(ISaodangCost, 0);
                    ZhaoxiangTime = reader.GetI32(IZhaoxiangTime, 0);
                    YanzhengmaTime = reader.GetI16(IYanzhengmaTime, 0);
                    LingShangxian = reader.GetI16(ILingShangxian, 0);
                    LingXiaohao = reader.GetI16(ILingXiaohao, 0);
                    LingBuchong = reader.GetI16(ILingBuchong, 0);
                    BuyLingNum = reader.GetI16(IBuyLingNum, 0);
                    HeroStarLimit = reader.GetI16(IHeroStarLimit, 0);
                    ShouciFapai = reader.GetI16(IShouciFapai, 0);
                    MeiciFapai = reader.GetI16(IMeiciFapai, 0);
                    SuijiShijian = reader.GetI16(ISuijiShijian, 0);

                    //WJHuanxingBL = reader.GetI16(IWJHuanxingBL, 0);

                    string[] getMustHeroList = reader.GetS(IGoldGetHero, 0).Split('_');
                    if (getMustHeroList.Length > 0 && getMustHeroList.Length < 5)
                    {
                        for (int i = 0; i < getMustHeroList.Length; i++)
                        {
                            GoldGetHero[i] = int.Parse(getMustHeroList[i]);
                        }
                    }

                    FillRefreshTime(reader.GetS(ICopperFreeReplay, 0), ref CopperFreeReplay);

                    for (int i = 1; i <= 7; i++)
                    {
                        xingSuipian[i - 1] = reader.GetI16(IxingSuipian[i - 1], 0);
                    }

                    for (int i = 2; i <= 7; i++)
                    {
                        HeroSXLV[i - 2] = reader.GetI16(IHeroSXLV[i - 2], 0);
                    }
                    for (int i = 1; i <= 6; i++)
                    {
                        xingCost[i - 1] = reader.GetI16(IxingCost[i - 1], 0);
                    }

                    for (int i = 2; i <= 5; i++)
                    {
                        ArmySXLV[i - 2] = reader.GetI16(IArmySXLV[i - 2], 0);
                    }
                    for (int i = 1; i <= 6; i++)
                    {
                        xingArmyCost[i - 1] = reader.GetI16(IxingArmyCost[i - 1], 0);
                    }

                    for (int i = 1; i <= 5; i++)
                    {
                        GoldCJZK[i - 1] = reader.GetF(IGoldCJZK[i - 1], 0);
                        Copper10ZK[i - 1] = reader.GetF(ICopper10ZK[i - 1], 0);
                        Gold10ZK[i - 1] = reader.GetF(IGold10ZK[i - 1], 0);
                    }

                    FillRefreshTime(reader.GetS(IResetTime1, 0), ref ResetTime1);
                }
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 KeyValue完毕!");
        }
    }


    #region (属性)

    public static SData_KeyValue Single = null;

    Random rand = new Random();
    public const int MAX_DA_TA_GK = 18;
    public List<int> MustHeroIdx = new List<int>() { 8, 9 };//必出武将索引

    int[] xingCost = new int[7];
    int[] xingArmyCost = new int[6];
    int[] HeroSXLV = new int[7];
    int[] ArmySXLV = new int[6];
    int[] xingSuipian = new int[8];
    float[] GoldCJZK = new float[5];
    float[] Copper10ZK = new float[5];
    float[] Gold10ZK = new float[5];


    public readonly int CopperFreeTimes = 5;//今日免费次数
    public readonly int CopperPrice = 10000;//铜一抽费用
    public readonly int Copper10LianPrice = 10000;//铜十抽费用
    public readonly int GoldPrice = 10000;//金一抽费用
    public readonly int Gold10LianPrice = 10000;//金十抽费用
    public readonly int SaodangCost = 1000;//扫荡费用
    public readonly int WJHuanxingBL = 10;
    public readonly int Minyuan = 10;
    public readonly int CopperFree = 99999999;//铜币一抽免费倒计时
    public readonly int GoldFree = 99999999;//金币一抽免费倒计时
    public readonly float Copper10LianDiscountKeep = 1800;//铜币十连抽打折持续时间
    public readonly float Gold10LianDiscountKeep = 600;//金十抽打折持续时间
    public readonly int GoldDiscountKeep = 1200;//金一抽打折持续时间
    public readonly int GoldControllableTimes = 20;//金币一抽可控范围
    public readonly int Gold10LianControllableTimes = 20;//金币10抽可控范围
    public RefreshTime CopperFreeReplay = new RefreshTime();//每日铜一抽刷新时间
    public readonly int[] GoldGetHero = new int[4];//必出英雄次数
    public readonly int ZhaoxiangTime = 0;//招募倒计时时间
    public readonly int BuyLingNum;
    public RefreshTime ResetTime1 = new RefreshTime();//军令定时发放时间
    public readonly int ShouciFapai = 3;
    public readonly int MeiciFapai = 1;
    public readonly int SuijiShijian = 0;



    public readonly int HeroStarLimit = 0;
    public readonly int[] xingFanhuan = new int[4];
    public readonly int YanzhengmaTime = 0;
    public readonly int LingShangxian = 0;
    public readonly int LingXiaohao = 0;
    public readonly int LingBuchong = 0;



    /*索引变量*/

    internal static short ICopperFreeTimes;
    internal static short ICopperPrice;
    internal static short ICopper10LianPrice;
    internal static short IGoldPrice;
    internal static short IGold10LianPrice;
    internal static short IMinyuan;
    internal static short ICopperFree;
    internal static short IGoldFree;
    internal static short ICopper10LianDiscountKeep;
    internal static short IGold10LianDiscountKeep;
    internal static short IGoldDiscountKeep;
    internal static short IGoldControllableTimes;
    internal static short IGold10LianControllableTimes;
    internal static short ISaodangCost;
    internal static short IWJHuanxingBL;
    internal static short ICopperFreeReplay;
    internal static short IGoldGetHero;
    internal static short IZhaoxiangTime;
    internal static short IHeroStarLimit;
    internal static short IYanzhengmaTime;
    internal static short ILingShangxian;
    internal static short ILingXiaohao;
    internal static short ILingBuchong;
    internal static short IBuyLingNum;
    internal static short IResetTime1;
    internal static short IShouciFapai;
    internal static short IMeiciFapai;
    internal static short ISuijiShijian;
    



    internal static short[] IxingSuipian = new short[8];
    internal static short[] IxingCost = new short[7];
    internal static short[] IHeroSXLV = new short[7];
    internal static short[] IxingArmyCost = new short[6];
    internal static short[] IArmySXLV = new short[6];
    internal static short[] IGoldCJZK = new short[5];
    internal static short[] ICopper10ZK = new short[5];
    internal static short[] IGold10ZK = new short[5];

    internal static short[] IxingFanhuan = new short[4];

    #endregion

    #region(方法)

    internal static void FillFieldIndex(ITabReader reader)
    {
        ICopperFreeTimes = reader.ColumnName2Index("CopperFreeTimes");
        ICopperPrice = reader.ColumnName2Index("CopperPrice");
        ICopper10LianPrice = reader.ColumnName2Index("Copper10LianPrice");
        IGoldPrice = reader.ColumnName2Index("GoldPrice");
        IGold10LianPrice = reader.ColumnName2Index("Gold10LianPrice");
        IMinyuan = reader.ColumnName2Index("Minyuan");
        ICopperFree = reader.ColumnName2Index("CopperFree");
        IGoldFree = reader.ColumnName2Index("GoldFree");
        ICopper10LianDiscountKeep = reader.ColumnName2Index("Copper10LianDiscountKeep");
        IGold10LianDiscountKeep = reader.ColumnName2Index("Gold10LianDiscountKeep");
        IGoldDiscountKeep = reader.ColumnName2Index("GoldDiscountKeep");
        IGoldControllableTimes = reader.ColumnName2Index("GoldControllableTimes");
        //IWJHuanxingBL = reader.ColumnName2Index("WJHuanxingBL");
        ISaodangCost = reader.ColumnName2Index("SaodangCost");
        IGold10LianControllableTimes = reader.ColumnName2Index("Gold10LianControllableTimes");
        ICopperFreeReplay = reader.ColumnName2Index("CopperFreeReplay");
        IGoldGetHero = reader.ColumnName2Index("GoldGetHero");
        IZhaoxiangTime = reader.ColumnName2Index("ZhaoxiangTime");
        IHeroStarLimit = reader.ColumnName2Index("HeroStarLimit");
        IYanzhengmaTime = reader.ColumnName2Index("YanzhengmaTime");
        ILingShangxian = reader.ColumnName2Index("LingShangxian");
        ILingXiaohao = reader.ColumnName2Index("LingXiaohao");
        ILingBuchong = reader.ColumnName2Index("LingBuchong");
        IBuyLingNum = reader.ColumnName2Index("BuyLingNum");
        IResetTime1 = reader.ColumnName2Index("ResetTime1");
        IShouciFapai = reader.ColumnName2Index("ShouciFapai");
        IMeiciFapai = reader.ColumnName2Index("MeiciFapai");
        ISuijiShijian = reader.ColumnName2Index("SuijiShijian");

        for (int i = 1; i <= 4; i++)
        {
            IxingFanhuan[i - 1] = reader.ColumnName2Index(i.ToString() + "xingFanhuan");
        }

        for (int i = 1; i <= 7; i++)
        {
            IxingSuipian[i - 1] = reader.ColumnName2Index(i.ToString() + "xingSuipian");
        }
        for (int i = 2; i <= 7; i++)
        {
            String istr = i.ToString();
            IHeroSXLV[i - 2] = reader.ColumnName2Index("HeroSXLV" + istr);
        }
        for (int i = 1; i <= 6; i++)
        {
            String istr = i.ToString();
            IxingCost[i - 1] = reader.ColumnName2Index(istr + "xingCost");
        }

        for (int i = 2; i <= 5; i++)
        {
            String istr = i.ToString();
            IArmySXLV[i - 2] = reader.ColumnName2Index("ArmySXLV" + istr);
        }
        for (int i = 1; i <= 6; i++)
        {
            String istr = i.ToString();
            IxingArmyCost[i - 1] = reader.ColumnName2Index(istr + "xingArmyCost");
        }
        for (int i = 1; i <= 5; i++)
        {
            String istr = i.ToString();
            IGoldCJZK[i - 1] = reader.ColumnName2Index("GoldDiscount" + istr);
            ICopper10ZK[i - 1] = reader.ColumnName2Index("Copper10LianDiscount" + istr);
            IGold10ZK[i - 1] = reader.ColumnName2Index("Gold10LianDiscount" + istr);
        }
    }

    //刷新时间1 倒计时(秒)
    public int RefreshTime1_DaoJiShi
    {
        get
        {

            RefreshTime rt = SData_KeyValue.Single.CopperFreeReplay;
            DateTime now = DateTime.Now;
            DateTime rtime = new DateTime(
                now.Year, now.Month, now.Day,
                rt.hour, rt.minute, rt.second,
                0
                );
            if (rtime < now)
            {
                rtime = rtime.AddDays(1);
            }

            TimeSpan span = rtime - now;
            return (int)span.TotalSeconds;
        }
    }

    /// <summary>
    /// 武将升星消耗
    /// </summary>
    /// <param name="currXJ"></param>
    /// <returns></returns>
    public int GetHeroXingCost(int currXJ)
    {
        return xingCost[currXJ - 1];
    }

    public int GetArmyXingCost(int currXJ)
    {
        return xingArmyCost[currXJ - 1];
    }


    /// <summary>
    /// 金币一抽折扣
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public float GetGoldCJZK(int cs)
    {
        cs -= 1;
        if (cs < 0) cs = 0;
        if (cs > GoldCJZK.Length - 1) cs = GoldCJZK.Length - 1;
        return GoldCJZK[cs];
    }
    /// <summary>
    /// 金币十抽折扣
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public float GetGold10ZK(int cs)
    {
        cs -= 1;
        if (cs < 0) cs = 0;
        if (cs > Gold10ZK.Length - 1) cs = Gold10ZK.Length - 1;
        return Gold10ZK[cs];
    }
    /// <summary>
    /// 铜十抽折扣
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public float GetGopper10ZK(int cs)
    {
        cs -= 1;
        if (cs < 0) cs = 0;
        if (cs > Copper10ZK.Length - 1) cs = Copper10ZK.Length - 1;
        return Copper10ZK[cs];
    }
    public int GetHeroSXLV(int currLv) { return HeroSXLV[currLv - 1]; }
    public int GetArmySXLV(int currLv) { return ArmySXLV[currLv - 1]; }

    public int RandomInt(int min, int max) { return rand.Next(min, max + 1); }

    /// <summary>
    /// 随机种子值
    /// </summary>
    /// <returns></returns>
    private static int GetRandomSeed()
    {
        byte[] bytes = new byte[4];
        System.Security.Cryptography.RNGCryptoServiceProvider rng = new System.Security.Cryptography.RNGCryptoServiceProvider();
        rng.GetBytes(bytes);
        return BitConverter.ToInt32(bytes, 0);
    }

    /// <summary>
    /// 招募所需碎片数
    /// </summary>
    /// <param name="xj"></param>
    /// <returns></returns>
    public int ZhaoMuXingSuiPian(int xj)
    {
        return xingSuipian[xj - 1];
    }

    #endregion

    public void FillRefreshTime(String str, ref RefreshTime refreshTime)
    {
        String[] ra = str.Split(':');
        refreshTime.hour = int.Parse(ra[0]);
        refreshTime.minute = int.Parse(ra[1]);
        refreshTime.second = int.Parse(ra[2]);
    }
    /// <summary>
    /// 计算是否需要更新今日次数
    /// </summary>
    /// <param name="now"></param>
    /// <param name="rt"></param>
    /// <param name="dbTime"></param>
    /// <param name="out_SaveDbTime"></param>
    /// <returns></returns>
    public static bool needUpdateCS(DateTime now, RefreshTime rt, DateTime dbTime, ref DateTime out_SaveDbTime)
    {
        DateTime rtime = new DateTime(
            now.Year, now.Month, now.Day,
            rt.hour, rt.minute, rt.second,
            0
            );

        bool needSave = false;

        TimeSpan span = now - dbTime;
        if (span.TotalDays > 1) //已经超出了24小时，立即刷新
        {
            out_SaveDbTime = rtime.AddDays(-1);
            needSave = true;
        }

        if (
            now >= rtime &&
            dbTime < rtime
            ) //刷新次数
        {
            out_SaveDbTime = rtime;
            needSave = true;
        }

        return needSave;
    }
}

