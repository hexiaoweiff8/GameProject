using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_cardplanenemy_c : MonoEX.Singleton<SData_cardplanenemy_c>
{
    public void setData(LuaTable table1, LuaTable table2)
    {
        var head = new string[table1.Length];
        SDataUtils.dealTable(table1, (Object o1, Object o2) =>
        {
            head[(int)(double)o1 - 1] = (string)o2;
        });
        SDataUtils.dealTable(table2, (Object o1, Object o2) =>
        {
            cardplanenemy_cInfo dif = new cardplanenemy_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "CardID": dif.CardID = (int)(double)o22; break;
					case "Num": dif.Num = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.CardID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.CardID.ToString());
            Data.Add(dif.CardID, dif);
        });
    }

    public cardplanenemy_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("cardplanenemy_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, cardplanenemy_cInfo> Data = new Dictionary<int, cardplanenemy_cInfo>();
}


public struct cardplanenemy_cInfo
{
	 /// <summary>
	 ///卡牌ID
	 /// </summary>
	public int CardID;
	 /// <summary>
	 ///数量
	 /// </summary>
	public short Num;
}
