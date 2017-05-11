using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardunioncost_c : MonoEX.Singleton<SData_armycardunioncost_c>
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
            armycardunioncost_cInfo dif = new armycardunioncost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UnionLevel": dif.UnionLevel = (short)(double)o22; break;
					case "Gold": dif.Gold = (int)(double)o22; break;
					case "Coin": dif.Coin = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UnionLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UnionLevel.ToString());
            Data.Add(dif.UnionLevel, dif);
        });
    }

    public armycardunioncost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardunioncost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardunioncost_cInfo> Data = new Dictionary<int, armycardunioncost_cInfo>();
}


public struct armycardunioncost_cInfo
{
	 /// <summary>
	 ///协同等级
	 /// </summary>
	public short UnionLevel;
	 /// <summary>
	 ///金币数量
	 /// </summary>
	public int Gold;
	 /// <summary>
	 ///兵牌
	 /// </summary>
	public int Coin;
}
