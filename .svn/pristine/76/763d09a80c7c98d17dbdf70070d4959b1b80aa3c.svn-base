using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class BuffMathInfo
{ 
    internal static short IID;
    internal static short Isort;
    internal static short IIsChuizhipian;
    internal static short IAtcMB;
    internal static short IAtcID;	
    internal static short IWidthScale;
    internal static short IHighScale;
    internal static short IAlpha;
    internal static short IOffsetX;
    internal static short IOffsetY;
    internal static short IOffsetZ;
    internal static short IBlend;
    internal static short IAnimMode;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        Isort = reader.ColumnName2Index("sort");
        IIsChuizhipian = reader.ColumnName2Index("IsChuizhipian");
        IAtcMB = reader.ColumnName2Index("AtcMB");
        IAtcID = reader.ColumnName2Index("AtcID");
        IWidthScale = reader.ColumnName2Index("WidthScale");
        IHighScale = reader.ColumnName2Index("HighScale");
        IAlpha = reader.ColumnName2Index("Alpha");
        IOffsetX = reader.ColumnName2Index("OffsetX");
        IOffsetY = reader.ColumnName2Index("OffsetY");
        IOffsetZ = reader.ColumnName2Index("OffsetZ");
        IBlend = reader.ColumnName2Index("Blend");
        IAnimMode = reader.ColumnName2Index("AnimMode");
    }

    public BuffMathInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(IID, row);
        sort = reader.GetF(Isort, row);
        IsChuizhipian = reader.GetI16(IIsChuizhipian, row) == 1;
        AtcMB = reader.GetS(IAtcMB, row);
        AtcID = reader.GetI16(IAtcID, row);
        //Blend = (TexiaoBlend)reader.GetI16(IBlend, row);
        AnimMode = (TexiaoAnimMode)reader.GetI16(IAnimMode, row);
        /*
        WidthScale = TexiaoInfo.ReadTeXiaoKeys(reader, IWidthScale, row);
        HeightScale = TexiaoInfo.ReadTeXiaoKeys(reader, IHighScale, row);
        Alpha = TexiaoInfo.ReadTeXiaoKeys(reader, IAlpha, row);
        OffsetX = TexiaoInfo.ReadTeXiaoKeys(reader, IOffsetX, row);
        OffsetY = TexiaoInfo.ReadTeXiaoKeys(reader, IOffsetY, row);
        OffsetZ = TexiaoInfo.ReadTeXiaoKeys(reader, IOffsetZ, row); 
        */
    }

    public readonly short ID;
    public readonly float sort;
    public readonly bool IsChuizhipian;
    public readonly string AtcMB;
    public readonly short AtcID;
    /*
    public readonly TexiaoKey[] WidthScale;
    public readonly TexiaoKey[] HeightScale;
    public readonly TexiaoKey[] Alpha;
    public readonly TexiaoKey[] OffsetX;
    public readonly TexiaoKey[] OffsetY;
    public readonly TexiaoKey[] OffsetZ;
    public readonly TexiaoBlend Blend;
     */
   public readonly TexiaoAnimMode AnimMode;
}

public class SData_BuffMath
{
    public SData_BuffMath()
    { 
        Single = this;
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 BuffMath");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "BuffMath");
            BuffMathInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                BuffMathInfo sa = new BuffMathInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }
    }

    public BuffMathInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    Dictionary<int, BuffMathInfo> Data = new Dictionary<int, BuffMathInfo>();
    public static SData_BuffMath Single;
} 