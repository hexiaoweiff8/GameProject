using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;


public class EventItem
{
    public int Index = 0;
    public SJEventType etype;
    public int EventID = 0;
    public int Rate = 0;
}

public enum SJEventType
{
    none = 0,
    SJBox = 1,
    SJMonster = 2,
    SJShop = 3,
}

public class SJEventInfo
{
    public SJEventInfo(ITabReader reader, int row)
    {
        ID = reader.GetI16(reader.ColumnName2Index("ID"), row);

        for (int i = 0; i < 8; i++)
        {
            int index = i + 1;
            int etype = reader.GetI16(reader.ColumnName2Index("Event" + index), row);
            if (etype != -1)
            {
                EventItem tempE = new EventItem();
                tempE.etype = (SJEventType)etype;
                tempE.Index = index;
                tempE.EventID = reader.GetI16(reader.ColumnName2Index("EventID" + index), row);
                tempE.Rate = reader.GetI16(reader.ColumnName2Index("Rate" + index), row);
                ItemList.Add(tempE.Index, tempE);

                sumRate += tempE.Rate;
            }
        }
    }


    Dictionary<int, EventItem> ItemList = new Dictionary<int, EventItem>();

    int sumRate = 0;//总重值


    public readonly int ID = 0;//ID


    #region(方法)
    /// <summary>
    /// 抽出一个随机事件
    /// </summary>
    /// <returns></returns>
    public EventItem GetCurrEvent(SJEventType getType = SJEventType.none)
    {
        /*測試用*/
        if (getType != SJEventType.none)
            foreach (KeyValuePair<int, EventItem> curr in ItemList)
            {
                if (curr.Value.etype == getType)
                    return curr.Value;
            }/*測試用*/
        else
        {
            if (SData_KeyValue.Single.RandomInt(0, 100) <= SData_KeyValue.Single.SuijiShijian)
            {
                int qz = SData_KeyValue.Single.RandomInt(0, sumRate - 1);
                foreach (KeyValuePair<int, EventItem> curr in ItemList)
                {
                    if (qz < curr.Value.Rate) return curr.Value;
                    qz -= curr.Value.Rate;
                }
            }
        }
        return null;
    }


    #endregion


}


public class SData_SuijiEvent : MonoEX.Singleton<SData_SuijiEvent>
{
    public SData_SuijiEvent()
    {
        Single = this;

        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 SuijiEvent");
            using (ITabReader reader = TabReaderManage.Single.CreateInstance())
            {
                reader.Load("bsv", "SuijiEvent");
                for (int row = 0; row < reader.GetRowCount(); row++)
                {
                    SJEventInfo sa = new SJEventInfo(reader, row);
                    Data.Add(sa.ID, sa);
                }
            }
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "装载 SuijiEvent完毕!");
        }
    }


    #region (属性)

    public static SData_SuijiEvent Single = null;

    Random rand = new Random();

    Dictionary<int, SJEventInfo> Data = new Dictionary<int, SJEventInfo>();


    #endregion

    #region(方法)

    public SJEventInfo Get(int id)
    {
        if (!Data.ContainsKey(id))
            return null;
        return Data[id];
    }

    #endregion

}

