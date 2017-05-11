using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_JunLingbaoData : MonoEX.Singleton<SData_JunLingbaoData>
{
    public SData_JunLingbaoData()
    {
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 JunLingbaoData");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "JunlingbaoData");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    JunLingbaoDataInfo sa = new JunLingbaoDataInfo(reader, i);
                    Data.Add(sa.ID, sa);

                    if (i == 0)
                        _DefaultID = sa.ID;
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 JunLingbaoData 完毕!");
        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public JunLingbaoDataInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }
    /// <summary>
    /// 默认军令包
    /// </summary>
    /// <returns></returns>
    public int getDefaultID
    {
        get { return _DefaultID; }
    }
    int _DefaultID = 0;

    #region (属性)

    Dictionary<int, JunLingbaoDataInfo> Data = new Dictionary<int, JunLingbaoDataInfo>();


    #endregion


}


public class JunLingbaoDataInfo
{
    public JunLingbaoDataInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        Name = reader.GetS(IName, row);
        Icon = reader.GetS(IIcon, row);
        Num = reader.GetI16(INum, row);
        Description = reader.GetS(IDescription, row);

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        IIcon = reader.ColumnName2Index("Icon");
        INum = reader.ColumnName2Index("Num");
        IDescription = reader.ColumnName2Index("Description");

    }

    public readonly int ID;
    public readonly string Name;
    public readonly string Icon;
    public readonly int Num;
    public readonly string Description;


    /*索引变量*/
    internal static short IID;
    internal static short IName;
    internal static short IIcon;
    internal static short INum;
    internal static short IDescription;

}

