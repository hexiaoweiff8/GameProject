using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
/*待删除
public class HeroShuxingGrowInfo
{
    internal static short IID;
    internal static short[] IxingGudingHP;
    internal static short[] IxingGudingWuli;
    internal static short[] IxingGudingTili;
    internal static short[] IxingGudingNu;
    internal static short[] IxingHP;
    internal static short[] IxingWuli;
    internal static short[] IxingTili;
    internal static short[] IxingNu;
    const int MaxXing = 8;//最高星级
    const int XingArrayLen = 7;
    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");

        IxingGudingHP = new short[XingArrayLen];
        IxingGudingWuli = new short[XingArrayLen];
        IxingGudingTili = new short[XingArrayLen];
        IxingGudingNu = new short[XingArrayLen];

        IxingHP = new short[XingArrayLen];
        IxingWuli = new short[XingArrayLen];
        IxingTili = new short[XingArrayLen];
        IxingNu = new short[XingArrayLen];
        for (int i = 0; i < XingArrayLen; i++)
        {
            string istr = (i + 2).ToString();
            IxingGudingHP[i] = reader.ColumnName2Index(istr + "xingGudingHP");
            IxingGudingWuli[i] = reader.ColumnName2Index(istr + "xingGudingWuli");
            IxingGudingTili[i] = reader.ColumnName2Index(istr + "xingGudingTili");
            IxingGudingNu[i] = reader.ColumnName2Index(istr + "xingGudingNu");

            IxingHP[i] = reader.ColumnName2Index(istr + "xingHP");
            IxingWuli[i] = reader.ColumnName2Index(istr + "xingWuli");
            IxingTili[i] = reader.ColumnName2Index(istr + "xingTili");
            IxingNu[i] = reader.ColumnName2Index(istr + "xingNu");
        }
    }

    internal HeroShuxingGrowInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        for (int i = 0; i < XingArrayLen; i++)
        {
            var attrGuding = xingGuding[i] = new XingAttr();
            var attrChengzhang = xingChengzhang[i] = new XingAttr();

            attrGuding.HP = reader.GetF(IxingGudingHP[i], row);
            attrGuding.Wuli = reader.GetF(IxingGudingWuli[i], row);
            attrGuding.Tili = reader.GetF(IxingGudingTili[i], row);
            attrGuding.Nu = reader.GetF(IxingGudingNu[i], row);

            attrChengzhang.HP = reader.GetF(IxingHP[i], row);
            attrChengzhang.Wuli = reader.GetF(IxingWuli[i], row);
            attrChengzhang.Tili = reader.GetF(IxingTili[i], row);
            attrChengzhang.Nu = reader.GetF(IxingNu[i], row);
        }
    }

    public XingAttr GetXingGuding(short xing) { if (xing > MaxXing) xing = MaxXing; return xingGuding[xing - 2]; }
    public XingAttr GetXingChengzhang(short xing) { if (xing > MaxXing) xing = MaxXing; return xingChengzhang[xing - 2]; }

    XingAttr[] xingGuding = new XingAttr[XingArrayLen];
    XingAttr[] xingChengzhang = new XingAttr[XingArrayLen]; 

    public readonly int ID;
}

public class SData_HeroShuxingGrow : MonoEX.Singleton<SData_HeroShuxingGrow>
{
    public SData_HeroShuxingGrow()
    {
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 HeroShuxingGrow");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("core", "HeroShuxingGrow");

            HeroShuxingGrowInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                HeroShuxingGrowInfo sa = new HeroShuxingGrowInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }

    }


    public HeroShuxingGrowInfo Get(int Id)
    {
        try
        {
            if (!Data.ContainsKey(Id)) return null;
            return Data[Id];
        }
        catch (Exception)
        {
            throw new Exception(String.Format("SData_HeroShuxingGrow::Get() not found data  Id:{0}", Id));
        }
    }

    Dictionary<int, HeroShuxingGrowInfo> Data = new Dictionary<int, HeroShuxingGrowInfo>();
}*/