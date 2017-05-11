using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using YQ2Common.CObjects;



public class SData_SuijiMonster : MonoEX.Singleton<SData_SuijiMonster>
{

    public SData_SuijiMonster()
    {
        try
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 SuijiMonster");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "SuijiMonster");

                int rowCount = reader.GetRowCount();
                for (int row = 0; row < rowCount; row++)
                {
                    SJMonsterInfo sa = new SJMonsterInfo(reader, row);
                    Data.Add(sa.ID, sa);
                }
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "SuijiMonster装载完毕");
        }
        catch (System.Exception ex)
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "SuijiMonster初始化失败");
            throw ex;
        }
    }

    Dictionary<int, SJMonsterInfo> Data = new Dictionary<int, SJMonsterInfo>();


    #region(方法)

    public SJMonsterInfo Get(int ID)
    {
        if (Data.ContainsKey(ID))
            return Data[ID];
        else
            return null;
    }

    #endregion

}

public class SJMonsterInfo
{


    public SJMonsterInfo(ITabReader reader, int row)
    {
        FillFieldIndex(reader);

        ID = reader.GetI16(IID, row);
        HeroID = reader.GetI16(IHeroID, row);
        Time = reader.GetI16(ITime, row);

        for (int i = 1; i <= 2; i++)
        {
            int b = reader.GetI16(reader.ColumnName2Index("BookName" + i), row);
            if (b > 0)
            {
                jlList.Add(new JLItem()
                {
                    BookName = (BOOK_NAME)b,
                    ItemId = reader.GetI16(reader.ColumnName2Index("SubType" + i), row),
                    Number = reader.GetI16(reader.ColumnName2Index("Num" + i), row)
                });
            }
        }


    }


    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IHeroID = reader.ColumnName2Index("HeroID");
        ITime = reader.ColumnName2Index("Time");
    }

    #region(属性)

    public List<JLItem> jlList = new List<JLItem>();

    public readonly int ID = 0;
    public readonly int HeroID = 0;//招降武将ID
    public readonly int Time = 0;


    /**索引属性**/
    internal static short IID;
    internal static short IHeroID;
    internal static short ITime;

    #endregion

}



