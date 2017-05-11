using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;


public class VipInfo
{
    public VipInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);
        ID = reader.GetI16(IID, row);
        ChongZhiRequire = reader.GetI32(IChongZhiRequire, row);
        Picture = reader.GetS(IPicture, row);
        Id2String = reader.GetS(IId2String, row);
        //Beizhu = reader.GetS(IBeizhu, row);
        LingBuyTime = reader.GetI32(ILingBuyTime, row);
        DuihuanTime = reader.GetI16(IDuihuanTime, row);
        LingShangxian = reader.GetI16(ILingShangxian, row);

        for (int i = 0; i < 4; i++)
        {
            int istr =i+1;
            //当次奖励
            JLitems[i].BookName = (BOOK_NAME)reader.GetI16(reader.ColumnName2Index("BookName" + istr.ToString()), row);
            JLitems[i].ItemId = reader.GetI32(reader.ColumnName2Index("SubType" + istr.ToString()), row);
            JLitems[i].Number = reader.GetI32(reader.ColumnName2Index("Num" + istr.ToString()), row);
            //Daily军令
            JLitemsDaily[i].BookName = (BOOK_NAME)reader.GetI16(reader.ColumnName2Index("BookNameDaily" + istr.ToString()), row);
            JLitemsDaily[i].ItemId = reader.GetI32(reader.ColumnName2Index("SubTypeDaily" + istr.ToString()), row);
            JLitemsDaily[i].Number = reader.GetI32(reader.ColumnName2Index("NumDaily" + istr.ToString()), row);
        }

    }
    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IChongZhiRequire = reader.ColumnName2Index("ChongZhiRequire");
        IPicture = reader.ColumnName2Index("Picture");
        IId2String = reader.ColumnName2Index("Id2String");
        //IBeizhu = reader.ColumnName2Index("Beizhu");
        ILingBuyTime = reader.ColumnName2Index("LingBuyTime");
        IDuihuanTime = reader.ColumnName2Index("DuihuanTime");
        ILingShangxian = reader.ColumnName2Index("LingShangxian");


    }

    public readonly int ID = 0;//16
    public readonly int ChongZhiRequire = 9999999;//32
    public readonly string Picture = "";
    public readonly string Id2String = "";
    public readonly string Beizhu = "";
    public readonly JLItem[] JLitems = new JLItem[4];
    public readonly JLItem[] JLitemsDaily = new JLItem[4];
    public readonly int LingBuyTime = 0;//32
    public readonly int DuihuanTime = 0;//16
    public readonly int LingShangxian = 0;//16

    internal static short IID;
    internal static short IChongZhiRequire;
    internal static short IPicture;
    internal static short IId2String;
    //internal static short IBeizhu;
    internal static short ILingBuyTime;
    internal static short IDuihuanTime;
    internal static short ILingShangxian;

}

public class SData_VIP : MonoEX.Singleton<SData_VIP>
{
    //public static SData_CJItem Single
    //{
    //    get
    //    {
    //        if (null == mSingle)
    //        {
    //            mSingle = new SData_CJItem();
    //        }
    //        return mSingle;
    //    }
    //}

    public SData_VIP()
    {
        try
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 VIP");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                int maxid = -1;
                reader.Load("bsv", "VIP");
                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    VipInfo sa = new VipInfo(reader, i);
                    DataList.Add(sa.ID, sa);

                    if (sa.ID > maxid)
                    {
                        MaxValue = sa;
                        maxid = sa.ID;
                    }
                }
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 VIP 完毕!");
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "VIP初始化失败!");
            throw ex;
        }
    }
    readonly Dictionary<int, VipInfo> DataList = new Dictionary<int, VipInfo>();
    public readonly VipInfo MaxValue = null;

    public VipInfo Get(int id)
    {
        if (DataList.ContainsKey(id))
        {
            return DataList[id];
        }
        else
        {
            return null;
        }
    }

    /// <summary>
    /// 是否为最高等级
    /// </summary>
    /// <param name="cs"></param>
    /// <returns></returns>
    public bool IsMaxID(int cs)
    {
        return cs > MaxValue.ID;
    }
}
