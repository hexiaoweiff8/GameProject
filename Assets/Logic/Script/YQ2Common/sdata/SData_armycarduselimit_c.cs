using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycarduselimit_c : MonoEX.Singleton<SData_armycarduselimit_c>
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
            armycarduselimit_cInfo dif = new armycarduselimit_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "ArmyCardID": dif.ArmyCardID = (int)(double)o22; break;
					case "UseLimitLevel": dif.UseLimitLevel = (short)(double)o22; break;
					case "UseLimit": dif.UseLimit = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public armycarduselimit_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycarduselimit_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycarduselimit_cInfo> Data = new Dictionary<int, armycarduselimit_cInfo>();
}


public struct armycarduselimit_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///卡牌ID
	 /// </summary>
	public int ArmyCardID;
	 /// <summary>
	 ///兵员等级
	 /// </summary>
	public short UseLimitLevel;
	 /// <summary>
	 ///携带上限
	 /// </summary>
	public short UseLimit;
}
