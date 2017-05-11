using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_avatarcost_c : MonoEX.Singleton<SData_avatarcost_c>
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
            avatarcost_cInfo dif = new avatarcost_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "AvatarLevel": dif.AvatarLevel = (short)(double)o22; break;
					case "Num": dif.Num = (short)(double)o22; break;
					case "Gold": dif.Gold = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.AvatarLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.AvatarLevel.ToString());
            Data.Add(dif.AvatarLevel, dif);
        });
    }

    public avatarcost_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("avatarcost_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, avatarcost_cInfo> Data = new Dictionary<int, avatarcost_cInfo>();
}


public struct avatarcost_cInfo
{
	 /// <summary>
	 ///时装等级
	 /// </summary>
	public short AvatarLevel;
	 /// <summary>
	 ///数量
	 /// </summary>
	public short Num;
	 /// <summary>
	 ///金币数量
	 /// </summary>
	public int Gold;
}
