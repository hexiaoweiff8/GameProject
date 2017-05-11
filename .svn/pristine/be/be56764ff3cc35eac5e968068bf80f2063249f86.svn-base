using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public struct SDShopItemInfo
{
    public int BookName;
    public int SubType;
    public int Num;
    public int Currency;
    public int Price;
}


public class SData_SuijiShop : MonoEX.Singleton<SData_SuijiShop>
{

    public SData_SuijiShop()
    {
        try
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SuijiShop");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "SuijiShop");

                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    SJShopInfo sj = new SJShopInfo(reader, row);
                    DataList.Add(sj.ID,sj);
                }
            }
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "SuijiShop初始化失败");
            throw ex;
        }
    }

    //商店列表
    Dictionary<int, SJShopInfo> DataList = new Dictionary<int, SJShopInfo>();
    //Dictionary<int, List<SJShopInfo>> DataList = new Dictionary<int, List<SJShopInfo>>();

    #region(方法)

    public SJShopInfo Get(int ID)
    {
        if (DataList.ContainsKey(ID))
            return DataList[ID];
        else
            return null;
    }

    #endregion


}

public class SJShopInfo
{

    const int itemCount = 8;

    public SJShopInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI32(IID, row);
        Name = reader.GetS(IName, row);
        Time = reader.GetI16(ITime, row);
        Flag = reader.GetI16(IFlag, row);

        for (int i = 0; i < itemCount; i++)
        {
            int index = i + 1;
            SDShopItemInfo item = new SDShopItemInfo();
            item.BookName = reader.GetI16(reader.ColumnName2Index("BookName" + index), row);
            item.SubType = reader.GetI16(reader.ColumnName2Index("SubType" + index), row);
            item.Num = reader.GetI32(reader.ColumnName2Index("Num" + index), row);
            item.Currency = reader.GetI16(reader.ColumnName2Index("Currency" + index), row);
            item.Price = reader.GetI32(reader.ColumnName2Index("Price" + index), row);

            Items.Add(index, item);

        }

    }


    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        ITime = reader.ColumnName2Index("Time");
        IFlag = reader.ColumnName2Index("Flag");
    }

    #region(属性)

    //商品列表
    public Dictionary<int, SDShopItemInfo> Items = new Dictionary<int, SDShopItemInfo>();

    public readonly int ID = 0;
    public readonly string Name = "";
    public readonly int Time = 0;
    public readonly int Flag = 0;


    /**索引属性**/
    internal static short IID;
    internal static short IName;
    internal static short ITime;
    internal static short IFlag;



    #endregion

}



