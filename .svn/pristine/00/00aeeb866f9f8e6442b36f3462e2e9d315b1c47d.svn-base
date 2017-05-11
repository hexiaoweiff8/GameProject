using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_XilianshiData : MonoEX.Singleton<SData_XilianshiData>
{
    public SData_XilianshiData()
    {
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 XilianshiData");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "XilianshiData");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    XilianshiDataInfo sa = new XilianshiDataInfo(reader, i);
                    Data.Add(sa.ID, sa);
                    AllIDList.Add(sa.ID);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 XilianshiData 完毕!");
        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public XilianshiDataInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }


    #region (属性)

    Dictionary<int, XilianshiDataInfo> Data = new Dictionary<int, XilianshiDataInfo>();
    public List<int> AllIDList = new List<int>();

    #endregion


}


public class XilianshiDataInfo
{
    public XilianshiDataInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        Name = reader.GetS(IName, row);
        Icon = reader.GetS(IIcon, row);
        Xilianzhi = reader.GetI32(IXilianzhi, row);
        Description = reader.GetS(IDescription, row);

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        IIcon = reader.ColumnName2Index("Icon");
        IXilianzhi = reader.ColumnName2Index("Xilianzhi");
        IDescription = reader.ColumnName2Index("Description");

    }

    public readonly int ID;
    public readonly string Name;
    public readonly string Icon;
    public readonly int Xilianzhi;
    public readonly string Description;


    /*索引变量*/
    internal static short IID;
    internal static short IName;
    internal static short IIcon;
    internal static short IXilianzhi;
    internal static short IDescription;

}

