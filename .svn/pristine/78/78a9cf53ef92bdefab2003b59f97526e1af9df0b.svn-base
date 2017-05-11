using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


public enum ItemType
{
    None = 0, // 缺省
    tb = 4,//铜币
    jb = 5,//	金币
    exp = 15,	//经验
    TiLi = 17,	//体力
    TongYongSuiPian = 20,//通用武将碎片
    TongYongSuiPianA = 21,//通用士兵碎片
    SDJuan = 22,	//扫荡卷
    mft1 = 101,//免费铜一抽
    mft10 = 102,//免费铜十连抽
    mfj1 = 103,//免费金一抽
    mfj10 = 104,//免费金十连抽
}

public class ItemInfo
{
    public ItemInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);
        _ID = reader.GetI16(IID, row);
        _Type = (ItemType)reader.GetI16(IType, row);
        _Diejia = reader.GetI16(IDiejia, row);
        _Name = reader.GetS(IName, row);

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IType = reader.ColumnName2Index("Type");
        IName = reader.ColumnName2Index("Name");
        IDiejia = reader.ColumnName2Index("Diejia");

    }

    #region（属性）
    public int ID { get { return _ID; } }
    public ItemType Type { get { return _Type; } }
    public int Diejia { get { return _Diejia; } }
    public String Name { get { return _Name; } }



    int _ID;
    ItemType _Type;//道具类型
    String _Name;//名称
    int _Diejia;//叠加数量


    /*索引变量*/
    internal static short IID;
    internal static short IType;
    internal static short IName;
    internal static short IDiejia;


    #endregion
}

public class SData_ItemData : MonoEX.Singleton<SData_ItemData>
{
    //public static SData_ItemData Single
    //{
    //    get
    //    {
    //        if (null == mSingle)
    //        {
    //            mSingle = new SData_ItemData();
    //        }
    //        return mSingle;
    //    }
    //}
    public SData_ItemData()
    {
        Single = this;

        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ItemData");
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            reader.Load("bsv", "ItemData");
            for (int i = 0; i < reader.GetRowCount(); i++)
            {
                ItemInfo sa = new ItemInfo(reader, i);
                Data.Add(sa.ID, sa);

            }
        }
        MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 ItemData完毕!");
    }
    public ItemInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }


    Dictionary<int, ItemInfo> Data = new Dictionary<int, ItemInfo>();

    public static SData_ItemData Single = null;
}

