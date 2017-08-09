using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_userdata_c : MonoEX.Singleton<SData_userdata_c>
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
            userdata_cInfo dif = new userdata_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UserLevel": dif.UserLevel = (short)(double)o22; break;
					case "Exp": dif.Exp = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UserLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UserLevel.ToString());
            Data.Add(dif.UserLevel, dif);
        });
    }

    public userdata_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("userdata_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, userdata_cInfo> Data = new Dictionary<int, userdata_cInfo>();
}


public struct userdata_cInfo
{
	 /// <summary>
	 ///主角等级
	 /// </summary>
	public short UserLevel;
	 /// <summary>
	 ///经验值
	 /// </summary>
	public int Exp;
}
