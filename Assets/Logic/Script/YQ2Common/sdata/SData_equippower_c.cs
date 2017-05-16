using System;
using System.Collections.Generic;
using LuaInterface;

public class SData_equippower_c : MonoEX.Singleton<SData_equippower_c>
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
            equippower_cInfo dif = new equippower_cInfo();
            SDataUtils.dealTable((LuaTable)o2, (Object o11, Object o22) =>
            {
                switch (head[(int)(double)o11 - 1])
				{
					case "EquipLevel": dif.EquipLevel = (short)(double)o22; break;
					case "Quality1": dif.Quality1 = (short)(double)o22; break;
					case "Quality2": dif.Quality2 = (short)(double)o22; break;
					case "Quality3": dif.Quality3 = (short)(double)o22; break;
					case "Quality4": dif.Quality4 = (short)(double)o22; break;
					case "Quality5": dif.Quality5 = (short)(double)o22; break;
					case "Quality6": dif.Quality6 = (short)(double)o22; break;
                }
            });
            if (Data.ContainsKey(dif.EquipLevel))
                MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, "重复的ID：" + dif.EquipLevel.ToString());
            Data.Add(dif.EquipLevel, dif);
        });
    }

    public equippower_cInfo GetDataOfID(int Id)
    {
        if (!Data.ContainsKey(Id)) throw new Exception(String.Format("equippower_cInfo::GetDataOfID() not found data  Id:{0}", Id));
        return Data[Id];
    }

    internal Dictionary<int, equippower_cInfo> Data = new Dictionary<int, equippower_cInfo>();
}


public struct equippower_cInfo
{
	 /// <summary>
	 ///强化等级
	 /// </summary>
	public short EquipLevel;
	 /// <summary>
	 ///白色
	 /// </summary>
	public short Quality1;
	 /// <summary>
	 ///绿色
	 /// </summary>
	public short Quality2;
	 /// <summary>
	 ///蓝色
	 /// </summary>
	public short Quality3;
	 /// <summary>
	 ///紫色
	 /// </summary>
	public short Quality4;
	 /// <summary>
	 ///橙色
	 /// </summary>
	public short Quality5;
	 /// <summary>
	 ///红色
	 /// </summary>
	public short Quality6;
}
