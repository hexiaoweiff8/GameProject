using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_DiaoluoType : MonoEX.Singleton<SData_DiaoluoType>
{
    public SData_DiaoluoType()
    {
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 DiaoluoType");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "DiaoluoType");

                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    DiaoluoTypeInfo sa = new DiaoluoTypeInfo(reader, i);
                    Data.Add(sa.ID, sa);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 DiaoluoType 完毕!");
        }
    }

    /// <summary>
    /// 根据ID 获取 信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public DiaoluoTypeInfo Get(int id)
    {
        if (Data.ContainsKey(id))
            return Data[id];
        else
            return null;
    }


    #region (属性)

    Dictionary<int, DiaoluoTypeInfo> Data = new Dictionary<int, DiaoluoTypeInfo>();


    #endregion


}


public class DiaoluoTypeInfo
{
    public DiaoluoTypeInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        DiaoluoType1 = reader.GetI16(IDiaoluoType1, row);
        SecondDiaoluoType1 = reader.GetI16(ISecondDiaoluoType1, row);
        ThirdDiaoluoType1 = reader.GetI16(IThirdDiaoluoType1, row);

    }

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IDiaoluoType1 = reader.ColumnName2Index("DiaoluoType1");
        ISecondDiaoluoType1 = reader.ColumnName2Index("2stDiaoluoType1");
        IThirdDiaoluoType1 = reader.ColumnName2Index("3rdDiaoluoType1");

    }

    public readonly int ID;
    public readonly int DiaoluoType1;
    public readonly int SecondDiaoluoType1;
    public readonly int ThirdDiaoluoType1;


    /*索引变量*/
    internal static short IID;
    internal static short IDiaoluoType1;
    internal static short ISecondDiaoluoType1;
    internal static short IThirdDiaoluoType1;

}

