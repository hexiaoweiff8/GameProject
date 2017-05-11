using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardstarcost_c : MonoEX.Singleton<SData_armycardstarcost_c>
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
            armycardstarcost_cInfo dif = new armycardstarcost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "StarLevel": dif.StarLevel = (short)(double)o22; break;
					case "CardNum": dif.CardNum = (short)(double)o22; break;
					case "Coin": dif.Coin = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.StarLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.StarLevel.ToString());
            Data.Add(dif.StarLevel, dif);
        });
    }

    public armycardstarcost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardstarcost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardstarcost_cInfo> Data = new Dictionary<int, armycardstarcost_cInfo>();
}


public struct armycardstarcost_cInfo
{
	 /// <summary>
	 ///卡牌星级
	 /// </summary>
	public short StarLevel;
	 /// <summary>
	 ///卡牌数量
	 /// </summary>
	public short CardNum;
	 /// <summary>
	 ///兵牌数量
	 /// </summary>
	public int Coin;
}
