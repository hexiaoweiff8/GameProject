using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


public class SData_MissionState : MonoEX.Singleton<SData_MissionState>
{
    public SData_MissionState()
    {

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载  MissionState");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "MissionState");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    MissionStateInfo sa = new MissionStateInfo(reader, i);
                    Data.Add(sa.ID, sa);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 MissionState 完毕!");
        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public MissionStateInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }


    #region (属性)

    Dictionary<int, MissionStateInfo> Data = new Dictionary<int, MissionStateInfo>();


    #endregion


}


public class MissionStateInfo
{
    public MissionStateInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        Name = reader.GetS(IName, row);
        QuyuID = reader.GetI16(IQuyuID, row);
        CityID = reader.GetS(ICityID, row);
        StartLv = reader.GetI16(IStartLv, row);
        MainCityID = reader.GetI16(IMainCityID, row);
        NextState = reader.GetI16(INextState, row);
        MoneyChixu = reader.GetI16(IMoneyChixu, row);
        ZhaomuHeroID = reader.GetI32(IZhaomuHeroID, row);

        if (!string.IsNullOrEmpty(CityID))
        {
            string[] strC = CityID.Split('|');
            if (strC.Length > 1)
            {
                foreach (string cid in strC)
                {
                    CityList.Add(int.Parse(cid));
                }
            }
            else
            {
                CityList.Add(int.Parse(strC[0]));
            }
        }

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IName = reader.ColumnName2Index("Name");
        IQuyuID = reader.ColumnName2Index("QuyuID");
        IStartLv = reader.ColumnName2Index("StartLv");
        ICityID = reader.ColumnName2Index("CityID");
        IMainCityID = reader.ColumnName2Index("MainCityID");
        INextState = reader.ColumnName2Index("NextState");
        IMoneyChixu = reader.ColumnName2Index("MoneyChixu");
        IZhaomuHeroID = reader.ColumnName2Index("ZhaomuHeroID");
    }

    public readonly int ID;
    public readonly string Name;
    public readonly int QuyuID;
    public readonly int StartLv;
    public readonly int MainCityID;
    public readonly string CityID;
    public readonly int NextState;
    public readonly int MoneyChixu;
    public readonly int ZhaomuHeroID;




    /*索引变量*/
    internal static short IID;
    internal static short IName;
    internal static short IQuyuID;
    internal static short IStartLv;
    internal static short IMainCityID;
    internal static short ICityID;
    internal static short INextState;
    internal static short IMoneyChixu;
    internal static short IZhaomuHeroID;


    public readonly List<int> CityList = new List<int>();

}

