using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_selectchest_c : MonoEX.Singleton<SData_selectchest_c>
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
            selectchest_cInfo dif = new selectchest_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "UniqueID": dif.UniqueID = (int)(double)o22; break;
					case "SelectChestID": dif.SelectChestID = (int)(double)o22; break;
					case "Type": dif.Type = (string)o22; break;
					case "ID": dif.ID = (int)(double)o22; break;
					case "Quality": dif.Quality = (short)(double)o22; break;
					case "Num": dif.Num = (int)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.UniqueID))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.UniqueID.ToString());
            Data.Add(dif.UniqueID, dif);
        });
    }

    public selectchest_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("selectchest_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, selectchest_cInfo> Data = new Dictionary<int, selectchest_cInfo>();
}


public struct selectchest_cInfo
{
	 /// <summary>
	 ///唯一ID
	 /// </summary>
	public int UniqueID;
	 /// <summary>
	 ///宝箱ID
	 /// </summary>
	public int SelectChestID;
	 /// <summary>
	 ///道具类型
	 /// </summary>
	public string Type;
	 /// <summary>
	 ///道具ID
	 /// </summary>
	public int ID;
	 /// <summary>
	 ///装备品质
	 /// </summary>
	public short Quality;
	 /// <summary>
	 ///数量
	 /// </summary>
	public int Num;
}
