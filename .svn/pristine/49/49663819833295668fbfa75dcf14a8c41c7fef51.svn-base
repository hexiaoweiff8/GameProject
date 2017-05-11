using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_SurrenderCost : MonoEX.Singleton<SData_SurrenderCost>
{
    public SData_SurrenderCost()
    {

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载  SurrenderCost");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "SurrenderCost");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    SurrenderInfo sa = new SurrenderInfo(reader, i);
                    if (!SurrenderList.ContainsKey(sa.SurrenderCostID))
                        SurrenderList.Add(sa.SurrenderCostID, new List<SurrenderInfo>());
                    SurrenderList[sa.SurrenderCostID].Add(sa);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 SurrenderCost 完毕!");
        }
    }

    /// <summary>
    /// 依据type类型，抽取次数获取处置信息
    /// </summary>
    /// <param name="typeid"></param>
    /// <param name="HCount"></param>
    /// <returns></returns>
    public SurrenderInfo GetInfoByTID(int typeid, int HCount)
    {
        if (SurrenderList.ContainsKey(typeid))
        {
            int typeCount = SurrenderList[typeid].Count;
            return SurrenderList[typeid].First(s => (s.SurrenderCostID == typeid && s.Time == (HCount >= typeCount ? typeCount : HCount)));
        }
        else
            return null;
    }

    /// <summary>
    /// 依据概率是否成功
    /// </summary>
    /// <param name="chance"></param>
    /// <returns></returns>
    public bool isSuccess(int chance)
    {
        return SData_KeyValue.Single.RandomInt(1, 100) <= chance;
    }


    #region (属性)


    Dictionary<int, List<SurrenderInfo>> SurrenderList = new Dictionary<int, List<SurrenderInfo>>();


    #endregion


}


public class SurrenderInfo
{
    public SurrenderInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        SurrenderCostID = reader.GetI16(ISurrenderCostID, row);
        Time = reader.GetI16(ITime, row);
        BookName2 = reader.GetI16(IBookName2, row);
        SubType2 = reader.GetI32(ISubType2, row);
        Num2 = reader.GetI32(INum2, row);
        SuccessRate = reader.GetI16(ISuccessRate, row);
    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        ISurrenderCostID = reader.ColumnName2Index("SurrenderCostID");
        ITime = reader.ColumnName2Index("Time");
        IBookName2 = reader.ColumnName2Index("BookName2");
        ISubType2 = reader.ColumnName2Index("SubType2");
        INum2 = reader.ColumnName2Index("Num2");
        ISuccessRate = reader.ColumnName2Index("SuccessRate");
    }

    public readonly int ID;
    public readonly int SurrenderCostID;
    public readonly int Time;
    public readonly int BookName2;
    public readonly int SubType2;
    public readonly int Num2;
    public readonly int SuccessRate;

    /*索引变量*/
    internal static short IID;
    internal static short ISurrenderCostID;
    internal static short ITime;
    internal static short IBookName2;
    internal static short ISubType2;
    internal static short INum2;
    internal static short ISuccessRate;

}

