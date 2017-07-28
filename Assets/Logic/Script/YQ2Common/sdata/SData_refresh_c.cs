using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_refresh_c : MonoEX.Singleton<SData_refresh_c>
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
            refresh_cInfo dif = new refresh_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "ID": dif.ID = (short)(double)o22; break;
					case "Time": dif.Time = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.ID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.ID.ToString());
            Data.Add(dif.ID, dif);
        });
    }

    public refresh_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("refresh_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, refresh_cInfo> Data = new Dictionary<int, refresh_cInfo>();
}


public struct refresh_cInfo
{
	 /// <summary>
	 ///刷新次数
	 /// </summary>
	public short ID;
	 /// <summary>
	 ///刷新时间
	 /// </summary>
	public short Time;
}
