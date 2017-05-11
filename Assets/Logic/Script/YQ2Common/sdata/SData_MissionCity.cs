using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_MissionCity : MonoEX.Singleton<SData_MissionCity>
{
    public SData_MissionCity()
    {
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 MissionCity");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "MissionCity");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    MissionCityInfo sa = new MissionCityInfo(reader, i);
                    Data.Add(sa.ID, sa);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 MissionCity 完毕!");
        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public MissionCityInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }


    #region (属性)

    Dictionary<int, MissionCityInfo> Data = new Dictionary<int, MissionCityInfo>();


    #endregion


}


public class MissionCityInfo
{
    public MissionCityInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI32(IID, row);
        Name = reader.GetS(IName, row);
        StateID = reader.GetI16(IStateID, row);
        CityID = reader.GetS(ICityID, row);
        NextCity = reader.GetI32(INextCity, row);
        PerfectTongguan = reader.GetI16(IPerfectTongguan, row);
        NormalChoujiangID = reader.GetI16(INormalChoujiangID, row);
        PerfectChoujiangID = reader.GetI16(IPerfectChoujiangID, row);
        SuijiEventID = reader.GetI16(ISuijiEventID, row);


        if (!string.IsNullOrEmpty(CityID))
        {
            string[] strC = CityID.Split('|');
            if (strC.Length > 1)
            {
                for (int i = int.Parse(strC[0]); i <= int.Parse(strC[1]); i++)
                {
                    GKList.Add(i);
                }
            }
            else
            {
                GKList.Add(int.Parse(strC[0]));
            }
        }

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        IStateID = reader.ColumnName2Index("StateID");
        ICityID = reader.ColumnName2Index("CityID");
        INextCity = reader.ColumnName2Index("NextCity");
        IPerfectTongguan = reader.ColumnName2Index("PerfectTongguan");
        INormalChoujiangID = reader.ColumnName2Index("NormalChoujiangID");
        IPerfectChoujiangID = reader.ColumnName2Index("PerfectChoujiangID");
        ISuijiEventID = reader.ColumnName2Index("SuijiEventID");

    }

    public readonly int ID;
    public readonly string Name;
    public readonly int StateID;
    public readonly string CityID;
    public readonly int NextCity;
    public readonly int PerfectTongguan;
    public readonly int NormalChoujiangID;
    public readonly int PerfectChoujiangID;
    public readonly int SuijiEventID;
    


    /*索引变量*/
    internal static short IID;
    internal static short IName;
    internal static short IStateID;
    internal static short ICityID;
    internal static short INextCity;
    internal static short IPerfectTongguan;
    internal static short INormalChoujiangID;
    internal static short IPerfectChoujiangID;
    internal static short ISuijiEventID;


    public readonly List<int> GKList = new List<int>();
}


