using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;



public class SData_OfficalRank : MonoEX.Singleton<SData_OfficalRank>
{
    public SData_OfficalRank()
    {
        Single = this;

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 OfflicalRank");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "OfflicalRank");
                FillFieldIndex(reader);
                for (int i = 0; i < reader.GetRowCount(); i++)
                {
                    LoadData(reader, i);
                }

            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 OfflicalRank 完毕!");
        }
    }












    #region (属性)

    public static SData_OfficalRank Single = null;


    Dictionary<int, int> officalList = new Dictionary<int, int>();

    /*索引变量*/

    internal static short IID;
    internal static short IExp;

    #endregion

    #region(方法)

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IExp = reader.ColumnName2Index("Exp");
    }

    void LoadData(ITabReader reader, int row)
    {
        officalList.Add(reader.GetI16(IID, row), reader.GetI32(IExp, row));
    }

    /// <summary>
    /// 返回当前经验所对应官阶
    /// </summary>
    /// <param name="exp"></param>
    /// <returns></returns>
    public int GetIDbyExp(int exp)
    {
        int reID = 0;
        foreach (KeyValuePair<int, int> item in officalList)
        {
            if (exp <= item.Value)
            {
                reID = item.Key;
                break;
            }
        }
        return reID;
    }

    #endregion
}

