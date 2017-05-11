using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycarduselimitcost_c : MonoEX.Singleton<SData_armycarduselimitcost_c>
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
            armycarduselimitcost_cInfo dif = new armycarduselimitcost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UseLimitLevel": dif.UseLimitLevel = (short)(double)o22; break;
					case "Card": dif.Card = (short)(double)o22; break;
					case "Coin": dif.Coin = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UseLimitLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UseLimitLevel.ToString());
            Data.Add(dif.UseLimitLevel, dif);
        });
    }

    public armycarduselimitcost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycarduselimitcost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycarduselimitcost_cInfo> Data = new Dictionary<int, armycarduselimitcost_cInfo>();
}


public struct armycarduselimitcost_cInfo
{
	 /// <summary>
	 ///兵员上限
	 /// </summary>
	public short UseLimitLevel;
	 /// <summary>
	 ///卡牌数量
	 /// </summary>
	public short Card;
	 /// <summary>
	 ///兵牌数量
	 /// </summary>
	public int Coin;
}
