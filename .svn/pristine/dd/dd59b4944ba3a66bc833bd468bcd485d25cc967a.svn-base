using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_armycardqualitycost_c : MonoEX.Singleton<SData_armycardqualitycost_c>
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
            armycardqualitycost_cInfo dif = new armycardqualitycost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "QualityLevel": dif.QualityLevel = (short)(double)o22; break;
					case "Gold": dif.Gold = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.QualityLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.QualityLevel.ToString());
            Data.Add(dif.QualityLevel, dif);
        });
    }

    public armycardqualitycost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("armycardqualitycost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, armycardqualitycost_cInfo> Data = new Dictionary<int, armycardqualitycost_cInfo>();
}


public struct armycardqualitycost_cInfo
{
	 /// <summary>
	 ///卡牌品质
	 /// </summary>
	public short QualityLevel;
	 /// <summary>
	 ///金币数量
	 /// </summary>
	public int Gold;
}
