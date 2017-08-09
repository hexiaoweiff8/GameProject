using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_avoidwar_c : MonoEX.Singleton<SData_avoidwar_c>
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
            avoidwar_cInfo dif = new avoidwar_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (short)(double)o22; break;
					case "Type": dif.Type = (string)o22; break;
					case "ID": dif.ID = (string)o22; break;
					case "Num": dif.Num = (short)(double)o22; break;
					case "Time": dif.Time = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public avoidwar_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("avoidwar_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, avoidwar_cInfo> Data = new Dictionary<int, avoidwar_cInfo>();
}


public struct avoidwar_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public short UniqueID;
	 /// <summary>
	 ///货币类型
	 /// </summary>
	public string Type;
	 /// <summary>
	 ///ID
	 /// </summary>
	public string ID;
	 /// <summary>
	 ///数目
	 /// </summary>
	public short Num;
	 /// <summary>
	 ///免战时间（h）
	 /// </summary>
	public short Time;
}
